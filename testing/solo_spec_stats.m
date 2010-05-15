% import "f" vector
% sequentially load all "spec_norm" matrices for each odor presentation

gamma = [50 100];
g_freqs = find(f>gamma(1) & f<gamma(2));
brthindx = [-10:1:20];

% sequentially import all channels
[pathname] = uipickfiles('refilter', '\.mat$', 'type', {'*.mat', 'MAT-files'},...
    'prompt', 'Select all .mat files from MEA channels', 'output', 'cell');

for odor = 1:length(pathname);
    load(pathname{odor}); % filename must be "spec_norm"
    for n=1:size(spec_norm,5);
        [sig_breaths(:,n),sig_vals(:,n),cis(:,n),all_specmax(:,:,n)] = test_breathsig(spec_norm(:,:,:,:,n),brthindx,g_freqs);
    end    
    sig_breaths_allodors(:,:,odor) = sig_breaths;
    sig_vals_allodors(:,:,odor) = sig_vals;
end

sumbreaths = squeeze(sum(sig_breaths_allodors,1));