function[Corr_Per_Breath]= CorrelationVsDistanceSep25(data,FirstChannel,LastChannel,sampFreq,filttype)

%function outputs the zerolag correlation per breath, (averaging along
%events) in the matrix Corr_Per_Breath(32X32X11 matrix, last dimension is the number of breaths). It is for plotting correlations
%versus distance per channel
data_filtered= filter_data(data, sampFreq,filttype);


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

 Corr_Per_Event(:,:,event)= newmatrix(qq,:,:);                %Check from here, supposed to get the zerolag correlation for all channels, per reference channel, per event
 
end

Corr_Per_Breath(:,:,breath)=mean(Corr_Per_Event,3);           %average over all events to get the breath correlations
end