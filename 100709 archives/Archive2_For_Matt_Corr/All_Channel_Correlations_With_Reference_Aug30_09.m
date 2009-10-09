
function[grid_correlations_averages]= All_Channel_Correlations_With_Reference_Aug30_09(data,FirstChannel,LastChannel,sampFreq,filttype)
%this function outputs the grid_correlations_averages matrix for every reference channel,which is an 8X4X11X32 matrix, 
%where first two dimension are the grid dimensions, the third dimension is the number of breaths, 
%and the last one is the 32 reference channels, so every reference channel
%will have its own grd outline plot. Now this function does NOT plot
%anything, rather it calculates the grid_correlations_averages matrix,
%which is used as an input for the function plot_grid_correlations_Aug31.
%Dividing the two functions like this is meant to speed plotting.
%Final

data_filtered= filter_data(data, sampFreq,filttype);

for reference_channel=1:32
for breath=1:length(data(1,1,:,1))     %go over all breaths
for event=1:length(data(1,:,1,1))      %go through all events
    
[specificbreath_per_event_corr]= Specific_breath_per_event(data_filtered,event,breath);                 %takes the specific breath

[newA1_channel]= Project_tdt_August11_09(specificbreath_per_event_corr,FirstChannel,LastChannel) ;      %reorderees the mapping
 
finalcorr11 = xcorr(newA1_channel,'coeff');   


m=1;
for x=1:((LastChannel-FirstChannel)+1)                                                     % we are referencing every channels correlation into a separated third dimension

    newmatrix(:,:,x)   = finalcorr11(:,(m):(m+(LastChannel-FirstChannel)));
    m=m+((LastChannel-FirstChannel)+1);
end




[qq,ww]=size(newA1_channel);


y=1;
for n=8:-1:1
    grid_correlations_reference_channel(n,1,event)=newmatrix(qq,y,reference_channel);     %the first two dimensions of grid_correlations_reference_channel is the grid with the correlations, the third dimension corresponds to events, which will be averaged later
    y=y+1;
end



t=9;
for b=8:-1:1
    grid_correlations_reference_channel(b,2,event)=newmatrix(qq,t,reference_channel);
    t=t+1;
end


tt=17;

for bb=8:-1:1
    grid_correlations_reference_channel(bb,3,event)=newmatrix(qq,tt,reference_channel);
    tt=tt+1;
end



aa=25;

for ee=8:-1:1
   grid_correlations_reference_channel(ee,4,event)=newmatrix(qq,aa,reference_channel);                          %finish the grid outline of correlations with reference channel
    aa=aa+1;
end

end                            %end of events for loop


grid_correlations_averages(:,:,breath,reference_channel)=mean(grid_correlations_reference_channel,3);                    %take the average across the third dimension, which is the events

end                           %end of breath for loop

end                           %end of reference_channels for loop

%{
for base_breaths=1:4                                                                                    %take the base_breaths, here we are taking the first four breaths
    grid_correlations_base_breaths(:,:,base_breaths)=grid_correlations_averages(:,:,base_breaths);
end

grid_correlations_base_breaths_average=mean(grid_correlations_base_breaths,3);                          %takes the average of the base breaths


for event_breaths=5:11
    important_variable=4;
    grid_correlations_event_breaths(:,:,event_breaths-important_variable)=grid_correlations_averages(:,:,event_breaths);
end

grid_correlations_event_breaths_average=mean(grid_correlations_event_breaths,3);

for car=1:2                                                                         %make a subplot of correlations with bases and event per desired reference channel in a grid according to the mapping
    subplot(2,1,car);
    if car==1 
        imagesc(grid_correlations_base_breaths_average);
    end
    if car==2 
      imagesc(grid_correlations_event_breaths_average);
    end
    
    xlabel('Correlations across grid according to mapping');
    %ylabel('32 Channels');
    colorbar('SouthOutside');
end
        
%}
%{
counter=5;
for all_non_base_breaths=5:11                              %we are taking all non base breaths to begins at breath 5, the rest of the program is for plotting
    
    filenum=counter;                               %an integer number, first file name equals counter
   filenumstring = num2str(counter);              %counter is a number, makes it a string
   string1= '.jpg';
   finalfilenum=(horzcat(filenumstring,string1));    %concactanate horizontally the number with .fig
    
imagesc(grid_correlations_averages(:,:,all_non_base_breaths));
colorbar('SouthOutside');
title('Correlation as a function of channels, ') ;
xlabel('electrode grid'); 


title(num2str(finalfilenum));
saveas(gcf,num2str(finalfilenum));
 counter = counter+1;
open(num2str(finalfilenum));
end

%}




%{
imagesc(grid_correlations_base_breaths_average);                                 %in end, output the base breath correlations
title('Correlation as a function of channels for base breaths (average)');      
xlabel('electrode grid');
colorbar('SouthOutside');

%}
