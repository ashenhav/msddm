% Example script for how to call function MSDDM_wrapper
    % Main inputs to change are vectors of stage onsets (deadlines), drift (a) /noise (s) at each stage, and distribution of starting points at 1st stage
    % For convenience, also currently allows for looping over multiple different *uniform* thresholds across the MS-DDM 
        % (using different thresholds for each stage is theoretically possible, but requires a few modifications to the core functions first)
    % Also options for running simulations to compare results (this will obviously take much longer) and some basic plots
% Outputs:
    % aRT, aER = vectors of analytic expected decision time and error rate, one for each threshold being tested [using multi_stage_ddm_metrics]
    % aCDF_T, aCDF_Y = cell array of analytic CDFs (..._T = RT range, ..._Y = cumul prob), one for each threshold being tested [using multistage_ddm_fpt_dist]
    % simMeanRT, simMeanER, simCDF_T, simCDF_Y = same as above, but using MC simulations to generate each value estimate

clc
clear all
close all


%%%%%%%%  EXAMPLE 1: 4 stages with variable drift/noise/threshold %%%%%%%%%
% % The following vectors need to be the same length:
% % Times (secs) at which  each stage starts (i.e., t0, t1, t2....)
% deadlines=[0 1 2 3];
% % Vector of drift rates (i.e., a0, a1, a2....)
% a=[0.1 0.2 0.05 0.3];
% % Vector of diffusion rates (noise coefficients)
% s=[1 1.5 1.25 2];
% % Vector of thresholds (IF varying by stage) - set to NaN if using uniform thresh
% varthresh = 2*[1 1.5 0.5 1.25];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%  EXAMPLE 2: collapsing to a lower bounds  %%%%%%%%%
% The following vectors need to be the same length:
% Times (secs) at which  each stage starts (i.e., t0, t1, t2....)
deadlines = linspace(0,5,20);
% Vector of drift rates (i.e., a0, a1, a2....)
a = 0.15*ones(1,20);
% Vector of diffusion rates (noise coefficients)
s = 1.0*ones(1,20);
% Vector of thresholds (IF varying by stage) - set to NaN if using uniform thresh
varthresh = linspace(3.0,1.0,20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%

% Thresholds to test (can enter vector or individual point) 
    % (IMPORTANT: these are thresholds to test for different runs of the multi-stage DDM, 
    %  each with a uniform threshold across stages -- thresholds for different *stages* would be set in varthresh)
    thresh=[];  % if using variable threshold, this can be ignored
    % % thresh=0.5:0.5:2.0;
    

% Support of initial condition (at first stage) and its density (i.e., can enter distribution or individual point)
    x0 = -0.2;   % starting point(s)     
    x0dist = 1;  % probability distribution of starting point(s) -- 1 if deterministic

% Run MC simulations for the sake of comparison? (NB: simulations can be made to be more efficient than currently)
    runSimulations = 1;

% Generate plots? Would include following subplots: 
    % (1a-b) analytic vs. simulated DT/ER across thresholds tested
    % (1c)   analytic vs. simulated CDF for *final* threshold
    % (2a-b) same as 1a,c but split into positive/negative threshold crossings
    doPlots = 1;

% Current error-check to avoid threshold values of exactly zero:
    varthresh(abs(varthresh)<1e-15) = sign(varthresh(abs(varthresh)<1e-15))*1e-15;


if runSimulations
    [aRT, aER, aRT_plus, aRT_minus, aCDF_T, aCDF_Y, aCDF_Y_plus, aCDF_Y_minus, ...
        simMeanRT, simMeanER,simMeanRT_plus,simMeanRT_minus, simCDF_T, simCDF_Y, simCDF_Y_plus, simCDF_Y_minus] = ...
        MSDDM_wrapper(a,s,varthresh,deadlines,thresh,x0,x0dist,runSimulations,doPlots);
else
    [aRT, aER, aRT_plus, aRT_minus, aCDF_T, aCDF_Y, aCDF_Y_plus, aCDF_Y_minus] = ...
        MSDDM_wrapper(a,s,varthresh,deadlines,thresh,x0,x0dist,runSimulations,doPlots);
end


