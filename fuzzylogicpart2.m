
% Benchmark functions
sphereFunction = @(x) sum(x.^2);
rastriginFunction = @(x) 10 * numel(x) + sum(x.^2 - 10 * cos(2 * pi * x));
griewankFunction = @(x) 1 + sum(x.^2 / 4000) - prod(cos(x ./ sqrt(1:numel(x))));

% Define the benchmark functions
benchmarkFuncs = {sphereFunction, rastriginFunction, griewankFunction};
benchmarkNames = {'SphereFunction', 'RastriginFunction', 'GriewankFunction'};

% Dimensions to evaluate
dimensionSizes = [2, 10];

% Number of iterations for averaging
iterations = 15;

% Initialize storage for results
evaluationResults = struct();

for idxFunc = 1:numel(benchmarkFuncs)
    currentFunc = benchmarkFuncs{idxFunc};
    funcName = benchmarkNames{idxFunc};
    
    for idxDim = 1:numel(dimensionSizes)
        D = dimensionSizes(idxDim);
        
        % Initialize storage for performance data
        performanceData = struct('GA', [], 'PSO', [], 'SA', []);
        
        for trial = 1:iterations
            % GA optimization
            gaOptions = optimoptions('ga', 'Display', 'off');
            [~, fval] = ga(currentFunc, D, [], [], [], [], [], [], [], gaOptions);
            performanceData.GA = [performanceData.GA; fval];
            
            % PSO optimization
            psoOptions = optimoptions('particleswarm', 'Display', 'off');
            [~, fval] = particleswarm(currentFunc, D, [], [], psoOptions);
            performanceData.PSO = [performanceData.PSO; fval];
            
            % SA optimization
            saOptions = saoptimset('Display', 'off');
            [~, fval] = simulannealbnd(currentFunc, rand(1, D), [], [], saOptions);
            performanceData.SA = [performanceData.SA; fval];
        end
        
        % Compute statistics
        evaluationResults.(funcName).(sprintf('Dim%d', D)).GA = performanceData.GA;
        evaluationResults.(funcName).(sprintf('Dim%d', D)).PSO = performanceData.PSO;
        evaluationResults.(funcName).(sprintf('Dim%d', D)).SA = performanceData.SA;
        
        % Display results
        fprintf('Function: %s, Dimension: %d\n', funcName, D);
        fprintf('GA - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(performanceData.GA), std(performanceData.GA), min(performanceData.GA), max(performanceData.GA));
        fprintf('PSO - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(performanceData.PSO), std(performanceData.PSO), min(performanceData.PSO), max(performanceData.PSO));
        fprintf('SA - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(performanceData.SA), std(performanceData.SA), min(performanceData.SA), max(performanceData.SA));
        
        % Plot results
        figure;
        hold on;
        plot(performanceData.GA, '-o', 'DisplayName', 'GA');
        plot(performanceData.PSO, '-x', 'DisplayName', 'PSO');
        plot(performanceData.SA, '-s', 'DisplayName', 'SA');
        xlabel('Run Number');
        ylabel('Objective Function Value');
        title(sprintf('Performance Comparison on %s (Dimension=%d)', funcName, D));
        legend;
        hold off;
    end
end