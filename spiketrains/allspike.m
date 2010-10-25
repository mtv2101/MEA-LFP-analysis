%% script to do all spike analysis
%% inputs:
%% Breaths vector: column vector with timestamps of all breaths (in seconds)
%% Events matrix: 2 column vectors with timestamps (seconds) of all events, second column with event codes
%% spikes vector: column vector with timestamps of all spikes (seconds)

clear all

%upload the breath file - "breaths" in workspace
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick breath file');
    load(datafile);
    clear datafile

%upload the event file - "events" in workspace
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick event file');
    cd(pathname);
    load(datafile);
    clear datafile

%sequentially open spike timestamps from each channel
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick a wave files for each ',...
    'MultiSelect', 'on');
cd(pathname);
datafile = datafile([2:length(datafile) 1]); %fix uigetfile bug, 32chan

for chan = 1:length(datafile)
    load(datafile{chan}); % name of array must be "spike"
    spikes = spike(:,1); %first dimension ontains timestamps
    if length(spikes) < 1000 % don't analyze any channel with fewer than this many spikes
        continue
    end

    [spikerate_abs, b_rate, allbins_raster, allbins_abs, winoverlap, bin_abs, raster_bin] = breathparse_spikes(breaths, events, spikes(:,1));
    %[h_phase num_sigbreaths] = spike_stats(spikerate_abs);

    SPIKES(chan).spikerate_abs = spikerate_abs;
    SPIKES(chan).snips = spike(:,2:size(spike,2));
    SPIKES(chan).b_rate = b_rate;
    SPIKES(chan).allbins_abs = allbins_abs;
    %SPIKES(chan).h_phase = h_phase;
    %SPIKES(chan).num_sigbreaths = num_sigbreaths;
%    SPIKES(chan).allbins_raster = allbins_raster;
    SPIKES(chan).bin_abs = bin_abs;
    SPIKES(chan).raster_bin = raster_bin;
%    SPIKES(chan).pathname = pathname(chan);
end

% for n=1:length(SPIKES);
%     if isnan(SPIKES(n).h_phase) == 0;
%         allsigphase(n,:) = SPIKES(n).h_phase;
%     else continue
%     end
% end
% for n=1:length(SPIKES); 
%     if isnan(SPIKES(n).num_sigbreaths) == 0;
%         allsigrate(n,:) = SPIKES(n).num_sigbreaths;
%     else continue
%     end
% end