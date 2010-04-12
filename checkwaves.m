channel_one = 5;
channel_two =6;
breath = 14;
breath2 = 3;

srate = 3051.76;  %Hz
winsize = .5;

checked_waves(:,:,1) = wave_segs(:,:,breath,channel_one);
checked_waves(:,:,2) = wave_segs(:,:,breath,channel_two);
checked_waves(:,:,3) = wave_segs(:,:,breath2,channel_one);
checked_waves(:,:,4) = wave_segs(:,:,breath2,channel_two);

max_amp = max(max(max(checked_waves)));
min_amp = min(min(min(checked_waves)));
    a=1;
for i=1:2:size(checked_waves,2)*2 %for each trial
    subplot(size(checked_waves,2),2,i,'align');
    plot(checked_waves(:,a,1),'r');ylim([min_amp max_amp]);
    hold on
    plot(checked_waves(:,a,2),'k');ylim([min_amp max_amp]);
    if a<size(checked_waves,2)
        set(gca,'xticklabel',[]);
        xlabel = 'off';
    else
        xlabel = [0 winsize];
    end  
    subplot(size(checked_waves,2),2,i+1,'align');
    plot(checked_waves(:,a,3),'r');ylim([min_amp max_amp]);
        hold on
    plot(checked_waves(:,a,4),'k');ylim([min_amp max_amp]);
    if a<size(checked_waves,2)
        set(gca,'xticklabel',[]);
        xlabel = 'off';
    else
        xlabel = [0 winsize/srate];
    end    
    a=a+1;
end