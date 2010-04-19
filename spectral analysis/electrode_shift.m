shift_size = 100; %in microns
num_shifts = 3; %number of recordings
response_breaths = [12:30]; %breaths from which to count significant responses
odor = 5;
PLOT_SPECS = 1; %this will plot mean spectrograms from all channels for selected odor

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
        spec = squeeze(mean(spec_norm(:,:,:,12,:),3));
        all_spec(:,:,:,pos) = spec;
    end
end

for pos = 1:num_shifts
    spec_max = squeeze(max(max(max(max(all_spec)))));
    spec_min = squeeze(min(min(min(min(all_spec)))));
    figure
    imagesc_mea(all_spec(:,:,:,pos),spec_min,spec_max);
end