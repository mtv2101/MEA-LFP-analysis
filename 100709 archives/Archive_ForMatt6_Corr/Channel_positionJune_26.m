function[AverageVector,uniquefinaldistance] = Channel_positionJune_26(finaldistance, finalcorrelations)

%this function correlates the unique distances with there respective
%correlations and then plots distance versus correlation. The inputs are
%finaldistance vector from the function distance_calculationlastJune23_09,
%the final coorelation vector output from the function
%no_redundancymatrix_zerolag_June22_09.

uniquefinaldistance = sort(unique(finaldistance));                      %we take the unique distances and sort them in ascending order, putting them in vector uniquefinaldistance



i=find(finaldistance == mode(finaldistance));                       %find where the distance that occurs the most often happens
l = length(i);                                                     %calculate how many times the most common distance occurs



for a=1:length(uniquefinaldistance)                                              %find the indices where final distance equals the specific unique distance
    indices1(a,1:length(find(finaldistance==uniquefinaldistance(a))))=find(finaldistance==uniquefinaldistance(a));                      %takes indices1, finds the indices where the distance equals the specified unique distance entry, and puts it in a matrix called indices 1
    n = length(indices1(a,:));                                                                                              % indices 1 goes from 1 to how many times the unique distance occured, then we add zeros in the next lines so that matlab will recognize it as a matrix
    if (length(indices1(a,:)) < l)                                                                                         %because the unique positions occur with different frequencies, in order to make a matrix indices1, we add zeros to the ends
        for nn=((n+1):l)
            indices1(a,nn) = 0;
        end
    end
end                                                                                                                           %so with this previous for loop, we get a matrix indices 1 where every row gives the indices of a certain distance, for example, the first row has all the indices where finaldistance=200 micrometers
%for indices1, every row represents the position of where that unique distance is located in finaldistance going from lowest to highest




for Q=1:length(uniquefinaldistance)                             % a is how many unique distances there are
    for w=1:l                   % w=1:l                     %the highest number of occurence for a distance, l was defined previous as length of i
        ka(Q,w)=indices1(Q,w);                              %the positions of the unique distances

        if (ka(Q,w)~=0)

            cm(Q,w)= finalcorrelations(ka(Q,w));
        end
    end
    %takes the correlation value at the index ka
    nnn=length(cm(Q,:));
    if length(cm(Q,:))<l
        for jj=((nnn+1):l)
            cm(Q,jj)=0;
        end
    end
end


for rr=1:length(uniquefinaldistance)                       % length(uniquefinaldistance)               how many unique distances there are      CHANGE HERE!!!!!!!! make it without numbers, put in length of uniquefinaldistance instead

    counter = 0;
    totalsum=0;
    for uu = 1:l                                                    % the highest number of occurence for a distance, l was defined previously as length of i
        if (cm(rr,uu)~=0)
            counter = counter+1;



            totalsum =totalsum+cm(rr,uu);


        end
        totalaverage=totalsum/counter;
        AverageVector(1,rr)= totalaverage ;

    end

end


%plot(uniquefinaldistance,AverageVector);
end

