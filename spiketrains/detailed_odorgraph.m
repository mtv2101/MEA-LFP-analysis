%% get detailed graphs of one odor stimulation on one channel

odor = 2;

data = spikerate_abs;% data is [bins, breaths, trials, events]
basebreaths = 1:12;
odorbreaths = 13:17;
post_odor = 18:size(data,2);

alldist = mean(mean(data(:,:,:,odor),3),1);
alldist_sem = std(mean(data(:,:,:,odor),1),0,3)./sqrt(size(data,3));

mean_spikes = errorbar(alldist, alldist_sem);

base_corr = squeeze(mean(data(:,basebreaths,:,:),2)); %transform [bins, breaths, trials, events] to [bins, trials, events]
odor_corr = squeeze(mean(data(:,odorbreaths,:,:),2));
post_corr = squeeze(mean(data(:,post_odor,:,:),2));
lin_base = reshape(base_corr, size(base_corr,1), size(base_corr,2)*size(base_corr,3));
anum = size(lin_base,2)/2; % get half the number of baseline trials
for ii = 1:anum
    corr_lin_base(:,ii) = xcorr(lin_base(:,ii), lin_base(:,(anum+ii)), 'coeff');
    [maxval_lin_base(ii) phase_lin_base(ii)] = max(corr_lin_base(:,ii),[],1);
end

rand_indxone = randperm(size(data,3));
rand_indxtwo = randperm(size(data,3));
for t = 1:size(data,3); %for each trial
    corr_basebase(:,t) = xcorr(base_corr(:,rand_indxone(t),odor), base_corr(:,rand_indxtwo(t),odor), 'coeff');
    corr_baseodor(:,t) = xcorr(base_corr(:,t,odor), odor_corr(:,t,odor), 'coeff');
    corr_basepost(:,t) = xcorr(base_corr(:,t,odor), post_corr(:,t,odor), 'coeff');
    [maxval_basebase(t) phase_basebase(t)] = max(corr_basebase(:,t),[],1);
    [maxval_baseodor(t) phase_baseodor(t)] = max(corr_baseodor(:,t),[],1);
    [maxval_basepost(t) phase_basepost(t)] = max(corr_basepost(:,t),[],1);
end

lin_base = reshape(base_corr, size(base_corr,1), size(base_corr,2)*size(base_corr,3));
anum = size(lin_base,2)/2; % get half the number of baseline trials
for ii = 1:anum
    corr_lin_base(:,ii) = xcorr(lin_base(:,ii), lin_base(:,(anum+ii)), 'coeff');
    [maxval_lin_base(ii) phase_lin_base(ii)] = max(corr_lin_base(:,ii),[],1);
end

n = sqrt(size(data,3));
mean_phases = [mean(phase_lin_base), mean(phase_baseodor), mean(phase_basepost)];
phase_sems = [std(phase_basebase)/n, std(phase_baseodor)/n, std(phase_basepost)/n];

mean_phases = errorbar(mean_phases, phase_sems);