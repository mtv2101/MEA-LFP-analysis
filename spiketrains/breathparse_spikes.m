function [spikerate_abs, b_rate, allbins_raster, allbins_abs, winoverlap, bin_abs, raster_bin] = breathparse_spikes(breaths, events, spikes);

%% This function will take a list of breaths, spikes, and events and bin the
%% spikes around breaths of interest (e.g. around the events).  You must menually
%% input the event codes that you wish to parse around in this file (sel_events)
%%
%% inputs:
%% Breaths vector: column vector with timestamps of all breaths (in seconds)
%% Events matrix: 2 column vectors with timestamps (seconds) of all events, second column with event codes
%% spikes vector: column vector with timestamps of all spikes (seconds)
%%
%% output:
%% spikes per second as: [bins, breath, trial, events];
%%
%% written by Matt Valley, March 2010

%clear all;

SCALE_BINS = 0; %if 1 apply breath-scaling to bin size

event_codes = [1 2 3 4 5]; %these are the event codes
b_win = [-10:1:20]; %these are the breaths to parse around an event
binoffset = 0; %to center around inhalation rather than I/E shift this many more bins before I/E
seek_time = .2; %second to seek forward and backwards from event to find corresponding breath
winoverlap = 10; %number of times to overlap windows -- e.g. #4 would give binsize/4 granularity
bins = 4; %% for bins scaled to breath rate:
bin_abs = .1; % absolute bin size in seconds
num_bin_abs = ceil(.35/bin_abs); %number of bins to take on one side of the I/E
raster_bin = 0.001; %binsize for rasterization of spikes in seconds

for i = 1:max(event_codes);
    b = find(events(:,2) == i);
    c(i) = length(b);
    clear b;
end
min_trials = min(c); %this is the lowest number of trials of an event type, set all trial num to this and exclude trials occuring aferwards

spikerate = zeros(bins*(winoverlap+2),length(b_win),min_trials,length(event_codes));
spikerate_abs = zeros(num_bin_abs*winoverlap*2,length(b_win),min_trials,length(event_codes));
allbins_raster = int32(NaN(size(spikerate_abs,1)*10, length(b_win), min_trials, length(event_codes))); %raster bins are 10x smaller than psth bins
spikes_int = int32(ceil(spikes/raster_bin));
    
for n = 1:length(event_codes); % number of event types
    sel_events = find(events(:,2) == event_codes(n));
    if length(sel_events)>min_trials 
        xx = randperm(length(sel_events)-1); % use random trials - don't pick last trial (this leads to overflow errors)
        sel_events_short = sel_events(xx(:,1:min_trials));
    else
        sel_events_short = sel_events(1:min_trials);
    end

    if SCALE_BINS == 1
        for t=1:min_trials; % number of trials
            a = find((events(sel_events_short(t),1)-seek_time) <= breaths & breaths <= (events(sel_events_short(t),1)+seek_time));
            if length(a) ~= 1 %sometimes the search for breaths matching events returns two breaths.  This happens during abnormally quick respiration.  Eliminate the second one
                a = a(1); % make a the earliest breath in the seek window around an event
            end
            b_indx(t) = a; clear a;
            for b = 1:length(b_win); %for each breath - this will bin the breath
                center_b = breaths(b_indx(t)+b_win(b)); %get breath +b around event
                b_rate(b,t,n) = center_b - breaths(b_indx(t)-1+b_win(b)); %time to next breath
                binsize = b_rate(b,t,n)/bins; %size in sec of each bin
                bin_inc = binsize/winoverlap; %increment bins by this much
                allbins_abs(:,b,t,n) = (center_b-binsize-((b_rate(b,t,n)/2)+binoffset)):bin_inc:(center_b+binsize+((b_rate(b,t,n)/2)-binoffset));
                for x = winoverlap:(size(allbins_abs,1)-winoverlap-1)
                    s = find(spikes >= allbins_abs(x,b,t,n) & spikes <= allbins_abs(x+winoverlap,b,t,n));
                    numspikes = length(s);
                    clear s;
                    spikerate(x,b,t,n) = numspikes/binsize; %aggregate as [bins, breaths, trials, events];
                    spikerate_abs = spikerate;
                end
            end
            allbins_raster=[];
        end
    elseif SCALE_BINS == 0
        for t=1:length(sel_events_short); % number of trials
            a = find((events(sel_events_short(t),1)-seek_time) <= breaths & breaths <= (events(sel_events_short(t),1)+seek_time));
            if length(a) ~= 1 %sometimes the search for breaths matching events returns two breaths.  This happens during abnormally quick respiration.  Eliminate the second one
                a = a(1); % make a the earliest breath in the seek window around an event
            end
            b_indx(t) = a; clear a;
            for b = 1:length(b_win); %for each breath - this will bin the breath
                center_b = breaths(b_indx(t)+b_win(b)); %get breath +b around event
                b_rate(b,t,n) = center_b - breaths(b_indx(t)-1+b_win(b)); %time to next breath
                binsize = b_rate(b,t,n)/bins; %size in sec of each bin
                abs_win = (center_b-(num_bin_abs*bin_abs)):(bin_abs/winoverlap):(center_b+(num_bin_abs*bin_abs)); % breath window in time during which to collect spikes
                allbins_abs(:,b,t,n) = abs_win;
                for x = (1+winoverlap):(size(allbins_abs,1)-winoverlap)
                    s_abs = find(spikes >= allbins_abs(x,b,t,n) & spikes <= allbins_abs(x+winoverlap,b,t,n)); % find all spikes in moving window
                    numspikes_abs = length(s_abs);
                    clear s_abs;
                    spikerate_abs(x,b,t,n) = numspikes_abs/bin_abs; %aggregate absolutesize bins as [bins, breaths, trials, events];
                end                
                win_spikes = find(spikes >= min(abs_win) & spikes <= max(abs_win)); %find all spikes that fall within breath window
                if win_spikes %if any spikes in the window..
                    s = spikes(win_spikes)-min(abs_win)+1; %how many raster bins before first spike
                    s = int32(ceil(s/raster_bin));
                    allbins_raster(s,b,t,n) = 1; %aggregate as [bins, breaths, trials, events];
                    clear abs_win win_spikes s;
                end
            end
        end
        allbins_abs = [];
    end
end
end