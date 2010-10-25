function [sig_breaths_allodors] = test_breathsig_posthoc(f);

%input: "spec_norm" is [time, freq, trials, breaths], defined per channel

brthindx = [-10:1:20];
gamma = [65 120];
g_freqs = find(f>gamma(1) & f<gamma(2));

% sequentially import all spec_norms
[pathname] = uipickfiles('refilter', '\.mat$', 'type', {'*.mat', 'MAT-files'},...
    'prompt', 'Select all .mat files from MEA channels', 'output', 'cell');
for n = 1:length(pathname);
    load(pathname{n});
    for x = 1:size(spec_norm,5) %for each channel
        baseline = find(brthindx <= 0); %get all breaths before stimilus (stim triggered on breath 0, so event occurs on next breath)
        signal = find(brthindx >= 1); %get all breaths after stimilus
        alpha = .01;
        base_mean = squeeze(mean(spec_norm(:,g_freqs,:,baseline,x),1));
        base_gmean = squeeze(mean(base_mean,1));
        all_mean = squeeze(mean(spec_norm(:,g_freqs,:,:,x),1));
        all_gmean = squeeze(mean(all_mean,1));
        for i=1:size(all_gmean,2) %for each breath
            [sig_vals(i),sig_breaths(i),cis(i,:)] = ranksum(all_gmean(:,i),base_gmean(:),alpha);%/size(all_gmean,2));
        end
        all_spec = all_gmean;
        sig_breaths_allodors(:,x,n) = sig_breaths;
       
        % base_max = squeeze(max(spec_norm(:,g_freqs,:,baseline),[],1));
        % base_gmax = squeeze(max(base_max,[],1));
        % all_max = squeeze(max(spec_norm(:,g_freqs,:,:),[],1));
        % all_gmax = squeeze(max(all_max,[],1));
        % for i=1:size(all_gmax,2) %for each breath
        %     [sig_vals(i),sig_breaths(i),cis(i,:)] = ranksum(all_gmax(:,i),base_gmax(:),alpha);%/size(all_gmax,2)); %do ranksum test, use bonferroni correction for n=all breaths
        % end
        % all_spec = all_gmax;
    end
end
end