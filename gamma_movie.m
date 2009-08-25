function [M] = gamma_movie(g_freqs,aveallgamma);

rows = 8;
cols = 4;
winsize = .5; %size in s of fft analysis window
time_scale = (size(aveallgamma,1))/winsize; %sample rate Hz
sparsen_factor = 2;
slow_rate = 2; %slow down real time by this factor
playback_rate = time_scale/(sparsen_factor*slow_rate);

% gammadata = squeeze(mean(spec_norm(:,g_freqs,:,:,:),2)); %ave over gamma
% gammadata = squeeze(mean(gammadata,2)); %ave over trials .. gammadata[time,breath,chan)

for i=1:size(aveallgamma,3) %for all channels
    a = aveallgamma(:,:,i);
    movie_mat(:,i) = a(:);
end

sparsenv = 1:sparsen_factor:size(movie_mat,1);
movie_mat2 = movie_mat(sparsenv,:);

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
        remap_movie(:,x,y) = movie_mat2(:,indx);
    end
end

nframes = size(remap_movie,1);
h = imagesc(squeeze(remap_movie(1,:,:)));
for k = 2:nframes
    h = imagesc(squeeze(remap_movie(k,:,:)));
    M(k) = getframe;
end
movie(M,1,playback_rate);

end