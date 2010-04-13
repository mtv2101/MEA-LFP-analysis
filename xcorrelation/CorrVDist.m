function[corrs_distances]= CorrVDist(Corr_Per_Breath,coordinates,FirstChannel,LastChannel,ReferenceChannel,DeadChannel)

%this is the function that plots correlation vs distance per specific
%reference channel. Final version. It uses the corr _Per_ Breath output
%from xcorr_alltoall function and the function called
%distcalc_perchan. In order to run this, it is
%necessary to run the xcorr_alltoall function first and obtain
%the output. 
%Corr_Per_Breath=the output from CorrelationVsDistanceSep25 function,
%(32X32X11 matrix, last dimension is the number of breaths)
%the coordinates input is the excel file we sent you with the x and y
%coordinates of the channels
%FirstChannel and LastChannel are the specified first and last channels
%ReferenceChannel-the speccified channel where are channel distances will
%be calculated with respect to that reference channel
%Deadchannel-Vector or scalar with all deadchannels, if no deadchannels put
%a number that is not between 1 and 32

if ((ReferenceChannel>LastChannel) | (ReferenceChannel<FirstChannel))
        error('Reference Channel Should Be Between First and Last Channel')
end

if ((DeadChannel<=LastChannel) & (DeadChannel>=FirstChannel))
        error('There is a DeadChannel, Need to implement addition to this code for this to take all distances of -1 out')
end

[distance_Chagit]=distcalc_perchan(coordinates,FirstChannel, LastChannel, ReferenceChannel,DeadChannel);    %calculates distance with respect to reference channel
unique_final_distance=unique(distance_Chagit);%%%%ARRGRRRRRRGRGRGRRGGR!!!          %unique all the distances
unique_corrs = squeeze(Corr_Per_Breath(ReferenceChannel,:));

for i=1:length(unique_final_distance)
    a=find(unique_final_distance(i)==distance_Chagit);                            %find where distance equal all the successive unique distances
    for ii=1:length(a)
        unique_corrdist(ii)=(unique_corrs(a(ii)));   %link the distances to their correlations       
    end
    aveunique_corrdist(i) = mean(unique_corrdist);
    clear a;
end

corrs_distances = [aveunique_corrdist; unique_final_distance]; %2 column vectors with correlations and distances, for scatter plotting