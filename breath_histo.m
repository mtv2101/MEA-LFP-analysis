for i = 1:length(breaths)-1
    brate(i) = breaths(i+1)-breaths(i);
end

x = .1:.01:1;
hist (brate,x); figure(gcf)