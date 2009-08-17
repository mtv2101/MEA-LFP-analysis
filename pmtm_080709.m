function [spectrogram t f] = pmtm_080709(wave,Fs,maxfreq)
%This function takes a multiple wave vectors, each coming fom a trial of
%the same stimilus, and outputs the max gamma oscillatory power during each
%trial, along with the time and fequency scales of the pmtm analysis

winsize = .1;
stepsize = .005;

%% Do PMTM anlysis
params.tapers = [4 5];                          
params.Fs = Fs;
params.fpass = [5 maxfreq];
% for i=1:size(wave,2);                    
%     [a,t,f] =  mtspecgramc(squeeze(wave(:,i)),[winsize stepsize],params);   
%     spectrogram(:,:,i) = a;                               
% end

[a,t,f] =  mtspecgramc(wave,[winsize stepsize],params);   
spectrogram = a;    
    
% %% Normalize Spectral density by frequency (over all trials), expresses as Db
% for i=1:size(spec,2); %iterate over frequency dim
%     a = mean(spec(:,i,:),1); %average power for each frequency band (ave over time)
%     fmean(i) = mean(a,3); %average this over all trials    
%     spec_norm(:,i,:) = 10.*(log10(spec(:,i,:)./fmean(i))); %normalize freq band to ave power of all trials - express as dB change
% end
% spec_mean = spec_norm;
%spec_mean = mean(spec_norm,3); %average over all trials

%% Plot
% g_freqs = find(f>40 & f<100);
% gammaplot = squeeze(mean(spec_norm(:,g_freqs,:),2));
% allgamma = mean(gammaplot,2);
% specplot = mean(spec_norm,3);
% subplot(3,1,1);imagesc(gammaplot');
% subplot(3,1,2);imagesc(specplot');
% subplot(3,1,3);plot(t,allgamma);
end