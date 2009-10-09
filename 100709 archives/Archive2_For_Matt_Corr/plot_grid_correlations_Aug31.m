function plot_grid_correlations_Aug31(grid_correlations_averages,reference_channel, first_base_breath,last_base_breath, first_event_breath,last_event_breath)
%this function is for plotting purposes, it takes the output from
%All_Channel_Correlations_With_Reference_Aug30_09 called
%grid_correlations_averages, which is a  8     4    11    32, the first two
%dimensions are the grid outlines, the third dimension is the breath, and
%the last dimension is the reference channel. You can specify the first
%base breath, the last base breath, the first event breath, the last event
%breath, ex. 1,3,4,11
%Final

for base_breaths=first_base_breath:last_base_breath                                                                                    %take the base_breaths, here we are taking the first four breaths
    grid_correlations_base_breaths(:,:,base_breaths)=grid_correlations_averages(:,:,base_breaths,reference_channel);
end

grid_correlations_base_breaths_average=mean(grid_correlations_base_breaths,3);                          %takes the average of the base breaths


for event_breaths=first_event_breath:last_event_breath
    important_variable=first_event_breath-1;
    grid_correlations_event_breaths(:,:,event_breaths-important_variable)=grid_correlations_averages(:,:,event_breaths,reference_channel);
end

grid_correlations_event_breaths_average=mean(grid_correlations_event_breaths,3);

for car=1:2                                                                         %make a subplot of correlations with bases and event per desired reference channel in a grid according to the mapping
    subplot(2,1,car);
    if car==1
        imagesc(grid_correlations_base_breaths_average);                          %grid plot for base breaths
    end
    if car==2
        imagesc(grid_correlations_event_breaths_average);                           %grid plot for event breaths
    end

    xlabel('Correlations across grid according to mapping');
    %ylabel('32 Channels');
    colorbar('SouthOutside');
end
