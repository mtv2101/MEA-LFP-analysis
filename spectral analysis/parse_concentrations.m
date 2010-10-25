baseline = [1 10];
odor = [12 16];
gamma = [50 100];
g_freqs = find(f>gamma(1) & f<gamma(2));

% sequentially import all spec_norms
[pathname] = uipickfiles('refilter', '\.mat$', 'type', {'*.mat', 'MAT-files'},...
    'prompt', 'Select all .mat files from MEA channels', 'output', 'cell');
for n = 1:length(pathname);
    load(pathname{n});
    spec_normall(:,:,:,:,:,n) = spec_norm; % spec_norm = [time, freq, trial, breath, chan, odor]
end

%aveallgamma_allodors = cat(4,aveallgamma_allodors,aveallgamma_allodors(:,:,:,1));
%aveallgamma_allodors(:,:,:,1) = [];
%aveallgamma_allodors = squeeze(aveallgamma_allodors);

% sig_breaths_allodors = squeeze(sig_breaths_allodors);
% sig_breaths_allodors = cat(3,sig_breaths_allodors,sig_breaths_allodors(:,:,1));
% sig_breaths_allodors(:,:,1) = [];
% sig_breaths_allodors = squeeze(sig_breaths_allodors);

powers = squeeze(mean(mean(spec_normall(:,g_freqs,:,:,:,:),3),2));
maxpower = squeeze(max(powers,[],1));
%maxpower = squeeze(max(aveallgamma_allodors,[],1));
%sigmaxpower = sig_breaths_allodors.*maxpower;

sum_sigs = squeeze(sum(sig_breaths_allodors(:,:,:),1));

maxpower_base = squeeze(mean(maxpower(baseline,:,:),1));
maxpower_odor = squeeze(mean(maxpower(odor,:,:),1)); %specify breaths with odor response
maxpower_norm = (maxpower_odor)-(maxpower_base);

% sigmaxpower_base = squeeze(mean(sigmaxpower(baseline,:,:),1));
% sigmaxpower_odor = squeeze(mean(sigmaxpower(odor,:,:),1)); %specify breaths with odor response
% sigmaxpower_norm = (sigmaxpower_odor)-(sigmaxpower_base);

tdt_map = [8,16,24,32;...
    7,15,23,31;...
    6,14,22,30;...
    5,13,21,29;...
    4,12,20,28;...
    3,11,19,27;...
    2,10,18,26;...
    1,9,17,25];

numodors = size(sig_breaths_allodors,3);
rows = 8;
cols = 4;
ymin = min(min(maxpower_norm));
ymax = max(max(maxpower_norm));
for x=1:rows
    for y=1:cols
        indx = tdt_map(x,y);
        subplot(rows,cols,(x*cols)-cols+y,'align');        
        plot(maxpower_norm(indx,:));
            ylim([ymin ymax]);
    end
end