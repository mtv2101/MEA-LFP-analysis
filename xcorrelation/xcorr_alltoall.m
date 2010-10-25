function[corr_breath corrtime_breath]= xcorr_alltoall(data,FirstChannel,LastChannel,sampFreq,filttype,filtorder)

%function outputs the zerolag correlation per breath, (averaging along
%events) in the matrix Corr_Breath [corrs, corrs, trials, breaths]
%versus distance per channel
%the data is wavesegs 4d matrix [samples,events,breaths,channels]
%FirstChannel and LastChannel are specified first and last channels
%SampFreq is the sampling frequency, in our case 3051.76
%filttype= filttype for sinofilt.m specifies frequency band e.g. [40 100]
%filtorder is order for SimoFilt.m, 200 typically works best for gamma

corr_win = 30; %window in which to find max correlation, in samples
breath_window = floor((size(data,1)/2)-size(data,1)/4):((size(data,1)/2)+size(data,1)/4);
data_filtered = filter_data(data,sampFreq,filttype,filtorder);

t0=clock;
for breath=1:size(data,3)     %go over all breaths
    for event=1:size(data,2)      %go through all events
       t1=clock;
        segs = squeeze(data_filtered(breath_window,event,breath,:));
        finalcorr = xcorr(segs,'coeff');
        [qq,ww] = size(segs);
        m=1;
        for x=1:((LastChannel-FirstChannel)+1)% we are referencing every channels correlation into a separated third dimension
            newmatrix(:,:,x) = finalcorr(:,(m):(m+(LastChannel-FirstChannel)));
            m=m+((LastChannel-FirstChannel)+1);
        end
        corr_event(:,:,event) = squeeze(max(newmatrix((qq-corr_win/2):(qq+corr_win/2),:,:),[],1));%get max correlation in window around time zero
        [C max_index] = max(newmatrix,[],1);
        max_index = squeeze(max_index)-qq;
        corrtime_event(:,:,event) = max_index;
        t2=etime(clock,t1);
        ['xcorr_alltoall will complete in t - ', num2str(t2*size(data,3)*size(data,2)-etime(t1,t0)), ' seconds.  Go get some coffee']
    end
    corr_breath(:,:,:,breath)=corr_event;
    corrtime_breath(:,:,:,breath)=corrtime_event;
end
end