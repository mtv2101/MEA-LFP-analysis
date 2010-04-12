% SinoFilt, modified Matt Valley 110209
%
% Usage: [Filtered,FiltAmp] = SinoFilt(eeg,sampFreq,filttype);
% filttype will be: [lowfreq highfreq]
% This will return the mean of the input
% channels filtered for the filttype

function [Filtered,Filtamp] = SinoFilt(eeg,sampFreq,filttype,filtorder);

Nyquist = sampFreq/2;
MyFilt=fir1(filtorder,filttype/Nyquist);

%fprintf('\nFiltering...\n');%
Filtered = Filter0(MyFilt,eeg);

if (nargout>1)
    FiltHilb = hilbert(Filtered);
    FiltAmp = abs(FiltHilb);
end
