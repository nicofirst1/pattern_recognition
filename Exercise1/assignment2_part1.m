clc;
clear;

% load all persons
ps=load_person();

%% Set S
S=ps(1).iriscode;
HDs=[];

for i=1:10000
    % randomly select two rows
    N=2; % no. of rows needed
    c=randperm(size(S,1),N);
    tmp=S(c,:);
    row1=tmp(1,:);
    row2=tmp(2,:);

    % estimate hamming distance
    hd=pdist2(row1,row2,'hamming');
    HDs=[HDs,hd];
end

disp(HDs);

%% Set D
% get two random person from the dataset
ps1=ps(2).iriscode;
ps2=ps(3).iriscode;
HDd=[];

for i=1:10000
    % randomly select two rows
    N=2; % no. of rows needed
    c=randperm(size(S,1),N);

    row_ps1=ps1(c(1),:);
    row_ps2=ps2(c(2),:);

    % estimate hamming distance
    hd=pdist2(row_ps1,row_ps2,'hamming');
    HDd=[HDd,hd];
end

disp(HDd);


%% Functions

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