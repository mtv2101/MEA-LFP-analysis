function [newA1_channel] = remap2(A, FirstChannel, LastChannel)

nn_map= [5,2,31,30;...     %the correct mapping
    16,11,20,17;...
    4,9,29,19;...
    7,12,18,32;...
    3,6,27,28;...
    14,13,22,21;...
    15,8,23,26;...
    10,1,24,25];

rows = 8;
cols = 4;
for x=1:rows
    for y=1:cols
        indx = nn_map(x,y);
        newA1_channel(:,((x*cols)-cols+y)) = A(:,indx);
    end
end
end