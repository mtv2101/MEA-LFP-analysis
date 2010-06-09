channel = 20;
odor_win = [13:20];
base_win = [1:10];

% sequentially import all corr_breath
[pathname] = uipickfiles('refilter', '\.mat$', 'type', {'*.mat', 'MAT-files'},...
    'prompt', 'Select all .mat files from MEA channels', 'output', 'cell');

for n = 1:length(pathname);
    load(pathname{n});    
    subplot(1,length(pathname),n);
    odormap = squeeze(mean(mean(corr_breath(channel,:,:,odor_win),4),3));
    basemap = squeeze(mean(mean(corr_breath(channel,:,:,base_win),4),3));
    diffmap = (odormap-basemap)./(1-basemap);
    imagesc_mea(diffmap, 0, .5);
end