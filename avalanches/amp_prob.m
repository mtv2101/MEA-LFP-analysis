chans = 1:32;

%open  and histogram wave data
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick source data file',...
    'MultiSelect', 'on');
load(datafile);
data_filt = SinoFilt(wave_segs(:),3051.76,[50 100],200);
%b = data_filt(:,:,:,chans);
%b = b(:);
s = ceil(std(data_filt)*3);
aa = 0:1:200;
c = hist(data_filt,aa);
c = c./length(data_filt);
clear wave;

%create distribution of random data
noise = randn(length(data_filt),1).*200;
noise_filt = SinoFilt(noise,3051.76,[40 100],200);
noise_hist = hist(noise_filt,aa)./length(noise_filt);

% sequentially open all channels of wave-peak data
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick all wave files',...
    'MultiSelect', 'on');
datafile = datafile([2:32 1]); %fix uigetfile bug, 32chan

for n = 1:length(datafile)
    load(datafile{n});
    amplits(n,:) = hist(peaks,ceil(aa));
    allpeaks(n) = length(peaks);
end
prob_amp = amplits(chans,:)./sum(allpeaks(chans));
allamps = sum(prob_amp);

%hold on;loglog(c,'xdata',aa,'marker','.','markeredgecolor','k','linestyle','none');
loglog(noise_hist,'xdata',aa,'marker','.','markeredgecolor','b','linestyle','none');
hold on;loglog(allamps,'xdata',aa,'marker','.','markeredgecolor','r','linestyle','none');