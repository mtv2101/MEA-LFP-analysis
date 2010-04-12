function[distance_Chagit]=distcalc_perchan(coordinates,FirstChannel, LastChannel, ReferenceChannel,DeadChannel)

%the function calculates distances with respect to a specified Reference Channel
%the coordinates input is the excel file we sent you with the x and y
%coordinates of the channels
%FirstChannel and LastChannel are the specified first and last channels
%ReferenceChannel-the speccified channel where are channel distances will
%be calculated with respect to that reference channel
%Deadchannel-Vector or scalar with all deadchannels, if no deadchannels put
%a number that is not between 1 and 32

if FirstChannel>1
    important_variable=FirstChannel-1; %this will make the indexing correct
else
    important_variable=0;
end

for j=ReferenceChannel,
    for  n=FirstChannel:LastChannel,
        if ((all(n~=DeadChannel)==1) && ((all(j~=DeadChannel)==1)))
            distance_Chagit(:,n-important_variable,1) = sqrt((coordinates(j,1)-coordinates(n,1))^2+(coordinates(j,2)-coordinates(n,2))^2);%take the coordinates in Excel, and calculates the distances uses the distance formula
        else
            distance_Chagit(:,n-important_variable,j-important_variable)=-1;%set all deadchannel distances to be -1
        end
    end
end