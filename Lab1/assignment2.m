clc;
clear;

% load all persons
[ps,j]=load_person();

%% Set S
HDs=[];

for i=1:10000
    S=ps(randi(20)).iriscode;
    
    % randomly select two rows
    N=2; % no. of rows needed
    c1=randi(size(S,1));
    c2=randi(size(S,1));

    row1=S(c1,:);
    row2=S(c2,:);

    % estimate hamming distance
    hd=pdist2(row1,row2,'hamming');
    HDs=[HDs,hd];
end

%disp(HDs);

%% Set D
HDd=[];

for i=1:10000
    r1 = randi(20);
    r2 = 1 + mod((randi(19) + r1 - 1), 20); %ensures r1 != r2
    if r1 == r2
         disp("Error, r1 = r2");
         continue;
    end
    
    % get two random person from the dataset
    ps1=ps(r1).iriscode;
    ps2=ps(r2).iriscode;
    
    % randomly select two rows
    c1=randi(size(ps1,1));
    c2=randi(size(ps2,1));

    row_ps1=ps1(c1,:);
    row_ps2=ps2(c2,:);

    % estimate hamming distance
    hd=pdist2(row_ps1,row_ps2,'hamming');
    HDd=[HDd,hd];
end

%disp(HDd);

%% Plotting

figure(9)
plot_hist(HDs,HDd);
%% Printing
meanS= mean(HDs);
varS=var(HDs);

meanD= mean(HDd);
varD=var(HDd);

%% Question 8

one=meanD*(1-meanD)/varD;
two=meanD^2*(1-meanD^2)/varD;
three=varD*(1-varD)/meanD;
four=varD*(1-varD)/meanD^2;
five=meanD*(1-meanD)/sqrt(varD);
six=sqrt(varD)*(1-sqrt(varD))/meanD^2;
seven=sqrt(varD)*(1-sqrt(varD))/meanD;
eight=sqrt(varD)*(1-sqrt(varD))/varD;

mu = mean(HDd);
sigma = std(HDd);

%Set this value to the desired false acceptance rate
given_false_acceptance_rate = 0.0005;

d=norminv(given_false_acceptance_rate,mu,sigma)
false_acceptance_rate = normcdf(0.1971, mu, sigma)



%% Question 12
counter=0;
for i=1:size(HDs,2)
    
    if HDs(i)>d
       counter=counter+1;
    end
end

false_rejection_rate=counter/size(HDs,2)

%% Question 14
test_person=load('/Users/giulia/Desktop/pr/Resources/lab1-data/testperson.mat').iriscode;
% getting indices where bit is 2
missing_idx=find(test_person==2);
% dropping them from test person
test_person(missing_idx)=[];

% loading other persons
[pss,names]=load_person();


mean_ps_hd=[];
% for evey p
for idx=1:size(pss,1)
    % get p 
    ps=pss(idx).iriscode;
    hds=[];
    % for every row in p
    for row=1:size(ps,1)
           
        % get row and drop
        row_ps=ps(row,:);
        row_ps(missing_idx)=[];
        hd=pdist2(row_ps,test_person,'hamming');
        hds=[hds, hd];      
    end
    mean_ps_hd=[mean_ps_hd,mean(hds)];   
    
end
[min_val_test,min_idx]=min(mean_ps_hd)
names(min_idx,:)
min_val_test

%% Question 15
HDd_test=[];
ps=load_person();

for i=1:10000
    r1 = randi(20);
    r2 = 1 + mod((randi(19) + r1 - 1), 20); %ensures r1 != r2
    if r1 == r2
         disp("Error, r1 = r2");
         continue;
    end
    
    % get two random person from the dataset
    ps1=ps(r1).iriscode;
    ps2=ps(r2).iriscode;
    
    % randomly select two rows
    c1=randi(size(ps1,1));
    c2=randi(size(ps2,1));

    row_ps1=ps1(c1,:);
    row_ps2=ps2(c2,:);

    row_ps1(missing_idx)=[];
    row_ps2(missing_idx)=[];
    % estimate hamming distance
    hd=pdist2(row_ps1,row_ps2,'hamming');
    HDd_test=[HDd_test,hd];
end

mu_test = mean(HDd_test);
sigma_test = std(HDd_test);


false_acceptance_rate_test = normcdf(0.1977, mu_test, sigma_test)

figure(1)
plot_hist([],HDd_test);





%% Function Definitions%%%%%%%%%%%%%%%%%%


function plot_hist(S,D)
hold on

histogram(S,'Normalization','pdf','FaceColor','blue','BinWidth',0.03333);
histogram(D,'Normalization','pdf','FaceColor','red','BinWidth',0.03333);

x_values = 0:.01:1;


pd=fitdist(S','Normal');
y = pdf(pd,x_values);
plot(x_values,y,'LineWidth',2,'Color','blue')


pd=fitdist(D','Normal');
y = pdf(pd,x_values);
plot(x_values,y,'LineWidth',2,'Color','red')


xlabel('Hamming distance')
ylabel('PDF')
title('Normal Distribution');


end


%find a value of d that gives the given false acceptance rate

function [persons,names]=load_person()
% load all persons in the dataset in random order
    persons=[];
    names=[];
    files=dir("Resources/lab1-data");
    files=files(randperm(length(files)));
    for f = 1:length(files)
        filename=files(f).name;
        if regexp(filename, 'person')
            if isempty(regexp(filename, 'test'))
                path=strcat(files(f).folder,"/",filename);
                p=load(path);
                persons=[persons;p];
                names=[names;filename];
            end
        end
    end
end