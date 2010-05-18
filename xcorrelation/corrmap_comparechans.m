% specific chahnnel correlation maps
%
% chan1 = 14;
% chan2 = 19;

%data = wave_segs; %[corr, corr, trials, breaths]
tdt_map = [8,16,24,32;...
    7,15,23,31;...
    6,14,22,30;...
    5,13,21,29;...
    4,12,20,28;...
    3,11,19,27;...
    2,10,18,26;...
    1,9,17,25];

rows = 8;
cols = 4;
basebreaths = 1:11;
odorbreaths = 13:15;
postbreaths = 16:30;

spec_max = max(max(mean(mean(corr_breath(:,:,:,basebreaths),4),3)));
%spec_max = .3;
spec_min = min(min(mean(mean(corr_breath,4),3)));
    
%chan2map = squeeze(mean(mean(corr_breath(chan2,:,:,:),4),3));
for x=1:rows
    for y=1:cols
        indx = tdt_map(x,y);
        chan1map = squeeze(mean(mean(corr_breath(indx,:,:,:),4),3));
        subplot(rows,cols,(x*cols)-cols+y,'align');
        imagesc_mea(chan1map,0,spec_max);
    end
end
%subplot(2,1,1);imagesc_mea(chan1map);colorbar;
%subplot(2,1,2);imagesc_mea(chan2map);colorbar;