clc;
clear,

%% Data generation
data=[4,5,6;6,3,9;8,7,3;7,4,8;4,6,5];
feat1=data(:,1);
feat2=data(:,2);
feat3=data(:,3);


%% Questions 1/2/3
if 0
    mu1=mean(feat1)
    mu2=mean(feat2)
    mu3=mean(feat3)
end

%% Questions 4 to 12
if 0
    
    cov_mat=cov(data)*4/5
end

%% Questions 14 to 16
if 1
    digits(6)
    mu=mean(data);
    sigma=cov(data)*4/5;
    
    Xs=[5,5,6;3,5,7;4,6.5,1];
    
    for idx=1:size(Xs,1)
        x=Xs(idx,:)
        pdf=mvnpdf(x,mu,sigma);
        vpa(pdf)

    end
    
end
