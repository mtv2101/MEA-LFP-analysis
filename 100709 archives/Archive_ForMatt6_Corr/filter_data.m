function data_filtered= filter_data(data, sampFreq,filttype)

%this function filters the data using SinoFilt function. The inputs are data, which as a 4-d matrix dividing the signal into breaths and events, sampFreq, which
%in our case is 3051.8, and filttype- specifying the desired frequency
%band which for gamma, will always be 2
%the output is data_filtered, which is the filtered data in a 4-d matrix

for Chan =1:length(data(1,1,1,:))                       %go through all chanels
    for i=1:length(data(1,:,1,1))                       %go through all events
        for j=1:length(data(1,1,:,1))                   %go through all breaths
            data_filtered(:,i,j,Chan)=SinoFilt(data(:,i,j,Chan),sampFreq,filttype);    %filter the data
        end
    end
end
