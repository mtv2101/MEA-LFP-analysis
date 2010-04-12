tdt_map = [8,16,24,32;...
    7,15,23,31;...
    6,14,22,30;...
    5,13,21,29;...
    4,12,20,28;...
    3,11,19,27;...
    2,10,18,26;...
    1,9,17,25];

numodors = size(sig_breaths_allodors,3);
rows = 8;
cols = 4;
%order_concs = [1 5 4 3 2]; %order of concentrations (event types) from low to high


sum_sigs = squeeze(sum(sig_breaths_allodors(:,:,:,:),1)); %sig_breaths_allodors dimensions (breaths,sigtype,channel,event_type)

% 
% for i=1:numodors
%     for x=1:rows
%         for y=1:cols
%             indx = empirical_map(x,y);
%             remap_sigodors(x,y,i) = sum_sigs(indx,i);
%         end
%     end
%     subplot(numodors,1,i);imagesc(squeeze(remap_sigodors(:,:,i)));
%     hold on;
% end

for x=1:rows
    for y=1:cols
        indx = tdt_map(x,y);
        subplot(rows,cols,(x*cols)-cols+y,'align');
        plot(sum_sigs(indx,:));
    end
end

% for h=1:numodors 
% subplot(numodors,1,h);imagesc(squeeze(sig_breaths_allodors(:,:,h)));
% hold on;
% end
