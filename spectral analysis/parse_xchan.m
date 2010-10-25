clear all;

% Define Global VARS
eventcodes = [1 2 3 4 5];
srate = 3051.76;  %Hz
winsize = .5;
brthindx = [-10:1:30];
maxfreq = 120;
gamma = [50 100]; %define gamma frequency window (Hz)
dead_chans = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
             %1 2 3 4 5 6 7 8 9 1 1 2 3 4 5 6 7 8 9 1 1 2 3 4 5 6 7 8 9 1 1 2   
%sigtype = 0; %0 gives mean power, 1 gives max power

base_mode = 1; %current favorite base_mode is #1
% 0 = normalizes to average baseline power in each band individaully
% 1 = normalizes to stdev of baseline power in each band individaully, and sets all baseline specs to zero
% 2 = normalizes to mean baseline power in each band individaully, and sets all baseline specs to zero
% 3 = normalizes to max baseline power of all gamma freq bands
% 4 = normalizes to max baseline power averaged over gamma freq bands
% 5 = normalizes to average baseline power in each band individaully, and also adjusts for band dynamic range
% 6 = normalizes to average baseline power in each band individaully, and also adjusts for band dynamic range after db normalization

% upload the breath file - "breaths" in workspace
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick breath file');
for n = 1:length(datafile);
    cd(pathname);
    load(datafile);
end
% upload the event file - "events" in workspace
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick event file');
for n = 1:length(datafile);
    cd(pathname);
    load(datafile);
end

% sequentially import all channels
[pathname] = uipickfiles('refilter', '\.mat$', 'type', {'*.mat', 'MAT-files'},...
    'prompt', 'Select all .mat files from MEA channels', 'output', 'cell');


tdt_allevents(:,1) = (events(:,1)*srate);
tdt_allevents(:,2) = events(:,2);
for odor = eventcodes;  
    sel_events = find(tdt_allevents(:,2) == odor);
    if max(sel_events,[],1) == size(events,1); % don't pick last trial (this leads to overflow errors)
        sel_events = sel_events(1:(length(sel_events)-1)); %cut out last event because the experiment is often ended before a sufficient number of breaths are recorded after this event
    end
    for a = eventcodes;
        b = find(tdt_allevents(:,2) == a);
        c(a) = length(b);
        clear b;
    end
    min_trials = min(c); %this is the lowest number of trials of an event type, set all trial num to this and exclude trials occuring aferwards
    if length(sel_events)>min_trials % if this event type has as ton of trials
        xx = randperm(length(sel_events)); % use randomly picked trials
        sel_events_short = sel_events(xx(:,1:min_trials));
    else
        sel_events_short = sel_events(1:min_trials);
    end
    sel_events_all(:,odor) = sort(sel_events_short); %resort event indices back into chronological order
    eventtimes(:,odor) = tdt_allevents(sel_events_all(:,odor),1);
    clear sel_events sel_events_short a c
end

for odor = eventcodes;
    disp('odor'); disp(odor);
    for n = 1:length(pathname); %n to number of selected channels 
        if dead_chans(n)==1
            continue 
        end
        load(pathname{n}); % name of imported data must be "wave"
        for x = 1:length(brthindx) %x to num of breaths
            [wave_segs(:,:,x,n) winstart(:,x,n)] = parsechans(wave,breaths,srate,eventtimes(:,odor),winsize,brthindx(x));
            [S, t, f] = pmtm_cust(squeeze(wave_segs(:,:,x,n)),srate,maxfreq);
            spec(:,:,:,x) = S; clear S; %spec = (time, freq, trial, breath)
            %disp('breath'); disp(x);
        end
        g_freqs = find(f>gamma(1) & f<gamma(2));
        disp('site'); disp(n);
        spec_all(:,:,:,:,n) = spec;
        [spec_norm(:,:,:,:,n) aveallgamma(:,:,n)] = pmtmprocess(spec,f,brthindx,base_mode,g_freqs);
        [sig_breaths(:,n),sig_vals(:,n),cis(:,:,n),all_specmax(:,:,n)] = test_breathsig(spec_norm(:,:,:,:,n),brthindx,g_freqs);
    end
    winstart_all(:,:,:,odor) = winstart;
    aveallgamma_allodors(:,:,:,odor) = aveallgamma;
    sig_breaths_allodors(:,:,odor) = sig_breaths;
    save(['spec_odor' num2str(odor)], 'spec_all');
    clear spec;
    save(['spec_norm_odor' num2str(odor)], 'spec_norm');
    clear spec_norm;
    save(['wave_segs' num2str(odor)], 'wave_segs');
    save('f','f');
end
save(['aveallgamma_allodors'], 'aveallgamma_allodors');
save(['sig_breaths_allodors'], 'sig_breaths_allodors');