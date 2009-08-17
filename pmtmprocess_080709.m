function [spec_norm aveallgamma allgamma] = pmtmprocess_080709(spec,f,brthindx);
% spec = (time, freq, trial, breath, channel(n))

spec = spec+100; %shift all values positive to avoid taking log of neg number
baseline = find(brthindx <= 0); %get all breaths before stimilus
g_freqs = find(f>45 & f<100);
%% Normalize Spectral density by frequency (over all trials), expresses as Db

if base_mode == 0 %base_mode=0 normalizes to average baseline power
for i=1:size(spec,2); %iterate over frequency dim
    a = squeeze(mean(spec(:,i,:,:),1)); %average power for each frequency band (ave over time)
    b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths    
    fmean(i) = mean(b); %average over all trials
    spec_norm(:,i,:,:) = 10.*(log10(spec(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
end

if base_mode == 1 %base_mode=1 normalizes to max baseline power of all freq bands
    for i=1:size(spec,2); %iterate over frequency dim
    a = squeeze(max(spec(:,i,:,:),[],1)); %maximum power for each frequency band (ave over time)
    b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths    
    fmean(i) = mean(b); %average over all trials
    spec_norm(:,i,:,:) = 10.*(log10(spec(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
    end
    
if base_mode == 2 %base_mode=2 normalizes to max baseline power averaged over freq bands
    for i=1:size(spec,2); %iterate over frequency dim
    a = squeeze(max(spec(:,i,:,:),[],1)); %maximum power for each frequency band (ave over time)
    b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths    
    fmean(i) = mean(b); %average over all trials
    spec_norm(:,i,:,:) = 10.*(log10(spec(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
end

%% Gamma extract
allgamma = squeeze(mean(spec_norm(:,g_freqs,:,:),2)); %average over all gamma frequencies
aveallgamma = squeeze(mean(allgamma,2)); %average over trials
end