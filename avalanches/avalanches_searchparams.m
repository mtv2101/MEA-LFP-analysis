dt = 16;
srate = 3051.76;
thresh = 1:.5:3;
chans = 1:32;
breaths = 1:30;
filt = [50 100];

for d = 1:length(thresh);
    [allpeaks av_size perct_filled pks_hist] = find_avalanches(wave_segs,srate,dt,thresh(d),chans,breaths,filt);
    Avalanches.allpeaks{d} = allpeaks; 
    Avalanches.av_size{d} = av_size; 
    Avalanches.perct_filled{d} = perct_filled; 
    Avalanches.pks_hist{d} = pks_hist; 
    Avalanches.srate{d} = srate;
    Avalanches.dt{d} = dt;
    Avalanches.thresh{d} = thresh;
    Avalanches.chans{d} = chans;
    Avalanches.breaths{d} = breaths;
    Avalanches.filt{d} = filt;
    clear allpeaks av_size perct_filled pks_hist;    
end

for d = 1:length(Avalanches.thresh);
    plot_data1(d,:) = Avalanches.pks_hist{d}/length(Avalanches.av_size{d});
    plot_data2 = Avalanches.allpeaks{d};
    sorted_peaks(d,:) = nanmean(sort(plot_data2,2,'descend'),1);
end
% figure
%     loglog(plot_data'); 
% figure
%     plot(sorted_peaks');
