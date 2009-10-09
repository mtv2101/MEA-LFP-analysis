function [newA1_channel]= Project_tdt_June24_09(A, FirstChannel, LastChannel)

%this function remaps the channels to the correct mapping. the inputs are
%A-which is a 1527 X 32 matrix, (1527 corresponding to the number of
%samples in a breath and 32 to the number of channels). FirstChannel and
%LastChannel are the channels that one wants to analyze. The output is
%newA1_channel, which is also a 1527 X 32 matrix, this time with the
%correct mapping of the channels.


tdt_map = [8,16,24,32;...                          %the incorrect map going in
    7,15,23,31;...
    6,14,22,30;...
    5,13,21,29;...
    4,12,20,28;...
    3,11,19,27;...
    2,10,18,26;...
    1,9,17,25];
%{
nn_map = [5,13,21,29;...
4,12,20,28;...
6,14,22,30;...
3,11,19,27;...
7,15,23,31;...
2,10,18,26;...
8,16,24,32;...
1,9,17,25];
%}


nn_map= [5,2,31,30;...        %the correct mapping
    16,11,20,17;...
    4,9,29,19;...
    7,12,18,32;...
    3,6,27,28;...
    14,13,22,21;...
    15,8,23,26;...
    10,1,24,25];

%{
nn_map1= [10,1,24,25;
15,8,23,26;
14,13,22,21;
3,6,27,28;
7,12,18,32;
4,9,29,19;
16,11,20,17;
5,2,31,30];
%}




z=1;
for c=1:4

    for b=1:8
        newtdt_map(1,z) =  tdt_map(b,c);
        z = z+1;
    end
end



zz=1;
for cc=1:4

    for bb=1:8
        newnn_map(1,zz) =  nn_map(bb,cc);
        zz = zz+1;
    end
end



for a=1:32
    tdt_map(a);
    nn_map(a);

    newA1(:,newtdt_map(a))= A(:,newnn_map(a));
end



if FirstChannel>1
    important_variable=FirstChannel-1;                                 %this will make the indexing always begins at one later in the program
else
    important_variable=0;
end


for i=FirstChannel:LastChannel
    newA1_channel(:,i-important_variable)=newA1(:,i);
end


end
