function [wave_segs] = parsechans(wave,events,breaths,srate,odor,brth_num,winsize,eventcodes)

%INPUTS:
% -- "events" matrix containing vectors with event time(in sec) 1st dim,
%    event code ("1,2,3"...etc) 2nd dim
% -- "breaths" double vector containing the time of each breath in the experiment (in sec)
%This script assumes that the events are triggered from breaths, but that
%   the real timing between the two may not be perfect (allowing to collect
%   event data from Spike2 and breath data from TDT OpenEx).
%
%   srate - tdt_srate = 3051.76Hz
%   eventcode - code of events to extract

win_time = (winsize/2)*srate; %time (samples) to window forward (or beackward) from a breath
win_offset = 0*srate; %time (seconds) to forward offset window in time
seek_time = 1000; %num samples to seek forward and backwards from event to find corresponding breath

tdt_allevents(:,1) = (events(:,1)*srate);
tdt_allevents(:,2) = events(:,2);
tdt_breaths = round(breaths*srate);
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
sel_events_short = sort(sel_events_short); %resort events back into chronological order

for i=1:min_trials; %arbitrary number of trials
    a = find((tdt_allevents(sel_events_short(i),1)-seek_time) <= tdt_breaths & tdt_breaths <= (tdt_allevents(sel_events_short(i),1)+seek_time));
    if length(a) ~= 1 %sometimes the search for breaths matching events returns two breaths.  This happens during abnormally quick respiration.  Eliminate the second one
        a = a(1);
    end
    brth_indx(i) = a;
    clear a;
    brth = tdt_breaths(brth_indx(i)+brth_num); %get breath +brth_num after event
    winstart = int32(brth-win_time+win_offset); %in tdt samples
    winend = int32(brth+win_time+win_offset); %in tdt samples
    if i==1;
        win_final = winend-winstart; %a bug occurs rarely where the int32 of the window creates a size mismatch between trials.  "winfinal" is the template size to maintain over all trials.
    end
    wave_segs(:,i) = wave(winstart:(winstart+win_final));
end
end