clc;
clear;

%% Initialize Constants
peoples=1000000;
turns=100;


%% Initialize data
scores=zeros(peoples,1);

% Start loop 
disp("Generating data....")
for t=0:turns
    for p=1:peoples
        
        % if tail increment score
        if rand > 0.5
            scores(p)=scores(p)+1;
        end
            
        
    end
end
disp("Data generated")


%% Question 1
if 1
    
    to_plot=zeros(turns,1);
    
    % get the number of people for each score
    for i=1:turns
        num=how_many_scored(scores,i);
        to_plot(i)=num;
    end
    
   
    % plotting
    hold on;
    plot(to_plot);
    title("Score distribution");
    xlabel("score");
    ylabel("peoples" );
    
    mu=mean(scores)
    variance=var(scores)
    
end


%% Function declaration

function p_num=how_many_scored(scores,score)
% return number of people which scored a score
    p_num=sum(scores == score);

end