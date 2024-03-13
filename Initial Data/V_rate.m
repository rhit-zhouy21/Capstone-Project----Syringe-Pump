%% read data
clc
clear all

filename = '3000_flowRateTest1.csv';
M = readmatrix(filename);

%% 2nd oder accurate

dx = 0.5;
N = size(M,1);
D = zeros(N,1);

D(1,1) = (-3/2*M(1,5) + 2*M(2,5) -1/2*M(3,5))/dx;

D(N,1) = (3/2*M(N,5) - 2*M(N-1,5) +1/2*M(N-2,5))/dx;
if(M(N,4) == M(N-1,4))
   M(N,4) = M(N,4)+0.5;
end
for i = 2:1:N-1
    if(M(i,4) == M(i-1,4))
       M(i,4) = M(i,4)+ 0.5;
    end
    D(i,1) = (0.5*M(i+1,5) - 0.5*M(i-1,5))/dx;
end

%% plot dV/dx

plot(M(:,4), D(:,1)*3600,'o')
hold on
yline(918.1189, 'LineWidth', 2, 'Color', 'red');
xlim([10,95]);
xlabel('Time (s)')
ylabel('V_r_a_t_e  ml/hr')
legend('experimental data','target value')

%title('Volumetric Flowrate (Second Order Accurate)')


