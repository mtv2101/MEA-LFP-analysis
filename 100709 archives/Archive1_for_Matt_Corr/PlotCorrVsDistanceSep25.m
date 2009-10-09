function[unique_final_distance,average_unique_correlations_base,average_unique_correlations_event]= PlotCorrVsDistanceSep25(Corr_Per_Breath,coordinates,FirstChannel,LastChannel,ReferenceChannel,DeadChannel,FirstBaseBreath,LastBaseBreath,FirstEventBreath,LastEventBreath)

%this is the function that plots correlation vs distance per specific
%reference channel. Final version. It uses the corr _Per_ Breath output
%from CorelationVsDistanceSep25 function and the function called
%distance_calculation_per_channel_sep25
%Final Version
if ((ReferenceChannel>LastChannel) | (ReferenceChannel<FirstChannel))
        error('Reference Channel Should Be Between First and Last Channel')
end

if ((DeadChannel<=LastChannel) & (DeadChannel>=FirstChannel))
        error('There is a DeadChannel, Need to implement addition to this code for this to take all distances of -1 out')
end


[distance_Chagit]=distance_calculation_per_channel_Sep25(coordinates,FirstChannel, LastChannel, ReferenceChannel,DeadChannel);    %calculates distance with respect to reference channel


unique_final_distance=unique(distance_Chagit);          %unique all the distances


for base_breaths=FirstBaseBreath:LastBaseBreath
    base(:,:,base_breaths)=Corr_Per_Breath(:,:,base_breaths);
end

plot_base_breaths=mean(base,3);                          %take the average of correlations across base breath
plot_base_breaths_reference_channel=plot_base_breaths(ReferenceChannel,:);                %the average base breath correlations, with respect to the reference channel

important_variable=FirstEventBreath-1;
for event_breaths=FirstEventBreath:LastEventBreath
    event(:,:,event_breaths-important_variable)=Corr_Per_Breath(:,:,event_breaths);
end
plot_event_breaths=mean(event,3);                                                     %take the average of event breath correlations
plot_event_breaths_reference_channel=plot_event_breaths(ReferenceChannel,:);          %the average event breaths, with respect to reference channel


for i=1:length(unique_final_distance)
    a=find(unique_final_distance(i)==distance_Chagit);                            %find where distance equal all the successive unique distances
    for ii=1:length(a)
        unique_correlations_base(ii)=(plot_base_breaths_reference_channel(a(ii)));   %link the distances to their correlations
    end
    for iii=1:length(a)
        unique_correlations_events(iii)=(plot_event_breaths_reference_channel(a(iii)));
    end
    average_unique_correlations_base(i)=mean(unique_correlations_base);               %this is what you plot, the average correlation with same distance
    average_unique_correlations_event(i)=mean(unique_correlations_events);            %this is what you plot, the average correlation with same distance
end

unique_final_distance=unique_final_distance';                                               %take the transposes of all the matrices for plotting purposes
average_unique_correlations_base=average_unique_correlations_base';
average_unique_correlations_event=average_unique_correlations_event';

plot(unique_final_distance,average_unique_correlations_base,'b');
hold on;


plot(unique_final_distance,average_unique_correlations_event,'r');

title('BaseBreath=Blue   EventBreaths=Red   Correlation Vs. Distance Per Channel')
