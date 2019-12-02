clc;
clear;

%% Declaring data
syms a b c d;

v1=[a,c];
v2=[b,d];
data=[v1;v2]

%% Question 1

if 0
    res=cov(v1,v2);
    simplify(res)
    
end

%% Question 2

if 0
    syms k;
    v1=v1+k;
    v2=v2+k;
    res=cov(v1,v2);
    simplify(res)
    
end


%% Question 3

if 1
    syms k;
    v1=v1*k;
    v2=v2*k;
    res=cov(v1,v2);
    simplify(res)
    
end