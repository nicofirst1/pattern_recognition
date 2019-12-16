I = rgb2gray(imread('/Users/giulia/Desktop/pr/Resources/lab4-data/chess.jpg'));
BW = edge(I, 'canny');
[H,T,R] = hough(BW);
P = houghpeaks(H, 15, 'threshold', ceil(0.3*max(H(:))));
x = T(P(:,2));
y = R(P(:,1));
figure(1)
imagesc(T,R,H);
xlabel("Theta");
ylabel("Rho");
hold on;
plot(x,y, 's', 'color', 'white');
hold off;


figure(2)

imshow(I)
hold on;

for i=1:15
    myhoughline(I,y(i),x(i));
end

function myhoughline(image, r, theta)
figure(2)

title("S4171632\_S2843013");

    [x,y] = size(image);
    angle = deg2rad(theta);
    if sin(angle) == 0
        line([r,r],[0,y], 'Color', 'red')
    else
        line([0,y],[r/sin(angle),(r-y*cos(angle))/sin(angle)],'Color', 'red')
    end
end