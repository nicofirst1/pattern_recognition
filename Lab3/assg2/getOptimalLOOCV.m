N = 30;

y = [];
x = [1:N];

for i=1:N
    y(i) = getLOOCV(i);
end

plot(x,y)
xlabel("N")
ylabel("Error rate")