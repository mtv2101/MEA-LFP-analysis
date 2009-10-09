
function[channel_correlations,channel_correlations_average,base_breaths_channel_correlations]= All_Channel_Coorelations_With_Reference_Aug18_09_lineplot(data, FirstChannel,LastChannel,reference_channel,sampFreq,filttype,FirstBaseBreath,LastBaseBreath,FirstEventBreath,LastEventBreath)
%this function makes a line plot of the correlations vs.channels with a
%specified reference channel
%channels, the final line plot is the averaged correlations of the same
%breath across all events in the correct grid format. We plot two things, the base breaths and the event breaths on the same figure.
%FINAL

data_filtered= filter_data(data, sampFreq,filttype);


for breath=1:length(data(1,1,:,1))     %go over all breaths
    for event=1:length(data(1,:,1,1))      %go through all events

        [specificbreath_per_event_corr]= Specific_breath_per_event(data_filtered,event,breath);                 %takes the specific breath

        [newA1_channel]= Project_tdt_August11_09(specificbreath_per_event_corr,FirstChannel,LastChannel) ;      %reorders the mapping

        finalcorr11 = xcorr(newA1_channel,'coeff');


        m=1;
        for x=1:((LastChannel-FirstChannel)+1)                                                     % we are referencing every channels correlation into a separated third dimension

            newmatrix(:,:,x)   = finalcorr11(:,(m):(m+(LastChannel-FirstChannel)));
            m=m+((LastChannel-FirstChannel)+1);
        end




        [qq,ww]=size(newA1_channel);                                                            %for zerolag correlations

        for y=1:32
            channel_correlations(y,event)=newmatrix(qq,y,reference_channel);                   %go through all the events and find correlations at zerolag

        end

    end

    channel_correlations_average(:,breath)=mean(channel_correlations,2);              %take the average across events per breath
end


for xxx=FirstBaseBreath:LastBaseBreath                                                                      %go through base breaths

    base_breaths_channel_correlations(:,xxx)=channel_correlations_average(:,xxx);
end

base_breaths_average=mean(base_breaths_channel_correlations,2);                 %plot this, average of base breaths correlation



for xx=FirstEventBreath:LastEventBreath                                                                     %go through all event breaths
    important_variable=FirstEventBreath-1;                                                    %for indexing purposes
    event_breaths_channel_correlations(:,xx-important_variable)=channel_correlations_average(:,xx);
end

event_breaths_average=mean(event_breaths_channel_correlations,2);                %plot this, average of event breaths correlation


channels=[1:32];
channels=channels';


plot(channels,base_breaths_average,'b');



hold on;

plot(channels,event_breaths_average,'r');




title('Correlation as a function of channels, Reference Channel 1') ;
xlabel('32 Channels');
ylabel('Correlations');

end