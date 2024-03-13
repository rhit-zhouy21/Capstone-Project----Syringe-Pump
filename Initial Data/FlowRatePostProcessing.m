clc
close all
clear variables

slopes = zeros(20,2);

for i = [2:10,15,20,30,40,50]
    filename1 = [num2str(i*100), '_flowRateTest1'];
    filename2 = [num2str(i*100), '_flowRateTest2'];
    
    data1 = readmatrix(filename1);
    data1(:,5) = data1(:,5)-data1(1,5);

    for j = 1:length(data1(:,4))-1
        if(data1(j,4)==data1(j+1,4))
            data1(j+1,4) = data1(j+1,4)+.5;
        end
    end
    
    data2 = readmatrix(filename2);
    data2(:,5) = data2(:,5)-data2(1,5);

    
    for j = 1:length(data2(:,4))-1
        if(data2(j,4)==data2(j+1,4))
            data2(j+1,4) = data2(j+1,4)+.5;
        end
    end
    
    %cut off the unlinear region by manually setting the startpoint and
    %endpoint. 
    sp1 = int32(1*length(data1(:,1))/2);
    sp2 = int32(1*length(data2(:,1))/2);
    ep1 = int32(4*length(data1(:,1))/5);
    ep2 = int32(4*length(data2(:,1))/5);
    
    %linear fit to get the slopes
    coeffs1 = polyfit(data1(sp1:ep1,4), data1(sp1:ep1,5), 1);
    coeffs2 = polyfit(data2(sp2:ep2,4), data2(sp2:ep2,5), 1);
    coeff = (coeffs1(1,1) + coeffs2(1,1))/2;
    
    slopes(i,1) = i*100;  % x value
    slopes(i,2) = coeff;  % y value
    
    %figure(i)
    %%plot(data1(sp1:ep1,4),data1(sp1:ep1,5), 'k.');
    %%hold on
    %%plot(data2(sp2:ep2,4),data2(sp2:ep2,5), 'rs');
    %%figure(i)
    %plot(data1(:,4),data1(:,5), 'k.');
    %hold on
    %plot(data2(:,4),data2(:,5), 'ro');
    %xlabel('time (s)')
    %ylabel('Mass (g)')
    %legend('data1','data2')
    %legend('data')
end

figure(1)
plot(slopes([2:10,15,20,30,40,50],1), slopes([2:10,15,20,30,40,50],2)*3600,'o')

hold on
curvefit1 = polyfit(slopes([2:10],1), slopes([2:10],2), 1);
fitvalue1 = polyval(curvefit1,linspace(0,1000,100));
%plot(linspace(0,1000,100),fitvalue1*3600)


hold on
curvefit2 = polyfit(slopes([10,15,20,30,40,50],1), slopes([10,15,20,30,40,50],2), 2);
fitvalue2 = polyval(curvefit2,linspace(1000,5000,100));
%plot(linspace(1000,5000,100),fitvalue2*3600)


%theoretical flowrate
hold on
D = linspace(200,5000,1000);
o = pi^2/(200*32)./(D/1000000);
V = pi*0.02672^2*o*0.008/1*1000000*3600;
%plot(D,V)

hold on
% Define ‘x’ and ‘y’ here
x = slopes([2:10,15,20,30,40,50],1);
y = slopes([2:10,15,20,30,40,50],2)*3600;
% Parameter Vector: b(1) = a,  b(2) = b,  b(3) = c
yfit = @(b,x) b(1)./(x + b(2)) + b(3);  % Objective Function
CF = @(b) sum((y-yfit(b,x)).^2);        % Cost Function
b0 = rand(1,3)*1000000;                      % Initial Parameter Estimates
[B, fv] = fminsearch(CF, b0);           % Estimate Parameters

a = linspace(0,5000,100);
b = B(1)./(a + B(2)) + B(3);
plot(a, b);
xlim([200,5000]);
xlabel('delaytime')
ylabel('flow rate ml/hr')
%legend('experiment','linear region apprixmation', 'non-linear region approximation','theoretical')
legend('experimental data','inverse power curve apprixmation')





%% 

