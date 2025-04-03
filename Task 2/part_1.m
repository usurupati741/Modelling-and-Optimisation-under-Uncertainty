%% Step 1: Create Fuzzy Inference System (FIS)
fis = mamfis('Name', 'SmartHomeFLC');

%% Step 2: Define Inputs (Temperature, Humidity, Light Level)
fis = addInput(fis, [0 50], 'Name', 'Temperature'); % Range: 0°C - 50°C
fis = addInput(fis, [0 100], 'Name', 'Humidity');   % Range: 0% - 100%
fis = addInput(fis, [0 1], 'Name', 'Light');        % 0 = Dark, 1 = Bright

%% Step 3: Define Outputs (Heating, Cooling, Lighting)
fis = addOutput(fis, [0 1], 'Name', 'Heating');     % 0 = Off, 1 = Full Heat
fis = addOutput(fis, [0 1], 'Name', 'Cooling');     % 0 = Off, 1 = Full Cooling
fis = addOutput(fis, [0 1], 'Name', 'Lighting');    % 0 = Off, 1 = Full Brightness

%% Step 4: Define Membership Functions (MFs)
% Temperature MFs
fis = addMF(fis, 'Temperature', 'trapmf', [0 0 10 20], 'Name', 'Cold');
fis = addMF(fis, 'Temperature', 'trimf', [10 25 40], 'Name', 'Comfortable');
fis = addMF(fis, 'Temperature', 'trapmf', [30 40 50 50], 'Name', 'Hot');

% Humidity MFs
fis = addMF(fis, 'Humidity', 'trapmf', [0 0 20 40], 'Name', 'Dry');
fis = addMF(fis, 'Humidity', 'trimf', [30 50 70], 'Name', 'Normal');
fis = addMF(fis, 'Humidity', 'trapmf', [60 80 100 100], 'Name', 'Humid');

% Light MFs
fis = addMF(fis, 'Light', 'trimf', [0 0 0.5], 'Name', 'Dark');
fis = addMF(fis, 'Light', 'trimf', [0.25 0.5 0.75], 'Name', 'Medium');
fis = addMF(fis, 'Light', 'trimf', [0.5 1 1], 'Name', 'Bright');

% Heating MFs
fis = addMF(fis, 'Heating', 'trimf', [0 0 0.5], 'Name', 'Low');
fis = addMF(fis, 'Heating', 'trimf', [0.25 0.5 0.75], 'Name', 'Medium');
fis = addMF(fis, 'Heating', 'trimf', [0.5 1 1], 'Name', 'High');

% Cooling MFs
fis = addMF(fis, 'Cooling', 'trimf', [0 0 0.5], 'Name', 'Low');
fis = addMF(fis, 'Cooling', 'trimf', [0.25 0.5 0.75], 'Name', 'Medium');
fis = addMF(fis, 'Cooling', 'trimf', [0.5 1 1], 'Name', 'High');

% Lighting MFs
fis = addMF(fis, 'Lighting', 'trimf', [0 0 0.5], 'Name', 'Dim');
fis = addMF(fis, 'Lighting', 'trimf', [0.25 0.5 0.75], 'Name', 'Normal');
fis = addMF(fis, 'Lighting', 'trimf', [0.5 1 1], 'Name', 'Bright');

%% Step 5: Define Fuzzy Rules
ruleList = [
    "Temperature==Cold & Light==Dark => Heating=High, Lighting=Bright (1)"
    "Temperature==Hot & Humidity==Dry => Cooling=High, Heating=Low (1)"
    "Temperature==Comfortable & Humidity==Normal => Cooling=Low, Lighting=Normal (1)"
    "Light==Dark => Lighting=Bright (1)"
    "Light==Medium => Lighting=Normal (1)"
    "Light==Bright => Lighting=Dim (1)"
];

fis = addRule(fis, ruleList);

%% Step 6: Display the Defined Rules
disp('Fuzzy Rules Successfully Added:');
disp(showrule(fis));

%% Step 7: Plot Membership Functions with Different Colors
color_list = {'r', 'g', 'b'}; % Define colors for each membership function

figure;
subplot(3,1,1);
[x, y] = plotmf(fis, 'input', 1);
plot(x', y', 'LineWidth', 1.5);
title('Temperature Membership Functions');
legend({'Cold', 'Comfortable', 'Hot'}, 'Location', 'best');
grid on;

subplot(3,1,2);
[x, y] = plotmf(fis, 'input', 2);
plot(x', y', 'LineWidth', 1.5);
title('Humidity Membership Functions');
legend({'Dry', 'Normal', 'Humid'}, 'Location', 'best');
grid on;

subplot(3,1,3);
[x, y] = plotmf(fis, 'input', 3);
plot(x', y', 'LineWidth', 1.5);
title('Light Membership Functions');
legend({'Dark', 'Medium', 'Bright'}, 'Location', 'best');
grid on;

figure;
subplot(3,1,1);
[x, y] = plotmf(fis, 'output', 1);
plot(x', y', 'LineWidth', 1.5);
title('Heating Membership Functions');
legend({'Low', 'Medium', 'High'}, 'Location', 'best');
grid on;

subplot(3,1,2);
[x, y] = plotmf(fis, 'output', 2);
plot(x', y', 'LineWidth', 1.5);
title('Cooling Membership Functions');
legend({'Low', 'Medium', 'High'}, 'Location', 'best');
grid on;

subplot(3,1,3);
[x, y] = plotmf(fis, 'output', 3);
plot(x', y', 'LineWidth', 1.5);
title('Lighting Membership Functions');
legend({'Dim', 'Normal', 'Bright'}, 'Location', 'best');
grid on;

%% Step 8: Evaluate and Simulate the Fuzzy Controller
input_values = [15 50 0]; % Example: Temperature=15°C, Humidity=50%, Light=Dark
output_values = evalfis(fis, input_values);

fprintf('\nSimulation Results:\n');
fprintf('Heating: %.2f\n', output_values(1));
fprintf('Cooling: %.2f\n', output_values(2));
fprintf('Lighting: %.2f\n', output_values(3));

%% Step 9: Visualizing the Control Surfaces with Different Colors
figure;
gensurf(fis, [1 2]); % Temperature vs Humidity for Heating
colormap(jet); % Use 'jet' colormap for variation
title('Control Surface: Temperature vs Humidity for Heating');
colorbar;

figure;
gensurf(fis, [1 3]); % Temperature vs Light for Lighting
colormap(parula); % Use 'parula' colormap for a different look
title('Control Surface: Temperature vs Light for Lighting');
colorbar;

figure;
gensurf(fis, [2 3]); % Humidity vs Light for Cooling
colormap(hot); % Use 'hot' colormap for distinction
title('Control Surface: Humidity vs Light for Cooling');
colorbar;


%% Step 10: Save and Export FIS
writeFIS(fis, 'SmartHomeFLC.fis');

disp('Fuzzy Logic Controller Successfully Designed and Simulated!');
