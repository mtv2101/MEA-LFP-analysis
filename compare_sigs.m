% empirical map collected on July 1-2 by Armen and Matt by systematically pulling electrode out of solution one electrode at a time.  
empirical_map = [5, 2,31,30;...
                16,11,20,17;...
                 4, 9,29,19;... %4 is dead
                 7,12,18,32;... %12 may equal 14
                 3, 6,27,28;...
                14,13,22,21;... %14 may equal 12
                15, 8,23,26;...
                10, 1,24,25]; 

numodors = size(sig_breaths_allodors,4);
rows = 8;
cols = 4;
% for i=1:numodors
%     for x=1:rows
%         for y=1:cols
%             indx = empirical_map(x,y);
%             remap_sigodors(:,x,y,i) = sig_breaths_allodors(:,indx,i);
%         end
%     end
% end

for h=1:numodors 
subplot(numodors,1,h);imagesc(squeeze(sig_breaths_allodors(:,2,:,h)));
hold on;
end
