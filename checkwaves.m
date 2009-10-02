channel = 8;
breath = 12;
breath2 = 13;

checked_waves(:,:,1) = wave_segs(:,:,breath,channel);
checked_waves(:,:,2) = wave_segs(:,:,breath2,channel);
max_amp = max(max(max(checked_waves)));
min_amp = min(min(min(checked_waves)));
    a=1;
for i=1:2:size(checked_waves,2)*2 %for each trial
    subplot(size(checked_waves,2),2,i,'align');
    plot(checked_waves(:,a,1));ylim([min_amp max_amp]);
    if a<size(checked_waves,2)
        set(gca,'xticklabel',[]);
        xlabel = 'off';
    else
        xlabel = [0 winsize];
    end  
    subplot(size(checked_waves,2),2,i+1,'align');
    plot(checked_waves(:,a,2));ylim([min_amp max_amp]);
    if a<size(checked_waves,2)
        set(gca,'xticklabel',[]);
        xlabel = 'off';
    else
        xlabel = [0 winsize];
    end    
    a=a+1;
end