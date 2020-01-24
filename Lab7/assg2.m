%% Data 
clc;
clear all;
clf;

load('/Users/giulia/Desktop/pr/Resources/lab7-data/cluster_data.mat')
t=0.15;

%% Question 1   


if 0

    imTired(cluster_data,'single');
end

%% Question 2
if 0
    imTired(cluster_data,'complete');

end


%% Question 5
if 1
z=linkage(cluster_data,'average');
c=cluster(z,'Maxclust',4);
cutoff=0.35;
dendrogram(z,'ColorThreshold',cutoff);
title("S4171632\_S2843013");


end




%% functions

function imTired(cluster_data, metric)

    z=linkage(cluster_data,metric);
    c=cluster(z,'Maxclust',4);
    scatter(cluster_data(:,1),cluster_data(:,2),30,c);
    hold on;
    for idx=1:length(unique(c))

        pnts=c==idx;
        pnts=cluster_data(pnts,:);
        centroid=mean(pnts);
        scatter(centroid(1),centroid(2),'filled')



    end

    title("S4171632\_S2843013");


end