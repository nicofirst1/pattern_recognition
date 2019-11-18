
% Splitting features into vectors
height=lab1_1(:,1);
age=lab1_1(:,2);
weight=lab1_1(:,3);



fprintf('##########################\n');
fprintf('Correlation coefficents\n');
fprintf('##########################\n');

corr_ha=cor_coef(height,age);
fprintf('Correlation coefficent between height and age %f\n', corr_ha);
figure(1);
plot_coeff(height,age,"height","age")


corr_hw=cor_coef(height,weight);
fprintf('Correlation coefficent between height and weight %f\n', corr_hw);
figure(2);
plot_coeff(height,weight,"height","weight")


corr_aw=cor_coef(age,weight);
fprintf('Correlation coefficent between age and weight %f\n', corr_aw);
figure(3);
plot_coeff(age,weight,"age","weight")



function plot_coeff(X,Y, namex, namey)
corr=cor_coef(X,Y);

scatter(X,Y,'filled');

tit=sprintf('Correlation coeff: %d',corr);

title(tit);
xlabel('Index') ;
ylabel('Values') ;
leg1=sprintf('X : %s,\nY : %s',namex,namey);

legend({leg1},'Location','southwest');


end

function correlation=cor_coef(X,Y)
% Estimate correlation index between two vectors
correlation=cov(X,Y);
correlation=correlation/(std(X)*std(Y));

end


function covariance=cov(x,y)

% getting vector length -1
n=length(x)-1;

% normalizing components
x=x-mean(x);
y=y-mean(y);

% multiplying element wise
num=times(x,y);
% reducing with sum
num=sum(num);

covariance=num/n;

end

