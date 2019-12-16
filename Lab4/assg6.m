clear;
clc;

%% Getting data
img = imread('/Users/giulia/Desktop/pr/Resources/lab4-data/dogGrayRipples.png');
img=im2double(img);
fs=fft2(img);
fs=fftshift(fs);
f=abs(fs);
f=log(1+f);

if 0
figure(1);
subplot(2,1,1);
imshow(fs,[]);
title("Furier Transform");


subplot(2,1,2);
imshow(img,[]);
title("Original Img")
end



figure(2);

mask=zeros(size(fs));
rows=size(fs,1);
cols=size(fs,2);
x=[1.668677148287282e+02;1.668677148287282e+02];
y=[1.208844955918715e+02;1.807663946149006e+02];
y=abs(y);
centers=[x';y'];

[xMat,yMat]=meshgrid(1:cols,1:rows);

for radius=13:1:13
    for idx=1:2
        dist=sqrt((xMat-centers(1,idx)).^2+(yMat-centers(2,idx)).^2);
        mask(dist<=radius)=1;

    end
    disp(radius);
    q10=fs.*(~mask);
    q10=ifftshift(q10);
    I=real(ifft2(q10));
    imshow(I,[]);
    title("S4171632");
    w = waitforbuttonpress;

    

end


%% define functions
function plot_furier(data)


L=length(data);
Fs=44100;

n = 2^nextpow2(L);

ft=fft2(data,n,2);
P2 = abs(ft/L);
P1 = P2(1:n/2+1,:);
P1(2:end-1) = 2*P1(2:end-1);
plot(0:(Fs/n):(Fs/2-Fs/n),P1(1:n/2,1))


end


function fucking_around()
plot_furier(img);

norm_low=4079/(44100/2);


[b,a] = butter(6,0.05);
low_filter = filter(b,a,img);

plot_furier(img);
imshow(low_filter);

end


