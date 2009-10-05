channel = 8;
g_freqs = find(f>0 & f<120);

for i = 1:size(spec_norm,4);

    aa = squeeze(spec_norm(:,:,:,i,channel));
    a = mean(aa,3);
    a_scaled = imagesc_freqscale(a);
    %a_scaled = a;
    subplot(1,size(spec_norm,4),i,'align');
    imagesc(t,f(g_freqs),a_scaled(:,g_freqs)');
    figure(gcf)
end

