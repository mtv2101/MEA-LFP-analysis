clear all;

% Define Global VARS
srate = 3051.76;  %Hz
eventcode = 2;
winsize = .5;
brthindx = [-10:1:20];
maxfreq = 200;
base_mode = 0; % 0 = normalizes to average baseline power in each band individaully
               % 1 = normalizes to max baseline power of all gamma freq bands
               % 2 = normalizes to max baseline power averaged over gamma freq bands
               
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

% sequentially open all channels
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick a wave files for each ',...
    'MultiSelect', 'on');
cd(pathname);
datafile = datafile([2:32 1]); %fix uigetfile bug, 32chan
for n = 1:length(datafile); %n to number of channels
    load(datafile{n}); % name of array must be "wave"
    for x = 1:length(brthindx) %x to num of breaths
        wave_segs(:,:,x,n) = parsechans_080709(wave,events,breaths,srate,eventcode,brthindx(x),winsize);
        [S, t, f] = pmtm_080709(squeeze(wave_segs(:,:,x,n)),srate,maxfreq);
        spec(:,:,:,x) = S; clear S; %spec = (time, freq, trial, breath)
        disp('breath'); disp(x);
    end
g_freqs = find(f>50 & f<100);
    disp('site'); disp(n);
    [spec_norm(:,:,:,:,n) aveallgamma(:,:,n) allgamma(:,:,:,n)] = pmtmprocess_080909(spec(:,:,:,:),f,brthindx,base_mode,g_freqs);
    [sig_breaths] = test_breathsig_080909(spec_norm(:,:,:,:,n),brthindx,g_freqs);
    %clear spec;
end