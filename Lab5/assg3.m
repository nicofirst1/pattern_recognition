clear;
clc;
clear all;

%% Get data

load('/Users/giulia/Desktop/pr/Resources/lab5-data/data_lvq_B.mat');
load('/Users/giulia/Desktop/pr/Resources/lab5-data/data_lvq_A.mat');




data=[matA;matB];
labels=[zeros(100,1);ones(100,1)];
folds=10;


%%  Question 1
if 0
res=kfold(data,labels,folds);
res=mean(res);
end

%% Question 2

if 0
res=kfold(data,labels,folds);

figure(1);

bar(res);
hold on;
xlim=get(gca,'xlim');
plot(xlim,[mean(res),mean(res)]);

title("S4171632\_S2843013");
xlabel("Fold")
ylabel("Error")
legend("err. bars","average")

end

%% Question 1
if 1
epochs=30;
lr=0.01;
neurons=[2,1];
[wsA,wsB,err]=LQV(neurons,lr,data,epochs,labels);

figure(1);
scatter(matA(:,1),matA(:,2));
hold on;
scatter(matB(:,1),matB(:,2));
title("S4171632\_S2843013");

scatter(wsA(:,1),wsA(:,2),'filled')
scatter(wsB(:,1),wsB(:,2),'filled')
legend("{Class A}","{Class B}","Prot. A","Prot. B")

end



%% function definition


function results=kfold(data,labels,folds)

% default params
epochs=30;
lr=0.01;
neurons=[2,1];


% generate indices
indices=randperm(length(labels));
% get fold size
splitter=length(labels)/folds;
% initialize empty set
sets=zeros(folds,splitter);

% fill set with indices
for k=1:folds
    sets(k,:)=indices(k:k+splitter-1);
end

% split data
train=data(sets(1:9,:),:);
test=data(sets(10,:),:);
results=zeros(folds,1);

% for every fold
for k=1:folds
    
    % get indices for fold
    test_i=sets(k,:);
    train_i=sets;
    % remove test set
    train_i(k,:)=[];
    
    % get train from indices
    testX=data(test_i,:);
    trainX=data(train_i,:);
    
    % get labels
    testY=labels(test_i,:);
    trainY=labels(train_i,:);
    
    % perform LQV training on trainSet
    [wsA,wsB,err]=LQV(neurons,lr,trainX,epochs,trainY);
    %test LQV weight on testSet
    res=test_lqv(wsA,wsB,testY,testX);
    % append mean result
    results(k)=1-mean(res);

end

end



function res=test_lqv(wsa,wsb,labels,data)

res=zeros(length(labels),1);

for idx=1:size(data,1)
    
    x=data(idx,:);
    distA=pdist2(x,wsa,'squaredeuclidean');
    distB=pdist2(x,wsb,'squaredeuclidean');

    minA=min(distA);
    minB=min(distB);
    
    if minA<minB && labels(idx)==0
         res(idx)=1;
            
    end
    
    if minA>minB && labels(idx)==1
         res(idx)=1;
            
    end
    
end


end


function [wsA,wsB,err]=LQV(neurons,lr,data,epochs,labels)

neurA=neurons(1);
neurB=neurons(2);



% generate indices
indices=randperm(length(labels));

wsA=rand(neurA,size(data,2))+mean(data);
wsB=rand(neurB,size(data,2))+mean(data);

err=zeros(epochs,1);

for idx=1:epochs
        
    wsA=LQV_step(lr,data(indices,:),labels(indices), wsA,0);
    wsB=LQV_step(lr,data(indices,:),labels(indices),wsB,1);
    
    if 1
    figure(1);
    dataA=data(1:100,:);
    dataB=data(101:200,:);


    scatter(dataA(:,1),dataA(:,2));
    hold on;
    scatter(dataB(:,1),dataB(:,2));
    title("S4171632\_S2843013");

    scatter(wsA(:,1),wsA(:,2),'filled')
    scatter(wsB(:,1),wsB(:,2),'filled')
    legend("{Class A}","{Class B}","Prot. A","Prot. B")
    end

  
    
    res=test_lqv(wsA,wsB,labels,data);
    err(idx)=1-mean(res);
    
    
end




end

function ws=LQV_step(lr,data,labels,ws,class)
% perform a step

for idx=1:size(data,1)
    
    x=data(idx,:);
    l=labels(idx);
    
    dist=pdist2(x,ws,'squaredeuclidean');
    [name,winner]=min(dist);
    if l==class
        ws(winner,:)=ws(winner,:)+lr*(x- ws(winner,:));
    else
        ws(winner,:)=ws(winner,:)-lr*(x- ws(winner,:));
    end

end



end
