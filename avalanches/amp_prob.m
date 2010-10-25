chans = 1:32;

%open  and histogram wave data
% [datafile, pathname] = uigetfile(...
%     '*.mat',...
%     'Please pick source data file',...
%     'MultiSelect', 'on');
% load(datafile);
data_filt = filter_data(wave_segs,3051.76,[50 100],200);
%b = data_filt(:,:,:,chans);
%b = b(:);
s = ceil(std(data_filt(:))*3);
wave_max = max(data_filt(:));
wave_min = min(data_filt(:));
wave_std = std(data_filt(:));
aa = wave_min:((wave_max-wave_min)/200):wave_max;
c = hist(data_filt(:),aa);
c = c./length(data_filt(:));
clear wave;

%create distribution of random data
% noise = randn(size(wave_segs));
% noise_filt = filter_data(noise,3051.76,[50 100],200);
% noise_max = max(noise_filt(:));
% noise_min = min(noise_filt(:));
% nn = noise_min:((noise_max-noise_min)/200):noise_max;
% noise_hist = hist(noise_filt(:),nn)./length(noise_filt(:));

% sequentially open all channels of wave-peak data
% [datafile, pathname] = uigetfile(...
%     '*.mat',...
%     'Please pick all wave files',...
%     'MultiSelect', 'on');
% datafile = datafile([2:32 1]); %fix uigetfile bug, 32chan

% for n = 1:length(datafile)
%     load(datafile{n});
    %amplits(n,:) = hist(peaks,ceil(aa));
for n=1:size(all_pks,4); %allpks should be [time,trials,breaths,channels]
    pkslin = all_pks(:,:,:,n);
    amplits(n,:) = hist(pkslin(:),aa);
    allpeaks(n) = length(pkslin);
end
prob_amp = amplits(chans,:)./sum(allpeaks(chans));
allamps = sum(prob_amp);

%hold on;loglog(c,'xdata',aa,'marker','.','markeredgecolor','k','linestyle','none');
%loglog(noise_hist,'xdata',aa,'marker','.','markeredgecolor','b','linestyle','none');
%hold on;
loglog(allamps,'xdata',aa,'marker','.','markeredgecolor','r','linestyle','none');