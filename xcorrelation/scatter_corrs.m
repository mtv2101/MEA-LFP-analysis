% input: corr_breath = [channels, channels, events, breaths]

events = size(corr_breath,3);
breaths = size(corr_breath,4);
basebreaths = 1:11;
odorbreaths = 13:15;
postbreaths = 16:30;
coors1 = repmat([0:200:600], [8 1]);
coors2 = repmat([0:200:1400]', [4 1]);
coordinates = [coors1(:) coors2];

all_distances = sort(unique(distcalc_perchan(coordinates,1,32,1,33)));
allcorrs = nan(2,length(all_distances),size(corr_breath,4),size(corr_breath,1),size(corr_breath,3));

for e = 1:size(corr_breath,3); %for each event
    for chan=1:size(corr_breath,1); %for each channel
        for b = 1:size(corr_breath,4); %for each breath            
            [corrs_distances] = CorrVDist(corr_breath(:,:,e,b),1,32,chan,33,coordinates);
            dist_remap = []; 
            for m = 1:size(corrs_distances,2)
                dist_remap = [dist_remap; find(corrs_distances(2,m) == all_distances)]; 
            end
            allcorrs(:,dist_remap,b,chan,e) = corrs_distances; %allcorrs = [2 25 31 32 16]
        end
    end
end
distances = allcorrs(2,:,1,1);

figure
mean_corrs_base = squeeze(nanmean(nanmean(nanmean(allcorrs(1,:,basebreaths,:,:),5),3),4));
    corrs_base = squeeze(allcorrs(1,:,basebreaths,:,:));
    lincorrs_base = reshape(corrs_base, [size(corrs_base,1) (size(corrs_base,2)*size(corrs_base,3)) size(corrs_base,4)]);
    sem_basecorrs = nanstd(squeeze(nanmean(lincorrs_base,2)),1,2);% / sqrt(size(lincorrs_base,2));
mean_corrs_odor = squeeze(nanmean(nanmean(nanmean(allcorrs(1,:,odorbreaths,:,:),5),3),4));
    corrs_odor = squeeze(allcorrs(1,:,odorbreaths,:,:));
    lincorrs_odor = reshape(corrs_odor, [size(corrs_odor,1) (size(corrs_odor,2)*size(corrs_odor,3)) size(corrs_odor,4)]);
    sem_odorcorrs = nanstd(squeeze(nanmean(lincorrs_odor,2)),1,2);% / sqrt(size(lincorrs_odor,2));
mean_corrs_all = squeeze(nanmean(nanmean(allcorrs(1,:,:,:,:),5),4));
% mean_corrs_post = squeeze(nanmean(nanmean(nanmean(allcorrs(1,:,postbreaths,:,:),5),3),4));
%     corrs_post = squeeze(allcorrs(1,:,postbreaths,:,:));
%     lincorrs_post = reshape(corrs_base, [size(corrs_base,1) (size(corrs_base,2)*size(corrs_base,3)) size(corrs_base,4)]);
%     sem_postcorrs = nanstd(squeeze(nanmean(lincorrs_post,2)),1,2);% / sqrt(size(lincorrs_post,2));
distances = allcorrs(2,:,1,1);

%subplot(2,1,1);
errorbar(distances,mean_corrs_base,sem_basecorrs', 'k');hold on
errorbar(distances,mean_corrs_odor,sem_odorcorrs', 'r');hold on
%errorbar(distances,mean_corrs_post,sem_postcorrs', 'b');hold on
xlim([0 1600]);ylim([0 1]);
%subplot(2,1,2);
%imagesc(squeeze(nanmean(allcorrs_meanevents(1,:,:,:),4)));