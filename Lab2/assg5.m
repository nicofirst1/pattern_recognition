clc;
clear;


%% Declaring constants
mu1=[3;5];
mu2=[2;1];
sigma1=[1,0;0,4];
sigma2=[2,0;0,1];
p1=0.3;
p2=0.7;

% get decision boundary
db1=get_decision_boundary_week2(mu1,sigma1,p1);
db2=get_decision_boundary_week2(mu2,sigma2,p2);

db=db1-db2;




%% Plotting
% plotting cov mats
hold on;
h1=error_ellipse('C',sigma1,'mu',mu1);
h2=error_ellipse('C',sigma2,'mu',mu2);

% gettind decision boundaries points

ezplot(db,[-10,20]);
title("Decision boundaries");
legend({'distribution 1','distribution 2','boundary'});

%% Declaring discriminants 

function error=g(obs,db)
    syms x1 x2
    error=subs(db,x1,obs(1));
    error=subs(error,x2,obs(2));
    error=double(error);

end





%% Declaring other functions

function db=get_decision_boundary_week3(mu,sigma)
% returns decision boundry given mu and sigma

    syms x1 x2;
    x=[x1;x2];
    d=size(mu,1);
    down=(2*pi)^(d/2)*sqrt(det(sigma));
    esp=-0.5*(x-mu)'*inv(sigma)*(x-mu);
   
    pd=1/down*exp(esp);
    pd=log(pd);
    
    db=simplify(pd);
    
   
end


function gi=get_decision_boundary_week2(mu,sigma,prior)

    
    syms x1 x2;
    x=[x1;x2];
    gi=-0.5*(x-mu)'*inv(sigma)*(x-mu)-0.5*log(det(sigma))+log(2*pi)+log(prior);
    gi=simplify(gi,'IgnoreAnalyticConstraints',true);

end

