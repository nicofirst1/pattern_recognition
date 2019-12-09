clc;
clear;

%%Load Data
data1=load('/Users/giulia/Desktop/pr/Resources/lab3-data/lab3_3_cat1.mat').x_w1;
data2=load('/Users/giulia/Desktop/pr/Resources/lab3-data/lab3_3_cat2.mat').x_w2;
data3=load('/Users/giulia/Desktop/pr/Resources/lab3-data/lab3_3_cat3.mat').x_w3;


u=[0.5;1;0];
v=[0.31;1.51;-0.5];
w=[-1.7;-1.7;-1.7];

%% Question 1 to 9

hn=1;
    
PU1=p(u,data1,hn);
PU2=p(u,data2,hn);
PU3=p(u,data3,hn);


PV1=p(v,data1,hn);
PV2=p(v,data2,hn);
PV3=p(v,data3,hn);

PW1=p(w,data1,hn);
PW2=p(w,data2,hn);
PW3=p(w,data3,hn);


%% Question 10 to 12

Prior1=1/3;
Prior2=1/3;
Prior3=1/3;



%% Question 13 to 21

denU=(PU1+PU2+PU3)/3;
denV=(PV1+PV2+PV3)/3;
denW=(PW1+PW2+PW3)/3;

PostU1=PU1*Prior1/denU;
PostU2=PU2*Prior2/denU;
PostU3=PU3*Prior3/denU;

PostV1=PV1*Prior1/denV;
PostV2=PV2*Prior2/denV;
PostV3=PV3*Prior3/denV;


PostW1=PW1*Prior1/denW;
PostW2=PW2*Prior2/denW;
PostW3=PW3*Prior3/denW;




%% defining functions

function res=k(x,xis,hn)
    
    res=0;
    for i=1:size(xis,1)
        
        res=res+phi(x,xis(i,:)',hn);
        
    end
   

end

function res=prior(x,xis,hn)
    Vn=(hn*sqrt(2*pi))^size(x,1);
    n=1;
    
    res=k(x,xis,hn)/n/Vn;
    
    


end

function p=p(x,xis,hn)
    Vn=(hn*sqrt(2*pi))^size(x,1);
    
    tmp=0;
    for i=1:size(xis,1)
        
        tmp=tmp+phi(x,xis(i,:)',hn)/Vn;
        
    end
    
    p=tmp/size(xis,i);
    

end

function res=phi(x,xi,hn)

num=(x-xi);
num=num.^2;
num=sum(num);

den=2*hn^2;
res=exp(-num/den);


end