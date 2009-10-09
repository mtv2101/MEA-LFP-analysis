function[Channel_resultfinal_zerolag_June24test] = Channel_no_redundancymatrix_zerolag(newA1,FirstChannel,LastChannel)

% this function calculates the correlations between the specified FirstChannel and LastChannel at zerolag and eliminates
% all redundant correlations
% It produces correlations between the specified FirstChannel and LastChannel at the zerolag.
%It additionally plots using imagesc the zerolag correlations
%A is the output of tdt_June24_09 function-the 1537 X 32 matrix with
%correct channel mapping, FirstChannel and LastChannel inputs are the
%specified channels one wants to analyze.


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




u=1;
for y=1:((LastChannel-FirstChannel)+1)

    resultdraft(:,u:(u+(LastChannel-FirstChannel)))=newmatrix1(:,:,y);                %make the three dimension newmatrix into a resultdraft two dimension matrix, this collects all the data into a two d matrix, for the columns we eliminated, matlab  adds a column of zeros
    u=u+((LastChannel-FirstChannel)+1);

end

resultdraft1=resultdraft;




[i,j]=find (resultdraft1==0);                           % we find the columns of zero

vectorR=unique(j);

resultdraft1(:,vectorR)=[];                            % we eliminate the columns of zero and receive the desired result, having elminated all redundancies

resultfinal=resultdraft1;

[qq,ww]=size(newA1);

Channel_resultfinal_zerolag_June24test=resultfinal(qq,:);               %take the zerolag correlations into a new matrix

%imagesc(resultfinal_zerolag_June24test');

%}


end


