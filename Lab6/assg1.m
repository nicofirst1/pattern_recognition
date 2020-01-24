clc;
clear all;

%% Data collection
load('kmeans1.mat')
load('checkerboard.mat')


retries=4;
k_max=50;


%% Question 2

if 0
    
    subplot(3,1,1)
    [clusters, centroids]=coolKmeans(kmeans1,2);
    plot_k_mean(clusters,kmeans1,centroids);
    
    subplot(3,1,2)
    [clusters, centroids]=coolKmeans(kmeans1,4);
    plot_k_mean(clusters,kmeans1,centroids);
    
    subplot(3,1,3)
    [clusters, centroids]=coolKmeans(kmeans1,8);
    plot_k_mean(clusters,kmeans1,centroids);
   
end

%% Question 3

if 1
    
    subplot(3,1,1)
    [clusters, centroids, centroid_hist]=coolKmeans(kmeans1,2);
    plot_k_mean_hist(clusters,kmeans1,centroids,centroid_hist);
    
    subplot(3,1,2)
    [clusters, centroids, centroid_hist]=coolKmeans(kmeans1,4);
    plot_k_mean_hist(clusters,kmeans1,centroids,centroid_hist);
    
    subplot(3,1,3)
    [clusters, centroids, centroid_hist]=coolKmeans(kmeans1,8);
    plot_k_mean_hist(clusters,kmeans1,centroids,centroid_hist);
   
end


%% Question 4


if 0
    % plotting optiaml dks
    dks=optimal_dk(k_max,kmeans1,retries);
    figure(2);
    plot_dk(dks);
    
   
    
end

%% Question 5

if 0
    
    % plotting optiaml Je & R
    [Jes,Rs]=optimal_JR(k_max,retries,kmeans1);
    figure(3);
    plot_optimal_JR(Jes,Rs);
   
    
end

%% Question 6

if 0
    figure(1);
    [clusters, centroids, centroid_hist]=coolKmeans(kmeans1,4,1);
    plot_k_mean_hist(clusters,kmeans1,centroids,centroid_hist);
    
     figure(2);
    [clusters, centroids, centroid_hist]=coolKmeans(kmeans1,4,0);
    plot_k_mean_hist(clusters,kmeans1,centroids,centroid_hist);

end


%% Question 7
if 0
    
    if 0
        figure(1);
        [clusters, centroids, centroid_hist]=coolKmeans(checkerboard,100,1);
        plot_k_mean_hist(clusters,checkerboard,centroids,centroid_hist);

         figure(2);
        [clusters, centroids, centroid_hist]=coolKmeans(checkerboard,100,0);
        plot_k_mean_hist(clusters,checkerboard,centroids,centroid_hist);
        
    end
    
    if 0
        figure(1);
        [clusters, centroids]=coolKmeans(checkerboard,100,1);
        plot_k_mean(clusters,checkerboard,centroids);

         figure(2);
        [clusters, centroids]=coolKmeans(checkerboard,100,0);
        plot_k_mean(clusters,checkerboard,centroids);
        
    end
    
    
    trials=20;
    
    Jeps=zeros(10,1);
    Jes=zeros(10,1);
    
    for idx=1:10
    
        [Jep,Je]=quant_err_comparison(checkerboard,trials);
        Jeps(idx)=min(Jep);
        Jes(idx)=min(Je);
        
    end
    
    [h,p]=ttest2(Jeps,Jes);
    mean_jeps=mean(Jeps);
    mean_jes=mean(Jes);
    
    std_jeps=std(Jeps);
    std_jes=std(Jes);
    
    
    
    
end


%% Function declarations


% ##############################
% QUANTIZATION ERROR FUNCTIONS
% ##############################


function [Jep,Je]=quant_err_comparison(data,trials)

