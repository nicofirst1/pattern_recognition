clc;
clear;

% load all persons
ps=load_person();

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

%% Printing
meanS= mean(HDs)
varS=var(HDs)

meanD= mean(HDd)
varD=var(HDd)

%% Correct estimation 

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

d=norminv(given_false_acceptance_rate,mu,sigma);
false_acceptance_rate = normcdf(d, mu, sigma)

%% Plotting

%figure(1)
%plot_hist(HDs,HDd);


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


end


%find a value of d that gives the given false acceptance rate

function persons=load_person()
% load all persons in the dataset in random order
    persons=[];
    files=dir("Resources/lab1-data");
    files=files(randperm(length(files)));
    for f = 1:length(files)
        filename=files(f).name;
        if regexp(filename, 'person')
            path=strcat(files(f).folder,"/",filename);
            p=load(path);
            persons=[persons;p];
        end
    end
end