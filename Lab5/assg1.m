clear;
clc;
clear all;

%% Get data

load('/Users/giulia/Desktop/pr/Resources/lab5-data/data_lvq_B.mat');
load('/Users/giulia/Desktop/pr/Resources/lab5-data/data_lvq_A.mat');


epochs=30;
lr=0.01;

data=[matA;matB];
labels=[zeros(100,1);ones(100,1)];
neurons=[2,1];





%% Question 1
if 0
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

%% Question 4
if 0
[wsA,wsB,err]=LQV(neurons,lr,data,epochs,labels);
figure(2);
plot(err);
title("S4171632\_S2843013");
xlabel("Epoch")
ylabel("error rate")
end

%% Question 5
if 0
    figure(3)

    neurons=[1,1;1,2;2,1;2,2];
    for n=1:size(neurons,1)
        subplot(4,1,n);
        [wsA,wsB,err]=LQV(neurons(n,:),lr,data,epochs,labels);
        plot(err);
        xlabel("epoch")
        ylabel("error rate")
        tit=['PrA: ',num2str(neurons(n,1)),' | PrB: ',num2str(neurons(n,2))];
        title(tit)

    end
    sgtitle("S4171632\_S2843013");

    
end


%% Question 6
if 1
    figure(4)

    neurons=[1,1;1,2;2,1;2,2];
    for n=1:size(neurons,1)
        subplot(4,1,n);
        [wsA,wsB,err]=LQV(neurons(n,:),lr,data,epochs,labels);

        hold on;
        scatter(matA(:,1),matA(:,2),10);
        scatter(matB(:,1),matB(:,2),10);
        tit=['PrA: ',num2str(neurons(n,1)),' | PrB: ',num2str(neurons(n,2))];
        title(tit);
        scatter(wsA(:,1),wsA(:,2),50,'filled')
        scatter(wsB(:,1),wsB(:,2),50,'filled')
        legend("{Class A}","{Class B}","Prot. A","Prot. B")

    end
        sgtitle("S4171632\_S2843013");

    
end



%% function definition




function res=test(wsa,wsb,labels,data)

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

dataA=data(1:100,:);
dataB=data(101:200,:);


wsA=rand(neurA,size(dataA,2))+mean(dataA);
wsB=rand(neurB,size(dataB,2))+mean(dataB);

err=zeros(epochs,1);

for idx=1:epochs
        
    wsA=LQV_step(lr,dataA,wsA);
    wsB=LQV_step(lr,dataB,wsB);
    
    res=test(wsA,wsB,labels,data);
    err(idx)=1-mean(res);
    
    
end


end

function ws=LQV_step(lr,data,ws)
% perform a step

for idx=1:size(data,1)
    
    x=data(idx,:);
    
    dist=pdist2(x,ws,'squaredeuclidean');
    [name,winner]=min(dist);
    ws(winner,:)=ws(winner,:)+lr*(x- ws(winner,:));
    
end

end