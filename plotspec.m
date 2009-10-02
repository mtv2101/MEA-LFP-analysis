%baseline_indx = find(brthindx <= 0);
channel = 8;
breath1 = 13;
breath2 = 10;
g_freqs = find(f>50 & f<100);

aa = squeeze(spec_norm(:,:,:,breath1,channel));
a = mean(aa,3)';
a_freq = mean(a,2);

bb = squeeze(spec_norm(:,:,:,breath2,channel));
b = mean(bb,3)';
b_freq = mean(b,2);

% base = mean(spec_norm(:,:,:,baseline_indx,channel),4);
% base_env1 = mean(base,3)';
% base_env = mean(base_env1(:,1:7),2); %dim 2 is time, 1:7 typically is the time before a breath
% scalef = 1./(max(base_env1,[],2))+1;
% 
% for i=1:size(a,1)
%     b(i,:) = a(i,:)-base_env(i);
%     c(i,:) = scalef(i).*(b(i,:));    
% end

subplot(2,1,1);imagesc (t,f(g_freqs),b(g_freqs,:),[-.1 2]);
subplot(2,1,2);imagesc (t,f(g_freqs),a(g_freqs,:),[-.1 2]);
%subplot(3,1,3);semilogy(a_freq,'-r');hold on;semilogy(b_freq,'-k');
figure(gcf)
%imagesc (t,f,a); figure(gcf)