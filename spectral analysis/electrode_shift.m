shift_size = 100; %in microns
num_shifts = 1; %number of recordings
response_breaths = [12:30]; %breaths from which to count significant responses
odor = 3;
PLOT_SPECS = 1; %this will plot mean spectrograms from all channels for selected odor
gamma = [50 100];
g_freqs = find(f>gamma(1) & f<gamma(2));
odor_breath = 13;

% for pos = 1:num_shifts
%     % sequentially open sig_breaths_allodors from each electrode position
%     [datafile, pathname] = uigetfile(...
%         '*.mat',...
%         'Please pick file for each ',...
%         'MultiSelect', 'on');
%     cd(pathname);
%     load(datafile); % name of array must be "sig_breaths_allodors"
%     all_sigs(:,:,:,pos) = sig_breaths_allodors;
%     clear sig_breaths_allodors;
% end

%all_sigs_short = squeeze(sum(all_sigs(response_breaths,:,odor,:),1));

if PLOT_SPECS == 1;
    for pos = 1:num_shifts
        [datafile, pathname] = uigetfile(...
            '*.mat',...
            'Please pick file for each ',...
            'MultiSelect', 'on');
        cd(pathname);
        load(datafile); % name of array must be "sig_breaths_allodors"
        spec_avetrial = squeeze(mean(spec_norm(:,:,:,odor_breath,:),3)); %average over trials
        all_spec_avetrial(:,:,:,pos) = spec_avetrial;
        all_max(pos).position = squeeze(max(max(spec_norm(:,g_freqs,:,odor_breath,:),[],2),[],1));
    end
end

% for pos = 1:num_shifts
%     spec_max = squeeze(max(max(max(max(all_spec_avetrial(:,g_freqs,:,:))))));
%     spec_min = squeeze(min(min(min(min(all_spec_avetrial(:,g_freqs,:,:))))));
%     figure
%     imagesc_mea(all_spec_avetrial(:,:,:,pos),spec_min,spec_max);
% end

for i = 1:num_shifts
    if i == 1;
        a = all_max(i).position;
    else
        a = [a;all_max(i).position];
    end
    for n = 1:size(a,2)
        plot(a(:,n));
        hold on
    end
end