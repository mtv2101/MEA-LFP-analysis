function data_filtered= filter_wave(data,sampFreq,filttype,filtorder)

%this function filters the data using SinoFilt function. The inputs are data, which as a 4-d matrix dividing the signal into breaths and events, sampFreq, which
%in our case is 3051.8, and filttype- specifying the desired frequency
%band which for gamma, will always be 2
%the output is data_filtered, which is the filtered data in a 4-d matrix

data_filtered = SinoFilt(data,sampFreq,filttype,filtorder);    %filter the data
