function [spectrogram t f] = pmtm_cust(wave,Fs,maxfreq)
%This function takes a multiple wave vectors, each coming fom a trial of
%the same stimilus, and outputs the max gamma oscillatory power during each
%trial, along with the time and fequency scales of the pmtm analysis

winsize = .2;
stepsize = .01;

%% Do PMTM anlysis
params.tapers = [5 7];                          
params.Fs = Fs;
params.fpass = [5 maxfreq];

[a,t,f] =  mtspecgramc(wave,[winsize stepsize],params);   
spectrogram = a;    

end