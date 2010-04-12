function plot_raster(spikes,spikerate_abs,allbins_abs,allbins_raster,winoverlap);

data = spikerate_abs;
raster = allbins_raster;

b_win = [-10:1:30]; %these are the breaths to parse around an event

event_codes = (1:size(data,4));
bins = size(data,1);
startbin = 1;
endbin = bins;
base_breaths = 1:10;
odor_breaths = 13:17;

trials = size(data,3);
all_bbspikes = zeros(size(data,1),(size(data,2)*trials));
k = 1; %iterator
for n = 1:(size(data,4));
    for t = 1:trials; %for each trial
        for b = 1:length(base_breaths)
            bb(:,t,b) = raster(:,b,t,n); % raster is [bins, breaths, trials, events];
        end        
        for o = 1:length(odor_breaths)
            oo(:,t,o) = raster(:,o,t,n); % raster is [bins, breaths, trials, events];
        end               
    end
    basebreath_spikes = reshape(bb, [(size(bb,1)), (size(bb,3))*size(bb,2)]); %reshape last two dimensions to make #rows = events*baseline breaths
    odorbreath_spikes = reshape(oo, [(size(oo,1)), (size(oo,3))*size(oo,2)]);
    
    subplot(3,length(event_codes),n); 
        imagesc(basebreath_spikes');colormap([1 1 1; 0 0 0]);
    subplot(3,length(event_codes),n+length(event_codes));
        imagesc(odorbreath_spikes');colormap([1 1 1; 0 0 0]);
        
    base = squeeze(mean(mean(data(:,base_breaths,:,k),3),2));
    odor = squeeze(mean(mean(data(:,odor_breaths,:,k),3),2));
        base(1:winoverlap-1,:) = NaN;
        base((size(base,1)-winoverlap+1):size(base,1),:) = NaN;
        odor(1:winoverlap-1,:) = NaN;
        odor((size(odor,1)-winoverlap+1):size(odor,1),:) = NaN;
    subplot(3,length(event_codes),(n+length(event_codes)*2));
    plot(base,'k');xlim([1 size(base,1)]);hold on;
    plot(odor,'r');xlim([1 size(odor,1)]);
    k=k+1;
end
end