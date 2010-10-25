%function[allpeaks av_size perct_filled pks_hist] = find_avalanches(wave_segs,srate,dt,thresh,chans,breaths,filtwin)

% input wave_segs is [time,events,breaths,channels]
% srate is sample rate, dt is window size in ms, thresh is multiplier
% (threshold * stdev) for threshold crossing algorithm.
% chans are the channels to analyze
% filtwin should be [minfrequency maxfrequyency]
%
% This function will detect a threshold crossing in one channel, and record
% the max or min values in all other channels regardless of their amplitude.
% Matt Valley, April 2010

%srate = 3051.76; %sample rate
%dt = 10; %window size in ms
% thresh = 1;

inc = floor(dt*srate/1000); %increment window this much
% chans = 1:32;

data_filt = single(filter_data(wave_segs,srate,filtwin,200));
%
% for n = 1:size(data_filt,4);
% dat = squeeze(data_filt(:,:,breaths,n));
% dat_lin(:,n) = dat(:);
% end

%the above can replaced with this code: -Armen 19May10
dat_lin = linearize_bychan(data_filt,0,breaths,0);

t = 100:inc:size(dat_lin,1);

%watch out using chans to index dat_lin, in case we change dat_lin
%to be filtered using chans. -armen
s(chans) = nanstd(dat_lin(:,chans))*thresh;
rpm = repmat(s,49,1);

%repmat makes it easier to use the > operator
% since M > N is allowed, and is fast, when
% N is a matrix instead of a scalar. Otherwise
% need to iterate over columns of 'window'

comp_zeros = false(size(rpm));
%this is just a [winsize x chans] matrix of
%zeros that is used to speed up checking of
%if there are any over-threshold matches


kernal = [-1,1]; %when neighboring values are of same sign this kernal will turn value to zero
allpeaks = NaN(length(t),length(chans));

%Vectorized this window scanning loop.
%speed increase from 10-15s to 500ms
%Armen - 19May10
for x = 2:length(t)
    %note that window length is inc+1 here. prob should be inc-1
    %Also, change has been made to create the window for all chans at once
    %-AE
    window = dat_lin((t(x-1)):t(x),:);
    
    %window > rpm is finding positions in the window
    %where dat is > sd*thresh. comp_zeros speeds comparison
    if ~isequal(window > rpm , comp_zeros)
        dat_dif1 = diff(window); %take 1st derivative
        dat_dif2 = sign(dat_dif1); %express all values by sign (+1 or -1)
        
        %note convolving with [-1; 1] not [-1, 1]
        %also, doing 2d convolution
        dat_dif = conv2(dat_dif2,kernal');
        maxpeaks = max(window.*logical(dat_dif),[],1);
        
        %the below can be used if we want to look at mins
        %minpeaks = min(window.*logical(dat_dif),[],1);
        allpeaks(x,:) = maxpeaks;
    end
end

av_size1 = sum(allpeaks,2);
av_size = av_size1(~isnan(av_size1));
perct_filled = length(av_size)/length(av_size1);

av_max = max(av_size);
av_min = min(av_size);
aa = av_min:((av_max-av_min)/100):av_max;
pks_hist = hist(av_size,aa);%./length(av_size);
%loglog(pks_hist);

%Note the below only prints right if all chans are included

if (0 == 1)
    figure
subplot(1,3,2:3);
plot(s,'-ko','LineWidth',2);
hold all;
title 'stddev of gamma filter signal. Ventral > Dorsal';
xlabel('Electrode index');
ylabel('SD');
plot(reshape(s(9:end),8,3),'-o');
legend('sites 1-32','sites 9-16','sites 17-24','sites 25-32',4)
subplot(1,3,1)
imagesc(reshape(s,8,4))
colorbar;
axis image
%%% end fig
end


