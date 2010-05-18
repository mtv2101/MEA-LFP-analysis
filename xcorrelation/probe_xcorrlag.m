% input data is "corrtime_breath" output from xcorr_alltoall

tdt_map = [8,16,24,32;...
    7,15,23,31;...
    6,14,22,30;...
    5,13,21,29;...
    4,12,20,28;...
    3,11,19,27;...
    2,10,18,26;...
    1,9,17,25];
rows = size(tdt_map,1);
cols = size(tdt_map,2);

basebreaths = 1:11;
odorbreaths = 13:15;
postbreaths = 16:30;

avelag_odor = mean(mean(corrtime_breath(:,:,:,odorbreaths),4),3);
avelag_base = mean(mean(corrtime_breath(:,:,:,basebreaths),4),3);

for x=1:rows
    for y=1:cols
        indx = tdt_map(x,y);
        plotlag_base(x,y) = mean(avelag_base(:,indx),1);
        plotlag_odor(x,y) = mean(avelag_odor(:,indx),1);
    end
end

lagdiff = plotlag_odor-plotlag_base;
imagesc(lagdiff);colorbar;