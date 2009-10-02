% Opens Spec_norm output of parse_xchan FFT analysis
% Opens sequentailly each Spec_norm representing one odor concentration
% Spec_norm is spectral power with dimensions (time, frequency, trial, breath, channel)
% sequentially open all channels

% [datafile, pathname] = uigetfile(...
%     '*.mat',...
%     'Please pick a spec_norm files for each ',...
%     'MultiSelect', 'on');
% cd(pathname);
% datafile = datafile([2:length(datafile) 1]); %fix uigetfile bug, 32chan
% 
% for n = 1:length(datafile); %n to number of channels
%     load(datafile{n}); % name of array must be "spec_norm"    
% end

aveallgamma_allodors = cat(4,aveallgamma_allodors,aveallgamma_allodors(:,:,:,1));
aveallgamma_allodors(:,:,:,1) = [];
aveallgamma_allodors = squeeze(aveallgamma_allodors);

sig_breaths_allodors = squeeze(sig_breaths_allodors);
sig_breaths_allodors = cat(3,sig_breaths_allodors,sig_breaths_allodors(:,:,1));
sig_breaths_allodors(:,:,1) = [];
sig_breaths_allodors = squeeze(sig_breaths_allodors);

maxpower = squeeze(max(aveallgamma_allodors,[],1));
sigmaxpower = sig_breaths_allodors.*maxpower;

sum_sigs = squeeze(sum(sig_breaths_allodors(:,:,:),1));

maxpower_base = squeeze(mean(maxpower(1:10,:,:),1));
maxpower_odor = squeeze(mean(maxpower(13:18,:,:),1)); %specify breaths with odor response
maxpower_norm = (maxpower_odor)-(maxpower_base);

sigmaxpower_base = squeeze(mean(sigmaxpower(1:10,:,:),1));
sigmaxpower_odor = squeeze(mean(sigmaxpower(13:18,:,:),1)); %specify breaths with odor response
sigmaxpower_norm = (sigmaxpower_odor)-(sigmaxpower_base);

% subplot(2,1,1);imagesc(maxpower_norm);
% subplot(2,1,2);imagesc(sigmaxpower_norm);



empirical_map = [5, 2,31,30;...
                16,11,20,17;...
                 4, 9,29,19;... %4 is dead
                 7,12,18,32;... %12 may equal 14
                 3, 6,27,28;...
                14,13,22,21;... %14 may equal 12
                15, 8,23,26;...
                10, 1,24,25]; 

numodors = size(sig_breaths_allodors,3);
rows = 8;
cols = 4;
ymin = min(min(maxpower_norm));
ymax = max(max(maxpower_norm));
for x=1:rows
    for y=1:cols
        indx = empirical_map(x,y);
        subplot(rows,cols,(x*cols)-cols+y,'align');        
        plot(maxpower_norm(indx,:));
            ylim([ymin ymax]);
    end
end
