function [sig_chans,sig_vals] = testsig_corr(corr_breath, chan, base, odor)

% corr_breath = [chans, chans, trials, breaths]
% chan = 1;
% base = 1:11;
% odor = 13:20;

odor_corrs = squeeze(corr_breath(:,chan,:,odor));
base_corrs = squeeze(corr_breath(:,chan,:,base));

for n = 1:size(odor_corrs,1)
    odor_corrslin = squeeze(odor_corrs(n,:,:));
    base_corrslin = squeeze(base_corrs(n,:,:));
    [sig_chans(n),sig_vals(n)] = ttest2(odor_corrslin(:), base_corrslin(:),.01);
end