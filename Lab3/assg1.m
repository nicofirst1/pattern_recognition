clc;
clear;

%% Getting data
mu1=5;
mu2=7;
var=4;
std_=2;
data=load('/Users/giulia/Desktop/pr/Resources/lab3-data/lab3_1.mat').outcomes;

%% Question 1/2
if 0
    xs=10;
    lims = [xs, inf];
    cp1 = normcdf(lims, mu1, std_);
    cp2 = normcdf(lims, mu2, std_);
    false_allarm=cp1(2)-cp1(1)
    hit=cp2(2)-cp2(1)

end

%% Question 3/4
if 0
    
    d4=discriminability(5,9,2)
    d3=discriminability(5,7,2)
    mu=mu_from_d(5,2,3)
end


%% Question 7-10
if 1
    

    [hits,fp,false_allarm,tn]=find_in_data(data);
    
    x=data(:,1)';
    t=data(:,2)';
    
    roc(data,'verbose',1);
    hold on;
    scatter(false_allarm,hits,'r','filled')
    legend({'No predictive val','','','ROC','optimal point','data point'})
    
    d=norminv(hits)-norminv(false_allarm);
end



%% Functions definitions


function [tp,fp,fn,tn]=find_in_data(data)
% return number of 11,01,10,00 in the data


tp=0;
fp=0;
fn=0;
tn=0;

for idx=1:size(data,1)
    
    row=data(idx,:);
    
    if row(1)==1
        if row(2)==1
            tp=tp+1;
        else
            fp=fp+1;
        end
        
    else
        if row(2)==1
            
            fn=fn+1;
        else
            tn=tn+1;
        end
        
    end
    
end
tp=tp/size(data,1);
fp=fp/size(data,1);
fn=fn/size(data,1);
tn=tn/size(data,1);




end

function res=discriminability(mu1,mu2,std)

    res=abs(mu2-mu1)/std;
end


function mu=mu_from_d(mu2,std,d)

syms mu;
eq=d==abs(mu2-mu)/std;
mu=solve(eq);


end