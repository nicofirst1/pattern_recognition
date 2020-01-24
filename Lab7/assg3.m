%% Data 
clc;
clear all;
clf;
load('/Users/giulia/Desktop/pr/Resources/lab7-data/provinces.mat')

%% Question

if 1
   
    Z=zscore(provinces);
    

    Y = pdist(Z,'Euclidean');


    D = squareform(Y);
    d=nonzeros(D);
    idx=find(D==min(d));

    
end