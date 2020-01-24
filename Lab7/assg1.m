%% Data 
clc;
clear all;
clf;

load('/Users/giulia/Desktop/pr/Resources/lab7-data/cluster_data.mat')
t=0.15;

%% Question 1

if 0
    
    t=[0.05,0.1,0.15,0.2,0.25];
    
    subplot(2,3,1);
    edge_mat=get_edge_matrix(cluster_data, t(1));
    clusters=adj2cluster(edge_mat);
    plot_edge(edge_mat,cluster_data,clusters);
    tit=sprintf("t= %.2f, n clst=%d",t(1),length(clusters));
    title(tit);
    
     subplot(2,3,2);
    edge_mat=get_edge_matrix(cluster_data, t(2));
    clusters=adj2cluster(edge_mat);
    plot_edge(edge_mat,cluster_data,clusters);
        tit=sprintf("t= %.2f, n clst=%d",t(2),length(clusters));
    title(tit);
    
     subplot(2,3,3);
    edge_mat=get_edge_matrix(cluster_data, t(3));
    clusters=adj2cluster(edge_mat);
    plot_edge(edge_mat,cluster_data,clusters);
        tit=sprintf("t= %.2f, n clst=%d",t(3),length(clusters));
    title(tit);
    
     subplot(2,3,4);
    edge_mat=get_edge_matrix(cluster_data, t(4));
    clusters=adj2cluster(edge_mat);
    plot_edge(edge_mat,cluster_data,clusters);
        tit=sprintf("t= %.2f, n clst=%d",t(4),length(clusters));
    title(tit);
    
    
     subplot(2,3,5);
    edge_mat=get_edge_matrix(cluster_data, t(5));
    clusters=adj2cluster(edge_mat);
    plot_edge(edge_mat,cluster_data,clusters);
        tit=sprintf("t= %.2f, n clst=%d",t(5),length(clusters));
    title(tit);
    
    sgtitle("S4171632\_S2843013");
    
    
end



%% Question 5
if 1
edge_mat=get_edge_matrix(cluster_data, t);
clusters=adj2cluster(edge_mat);
plot_edge(edge_mat,cluster_data,clusters);
title("S4171632\_S2843013");

end
%% Functions

function C = adj2cluster(A)
% Symmetrize adjacency matrix
S = A + A';
% Reverse Cuthill-McKee ordering
r = fliplr(symrcm(S));
% Get the clusters
C = {r(1)};
for i = 2:numel(r)
    if any(S(C{end}, r(i)))
        C{end}(end+1) = r(i);
    else
        C{end+1} = r(i);
    end
end
end

function plot_edge(edge_mat, data, clusters)

hold on;

num_point=size(edge_mat,1);
gplot(edge_mat,data);

for idx=1:size(clusters,2)
    idxs=clusters{idx};
    points=data(idxs,:);
    
    scatter(points(:,1),points(:,2),15,'filled')

  
end


end

function edge_matrix=get_edge_matrix(data,t)
% return a triangular matrix in which mat[i,j]=1 if dist(pi,pj)<t, else  mat[i,j]=1 
n_points=size(data,1);

edge_matrix=zeros(n_points,n_points);

for idx=1:n_points
    
    % get the number of points left
    left=data(idx:n_points,:);
    % get current point
    x=data(idx,:);
    % estiamte distance between point and vector
    d=distance(x,left);
    % get vecotr of 1 (near) 0 (far)
    nears=d<t;
    % assign it to the edge matrix
    edge_matrix(idx,idx:n_points)=nears;
    
       
end

end

function dist=distance(p1,p2)
% p1 is a point, p2 can be point or vecotr of points, return a
% scalar/vector
point_num=size(p2,1);

dist=zeros(point_num,2);

% eucliudean distance
if 1
    dist=sqrt((p1(1)-p2(:,1)).^2 + (p1(2)-p2(:,2)).^2);

end


end