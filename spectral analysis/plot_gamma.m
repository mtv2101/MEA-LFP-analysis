tdt_map = [8,16,24,32;...
    7,15,23,31;...
    6,14,22,30;...
    5,13,21,29;...
    4,12,20,28;...
    3,11,19,27;...
    2,10,18,26;...
    1,9,17,25];
    
% nn_map = [5,13,21,29;...
%     4,12,20,28;...
%     6,14,22,30;...
%     3,11,19,27;...
%     7,15,23,31;...
%     2,10,18,26;...
%     8,16,24,32;...
%     1,9,17,25];

rows = 8;
cols = 4;
odor = 5;

aveallgamma = aveallgamma_allodors(:,:,:,odor);
sig_breaths = sig_breaths_allodors(:,:,odor);

aveallgamma_sigs = aveallgamma;
 aveallgamma_sigs(size(aveallgamma_sigs,1)+1,:,:) = squeeze(sig_breaths); %concatenate significance binaries to specs
 aveallgamma_sigs(size(aveallgamma_sigs,1)+1,:,:) = squeeze(sig_breaths);
 aveallgamma_sigs(size(aveallgamma_sigs,1)+1,:,:) = squeeze(sig_breaths);
 aveallgamma_sigs(size(aveallgamma_sigs,1)+1,:,:) = squeeze(sig_breaths);

gam_max = max(max(max(aveallgamma)));
gam_min = min(min(min(aveallgamma)));
for x=1:rows
    for y=1:cols
        indx = tdt_map(x,y);
        subplot(rows,cols,(x*cols)-cols+y,'align');
        imagesc(aveallgamma_sigs(:,:,indx), [gam_min gam_max]);
    end
end

% gam_max = max(max(max(aveallgamma)));
% gam_min = min(min(min(aveallgamma)));
% for x=1:rows
%     for y=1:cols
%         indx = tdt_map(x,y);
%         subplot(rows,cols,(x*cols)-cols+y,'align');
%         imagesc(aveallgamma(:,:,indx), [gam_min gam_max]);
%     end
% end