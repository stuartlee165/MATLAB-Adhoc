% Class 3&4: MA trading strategy
help hist_stock_data

%% Simple Trading Strategy: Moving Average CrossOver




% ticker symbol: SP500 ETF
symbol = 'SPY';
% start/end dates, format ddmmyyyy
start_date = '01012000';
end_date = '31072015';

spy_data = hist_stock_data(start_date, end_date, symbol);

spy_dates = datenum(flipud(spy_data.Date));
spy_prices = flipud(spy_data.AdjClose);
spy_volumes = flipud(spy_data.Volume);

% daily log return
spy_rets = diff(log(spy_prices));

% plot histogram
clf;
figure(4);
histfit(spy_rets, 10) % histogram of data with 50 bins to separate data
title('Histogram of SPY Returns')

% short-term exponential moving average 20 days
ema_20 = tsmovavg(spy_prices', 'e', 20);
% long-term exponential moving average 120 days
ema_120 = tsmovavg(spy_prices', 'e', 120);

% crossover signals
signs = (ema_20 - ema_120)./abs(ema_20 - ema_120);
signs_current = signs(2:end);
signs_lag = signs(1:end-1);
% buy signal: when the ema_20 cross ema_120 from below 
% t: ema_20 > ema_120 (signal_current > 0) 
% t-1: ema_20 < ema_120 (signal_lag < 0)
idx_buy = find((signs_current > 0) & (signs_lag < 0));

% sell signal: when the ema_20 drop to cross ema_120 from above
% t: ema_20 < ema_120 (signal_current < 0) 
% t-1: ema_20 > ema_120 (signal_lag > 0)
idx_sell = find((signs_current < 0) & (signs_lag > 0));


% plot
clf;
figure(5);
dates_limits = [min(spy_dates), max(spy_dates)];
plot(spy_dates, spy_prices, 'b', spy_dates, ema_20, 'r',...
    spy_dates, ema_120, 'g')
legend('SPY Price', 'EMA(20)', 'EMA(120)', 'Location','northwest')
datetick('x')
xlim(dates_limits)
hold on
scatter(spy_dates(idx_buy), spy_prices(idx_buy), 'r^', 'filled')
scatter(spy_dates(idx_sell), spy_prices(idx_sell), 'gv', 'filled')
xlabel('Date')
ylabel('Price')
title('MA-CrossOver Trading Strategy')







%% naive backtest
% long when having a buy signal and short when having a 
% sell signal

% backtest
% create empty position the same length as prices
positions = nan(length(spy_prices),1);
% replace position = 1 if buy signal 
positions(idx_buy) = 1;
% replace position =-1 if sell signal
positions(idx_sell) = -1;
% logical value to identify non-NaN elements 
idx = (~isnan(positions)); 
% position(idx) only read data of position when idx has a logical value ==1
signals = [0; positions(idx)];
% combine the singal to creat the positions vector by using cumsum tricks
% (not examinable)
positions = signals(cumsum(idx)+1);

% daily SPY return
spy_rets = diff(spy_prices)./spy_prices(1:end-1,:);
% daily portfolio return
p_rets = spy_rets .* positions(2:end);

% equity curve cumulative equity return
equity_curve = cumprod(1+p_rets);

% drawdown curve
high_water_mark = 1; % return percentage
dd_curve = zeros(length(equity_curve),1);
for i = 1:length(equity_curve)
    if equity_curve(i) > high_water_mark
        high_water_mark = equity_curve(i);
    end
    drawdown = (high_water_mark - equity_curve(i)) / equity_curve(i);
    dd_curve(i) = drawdown;
end

% plot equity curve and drawdown curve
clf;
figure(6);
subplot(2,1,1)
plot(spy_dates(2:end), equity_curve)
ylim([0.5, 4])
datetick('x')
title('Equity Curve')
subplot(2,1,2)
plot(spy_dates(2:end), dd_curve)
datetick('x')
title('DrawDown Curve')

% number of trading signals
num_signals = length(idx_buy) + length(idx_sell);
fprintf('Number of signals generated is %i \n', num_signals);

% calculate CRGA; (14+7/12)as 14 yr 7 mth sample period
CRGA = (spy_prices(end)/spy_prices(1))^(1/(14+7/12)) - 1;
fprintf('Average Annual Return is %.4f \n', CRGA);

% calculate sharpe ratio
annual_ret = mean(p_rets) * 252;
annual_std = std(p_rets) * sqrt(252); 
sharpe_ratio = (annual_ret - 0.03) / annual_std;
fprintf('Sharpe Ratio is %.2f \n', sharpe_ratio);
