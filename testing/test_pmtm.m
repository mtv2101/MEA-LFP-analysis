% Nwin=round(Fs*movingwin(1)); % number of samples in window
% nfft=max(2^(nextpow2(Nwin)+pad),Nwin); %length fft

chan=10;
gamma = [50 100];
winsize = [.1 .15 .2 .25 .3 .35 .4];
stepsize = .01;
tapers = [5 7];
srate = 3051.76;
freqs = [5 120];
base_mode = 1;
brthindx = [-10:1:20];
baseline = find(brthindx <= 1); %get all breaths before stimilus (stim triggered on breath 0, so event occurs on next breath)
signal = find(brthindx > 1 & brthindx < 5);

for x=1:length(winsize)
    for b = 1:length(brthindx);
        [S, t, f] = pmtm_cust2(squeeze(wave_segs(:,:,b,chan)),srate,freqs,winsize(x),stepsize,tapers);
        spec(:,:,:,b) = S; clear S; %spec = (time, freq, trial, breath)
    end
    g_freqs = find(f>gamma(1) & f<gamma(2));
    window = find(t>.22 & t<.28);
    [spec_norm aveallgamma] = pmtmprocess(spec,f,brthindx,base_mode,g_freqs);
    plot{x}.basemeanspec = log10(squeeze(mean(mean(mean(spec(window,:,:,baseline,:),4),3),1)));
    plot{x}.basemeanspec_norm = (squeeze(mean(mean(mean(spec_norm(window,:,:,baseline,:),4),3),1)));
    plot{x}.t = t;
    plot{x}.f = f;
    plot{x}.odormeanspec = log10(squeeze(mean(mean(mean(spec(window,:,:,signal,:),4),3),1)));
    plot{x}.odormeanspec_norm = (squeeze(mean(mean(mean(spec_norm(window,:,:,signal,:),4),3),1)));
    plot{x}.spec_norm = spec_norm;
    clear spec
end

% for x=1:length(winsize)
%     h1 = plot(f(:,x),log10(basemeanspec(:,x)),'k');hold on
%     h2 = plot(f(:,x),log10(odormeanspec(:,x)),'r');hold on
% end

% figure
% normbasemeanspec = squeeze(mean(mean(mean(spec_norm(:,:,:,baseline),4),3),1));
% normodormeanspec = squeeze(mean(mean(mean(spec_norm(:,:,:,signal),4),3),1));
% plot(f,normbasemeanspec,'k');hold on;plot(f,normodormeanspec,'r');

%
% figure
% basemeanfreq = squeeze(mean(mean(mean(spec(:,g_freqs,:,baseline),4),3),2));
% odormeanfreq = squeeze(mean(mean(mean(spec(:,g_freqs,:,signal),4),3),2));
% plot(t,log10(basemeanfreq),'k');hold on;plot(t,log10(odormeanfreq),'r');
%
% figure
% normbasemeanfreq = squeeze(mean(mean(mean(spec_norm(:,g_freqs,:,baseline),4),3),2));
% normodormeanfreq = squeeze(mean(mean(mean(spec_norm(:,g_freqs,:,signal),4),3),2));
% plot(t,normbasemeanfreq,'k');hold on;plot(t,normodormeanfreq,'r');