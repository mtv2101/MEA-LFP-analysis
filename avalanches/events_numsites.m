srate = 3051.76; %sample rate
dt = 10; %window size in ms
thresh = 1;
inc = floor(dt*srate/1000); %increment window this much
chans = 1:32;

t = 100:inc:size(all_pkslin,1);
s(chans) = nanstd(all_pkslin(:,chans))*thresh;

for n = chans
    for x = 2:length(t)
        aa = find(all_pkslin((t(x-1)):t(x),n) > s(n));
        if length(aa) >= 1;
            sigpks(x,n) = 1;
        else
            sigpks(x,n) = 0;
        end
    end
    disp('site'); disp(n);
end

p = sum(sigpks,2);
pks_hist = hist(p,32)./length(t);
loglog(pks_hist(2:32));



%%%% to do
% 1. find all filtered peaks over a threshold in a window dt
%     - vary thresholds
%     - vary window size
%     - express avalance size as sum of all peak amplitudes
% 2. find all peaks in a window dt where one channel shows a peak above threshold
%     - vary thresholds
%     - vary window size
%     - express avalance size as sum of all peak amplitudes
