c = imread('cameraman.tif');
figure(1)
imshow(c)

bw = edge(c, 'canny');
figure(2)
imshow(bw)

figure(3)
[hc, T, R] = hough(bw);
T
imagesc(T, R, hc);
title("s2843013 & s4171632");
xlabel('\theta'), ylabel('\rho');
peaks = houghpeaks(hc, 5);
hold on;
plot(T(peaks(:,2)), R(peaks(:,1)), 'ro')

myhoughline(c, R(peaks(1,1)), T(peaks(1,2)))

function myhoughline(image, r, theta)
    figure(1)
    [x,y] = size(image);
    angle = deg2rad(theta);
    if sin(angle) == 0
        line([r,r],[0,y], 'Color', 'red')
    else
        line([0,y],[r/sin(angle),(r-y*cos(angle))/sin(angle)],'Color', 'red')
    end
end
