clc;
clear all;

%% Data collection
load('checkerboard.mat')

k_num=100;
epochs=600;


%% Question 2

if 0


subplot(2,2,1)
prototypes = batchNG(checkerboard, k_num, 20);
plot_proto(checkerboard,prototypes,20)

subplot(2,2,2)
prototypes = batchNG(checkerboard, k_num, 100);
plot_proto(checkerboard,prototypes,100)

subplot(2,2,3)
prototypes = batchNG(checkerboard, k_num, 200);
plot_proto(checkerboard,prototypes,200)

subplot(2,2,4)
prototypes = batchNG(checkerboard, k_num, 500);
plot_proto(checkerboard,prototypes,500)


sgtitle("S4171632\_S2843013");

end


%% Question 3
if 1
  

    figure(2);
    [clusters, centroids]=coolKmeans(checkerboard,k_num);
    plot_k_mean(clusters,checkerboard,centroids);
    
    
    figure(3);
    [clusters, centroids]=coolKmeans(checkerboard,k_num,1);
    plot_k_mean(clusters,checkerboard,centroids);
    
      figure(1);
    prototypes = batchNG(checkerboard, k_num, 200);
    plot_proto(checkerboard,prototypes,20)
    
end


%% Function definitions

function plot_proto(data,prototypes,epochs)

    xdim=1; ydim=2;
    hold off
    plot(data(:,xdim),data(:,ydim),'bo','markersize',3)
    hold on
    plot(prototypes(:,xdim),prototypes(:,ydim),'r.','markersize',10,'linewidth',3)
    voronoi(prototypes(:,xdim),prototypes(:,ydim));

    drawnow
    title(sprintf('%d epochs \r',epochs))


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

function plot_k_mean(clusters, data, centroids)

hold on;
k_num=size(centroids,1);
leg=[];
for idx=1:k_num
    
    fdata=data(find(clusters==idx),:);
    scatter(fdata(:,1),fdata(:,2),15);
    scatter(centroids(idx,1),centroids(idx,2),100,'filled');
    
    leg=[leg,sprintf("Data cluster %d",idx)];
    leg=[leg,sprintf("Centroid %d",idx)];

    
end

    voronoi(centroids(:,1),centroids(:,2))

%legend(leg)
sgtitle("Kampo di Fiori");



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

