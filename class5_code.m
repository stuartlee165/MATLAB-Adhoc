%% Basic Linear Regression

%% Notes
% The main task in this assignment is to write an OLS function to compute
% many interesting quantities from a regression. 

% Setup
clear all
close all
clc


%% Estimate the model on S1, V1
% alternative code of reading from excel file 
[FF_factors, FF_factors_labels]= xlsread('FF_data_monthly.xlsx');
[FF_portfolios, FF_portfolios_labels]= xlsread('FF_data_IndusPort.xlsx');
save FF_data_class5.mat

% Load data Fama French 3 Factors
load FF_data_class5.mat
% Assign X: Mkt-RF, SMB, HML (last col as rf)
x = FF_factors(:,1:3);
% Assign y: Use the Consumer Industry portoflio return;
y = FF_portfolios(:,1);

% Remove row observations with nan values due to missing data
missing = any(isnan(x),2);
x = x(~missing,:);
y = y(~missing);
% Use ols: 3rd input =1 as including constant
[b,s2,R2,yhat] = ols(y,x,1);
% Display results
disp('Coefficients for constant,Mkt-RF, SMB, HML')
disp(b')
disp('Standard Error of Residual')
disp(sqrt(s2));
disp('R2')
disp(R2);

%% Rolling Regressions for 1 asset
clear all
close all
clc


%% Rolling Regressions for 1 asset
% Rolling estimates are just the usual estimate only for a sub-sample of
% the data, and so a loop is needed.

% Load data
load FF_data_class5.mat
dd = FF_factors_labels(2:end,1);
ddnum = datenum(dd,'dd/mm/yyyy');
datestr(ddnum)
% Remove row observations with nan values due to missing data
missing = any(isnan(x),2);
x = x(~missing,:);
y = y(~missing);
n = size(y,1);

% Full sample estimate as set for benchmark
[b_full_sample,~,~,~] = ols(y,x,1); % only read the first output 
% Matrix n*k to store the output
k = 4;
se_roll = zeros(n,k);
b_roll = zeros(n,k);
% Define the Window 
tau = 60;
% Loop from 60 to the end
for t=60:n
    x_roll = x(t-tau+1:t,:);
    y_roll = y(t-tau+1:t);
    [b_roll(t,:),var_roll,~,~]=ols(y_roll,x_roll,1);
    se_roll(t,:) = sqrt(var_roll);
end

% only plot the exposure to the market risk: 
% the second element of the coefficient output 
plotdd = ddnum(tau:end,:);
plotb_full_sample = b_full_sample(2)*ones(n-60+1,1);
plotb_roll = b_roll(tau:end,2);
% Plot the data
plot(plotdd, plotb_full_sample, plotdd, plotb_roll);
datetick('x');
xlim([plotdd(1), plotdd(end)]);
% Add a legend
legend('Constant \beta','Rolling \beta','Location','NorthWest');

%% Do the market exposures appear constant?
% Most of the exposures spend a good deal of time outside of the naive
% confidence intervals.  While this isn't proof, it is a strong indication
% that market exposures are time varying.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Maximum Likelihood
% Clean up everything
clear all; 
close all;
clc; 

% Maximum Likelihood: 
load FF_data_class5.mat
% calculate log return for the 1st asset only 
x = FF_portfolios(:,1);
% Random Initial Guessing
param0 = [1, 2];
% Estimate with conditional optimization
parm_est = fmincon(@(parameters)loglike_normal(parameters,x),param0);
% Calculate the sample statistics
parm_data = [mean(x) std(x)];
% Display
disp('Consumption Industry Returns')
disp('MLE estimates of mu, sigma')
disp(parm_est)
disp('sample estimates of mu, sigma')
disp(parm_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Results 
% Consumption Industry Returns
% MLE estimates of mu, sigma
%    1.0060    5.3530
% sample estimates of mu, sigma
%    1.0060    5.3556

