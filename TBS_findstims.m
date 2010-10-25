srate = 3051.76;

a = find(wave>150);
n=1;
for i = 2:length(a)
    if a(i) > a(i-1)+6000 %| a(i+1) > a(i)+6000
        stims(n) = a(i);
        n=n+1;
    end
end

% sequentially open all channels
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick a wave files for each ',...
    'MultiSelect', 'on');
cd(pathname);
datafile = datafile([2:32 1]); %fix uigetfile bug, 32chan

for n = 1:length(datafile); %n to number of channels
    load(datafile{n}); % name of array must be "wave"
    wave_filt = filter_wave(wave,srate,[20 500],200);
    for s = 1:length(stims); %s to number of stimulations
        base = mean(wave_filt((stims(s)-30):(stims(s)-1),:),1);
        peak(s,n) = max(wave_filt((stims(s)+10):(stims(s)+40))) - base;
        area1 = wave_filt((stims(s):stims(s)+50)) - base;
        pos_vals = sign(area1);
        for i=1:length(area1)
            if pos_vals(i) == 1
                area2(i) = area1(i);
            else
                area2(i) = 0;
            end
        end
        area(s,n) = sum(area2);
        wave_snips(:,s,n) = wave_filt((stims(s)-20):(stims(s)+200));
    end
    for i = 1:length(stims)
        peak_base(i,n) = mean(peak((3:30),n),1);
        area_base(i,n) = mean(area((3:30),n),1);
        peak_norm(i,n) = peak(i,n)./peak_base(i,n);
        area_norm(i,n) = area(i,n)./area_base(i,n);
    end
end

% for n = 1:size(peak,2);
% scatter(stims(3:size(stims,2)-3)./srate, area_norm(3:(size(area_norm,1))-3,n),5,'k');
% hold on
% end

kernal = [1;1;1;1;1];

for n = 1:size(peak,2);
    peak_smooth(:,n) = conv(peak_norm(:,n),kernal)/5;
    area_smooth(:,n) = conv(area_norm(:,n),kernal)/5;
scatter(stims(3:size(stims,2)-3)./srate, area_smooth(5:(size(area_smooth,1))-5,n),5,'k');
hold on;
end

% tdt_map = [8,16,24,32;...
%     7,15,23,31;...
%     6,14,22,30;...
%     5,13,21,29;...
%     4,12,20,28;...
%     3,11,19,27;...
%     2,10,18,26;...
%     1,9,17,25];
% 
% rows = 8;
% cols = 4;
% gam_max = max(max(max(wave_snips)));
% gam_min = min(min(min(wave_snips)));
% for x=1:rows
%     for y=1:cols
%         indx = tdt_map(x,y);
%         subplot(rows,cols,(x*cols)-cols+y,'align');
%         imagesc(wave_snips(:,:,indx), [gam_min gam_max]);
%     end
% end