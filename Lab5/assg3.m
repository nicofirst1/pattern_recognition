clear;
clc;
clear all;

%% Get data

load('/Users/giulia/Desktop/pr/Resources/lab5-data/data_lvq_B.mat');
load('/Users/giulia/Desktop/pr/Resources/lab5-data/data_lvq_A.mat');




data=[matA;matB];
labels=[zeros(100,1);ones(100,1)];
folds=10;
neurons=[2,1];
lr=[0.01,0.01];
epochs=60;

%%  Question 3
if 0
[ws,err,lambdas]=LQV(neurons,lr,data,epochs,labels);
figure(2);

subplot(1,2,1);
plot(err);
xlabel("Epoch")
ylabel("error rate")


subplot(1,2,2);
plot(lambdas);
xlabel("Epoch")
ylabel("lamba val")
legend('l1','l2');

sgtitle("S4171632\_S2843013");


end


%% Question 2
if 1
    [ws,err,lambdas]=LQV(neurons,lr,data,epochs,labels);
    dataA=data(1:100,:);
    dataB=data(101:200,:);


    scatter(dataA(:,1),dataA(:,2));
    hold on;
    scatter(dataB(:,1),dataB(:,2));
    title("S4171632\_S2843013");

    scatter(ws(1:2,1),ws(1:2,2),'filled')
    scatter(ws(3,1),ws(3,2),'filled')
    legend("{Class A}","{Class B}","Prot. A","Prot. B")

    
end


%% Question 4

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
lr=[0.01,0.01];
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
classes=[zeros(neurons(1),1);ones(neurons(2),1)];

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
    [ws,err,lambdas]=LQV(neurons,lr,trainX,epochs,trainY);
    lambda=lambdas(end,:);
    %test LQV weight on testSet
    res=test_lqv(ws,lambda,classes,testY,testX);
    % append mean result
    results(k)=1-mean(res);

end

end



function res=test_lqv(ws,lambdas,classes,labels,data)

res=zeros(length(labels),1);

for idx=1:size(data,1)
    
    x=data(idx,:);
    dist=pdist2(x.*lambdas,ws.*lambdas,'squaredeuclidean');

    [name,winner]=min(dist);
    
    if classes(winner)==labels(idx)
                 res(idx)=1;
    else
                 res(idx)=0;
    end

    
    
    
end


end


function [ws,err,lambdas_ret]=LQV(neurons,lr,data,epochs,labels)

neurA=neurons(1);
neurB=neurons(2);



% generate indices
indices=randperm(length(labels));

wsA=rand(neurA,size(data,2))+mean(data);
wsB=rand(neurB,size(data,2))+mean(data);


ws=[wsA;wsB];

classes=[zeros(neurons(1),1);ones(neurons(2),1)];

err=zeros(epochs,1);
lambdas=[0.5,0.5];
lambdas_ret=[];

for idx=1:epochs
    
    [ws,lambdas]=LQV_lambda(lr,data,labels,lambdas,ws,classes);
    lambdas_ret=[lambdas_ret;lambdas];
    
    if 0
    figure(1);
    dataA=data(1:100,:);
    dataB=data(101:200,:);


    scatter(dataA(:,1),dataA(:,2));
    hold on;
    scatter(dataB(:,1),dataB(:,2));
    title("S4171632\_S2843013");

    scatter(ws(1:2,1),ws(1:2,2),'filled')
    scatter(ws(3,1),ws(3,2),'filled')
    legend("{Class A}","{Class B}","Prot. A","Prot. B")
    end

  
    
    res=test_lqv(ws,lambdas,classes,labels,data);
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

function [ws,lambdas]=LQV_lambda(lr,data,labels,lambdas,ws,classes)
% perform a step

% take the correct lambdaas
lr_ws=lr(1);
lr_lambda=lr(2);

% for every point in the dataset
for idx=1:size(data,1)
    
    % get point and labe;
    x=data(idx,:);
    l=labels(idx);
    
    % estimate distance with lambdas
    dist=pdist2(x.*lambdas,ws.*lambdas,'squaredeuclidean');
    % get closest prototype
    [name,winner]=min(dist);
    
    % if winner is same class as datapoint
    if l==classes(winner)
        % update to get closer, attract
        ws(winner,:)=ws(winner,:)+lr_ws*(x- ws(winner,:));
        lambdas=lambdas-lr_lambda*abs((x- ws(winner,:)));
    else
        % else update to get farther, repel
        ws(winner,:)=ws(winner,:)-lr_ws*(x- ws(winner,:));
        lambdas=lambdas+lr_lambda*abs((x- ws(winner,:)));
    end
    
    % positive lambdas
    lambdas(lambdas < 0) = 0;
    % sum to 1
    lambdas=lambdas/sum(lambdas);
    
end



end
