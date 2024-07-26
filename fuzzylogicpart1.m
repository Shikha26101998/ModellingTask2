
% Define the FIS
fis = mamfis('Name', 'FanSpeedController');

% Add input variables with different range names
fis = addInput(fis, [0 40], 'Name', 'Temp');
fis = addInput(fis, [0 100], 'Name', 'HumidityLevel');

% Add output variable
fis = addOutput(fis, [0 100], 'Name', 'Speed');

% Add membership functions for Temp
fis = addMF(fis, 'Temp', 'trimf', [-10 0 20], 'Name', 'Cold');
fis = addMF(fis, 'Temp', 'trimf', [10 20 30], 'Name', 'Warm');
fis = addMF(fis, 'Temp', 'trimf', [20 40 50], 'Name', 'Hot');

% Add membership functions for HumidityLevel
fis = addMF(fis, 'HumidityLevel', 'trimf', [0 20 40], 'Name', 'Dry');
fis = addMF(fis, 'HumidityLevel', 'trimf', [30 50 70], 'Name', 'Normal');
fis = addMF(fis, 'HumidityLevel', 'trimf', [60 80 100], 'Name', 'Wet');

% Add membership functions for Speed
fis = addMF(fis, 'Speed', 'trimf', [0 25 50], 'Name', 'Slow');
fis = addMF(fis, 'Speed', 'trimf', [25 50 75], 'Name', 'Moderate');
fis = addMF(fis, 'Speed', 'trimf', [50 75 100], 'Name', 'Fast');

% Add rules with different names for readability
ruleList = [
    1 1 1 1 1;
    1 2 2 1 1;
    1 3 3 1 1;
    2 1 1 1 1;
    2 2 2 1 1;
    2 3 3 1 1;
    3 1 2 1 1;
    3 2 3 1 1;
    3 3 3 1 1;
];

fis = addRule(fis, ruleList);

% Save the FIS for future use
writeFIS(fis, 'FanSpeedController');

% Generate the FIS Structure plot
figure;
subplot(2,2,1);
plotmf(fis, 'input', 1);
title('MF for Temp');

subplot(2,2,2);
plotmf(fis, 'input', 2);
title('MF for HumidityLevel');

subplot(2,2,3);
plotmf(fis, 'output', 1);
title('MF for Speed');

% Generate the Control Surface plot
figure;
gensurf(fis);
title('Control Surface Plot');
xlabel('Temp');
ylabel('HumidityLevel');
zlabel('Speed');

% Open the Rule Viewer
figure;
ruleview(fis);
title('Rule Viewer');


