clear;clc;

%Periyodu belirleme
duty_cycle=50;
t=0:1:800;

input = 1;

if(input == 1)%input kare dalga
    u=square(2*pi*0.01.*t,duty_cycle);
else %input t=50'de impulse
    u=1*(t==50);
end

%sistemdeki katsayilar
a=-0.8;
b=0.5;
c=-0.5;
lambda = 0.95;
%parametreleri initialize ve preallocation ediyoruz
theta_hat(:,1)=zeros(2,1);
phi_transpose = zeros(800,2);
K = zeros(2,800);
err = zeros(1,800);
y = zeros(1,800);
e = zeros(1,800);
P=10^6*eye(2);

%Sistem cevabini elde etme
for i=2:800
    e(i)=sqrt(0.5)*randn(1); %noise ifadesi
    y(i)=-a*y(i-1)+b*u(i-1)+e(i)+c*e(i-1); %cikis ifadesi
end

%Recursive Least Squares with forgetting factor algoritmasi
for i=2:800
    phi_transpose(i,:)=[-y(i-1) u(i-1)]; %fi transpoz matrisi. Bir daha transpose alýnca fi matrisine ulasilabilir.
    K(:,i)=P*transpose(phi_transpose(i,:))*inv(lambda+phi_transpose(i,:)*P*transpose(phi_transpose(i,:)));
    err(:,i)=y(i)-phi_transpose(i,:)*theta_hat(:,i-1);
    theta_hat(:,i)=theta_hat(:,i-1)+K(:,i)*err(:,i);
    P=(eye(2)-K(:,i)*phi_transpose(i,:))*P/lambda;
end
plot(theta_hat(1,:))
hold on
grid on
plot(theta_hat(2,:))
hold off