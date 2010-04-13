%allcorrs =
%2    32    30    32
events = size(Corr_Per_Breath,3);
breaths = size(Corr_Per_Breath,4);
basebreaths = 1:11;
odorbreaths = 12:14;
postbreaths = 15:30;
% Corr_Per_Breath = [channels, channels, events, breaths]

for e = 1:events;
    for chan=1:32;
        for b = 1:breaths;
            [corrs_distances]= CorrVDist(Corr_Per_Breath(:,:,e,b),coordinates,1,32,chan,33);
            allcorrs(:,1:size(corrs_distances,2),b,chan) = corrs_distances;
        end
    end
end

mean_corrs_base = squeeze(mean(mean(allcorrs(1,:,basebreaths,:),3),4));
    corrs_base = squeeze(allcorrs(1,:,basebreaths,:));
    lincorrs_base = reshape(corrs_base, [size(corrs_base,1) (size(corrs_base,2)*size(corrs_base,3))]);
    sem_basecorrs = std(lincorrs_base,1,2)./sqrt(size(lincorrs_base,2));
mean_corrs_odor = squeeze(mean(mean(allcorrs(1,:,odorbreaths,:),3),4));
    corrs_odor = squeeze(allcorrs(1,:,odorbreaths,:));
    lincorrs_odor = reshape(corrs_odor, [size(corrs_odor,1) (size(corrs_odor,2)*size(corrs_odor,3))]);
    sem_odorcorrs = std(lincorrs_odor,1,2)./sqrt(size(lincorrs_odor,2));
mean_corrs_post = squeeze(mean(mean(allcorrs(1,:,postbreaths,:),3),4));
    corrs_post = squeeze(allcorrs(1,:,postbreaths,:));
    lincorrs_post = reshape(corrs_post, [size(corrs_post,1) (size(corrs_post,2)*size(corrs_post,3))]);
    sem_postcorrs = std(lincorrs_post,1,2)./sqrt(size(lincorrs_post,2));
distances = allcorrs(2,:,1,1);

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