%allcorrs =
%2    32    30    32
events = size(Corr_Per_Breath,3);
breaths = size(Corr_Per_Breath,4);
% Corr_Per_Breath = [channels, channels, events, breaths]

for event = 12:17;
    for chan=1:32;
        for breath = 1:breaths;
            [corrs_distances]= CorrVDist(squeeze(Corr_Per_Breath(:,:,events,:)),coordinates,1,32,chan,33,breath);
            allcorrs(:,1:size(corrs_distances,2),breath,chan) = corrs_distances;
        end
    end
end

for breath = 1:10;
    for chan = 1:32;
        %i = (allcorrs(1,:,breath,chan),allcorrs(2,:,breath,chan),8);
            %dist_vals = find(
        %scatter(allcorrs(1,:,breath,chan),allcorrs(2,:,breath,chan),8);
        distances = allcorrs(2,:,breath,chan);
        plot(allcorrs(1,:,breath,chan), distances);
        hold on;
    end
end

mean_corrs = squeeze(mean(mean(allcorrs(1,:,:,:),3),4));
distances = allcorrs(2,:,1,1);

for i = 1:size(allcorrs,2)
    a = squeeze(allcorrs(1,i,:,:));
    b(:,i) = a(:);
end
stdev_corrs = std(b,1);%./sqrt(size(b,1));

plot(distances,mean_corrs);
hold on;
plot(distances,mean_corrs+stdev_corrs,'r');
hold on;
plot(distances,mean_corrs-stdev_corrs,'r');