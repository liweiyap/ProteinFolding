clear all;  % just a precaution
addpath('include');

% folding variables
temperature = 1;      % temperature
maxiter = 10^7;       % total no. of iterations of Metropolis algorithm
max_folding_seq = 2;  % no. of folding sequences to be concurrently run on the same starting polypeptide

% protein variables
hydrophobicity = [0, 0, 1, 0, 1, 1, ...
                  0, 1, 0, 0, 0, 0, ...
                  1, 1, 0, 0, 1, 1, ...
                  0, 0, 0, 1, 0, 1, ...
                  1, 0, 0, 0, 1, 1, ...
                  0, 0, 1, 1, 0, 1];                     % let 0 be P residue and let 1 be H residue
xvals = 1:length(hydrophobicity);                        % initial x-values of every residue in polypeptide
for folding_seq = 1:(max_folding_seq-1)
    xvals = cat(1, xvals, xvals(1,:));
end
yvals = zeros(max_folding_seq, length(hydrophobicity));  % initial y-values of every residue in polypeptide
energyArray = zeros(max_folding_seq, maxiter+1);         % energy at the end of all trial moves

% start the timer: takes <180 seconds (<3 minutes) with 10^7 iterations for 2 parallel folding_seq
tic;
parfor folding_seq = 1:max_folding_seq
    [xvals(folding_seq,:), yvals(folding_seq,:), energyArray(folding_seq,:)] = fold(hydrophobicity, xvals(folding_seq,:), yvals(folding_seq,:), energyArray(folding_seq,:), temperature, maxiter);
end
toc;

% plot results
for folding_seq = 1:max_folding_seq
    figure(folding_seq);
    
    subplot(2, 2, 1); hold on;
    plotInitialStruct(hydrophobicity, 1:length(hydrophobicity), zeros(1,length(hydrophobicity)));
    hold off;
    
    subplot(2, 2, 2); hold on;
    plotFinalStruct(hydrophobicity, xvals(folding_seq,:), yvals(folding_seq,:), false);
    hold off;
    
    subplot(2, 2, [3, 4]);
    plotEnergy(energyArray(folding_seq,:));
end