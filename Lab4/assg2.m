clc;
clear;

%% Test
c=imread("/Users/giulia/Desktop/pr/Resources/lab4-data/Cameraman.tiff");
bw=edge(c,'canny');

figure(2);
imshow(bw);
title("edge image");


figure(1);

range=1:1:180;
myacc=myhough(range,bw);
[hgacc,T,R]=hough(bw);


subplot(2,1,1);
imagesc(T,R,myacc);
title("Custom Hough");
xlabel("Theta");
ylabel("Rho");


subplot(2,1,2);
imagesc(T,R,hgacc);
title("Standard Hough")
xlabel("Theta");
ylabel("Rho");




%% FUnction declaration
function accumulator=myhough(theta_range,img)


% getting max rho
rho_base= ceil(sqrt(size(img,1).^2 + size(img,2).^2));

%initialize accumulator to [max_rho*2+1,theta range]
accumulator=zeros(rho_base*2,length(theta_range));

disp("Starting Hough Transform...")

% find non zero points in the image  
[x,y]=find(img==1);
points=[x,y];

% for every non zero point in image
for p=1:size(points,1)
    
    % get coordinates
    x=points(p,1);
    y=points(p,2);
    
    % for every t in range
    for T=theta_range
        
        % convert t to rad
        t=deg2rad(T);
        % get rho
        rho=x*cos(t)+y*sin(t);
        rho=rho+rho_base;
        rho=floor(rho);
        
        % shift T to get correct index
        T_idx=181-T;
        
        % update accumulator
        accumulator(rho,T_idx)=accumulator(rho,T_idx)+1;
    end

end
end

