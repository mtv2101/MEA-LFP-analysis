function [h_phase num_sigbreaths] = spike_stats(spikerate_abs);

%% This code will apply two statistical tests to vectors of spike-rates (spikes per bin within a breath cycle)
%%
%%  The Kolmogorov-Smirnov test to compare the distribution of two samples is used to compare the vector
%%  of spikerates within a breath window between all baseline breaths and all breaths.
%%  This test shuffles the distributions and asks if the test distribution is drawn from the shuffled distributions.
%%  This tests if the firing rate over the entire breath is significantly different upon odor stimulation, and
%%  is thus a non-parametric way of handling with variable firing rates at different phases of breathing.
%%
%%  Use two-tailed t-test to test difference in mean time of max cross-correlation between spikerate curves of:
%%  1. baseline xcorr odor and 2. half baseline events and the other half of baseline events (each half is essentially randomly
%%  distributed across the experiment).  This time of max corss-corrrelation is essentially the phase differenec between the curves.
%%  This cross-correlation of baseline to baseline IS NOT an auto-correlation, seperate events are chosen, in this way it similar to bootstrapping.
%%
%% Written by Matt Valley, April 2010

alpha = .01;
data = spikerate_abs;
basebreaths = 1:12;
odorbreaths = 13:17;
post_odor = 18:size(data,2);
binsize = 10; %make this the binsize of absolute bins (in ms)
analysis_win = (1:size(data,1)); %cur off first and last 100ms from analysis - to avoid applying stats to the next or previous breath
corr_win = (size(data,1)*.6):1:(size(data,1)*2)-(size(data,1)*.6);

for i = 1:size(data,4) %for each odor
    for n = 1:size(data,2); %for each breath
        basedist = data(analysis_win,basebreaths,:,i);
        basedist_lin = basedist(:);
        testdist = squeeze(data(analysis_win,n,:,i));
        testdist_lin = testdist(:);
        [h p_rank] = kstest2(basedist_lin, testdist_lin, alpha/size(data,2)); %Kolmogorov-Smirnov test - apply bonferroni correction - divide alpha by "n" (num breaths)
        allp_rank(i,n) = p_rank;
        all_h(i,n) = h;
    end
    num_sigbreaths(i) = sum(all_h(i,(odorbreaths(1):size(data,2))));
end

base_corr = squeeze(mean(data(analysis_win,basebreaths,:,:),2)); %transform [bins, breaths, trials, events] to [bins, trials, events]
odor_corr = squeeze(mean(data(analysis_win,odorbreaths,:,:),2));
post_corr = squeeze(mean(data(analysis_win,post_odor,:,:),2));
lin_base = reshape(base_corr, size(base_corr,1), size(base_corr,2)*size(base_corr,3));
anum = size(lin_base,2)/2; % get half the number of baseline trials
%%%snum must be eve, add error checking for odd%%
for ii = 1:anum
    corr_lin_base(:,ii) = xcorr(lin_base(:,ii), lin_base(:,(anum+ii)), 'coeff');
    [maxval_lin_base(ii) phase_lin_base(ii)] = max(corr_lin_base(:,ii),[],1);
end
% rand_indxone = randperm(size(data,3));
% rand_indxtwo = randperm(size(data,3));
for i = 1:size(data,4) %for each odor
    for t = 1:size(data,3); %for each trial
        corr_baseodor(:,t,i) = xcorr(base_corr(:,t,i), odor_corr(:,t,i), 'coeff');
        corr_basepost(:,t,i) = xcorr(base_corr(:,t,i), post_corr(:,t,i), 'coeff');
        [maxval_baseodor(t,i) phase_baseodor(t,i)] = max(corr_baseodor(:,t,i),[],1);
        [maxval_basepost(t,i) phase_basepost(t,i)] = max(corr_basepost(:,t,i),[],1);
    end
    [h_phase(:,i),sig_phase(:,i),stats_phase(:,i)] = ttest2(phase_lin_base,phase_baseodor(:,i)',alpha);
end
end