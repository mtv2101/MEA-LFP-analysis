function plot_redundant_matrix_August26(average_no_redundant_matrix,FirstBaseBreath,LastBaseBreath,FirstEventBreath,LastEventBreath)
% this function plots the matrix from the function
% Channel_no_redundancymatrix_August18_09 to speed up the plotting. This output, which is called average_no_redundant_matrix(32X32)
%This Channel_no_redundancymatrix_August18_09 function plots all the non
% redundances with all the channels on the rows. We divided it into three parts, the base breaths, the breaths immediately after
%last base breaths, and then the last couple of breaths. Plot for Matt


for xxx=FirstBaseBreath:LastBaseBreath                                                                      %go through base breaths
    base_breaths(:,:,xxx)=average_no_redundant_matrix(:,:,xxx);
end

average_base_breaths=mean(base_breaths,3);                                    %this is what you imagesc, take the average across all base breaths, in this case the first five breaths, this you imagesc


for xx=FirstEventBreath:LastEventBreath                                                          %go through event breaths
    important_variable=FirstEventBreath-1;                                              %for indexing purposes
    event_breaths(:,:,xx-important_variable)=average_no_redundant_matrix(:,:,xx);

end

average_event_breaths=mean(event_breaths,3);                                            %this you imagesc, the average of the event breath zerolag correlations

%{
for yy=LastBaseBreath+3:LastEventBreath
important_variable=6;
event_breaths_late(:,:,yy-important_variable)=average_no_redundant_matrix(:,:,yy);
end
average_event_breaths_late=mean(event_breaths_late,3);

%}

%for plotting the average base_breaths
%versus average event_breaths
j=1;
for j=1:2
    subplot(2,1,j);
    if j==1
        imagesc(average_base_breaths);
        %title('Zerolag Correlation with No Redundancy-Base Breaths') ;
    elseif j==2
        imagesc(average_event_breaths);
        %title('Zerolag Correlation with No Redundancy-Breaths 5-6') ;
        %else j==3
        %imagesc(average_event_breaths_late);
    end
    %title('Zerolag Correlation with No Redundancy') ;
    xlabel('Correlations across channels');
    ylabel('32 Channels');
    colorbar('SouthOutside');
end

