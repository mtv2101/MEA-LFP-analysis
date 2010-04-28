function[corr_breath]= xcorr_alltoall(data,FirstChannel,LastChannel,sampFreq,filttype,filtorder)

%function outputs the zerolag correlation per breath, (averaging along
%events) in the matrix Corr_Per_Breath(32X32X11 matrix, last dimension is the number of breaths). It is for plotting correlations
%versus distance per channel
%the data is wavesegs 4d matrix [samples,events,breaths,channels]
%FirstChannel and LastChannel are specified first and last channels
%SampFreq is the sampling frequency, in our case 3051.76
%filttype= filttype for sinofilt.m specifies frequency band e.g. [40 100]
%filtorder is order for SimoFilt.m, 200 typically works best for gamma
data_filtered = filter_data(data,sampFreq,filttype,filtorder);

t0=clock;
for breath=1:size(data,3)     %go over all breaths
    for event=1:size(data,2)      %go through all events
       t1=clock;
        segs = squeeze(data_filtered(:,event,breath,:));
        finalcorr = xcorr(segs,'coeff');
        [qq,ww] = size(segs);
        m=1;
        for x=1:((LastChannel-FirstChannel)+1)          % we are referencing every channels correlation into a separated third dimension
            newmatrix(:,:,x) = finalcorr(:,(m):(m+(LastChannel-FirstChannel)));
            m=m+((LastChannel-FirstChannel)+1);
        end
        corr_event(:,:,event)= newmatrix(qq,:,:);   %Check from here, supposed to get the zerolag correlation for all channels, per reference channel, per event
        t2=etime(clock,t1);
        disp('xcorr_alltoall will complete in t - ', num2str(t2*size(data,3)*size(data,2)-etime(t1,t0)), ' seconds.  Go get some coffee');
    end
    corr_breath(:,:,:,breath)=corr_event;
end
end