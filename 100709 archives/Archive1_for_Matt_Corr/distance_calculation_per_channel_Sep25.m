function[distance_Chagit]=distance_calculation_per_channel_Sep25(coordinates,FirstChannel, LastChannel, ReferenceChannel,DeadChannel)


%the function calculates distances with respect to a specified Reference
%Channel


if FirstChannel>1
    important_variable=FirstChannel-1;                                 %this will make the indexing correct
else
    important_variable=0;
end



for j=ReferenceChannel,



    for  n=FirstChannel:LastChannel,

        if ((all(n~=DeadChannel)==1) && ((all(j~=DeadChannel)==1)))

            distance_Chagit(:,n-important_variable,1) = sqrt((coordinates(j,1)-coordinates(n,1))^2+(coordinates(j,2)-coordinates(n,2))^2);               %take the coordinates in Excel, and calculates the distances uses the distance formula
        else
            distance_Chagit(:,n-important_variable,j-important_variable)=-1;        %set all deadchannel distances to be -1

        end
    end
end

%{
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
%}
