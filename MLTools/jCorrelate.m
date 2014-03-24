function [Ptable, crl] = jCorrelate(data1, data2, reference)
%Data1, Data2, binary

if(numel(data1) ~= numel(data2))
    throw('Size mismatch');
end

% correlatrix = [data1(:);data2(:);reference(:)];

correlatrix = zeros(3,numel(data1)); %3 down n long


for k = 1:numel(data1)
    correlatrix(:,k) = [round(double(data1(k))*10)/10; round(double(data2(k))*10)/10; double(reference(k))];
end
crl = correlatrix;    
% Ptable = zeros(size(unique(correlatrix)));
% Ptable = zeros(size( unique(correlatrix(1:2,:)) ));

Ptable = [];

for z = unique(correlatrix(1:2,:)', 'rows')'
    same1 = correlatrix(1,:) == z(1);
    same2 = correlatrix(2,:) == z(2);
    same = logical(same1 & same2);
    %correlatrix(same);
    trues = correlatrix(3,same) == 1;
    falses = correlatrix(3,same) == 0;
    %amtTrue = numel(correlatrix(:,trues))
    %amtFalse = numel(correlatrix(:,falses))
    
    amtTrue = double(sum(trues));
    amtFalse = double(sum(falses));
    
    
    correlatrix = correlatrix(:,~same); %Eliminate all of the values we just examined so they aren't used twice
    
    Ptable = [Ptable, [z(1:2); amtTrue/(amtTrue + amtFalse); amtTrue+amtFalse]];
    
end
    
%     correlator = data1==k;
%     trues = length(correlator(reference));
%     falses = length(correlator(~reference));
%     truthval = trues/(trues+falses);
%     
%     length(data1(data1==k));
    