Jep=zeros(trials,1);
Je=zeros(trials,1);
    
    
f = waitbar(0,'1','Name','Quantization error...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    
    for idx=1:trials
        [clusters, centroids]=coolKmeans(data,100,1);
        Jep(idx)=quant_error(clusters,centroids,data);
        
        [clusters, centroids]=coolKmeans(data,100,0);
        Je(idx)=quant_error(clusters,centroids,data);
        
        waitbar(idx/trials,f,sprintf('Step %d/%d',idx,trials))

        
    end


end

function [Jes,Rs]=optimal_JR(k_max,retries,data)
% return a list of Jes and Rs for k in range 1:k_max
    


f = waitbar(0,'1','Name','Optimal dk',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% initialize vectos
Jes=zeros(k_max,1);
Rs=zeros(k_max,1);
% for every k
for k_num=1:k_max
    
    % initialize Je and repeat for numper of retries
    Je=0;
    for i=1:retries
          [clusters, centroids]=coolKmeans(data,k_num);
          Je=Je+quant_error(clusters,centroids,data);
    end
    % normalize Je and add to list
    Jes(k_num)=Je/retries;
    Rs(k_num)=R_funciton(k_num,data);
    waitbar(k_num/k_max,f,sprintf('Step %d/%d',k_num,k_max))


end

end

function Dks=optimal_dk(k_max,data,retries)
% return the a list of Dks for every possible k in range(1:k_max). Each Je
% calculation is ran retries times 

Dks=zeros(1,k_max);


f = waitbar(0,'1','Name','Optimal dk',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

for k=1:k_max
    
    Dks(k)=Dk(k,data,retries);
    waitbar(k/k_max,f,sprintf('Step %d/%d',k,k_max))
    
end


end

function D=Dk(k_num,data,retries)
% get the value of the ration dk with multiple retries
Je=0;

for i=1:retries
      [clusters, centroids]=coolKmeans(data,k_num);
      Je=Je+quant_error(clusters,centroids,data);
end

Je=Je/retries;
R=R_funciton(k_num,data);
D=R/Je;

end

function R=R_funciton(k_num,data)
% Implementation of the R function

centroid=mean(data);
d=2;
J1=sum(abs(data-centroid).^2,'all')/2;
R=J1*k_num^(-2/d);

end

function Je=quant_error(clusters,centroids,data)
% return the quantization error given data, clusters and centroids
Je=0;
for idx=1:size(centroids,1)
    
    % get centroid for the current class
    c=centroids(idx,:);
    % get data for that centroid
    fdata=data(find(clusters==idx),:);
    % sum everything
    Je=Je+sum(abs(fdata-c).^2,'all');
       
end

Je=Je/2;

end

% ##############################
% PLOTTING FUNCTIONS
% ##############################



function plot_k_mean_hist(clusters, data, centroids,centroid_hist)
% plot kmeans clustering given the history of centorids

hold on;

k_num=size(centroids,1);
leg=[];
symbols=['o','s','d','p','^','v','>','h'];

% plot data points divide into clusters
for idx=1:k_num
    
    % plot data 
    fdata=data(find(clusters==idx),:);
    scatter(fdata(:,1),fdata(:,2),15,symbols(idx));
    
    % add to legend
    leg=[leg,sprintf("Data cluster %d",idx)];
    
    % plot centroid
    scatter(centroid_hist(idx,1,end),centroid_hist(idx,2,end),50,'filled',symbols(idx));
    
    % add to legend
    leg=[leg,sprintf("Centroid %d",idx)];
end


% plot centroid history
for idx=2:size(centroid_hist,3)
    
    % get prev and cur centroid point
    p1=centroid_hist(:,:,idx-1);
    p2=centroid_hist(:,:,idx);
     
    % draw arrow
    dp=p2-p1;
    quiver(p1(:,1),p1(:,2),dp(:,1),dp(:,2),0,'color','black');

    %text(p1(1),p1(2), sprintf('(%.1f,%.1f)',p1))
    %text(p2(1),p2(2), sprintf('(%.1f,%.1f)',p2))
    
    % drow point
    scatter(p1(:,1),p1(:,2),25,'filled','black');
end
if size(centroids,1)>2
    voronoi(centroids(:,1),centroids(:,2));
end
%legend(leg)
sgtitle("S4171632\_S2843013");

end


function plot_optimal_JR(Jes,Rs)

hold on;

plot(Jes);
plot(Rs);
dks=Rs./Jes;
[d_optimal,k_optimal]=max(dks);
scatter(k_optimal,Rs(k_optimal),'filled');

legend(["Je(k)","R(k)",sprintf("Optimal K=%d",k_optimal)]);
xlabel("Number of k");
ylabel("Value of F(k)");
title("S4171632\_S2843013");

end

function plot_dk(dks)
    [d_optimal,k_optimal]=max(dks);

 % plotting Dk
    hold on;
    plot(dks);
    scatter(k_optimal,d_optimal,'filled');
    xlabel("Number of k");
    ylabel("Value of D(k)");
    title("S4171632\_S2843013");
    legend(["D(k)",sprintf("Optimal K=%d",k_optimal)])


end

function plot_k_mean(clusters, data, centroids)

hold on;
k_num=size(centroids,1);
leg=[];
symbols=['o','s','d','p','^','v','>','h'];
for idx=1:k_num
    
    fdata=data(find(clusters==idx),:);
    scatter(fdata(:,1),fdata(:,2),15,symbols(idx));
    scatter(centroids(idx,1),centroids(idx,2),100,'filled',symbols(idx));
    
    leg=[leg,sprintf("Data cluster %d",idx)];
    leg=[leg,sprintf("Centroid %d",idx)];

    
end
if size(centroids,1)>2
    voronoi(centroids(:,1),centroids(:,2));
end


%legend(leg)
sgtitle("S4171632\_S2843013");



end


% ##############################
% K-MEANS FUNCTIONS
% ##############################


function [centroids] = kplus_init(data,k_num)

idx = randperm(size(data,1));
centroids=zeros(k_num,size(data,2));

centroids(1,:)=data(idx(1),:);

for idx=2:k_num
    % filter current controids
    c=centroids(1:idx-1,:);
    % estimate distance from data point
    dists=centroid_distances(data, c);
    % get min distance between centr
    [dists,~] = min(dists,[],2);
    % normalize to sum up to 1
    probs=dists./sum(dists);
    
    % get data idx with probs
    data_idx=sum(rand >= cumsum([0,probs']));
    % set centroid to data point
    centroids(idx,:)=data(data_idx,:);
        
end



end

function [clusters, centroids, centroid_hist]=coolKmeans(data,k_num,plus_init)


 if ~exist('plus_init','var')
     % third parameter does not exist, so default it to something
      plus_init = 0;
 end



% getting initialiation method (random or k-means++)
if plus_init
    centroids=kplus_init(data,k_num);
else
    
    a=min(data,[],'all');
    b=max(data,[],'all');
    centroids=(b-a).*rand(k_num,size(data,2)) + a;
end

% initializing additional params
max_iter=100000;
iter=1;
prev_classes=zeros(1,size(data,1));
centroid_hist=zeros(k_num,size(data,2),max_iter);

while iter<max_iter
    % compute a step for centroids update
    [new_c,classes]=compute_centroids(centroids, data);

    % check stop condition, if there are no zeros in the vecotr, and if it
    % is different from previous run
    if any(prev_classes) &&  isequal(prev_classes,classes)
        %disp(['Stopped at iteration ',num2str(iter)])
        break;
    else
        prev_classes=classes;
    end
    
    centroid_hist(:,:,iter)=centroids;
    centroids=new_c;
    iter=iter+1;
    
end



centroid_hist=centroid_hist(:,:,1:iter-1);

clusters=zeros(1,size(data,1));

for idx=1:size(data,1)
    
    x=data(idx,:);
    dist=sqrt((x(1)-centroids(:,1)).^2 + (x(2)-centroids(:,2)).^2);
    [min_distances,class]=min(dist);
    clusters(idx)=class;

    
    
end


end


function dist=centroid_distances(data, centroids)

k_num=size(centroids,1);
% initialize the distance
dist=zeros(size(data,1),k_num);

% for every point get the distance to the centroids and save 
for idx=1:size(data,1)
    % get the data
    x=data(idx,:);
    % compute distance with all centroids
    dist(idx,:)=sqrt((x(1)-centroids(:,1)).^2 + (x(2)-centroids(:,2)).^2);

end



end

function [centroids,classes]=compute_centroids(centroids, data)
% function to compute a single step of the k mean alg

% get the number of centroids
k_num=size(centroids,1);
% get the distances from each centroid
dist=centroid_distances(data,centroids);
% get min distances and classes
[min_distances,classes]=min(dist,[],2);

% for every centroid update the value
for idx=1:k_num
    f=find(classes==idx);
    % if centorid is min
    if f
        % update
        centroids(idx,:)=mean(data(find(classes==idx),:),1);

    end

end


end

