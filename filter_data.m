%this function filters the data using SinoFilt function. The inputs are data, which as a 4-d matrix dividing the signal into breaths and events, sampFreq, which
%in our case is 3051.8, and filttype- specifying the desired frequency
%band which for gamma, will always be 2
%the output is data_filtered, which is the filtered data in a 4-d matrix
%-----comment above by Matt Valley

%Armen Enikolopov 5/18/2010
%  rewrote this so as to avoid 3 nested for loops 
%  by reshaping 4D matrix to a 2D matrix
%  a ~10x speed increase is achieved when used on current data.

function data_filtered= filter_data(data,sampFreq,filttype,filtorder)
    orig_size = size(data);
    % new shape is [time x (event*breath*chan)]
    size2D = [orig_size(1), prod(orig_size(2:end))];
    data2D = reshape(data, size2D);
    data2D_filtered = SinoFilt(data2D,sampFreq,filttype,filtorder);
    data_filtered = reshape(data2D_filtered,orig_size);
 end