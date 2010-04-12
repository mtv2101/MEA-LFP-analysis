srate = 3051.76; %sample rate
inc = floor(srate/200); %increment window this much

% open all_pkslin.mat
[datafile1, pathname] = uigetfile(...
    '*.mat',...
    'Please pick all_pkslin.mat');
load(datafile1);

t = 100:inc:size(all_pkslin,1);

% sequentially open all channels of wave-peak data
[datafile2, pathname] = uigetfile(...
    '*.mat',...
    'Please pick all wave files',...
    'MultiSelect', 'on');
datafile2 = datafile2([2:32 1]); %fix uigetfile bug, 32chan
for n = 1:length(datafile2)
    load(datafile2{n});
    s(n) = std(peaks)*2;
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