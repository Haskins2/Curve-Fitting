close all
clear

% Answer each task in the places shown. The code at the end checks that you
% have created the right variables requested
raw_data = xlsread('muscle_data_2023.xlsx');
strain = raw_data(:, 3);
stress = raw_data(:, 4);


% Task 1

figure(1);
h_task1 = plot(strain, stress, 'Color', 'Blue', 'LineWidth', 3.0 );

hold on;
grid on;
title('Stress vs Strain', 'FontSize', 20);
xlabel('Strain', 'FontSize', 20);
ylabel('Stress', 'FontSize', 20);


% Task 2

m = (1:5);
sse_per_m = zeros(1, length(m));

for i = m
    poly_coeffs = polyfit(strain, stress, i);
    stress_error = polyval(poly_coeffs, strain, i);
    sse_per_m(i) = sum((stress - stress_error) .^ 2);
end

figure(2);
h_2 = plot(m, sse_per_m, 'Color', 'red', 'LineWidth', 3.0);
hold on;
grid on;

my_m = 3; %curve flattens out after 3


% Task 3

polyToGraph = polyfit(strain, stress, my_m);
estStress = polyval(polyToGraph, strain);

figure(1);
h_3 = plot(strain, estStress, 'Color', 'red', 'LineWidth', 3.0);


% Task 4

figure(3);

stressError = stress - estStress;

hist(stressError, 20);

SST = norm(stress - mean(stress)) ^ 2;
SSR = norm(stressError) ^ 2;
ccoef_p = 1 - SSR / SST;
fprintf('Coeffecient of Determination = %f \n', ccoef_p);

% Task 5

initialEst = [0.2, 0.2, 0.2, 0.2, 0.2];

func = @(x) sum(abs((stress - (x(1) + x(2) * strain + x(3) * strain .^ 2 ...
 + x(4) * strain .^ 3))));

a = fminsearch(func, initialEst);
abs_est_stress = a(1) + a(2) * strain + a(3) * strain .^ 2 ...
 + a(4) * strain .^ 3 + a(5) * strain .^ 4;


figure(1);
task_5 = plot(strain, abs_est_stress, 'Color', 'black', ...
    'LineStyle', '--', 'LineWidth', 3.0);
legend('Stress vs Strain', 'Estimated Stress', 'ABS Estimated Stress');
legend('Location', 'southeast');

% Task 6

nl_data = abs_est_stress(25:70);
poly = polyfit(strain, stress, 4);
est_stress = polyval(poly, strain);
ls_data = est_stress(25:70);
%finding data needed for MSE

%mseVal = mean((a - b).^2)


ccoef_nl = mean((stress(25:70) - ls_data) .^ 2);
err_nl = mean((stress(25:70) - nl_data) .^ 2);
fprintf('MSE of LS = %f \n', ccoef_nl);
fprintf('MSE of Robust fit = %f', err_nl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The lines below here just check that you have addressed the variables
% required in the assignment.
%% Check my variables
if ( ~ exist('a'))
  fprintf('\nVariable "a" does not exist.')
end;
if ( ~ exist('err_nl'))
  fprintf('\nVariable "mse_nl" does not exist.')
end;
if ( ~ exist('ccoef_nl'))
  fprintf('\nVariable "mse_ls" does not exist.')
end;
if ( ~ exist('ccoef_p'))
  fprintf('\nVariable "ccoef_p" does not exist.')
end;
if ( ~ exist('est_stress'))
  fprintf('\nVariable "est_stress" does not exist.')
end;
if ( ~ exist('my_m'))
  fprintf('\nVariable "my_m" does not exist.')
end;
if ( ~ exist('sse_per_m'))
  fprintf('\nVariable "sse_per_m" does not exist.')
end;
fprintf('\n');