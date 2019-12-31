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
if 1
res=kfold(data,labels,folds);
res=mean(res);
end

%% Question 2

if 1
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


wsA=rand(neurA,size(data,2))+mean(data);
wsB=rand(neurB,size(data,2))+mean(data);
classes=[zeros(neurons(1),1);ones(neurons(2),1)];

err=zeros(epochs,1);

for idx=1:epochs
        
    ws=LQV_step(lr,data,labels,[wsA;wsB],classes);
    wsA=ws(1:neurA,:);
    wsB=ws(neurA+1:end,:);
    
    res=test_lqv(wsA,wsB,labels,data);
    err(idx)=1-mean(res);
    
    
end


end

function ws=LQV_step(lr,data,labels,ws,classes)
% perform a step

for idx=1:size(data,1)
    
    x=data(idx,:);
    l=labels(idx);
    
    dist=pdist2(x,ws,'squaredeuclidean');
    [name,winner]=min(dist);
    if l==classes(winner)
        ws(winner,:)=ws(winner,:)+lr*(x- ws(winner,:));
    else
        ws(winner,:)=ws(winner,:)-lr*(x- ws(winner,:));
    end

end
end