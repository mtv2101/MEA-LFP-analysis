function[finaldistance_Channel]=Channel_distance_calculation(coordinates,FirstChannel, LastChannel,DeadChannel)


%this function calculates the distances between all channels, eliminates
%all redunancies between channels, and then puts it into a row matrix
%called finaldistance_Channel. If you have a dead channel, the function
%will automatically make any distance associated with that channel equal to
%-1, which will be removed in Call all function by removing the first
%entry, which will automatically correspond to the -1 distance, because no
%other distance will be negative.
%the inputs are coordinates-a matrix with all the coordinates of the
%channels imported from excel, FirstChannel, LastChannel, and
%DeadChannel-which can be a number or vector specifying all deadchannels,
%if no deadchannels-input a number that is NOT between FirstChannel and
%LastChannel and it will not be considered


if FirstChannel>1
    important_variable=FirstChannel-1;                                 %this will make the indexing correct
else
    important_variable=0;
end



for j=FirstChannel:LastChannel,



    for  n=j:LastChannel,

        if ((all(n~=DeadChannel)==1) && ((all(j~=DeadChannel)==1)))

            distance_Chagit(:,n-important_variable,j-important_variable) = sqrt((coordinates(j,1)-coordinates(n,1))^2+(coordinates(j,2)-coordinates(n,2))^2);               %take the coordinates in Excel, and calculates the distances uses the distance formula
        else
            distance_Chagit(:,n-important_variable,j-important_variable)=-1;        %set all deadchannel distances to be -1

        end
    end
end


for t=FirstChannel:LastChannel,

    distance_draft(t-important_variable,:)=distance_Chagit(:,:,t-important_variable);   %every distance with different reference channel goes in a row vector
end



a=1;
r=1;
y=(LastChannel-FirstChannel);
for m=1:((LastChannel-FirstChannel+1)),


    finaldistance_Channel(1,r:y+r)=distance_draft(m,a:((LastChannel-FirstChannel)+1));                               %eliminate redundancies in distances and put it into final matrix called finaldistance, which is the vector that is input into position function
    r=r+y+1;
    a=a+1;
    y=y-1;



end

