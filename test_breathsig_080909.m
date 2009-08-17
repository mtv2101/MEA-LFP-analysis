function [sig_breaths] = test_breathsig_080909(spec_norm(:,:,:,:,n),brthindx,g_freqs);

baseline = find(brthindx <= 0); %get all breaths before stimilus (stim triggered on breath 0, so event occurs on next breath)
signal = find(brthindx >= 1); %get all breaths after stimilus

base_means(i,:,:) = squeeze(mean(spec_norm(:,g_freqs,:,baseline),1)); %max power for each frequency band (ave over time)
sig_means(i,:,:) = squeeze(mean(spec_norm(:,g_freqs,:,signal),1)); %take power change from baseline, per frequency

for i=length(sig_means,3)
    sig_test = 