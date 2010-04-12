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

% for breath = 1:10;
%     for chan = 1:32;
%         %i = (allcorrs(1,:,breath,chan),allcorrs(2,:,breath,chan),8);
%             %dist_vals = find(
%         %scatter(allcorrs(1,:,breath,chan),allcorrs(2,:,breath,chan),8);
%         distances = allcorrs(2,:,breath,chan);
%         plot(allcorrs(1,:,breath,chan), distances);
%         hold on;
%     end
% end
% 
mean_corrs_base = squeeze(mean(mean(allcorrs(1,:,basebreaths,:),3),4));
mean_corrs_odor = squeeze(mean(mean(allcorrs(1,:,odorbreaths,:),3),4));
mean_corrs_post = squeeze(mean(mean(allcorrs(1,:,postbreaths,:),3),4));
distances = allcorrs(2,:,1,1);

% for i = 1:size(allcorrs,2)
%     a = squeeze(allcorrs(1,i,:,:));
%     b(:,i) = a(:);
% end
% stdev_corrs = std(b,1);%./sqrt(size(b,1));

plot(distances,mean_corrs_base, 'k');
hold on;
plot(distances,mean_corrs_odor, 'r');
%plot(distances,mean_corrs+stdev_corrs,'r');
hold on;
plot(distances,mean_corrs_post, 'g');
%plot(distances,mean_corrs-stdev_corrs,'r');