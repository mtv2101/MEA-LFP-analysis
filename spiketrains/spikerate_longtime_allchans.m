clear all
%for x = 1:3;

    %endtime = ceil(max(spikes,[],2))+10; %round down to nearest second
    binsize = 10; %size in seconds

    % sequentially open spike timestamps from each channel
    [datafile, pathname] = uigetfile(...
        '*.mat',...
        'Please pick a wave files for each ',...
        'MultiSelect', 'on');
    cd(pathname);
    datafile = datafile([2:length(datafile) 1]); %fix uigetfile bug, 32channel

    for chan = 1:length(datafile)
        load(datafile{chan}); % name of array must be "spike"
        a(chan) = max(max(spike));
    end

    endtime = max(a,[],1);
    for chan = 1:length(datafile)
        load(datafile{chan}); % name of array must be "spikes"

        %     if spikes < 1000 % don't analyze any channel with fewer than this many spikes
        %         continue
        %     end

        for n = 1:endtime
            a = find(spike > n & n+binsize > spike);
            spikerate(n,chan) = length(a)/binsize;
        end
    end
%end

% for x = 1:3;
%     subplot(3,1,x);
%     imagesc(spikerate(:,:,x)', [0 30]);h = colorbar;%ylabel(datafile);
% end