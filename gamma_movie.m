rows = 8;
cols = 4;
% winsize = .5; %size in s of fft analysis window
% time_scale = (size(spec_norm,1))/winsize; %sample rate Hz
% 
% gammadata = squeeze(mean(spec_norm(:,g_freqs,:,:,:),2)); %ave over gamma
% gammadata = squeeze(mean(gammadata,2)); %ave over trials .. gammadata[time,breath,chan)

for i=1:size(gammadata,3) %for all channels
    a = gammadata(:,:,i);
    movie_mat(:,i) = a(:);
end

empirical_map = [5, 2,31,30;...
                16,11,20,17;...
                4, 9,29,19;... %4 is dead
                7,12,18,32;... %12 may equal 14
                3, 6,27,28;...
                14,13,22,21;... %14 may equal 12
                15, 8,23,26;...
                10, 1,24,25];

for x=1:rows
    for y=1:cols
        indx = empirical_map(x,y);
        remap_movie(:,x,y) = movie_mat(:,indx);
    end
end

nframes = size(remap_movie,1);
h = imagesc(squeeze(remap_movie(1,:,:)));
for k = 2:nframes
    h = imagesc(squeeze(remap_movie(k,:,:)));
    M(k) = getframe;
end
movie(M,1,time_scale);