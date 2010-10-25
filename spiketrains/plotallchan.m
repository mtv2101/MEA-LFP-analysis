%% open SPIKES in the workspace

base_breaths = 1:10;
odor_breaths = 13:17;
ii = 1; % iterator for spikes

for n = 1:length(SPIKES);
    if size(SPIKES(n).snips,1) < 20 %ignore channels with less than x spikes (after event parsing)
        continue
    else
        figure
        i = 1; % iterator for subplots
        spikerate = SPIKES(n).spikerate_abs;
        snips = SPIKES(n).snips;
        subplot(size(spikerate,4),4,[1 5])
            if size(snips,1) > 2000
                plot(snips(1:2000,:)','k');hold on;
            else
                plot(snips','k');hold on;
            end
            plot(mean(snips,1),'r','LineWidth',3);
        for o = 1:size(spikerate,4);
            base = squeeze(mean(mean(spikerate(:,base_breaths,:,o),3),2));
            odor = squeeze(mean(mean(spikerate(:,odor_breaths,:,o),3),2));
            subplot(size(spikerate,4),4,i+1)
                plot(base,'k');xlim([1 size(base,1)]);hold on;
                plot(odor,'r');xlim([1 size(odor,1)]);
            subplot(size(spikerate,4),4,[i+2 i+3])
                imagesc(squeeze(mean(spikerate(:,:,:,o),3)));colorbar;
                title(['PSTH for channel_' num2str(n)]);
                odor_diff(:,o,ii) = odor-base;
                i = i+4;
                ii = ii+1;
        end
    end
end