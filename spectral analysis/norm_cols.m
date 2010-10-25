function [data_norm] = norm_cols(data)

%% normalize a 2-d matrix according to the mean of each column

for n=1:size(data,2);
    dat_norm(:,n) = data(:,n)./(mean(data(:,n),1));
end

end