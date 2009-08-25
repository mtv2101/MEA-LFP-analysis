kernal = [1 1 1 1 1 1 1 1 1 1];
resp = conv(resp,kernal);
[MAXTAB, MINTAB] = peakdet(resp, 10);

for i = 1:length(breaths)-1
    brate(i) = breaths(i+1)-breaths(i);
end

x = .1:.01:1;
subplot(2,1,1);hist (brate,x); figure(gcf);
subplot(2,1,2);plot(brate);