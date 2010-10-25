function[AverageVector1,unique_final_angle_vector_sorted] = Channel_positionangle(final_angle_vector,finalcorrelations)

%this function corresponds the unique angles with there respective
%correlations and then plots correlation versus angle. The inputs are
%final_angle_vector, which is an output from the function
%Channel_angle_calculationJune25_09, and the finalcorrelations input refers
%to the correlation values vector between all channels, which is the output
%from Channel_no_autocorr. The outputs are AverageVector1, which is a row
%vector with the averages of the correlations corresponding to all angles,
%and unique-final_angle_vector, which is a vector of the unique angles in
%ascending order, used for plotting

final_angle_vector_sorted = sort(final_angle_vector);

II = mode(final_angle_vector_sorted);
LL=length(find(final_angle_vector == II));  %find where the angle that occurs the most often happens, so that when we order the angles in rows, we will be able to get a square matrix
unique_final_angle_vector_sorted =unique(final_angle_vector_sorted);
for a=1:length(unique_final_angle_vector_sorted)  %find the indices where final angle equals the specific unique angle
    indices11(a,1:length(find(unique_final_angle_vector_sorted(a)==final_angle_vector)))= find(unique_final_angle_vector_sorted(a)==final_angle_vector) ;         %takes indices1, finds the indices where the angle equals the specified unique angle, and puts it in a matrix called indices 1
    n = length(indices11(a,:));     % indices 1 goes from LL to how many times the unique angle occured, then we add zeros in the next lines so that matlab will recognize it as a matrix
    if (length(indices11(a,:)) < LL) %because the unique angles occur with different frequencies, in order to make a matrix indices1, we add zeros to the ends
        for n=((n+1):LL)
            indices11(a,n) = 0;
        end
    end
end            %so with this previous for loop, we get a matrix indices 1 where every row gives the indices ofa certain angle, for example, the first row has all the indices where angle = 90
%for indices1, every row represents the position of where that unique angle is located in final angle going from lowest to highest

for Q=1:length(unique_final_angle_vector_sorted)   % a is how many unique angles there are
    for w=1:LL                % w=1:LL      %the highest number of occurence for an angle, LL was defined previous as length of i
        ka1(Q,w)=indices11(Q,w);      %the positions of the unique angles
        if (ka1(Q,w)~=0)
            cm1(Q,w)= finalcorrelations(ka1(Q,w));
        end
    end                               %takes the correlation value at the index ka
    nnn=length(cm1(Q,:));
    if length(cm1(Q,:))<LL
        for jj=((nnn+1):LL)
            cm1(Q,jj)=0;
        end
    end
end

for rr=1:length(unique_final_angle_vector_sorted)  % how many unique angles there are
    counter = 0;
    totalsum=0;
    for uu = 1:LL                % uu-1:l the highest number of occurence for an angle, LL was defined previously as length of i
        if (cm1(rr,uu)~=0)
            counter = counter+1;
            totalsum =totalsum+cm1(rr,uu);
        end
    end
    totalaverage=totalsum/counter;
    AverageVector1(1,rr)= totalaverage ;
end
%plot(unique_final_angle_vector_sorted,AverageVector1);
end