function [Final_Correlation_Average_Across_Events]= Channel_correlationdistance_specificbreath_allevents_Aug1809(coordinates, data,FirstChannel,LastChannel,DeadChannel,firstbreath,lastbreath,sampFreq,filttype)

%this function takes the average of one breath's correlation vs. distance
%over all events, and then makes a vector finalmatrix with All the breaths,
%so all the correlation averages across all breaths, breaths correlations
%being averaged across all events. 
%this is the matrix with the breaths as columns, the y-axis equal to the
%unique distances, and the color representing correlation
%This is the most recent version-
%Final

indexing_variable=firstbreath-1;
finaldistance_Channel=Channel_distance_calculation(coordinates,FirstChannel, LastChannel,DeadChannel);
data_filtered= filter_data(data, sampFreq,filttype);



for breath=firstbreath:lastbreath;     %go over all breaths
for event=1:length(data(1,:,1,1))      %go through all events


%Channel_new_signal = Channel_average_across_all_events(data, breath,FirstChannel,LastChannel);         %takes the average across all events
%Channel_new_signal = Channel_average_across_all_events(data_filtered, breath,1,32);                         %take the average of all channels so that project_tdt... can have the correct input size, we are taking average of filtered data


[specificbreath_per_event_corr]= Specific_breath_per_event(data_filtered,event,breath);                               %this gives you the output of the specified breath in the specified event you want to look at
[newA1_channel]= Project_tdt_August11_09(specificbreath_per_event_corr,FirstChannel,LastChannel) ;           %uses the August tdt because the  Project_tdt_June24_09 was having indexing problems after demonstration                   




Channel_resultfinal_zerolag_June24test = Channel_no_redundancymatrix_zerolag(newA1_channel,FirstChannel,LastChannel);           %had Channel_new_signal instead of Filtered here! computes zerolag correlations between desired channels

[AverageVector,uniquefinaldistance]= Channel_positionJune_26(finaldistance_Channel,Channel_resultfinal_zerolag_June24test);           %links correlations to their distances, enabling plotting


if ((any(DeadChannel<=LastChannel)==1)&&(any(DeadChannel>=FirstChannel)==1))
    AverageVector(1)=[];                                                   %get rid of all calculations to do with the deadchannel, they correspond to a distance of -1, which will automatic ally be the lowest cause no real distance is negative
    uniquefinaldistance(1)=[];
end


%standard_deviation_AverageVector = std(AverageVector);                   %compute the standard deviation, make sure they are independent,identically distributed samples

%subplot(8,1,event);plot(uniquefinaldistance,AverageVector);


finalmatrix(:,event)=AverageVector';

%set(gca,'xtick',uniquefinaldistance);


%errorbar(AverageVector,standard_deviation_AverageVector);

end



%for t= 1:length(finalmatrix(:,1))      %go through all final correlation values and average
   
        Final_Correlation_Average_Across_Events(:,breath-indexing_variable)=mean(finalmatrix,2);                %this is the matrix with the breaths as columns, the y-axis equal to distance, and the color representing correlation
%end

end

imagesc(Final_Correlation_Average_Across_Events);
colorbar('SouthOutside');