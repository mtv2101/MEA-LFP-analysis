function [sig_breaths,sig_vals,cis] = test_breathsig_081009(spec_norm,brthindx,g_freqs);

baseline = find(brthindx <= 0); %get all breaths before stimilus (stim triggered on breath 0, so event occurs on next breath)
signal = find(brthindx >= 1); %get all breaths after stimilus

% base_means = squeeze(mean(spec_norm(:,g_freqs,:,baseline),1)); 
%     base_gmean = squeeze(mean(base_means,1));
% all_means = squeeze(mean(spec_norm(:,g_freqs,:,:),1));
%     all_gmean = squeeze(mean(all_means,1));
% 
% for i=size(all_gmean,2) %for each breath
%     test_vals = all_gmean(:,i);
%     base_test = base_gmean(:); 
%     sig_breaths(i) = ttest2(test_vals,base_test,.05,'right'); %do two-tailed t-test
% end

base_max = squeeze(max(spec_norm(:,g_freqs,:,baseline),[],1)); 
    base_gmax = squeeze(max(base_max,[],1));
all_max = squeeze(max(spec_norm(:,g_freqs,:,:),[],1));
    all_gmax = squeeze(max(all_max,[],1));

for i=1:size(all_gmax,2) %for each breath
    [sig_breaths(i),sig_vals(i),cis(i,:)] = ttest2(all_gmax(:,i),base_gmax(:),.05,'right','unequal'); %do two-tailed t-test
end