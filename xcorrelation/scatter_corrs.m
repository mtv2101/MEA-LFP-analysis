%allcorrs =
%2    32    30    32
events = size(Corr_Per_Breath,3);
breaths = size(Corr_Per_Breath,4);
basebreaths = 1:11;
odorbreaths = 12:14;
postbreaths = 15:30;
% Corr_Per_Breath = [channels, channels, events, breaths]

all_distances = sort(unique(distcalc_perchan(coordinates,1,32,1,33)));
allcorrs = nan(2,length(all_distances),30,32);
%for e = 1:events;
for e = 2
for chan=1:32;
        chan,
       % for b = 13
        for b = 1:breaths;
            
            [corrs_distances] = CorrVDist(Corr_Per_Breath(:,:,e,b),coordinates,1,32,chan,33);
            dist_remap = []; for m = 1:size(corrs_distances,2) dist_remap = [dist_remap; find(corrs_distances(2,m) == all_distances)]; end;
            %size(allcorrs(:,dist_remap,b,chan)), size(corrs_distances),
            allcorrs(:,dist_remap,b,chan) = corrs_distances;
        end
    end
end

distances = allcorrs(2,:,1,1);
figure
mean_corrs_base = squeeze(nanmean(nanmean(allcorrs(1,:,basebreaths,:),3),4));
    corrs_base = squeeze(allcorrs(1,:,basebreaths,:));
    lincorrs_base = reshape(corrs_base, [size(corrs_base,1) (size(corrs_base,2)*size(corrs_base,3))]);
    sem_basecorrs = std(lincorrs_base,1,2)./sqrt(size(lincorrs_base,2));
mean_corrs_odor = squeeze(nanmean(nanmean(allcorrs(1,:,odorbreaths,:),3),4));
    corrs_odor = squeeze(allcorrs(1,:,odorbreaths,:));
    lincorrs_odor = reshape(corrs_odor, [size(corrs_odor,1) (size(corrs_odor,2)*size(corrs_odor,3))]);
    sem_odorcorrs = std(lincorrs_odor,1,2)./sqrt(size(lincorrs_odor,2));
mean_corrs_post = squeeze(nanmean(nanmean(allcorrs(1,:,postbreaths,:),3),4));
    corrs_post = squeeze(allcorrs(1,:,postbreaths,:));
    lincorrs_post = reshape(corrs_post, [size(corrs_post,1) (size(corrs_post,2)*size(corrs_post,3))]);
    sem_postcorrs = std(lincorrs_post,1,2)./sqrt(size(lincorrs_post,2));
distances = allcorrs(2,:,1,1);




%imagesc(squeeze(allcorrs(1,:,13,:)))

plot(distances,mean_corrs_base, 'k');hold on;
    plot(distances,mean_corrs_base+sem_basecorrs', 'k');hold on;
    plot(distances,mean_corrs_base-sem_basecorrs', 'k');hold on;
plot(distances,mean_corrs_odor, 'r');hold on;
    plot(distances,mean_corrs_odor+sem_odorcorrs', 'r');hold on;
    plot(distances,mean_corrs_odor-sem_odorcorrs', 'r');hold on;
plot(distances,mean_corrs_post, 'b');hold on;
    plot(distances,mean_corrs_post+sem_postcorrs', 'b');hold on;
    plot(distances,mean_corrs_post-sem_postcorrs', 'b');hold on;
%plot(distances,mean_corrs-stdev_corrs,'r');