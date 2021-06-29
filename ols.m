function [b,s2,R2,yhat]=ols(y,x,c)
% PURPOSE: Estimate coefficients using OLS 

% INPUTS:
%   y - n by 1 vector containing the independent variable
%   x - n by k matrix of regressors.  Should not contain a constant
%   c - Boolean indicating whether to add a constant to X (c = 1 include constant) 
%
% OUTPUT:
%   b          - Parameter estimates
%   s2         - Estimated variance of residual (uses T, not T-1)
%   R2         - R-squared
%   yhat       - Fit values

n = length(y);% Length of data
k = size(x,2);% Number of regressors

% Add constant if needed by setting c ==1
if c == 1;
    x = [ones(n,1), x]; % extend x with 1st col as ones
    k = k + 1; % increase the number of regressors with constant
end

% Compute OLS coefficients
b = inv(x'*x)*(x'*y);
% Compute fitted values
yhat = x*b;
% Compute residual errors
e = y - yhat; 
% Compute s2
s2 = e'*e/(n-k);
% Compute correct R2
R2 = 1 - (e'*e)/((y - mean(y))'*(y - mean(y)));

