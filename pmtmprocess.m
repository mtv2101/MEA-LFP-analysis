function [spec_norm aveallgamma allgamma] = pmtmprocess(spec,f,brthindx,base_mode,g_freqs);
% spec = (time, freq, trial, breath, channel(n))

spec = spec+100; %shift all values positive to avoid taking log of neg number
baseline = find(brthindx <= 0); %get all breaths before stimilus (stim triggered on breath 0, so event occurs on next breath)
signal = find(brthindx >= 1); %get all breaths after stimilus
%% Normalize Spectral density by frequency (over all trials), expresses as Db

if base_mode == 0 %base_mode=0 normalizes to average baseline power in each band individaully
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(spec(:,i,:,:),1)); %average power for each frequency band (ave over time)
        b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
        fmean(i) = mean(b); %average over all trials
        spec_norm(:,i,:,:) = 10.*(log10(spec(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
    end

elseif base_mode == 1 %base_mode=1 normalizes to max baseline power of all gamma freq bands
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(max(spec(:,i,:,:),[],1)); %maximum power for each frequency band (ave over time)
        b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
        fmean(i) = mean(b); %average over all trials
    end
    fmean_gamma = max(fmean(g_freqs)); %take max baseline gamma power
    spec_norm(:,:,:,:) = 10.*(log10(spec(:,g_freqs,:,:)./fmean_gamma)); % express as dB change

elseif base_mode == 2 %base_mode=2 normalizes to max baseline power averaged over gamma freq bands
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(max(spec(:,i,:,:),[],1)); %maximum power for each frequency band (ave over time)
        b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
        fmean(i) = mean(b); %average over all trials
    end
    fmean_gamma = mean(fmean(g_freqs)); %take aveage of max baseline gamma powers
    spec_norm(:,:,:,:) = 10.*(log10(spec(:,g_freqs,:,:)./fmean_gamma)); % express as dB change

elseif base_mode == 3 %base_mode=0 normalizes to average baseline power in each band individaully, and also adjusts for band dynamic range
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(mean(spec,4),3)); %average power for each frequency band (ave over time)
        fmean(i) = squeeze(mean(a(i,baseline),2)); %average this over baseline breaths
        fmax(i) = max(a(:,i),[],1);
        fmin(i) = min(a(:,i),[],1);
        spec_dyn_norm(:,i,:,:) = spec(:,i,:,:)./(fmax(i)/fmin(i));
        spec_norm(:,i,:,:) = 10.*(log10(spec_dyn_norm(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
    end

elseif base_mode == 4 %base_mode=0 normalizes to average baseline power in each band individaully, and also adjusts for band dynamic range after db normalization
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(mean(spec,4),3)); %average power for each frequency band (ave over time)
        fmean(i) = squeeze(mean(a(i,baseline),2)); %average this over baseline breaths
        spec_norm(:,i,:,:) = 10.*(log10(spec(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
        b = squeeze(mean(mean(spec_norm,4),3));
        fmax(i) = max(b(:,i),[],1);
        fmin(i) = min(b(:,i),[],1);
        spec_dyn_norm(:,i,:,:) = spec_norm(:,i,:,:)./(fmax(i)/fmin(i));
    end
end

%% Gamma extract
allgamma = squeeze(mean(spec_norm(:,g_freqs,:,:),2)); %average over all gamma frequencies
aveallgamma = squeeze(mean(allgamma,2)); %average over trials
end