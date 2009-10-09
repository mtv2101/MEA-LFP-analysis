function[average_no_redundant_matrix] = Channel_no_redundancymatrix_August18_09(data,FirstChannel,LastChannel,sampFreq,filttype,FirstBaseBreath,LastBaseBreath,FirstEventBreath,LastEventBreath)

%This is a matrix for Matt the has one the rows the all the correlations
%between all the channels at zerolag, with the redundancies equal to 0. So
%it will output a 32X32 matrix, with the first row having all correlations
%in reference to the first channels, second row having all correlations in
%reference to second channels, but no correlation between first channel and second channel because it is redundance etc.
%The redundancies equal to 0.
%newA1 is the matrix with the reordered mapping, the output from
%project_tdt_August11_09
%Final


data_filtered= filter_data(data, sampFreq,filttype);

for breath=1:length(data(1,1,:,1))     %go over all breaths
    for event=1:length(data(1,:,1,1))      %go through all events

        [specificbreath_per_event_corr]= Specific_breath_per_event(data_filtered,event,breath);                 %takes the specific breath

        [newA1]= Project_tdt_August11_09(specificbreath_per_event_corr,FirstChannel,LastChannel) ;      %reorderees the mapping


        finalcorr11 = xcorr(newA1,'coeff');                                                 % use matlab command to find the correlations between all channels, including redundancies, and normalized


        m=1;
        for x=1:((LastChannel-FirstChannel)+1)                                                     % we are referencing every channels correlation into a separated third dimension

            newmatrix(:,:,x)   = finalcorr11(:,(m):(m+(LastChannel-FirstChannel)));
            m=m+((LastChannel-FirstChannel)+1);
        end





        r=0;

        for t=2:((LastChannel-FirstChannel)+1)                          %don't eliminate anything on first dimension, we eliminate all redundant channels, the first one won't have any redunant, the second will have one redundant, and so on
            r = r+1;

            newmatrix(:,1:r,t)=0;
            newmatrix1=newmatrix;
        end



        [qq,ww]=size(newA1);                      %for zerolag correlations


        index=1;
        for rr=1:((LastChannel-FirstChannel)+1)
            no_redundant_matrix(index,:,event)=newmatrix1(qq,:,rr);                   %for zerolag correlations
            index=index+1;
        end

    end

    average_no_redundant_matrix(:,:,breath)=mean(no_redundant_matrix,3);           %take the average across events for one breath and store it into third dimension corresponding to the specific breath
end


for xxx=FirstBaseBreath:LastBaseBreath                                                                      %go through base breaths
    base_breaths(:,:,xxx)=average_no_redundant_matrix(:,:,xxx);
end

average_base_breaths=mean(base_breaths,3);                                    %this is what you imagesc, take the average across all base breaths, in this case the first five breaths, this you imagesc


for xx=FirstEventBreath:LastEventBreath                                                           %go through event breaths
    important_variable=FirstEventBreath-1;                                              %for indexing purposes
    event_breaths(:,:,xx-important_variable)=average_no_redundant_matrix(:,:,xx);

end

average_event_breaths=mean(event_breaths,3);                                            %this you imagesc, the average of the event breath zerolag correlations




%for plotting the average base_breaths
%versus average event_breaths
j=1;
for j=1:2
    subplot(2,1,j);
    if j==1
        imagesc(average_base_breaths);
        title('Zerolag Correlation with No Redundancy-Base Breaths') ;
    else
        imagesc(average_event_breaths);
        title('Zerolag Correlation with No Redundancy-Breaths 5-6') ;
    end
    %title('Zerolag Correlation with No Redundancy') ;
    xlabel('Correlations across channels');
    ylabel('32 Channels');
    colorbar('SouthOutside');
end

