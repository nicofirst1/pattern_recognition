clear;
clc;

%% Getting data
[x,Fs] = audioread('/Users/giulia/Desktop/pr/Resources/lab4-data/corrupted_voice.wav');
% get time
dt = 1/Fs;
L=length(x);
t = (0:L-1)*dt;

%% Plot audio
figure(1);
x = x(:,1);
plot(t,x); 
xlabel('Seconds'); 
ylabel('Amplitude');
title("Corrupted audio");


%% Question 1
if 0
figure(2);
plot_furier(x);
end

%% Question 2
figure(3);
% generating 100HZ filter
norm_low=100/(Fs/2);
norm_high=6000/(Fs/2);
eps_low=200;
eps_low=eps_low/(Fs/2);

eps_high=4000;
eps_high=eps_high/(Fs/2);

[b,a] = butter(6,[norm_low+eps_low,norm_high-eps_high]);
low_filter = filter(b,a,x);
plot_furier(low_filter)
audiowrite('filtered_voice.wav',low_filter,Fs)





%% defining functions



function plot_furier(data)


L=length(data);
Fs=44100;

n = 2^nextpow2(L);

ft=fft(data,n,1);
P2 = abs(ft/L);
P1 = P2(1:n/2+1,:);
P1(2:end-1) = 2*P1(2:end-1);
plot(0:(Fs/n):(Fs/2-Fs/n),P1(1:n/2,1))


end

