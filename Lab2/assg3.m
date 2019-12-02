clc;
clear;

%% Get data
mu=[3,4];
sigma=[1,0;0,2];

%% Question 1
if 0
    
    % get the range
    range=[-10:0.1:10];
    
    % initialize grid for plotting [21,21]
    [x,y] = meshgrid(range,range);      
    % concat for having  [21,21,2]
    c=cat(3,x,y);
    % reshape for having  [441,2]
    c=reshape(c,size(range,2)^2,2);
    
    % get prob [441,1]
    z=mvnpdf(c,mu,sigma);
    
    % reshape to [21,21]
    z=reshape(z,size(range,2),size(range,2));

    mesh(x,y,z);
    title("Gaussian PDF");
    
end


%% Question 2 to 5
if 0
    
    Xs=[10 ,10;0, 0; 3, 4; 6, 8];
    pd=mvnrnd(mu,sigma,99999);
    res=mahal(Xs,pd);
    sqrt(res)
    
   

    
    
end
