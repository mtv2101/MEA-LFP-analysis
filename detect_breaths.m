clear all

% upload the respiration trace in workspace
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick breath file');
for n = 1:length(datafile);
    cd(pathname);
    load(datafile);
end

breath_srate = 305.176;
kernal = [1 1 1 1 1 1 1 1 1 1];
resp = conv(resp,kernal);
[MAXTAB, MINTAB] = peakdet(resp, 6);
breaths = MINTAB(:,1)/breath_srate;

for i = 1:length(breaths)-1
    brate(i) = breaths(i+1)-breaths(i);
end

x = .1:.02:2;
subplot(2,1,1);hist (brate,x); figure(gcf);
subplot(2,1,2);plot(brate);