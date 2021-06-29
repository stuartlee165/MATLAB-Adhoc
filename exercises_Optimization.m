%% Exercise 1
% read Harvard Management Compnay data from HMC data.xls 
[num,txt] = xlsread('HMC data.xls', 'Sheet1');
ret = num(:,1) * 100; % convert to percentage 
stdev = num(:,2) * 100;
corr_mat = num(:,3:end); % correlation matrix

assets = txt(2:end,1); % read name


%% Exercise 2
% use scatterplot() function to plot (risk, return) pairs in a mean-variance space

clf; %clear current figure window
figure(1);
scatter(stdev, ret, 40, 'filled'); % 40mm circle area with filled color
title('Scatter Plot')
xlabel('Risk (%)');
ylabel('Return (%)');
xlim([0 25]); % x-axis limits
ylim([0 10]);
% text annotation: text(x-axis location, y-axis location, content, size)
assets_labels = {'DE', 'FE', 'EM', 'PE', 'AR', 'HY', 'CMD', 'RE', 'DB', 'FB', 'IB', 'CASH'};
for i=1:length(ret)
    text(stdev(i)-0.35, ret(i)-0.2, assets_labels(i), 'FontSize',8);
end



%% Exercise 3
% compute covariance matrix
cov_mat = stdev * stdev' .* corr_mat;

% compute portfolio variance
% see compute_pvar function

%% Exercise 5
% use fmincon to calculate Global Minimum Variance Portfolio

% constraint: sum of weights is 1
N = length(ret); % number of asset in the portofolio
Aeq = ones(1, N);beq = 1;

% suppress optimization message
options = optimset('Display', 'off');

% column vector for initial weight 
w0 = ones(N,1)*(1/N);  

w1 = fmincon(@(w)compute_pvar(w, cov_mat), w0, [], [], Aeq, beq,...
    [], [], [], options);

pvar1 = compute_pvar(w1, cov_mat);
fprintf('The variance of GMVP is %.4f.\n', pvar1);


%% Exercise 6
% Minimum Variance Portfolio with the following constraints
% no shortsell
% all individual sector weights must be less than 20%

Aeq = ones(1, N);
beq = 1;
lb = zeros(1, N);
ub = ones(1,N) * 0.2;

w0 = ones(N,1)*(1/N);  
w2 = fmincon(@(w)compute_pvar(w, cov_mat), w0, [], [], Aeq, beq, lb, ub, [], options);
pvar2 = compute_pvar(w2, cov_mat);
fprintf('The variance of constrainted MVP is %.4f.\n', pvar2);


%% Exercise 7:
% Minimize portfolio variance for a given target return 10%

% two constraints: fully invested and target portfolio return
Aeq = [ones(1,N); ret'];
beq = [1; 10];

w0 = ones(N,1)*(1/N);  
w3 = fmincon(@(w)compute_pvar(w, cov_mat), w0, [], [], Aeq, beq, [], [], [], options);
pvar3 = compute_pvar(w3, cov_mat);
fprintf('The minimum variance for a portfolio of 10 percent target return is %.4f.\n', pvar3);


%% Exercise 8:
% (1) write a user-defined function to calculate sharpe ratio of a
% portfolio (assuming risk-free is 3% per year)
% (2) compute the optimal portfolio weight that maximizes sharpe ratio

% see compute_sharpe

% maximize sharpe
Aeq = ones(1,N);
beq = 1;

w0 = ones(N,1)*(1/N);  
% NOTE: use - to convert max optimization to a min optimization problem
w4 = fmincon(@(w)-compute_sharpe(w, ret, cov_mat), w0, [], [], Aeq, beq, [], [], [], options);
sr1 = compute_sharpe(w4, ret, cov_mat);
fprintf('The maximized Sharpe Ratio is %.4f.\n', sr1);


%% Exercise 9:
% construct Efficient Frontier (exclude CASH) and plot it

target_ret = 3:0.2:15;
M = length(target_ret);
pstdevs = zeros(M,1);
prets = zeros(M,1);

% Minimize variance for a range of target returns
for i=1:M
    Aeq = [ones(1,N-1); ret(1:end-1)'];
    beq = [1; target_ret(i)];

    w0 = ones(N-1,1)*1/(N-1)
    w_res = fmincon(@(w)compute_pvar(w, cov_mat(1:end-1, 1:end-1)), w0, [], [], Aeq, beq, [], [], [], options);
    pstdevs(i)  = sqrt(compute_pvar(w_res, cov_mat(1:end-1, 1:end-1)));
    prets(i) = w_res' * ret(1:end-1);
end

% plot
clf;
figure(3);
plot(pstdevs, prets)
hold on
scatter(stdev(1:end-1), ret(1:end-1), 40, 'filled');
title('Efficient Frontier')
xlabel('Risk (%)');
ylabel('Return (%)')



