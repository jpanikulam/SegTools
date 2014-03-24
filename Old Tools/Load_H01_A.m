load('C:\Users\Jacob\Documents\MATLAB\Workspaces\H01_A.mat')
S='H01_A';
names = fieldnames(eval(S));
for j = 1:length(names)
    eval(strcat(names{j},' = ',S,'.',names{j},';'));
end;
