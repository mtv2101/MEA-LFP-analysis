
function[channel_correlations,channel_correlations_average,base_breaths_channel_correlations]= allchan_xcorr(data,FirstChannel,LastChannel,reference_channel,sampFreq,filttype,filtorder,FirstBaseBreath,LastBaseBreath,FirstEventBreath,LastEventBreath)
%this function makes a line plot of the correlations vs.channels with a
%specified reference channel
%channels, the final line plot is the averaged correlations of the same
%breath across all events in the correct grid format. We plot two things, the base breaths and the event breaths on the same figure.
%FINAL
%the data is the wavesegs_July29 4d matrix that you give us from your
%analysis,the first dimension is samples, the second is events, the third
%is breaths, and the fourth is all thirty two channels
%FirstChannel and LastChannel are specified first and last channels
%SampFreq is the sampling frequency, in our case 3051.8
%filttype= filttype for sinofilt, 2 for the gamma band
%FirstChannel and LastChannel are the specified first and last channels
%ReferenceChannel-the speccified channel where are channel distances will
%be calculated with respect to that reference channel
%Deadchannel-Vector or scalar with all deadchannels, if no deadchannels put
%a number that is not between 1 and 32
%FirstBaseBreath and LastBaseBreath=first and last specified base breaths
%FirstEventBreath and LastEventBreath=first and last specified event
%breaths

data_filtered = filter_data(data,sampFreq,filttype,filtorder);

for breath = 1:length(data(1,1,:,1))     %go over all breaths
    for event = 1:length(data(1,:,1,1))      %go through all events
        wavseg = squeeze(data_filtered(:,event,breath,:));
        finalcorr = xcorr(wavseg,'coeff');
        [qq,ww]=size(wavseg);         
        m=1;
        for x=1:size(data,4)   % we are referencing every channels correlation into a separated third dimension
            newmatrix(:,:,x) = finalcorr(:,(m):(m+(LastChannel-FirstChannel)));
            m=m+((LastChannel-FirstChannel)+1);
        end                           %for zerolag correlations
        for y=1:size(data,4)
            channel_correlations(y,event) = newmatrix(qq,y,reference_channel);  %go through all the events and find correlations at zerolag
        end
    end
    channel_correlations_average(:,breath) = mean(channel_correlations,2);      %take the average across events per breath
end

for rr=FirstBaseBreath:LastBaseBreath                                         %go through base breaths
    important_variable_two=FirstBaseBreath-1;
    base_breaths_channel_correlations(:,rr-important_variable_two)=channel_correlations_average(:,rr);
end
base_breaths_average=mean(base_breaths_channel_correlations,2);                 %plot this, average of base breaths correlation
for xx=FirstEventBreath:LastEventBreath                                         %go through all event breaths
    important_variable=FirstEventBreath-1;                                      %for indexing purposes
    event_breaths_channel_correlations(:,xx-important_variable)=channel_correlations_average(:,xx);
end
event_breaths_average=mean(event_breaths_channel_correlations,2);               %plot this, average of event breaths correlation

channels=[1:32];
channels=channels';
plot(channels,base_breaths_average,'b');
hold on;
plot(channels,event_breaths_average,'r');
title('Correlation as a function of channels, Reference Channel 1') ;
xlabel('32 Channels');
ylabel('Correlations');
end