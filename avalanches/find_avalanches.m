function[allpeaks av_size perct_filled pks_hist] = find_avalanches(wave_segs,srate,dt,thresh,chans,breaths,filtwin)

% input wave_segs is [time,events,breaths,channels]
% srate is sample rate, dt is window size in ms, thresh is multiplier
% (threshold * stdev) for threshold crossing algorithm.
% chans are the channels to analyze
% filtwin should be [minfrequency maxfrequyency]
%
% This function will detect a threshold crossing in one channel, and record
% the max or min values in all other channels regardless of their amplitude.
% Matt Valley, April 2010

% srate = 3051.76; %sample rate
% dt = 10; %window size in ms
% thresh = 1;
inc = floor(dt*srate/1000); %increment window this much
% chans = 1:32;

data_filt = single(filter_data(wave_segs,srate,filtwin,200));
for n = 1:size(data_filt,4);
    dat = squeeze(data_filt(:,breaths,:,n));
    dat_lin(:,n) = dat(:);
end

t = 100:inc:size(dat_lin,1);
s(chans) = nanstd(dat_lin(:,chans))*thresh;

allpeaks = NaN(length(t),length(chans));
sorted_peaks = allpeaks;
for x = 2:length(t)
    for n = chans
        window(:,n) = dat_lin((t(x-1)):t(x),n);
        aa = find(window(:,n) > s(n));
    end
    if length(aa) >= 1;
        dat_dif1 = diff(window); %take 1st derivative
        dat_dif2 = sign(dat_dif1); %express all values by sign (+1 or -1)
        kernal = [-1,1]; %when neighboring values are of same sign this kernal will turn value to zero
        for n = chans
            dat_dif(:,n) = conv(kernal,dat_dif2(:,n)); %convolve to isolate zero-crossings
            peaks = find(dat_dif(:,n)); %return non-zero indices
            maxpeaks(n) = max(window(peaks,n),[],1); %values of max peaks
            minpeaks(n) = min(window(peaks,n),[],1); %values of min peaks            
        end
        allpeaks(x,:) = maxpeaks;
    else 
        allpeaks(x,:) = NaN;
    end
    x
    sorted_peaks(x,:) = sort(allpeaks(x,:),'descend');
end

av_size1 = sum(allpeaks,2);
av_size = av_size1(~isnan(av_size1));
perct_filled = length(av_size)/length(av_size1);

av_max = max(av_size);
av_min = min(av_size);
aa = av_min:((av_max-av_min)/100):av_max;
pks_hist = hist(av_size,aa);%./length(av_size);
%loglog(pks_hist);
