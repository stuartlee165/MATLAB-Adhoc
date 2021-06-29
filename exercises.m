%% Exercise 1
% Create a simple if structure that returns the absolute value of a variable x.
% MATLAB predefined function abs(.) performs the same task.


x = input('Please enter a number: ');

if (x >= 0)
    res = x;  % in case that x is non-negative, return itself
else
    res = -x;  % in case that x is negative, return its negated value 
end
% display results: display 
display (['Input = ', num2str(x)])
display (['Result = ', num2str(res)])

% display results: fprintf 
fprintf('Input value is %.2f.\nResult is %.2f.\n', x, res)

% num2str convert number variable x into string to display together in the file
% fprintf format: %:start of formating; .2: 2 digitals; f: floating number 
%                 \n : start of new row

%% Exercise 2
% Create an if structure that depending on some control variable, called
% control, calculates and stores in a new variable result (i) the absolute
% value, (ii) the square, (iii) the square root, in case it is positive, of
% variable x, when control = 1,2 or 3 respectively.


% control variable
control = input('Please specify the control variable.\n1 for abs, 2for squared, 3 forsquare root:  ');
x = input('Please enter a number: ');
if (control == 1)
    res = abs(x);
elseif (control == 2)
    res = x * x;
elseif (control == 3)
    if (x > 0)
        res = sqrt(x);
    else
        error('Negative number has no squared root.')
    end
else 
    error('Invalid control variable.\n') 
end           
fprintf('Input value is %.2f.\nResult is %.2f.\n', x, res)
      

%% Exercise 3
% Extend exercise 2 and set x = 0 and result=0 when the control variable is
% different from the one of the expected choices.
% error: the code will stop at the line when error emerged 

% control variable
control = input('Please specify the control variable.\n1 for abs, 2 for squared, 3 forsquare root:  ');
x = input('Please enter a number: ');

if (control == 1)
    res = abs(x);
elseif (control == 2)
    res = x * x;
elseif (control == 3)
    if (x > 0)
        res = sqrt(x);
    else
        error('Negative number has no squared root.')
    end
else
    fprintf('Invalid control variable.\n')
    x = 0;
    res = 0;
end
           
fprintf('Input value is %.2f.\nResult is %.2f.\n', x, res)


%% Exericse 4
% Perform the same tasks as in exercise 2 and 3 with the use of a switch
% structure.

control = menu('Please specify the control variable', 'abs', 'squared', 'square root');
x = input('Please enter a number: ');
switch control
    case 1
        res = abs(x);
    case 2
        res = x * x;
    case 3
        if (x > 0)
            res = sqrt(x);
        else
            error('Negative number has no squared root.')
        end
    otherwise
        fprintf('Invalid control variable.\n')
        x = 0;
        res = 0;
end     
fprintf('Input value is %.2f.\nResult is %.2f.\n', x, res)


%% Exericse 5
% Create a 1-by-8 row vector of zeros and set each element equal to the product
% (row number)*(column number), with the use of a for loop.

x = zeros(1,8); disp(x)
cols = size(x,2); % read the col num of x
for j = 1:cols
    x(1, j) = 1 * j;
end
disp(x)


%% Exericse 6
% Extend exercise 5 to a 6-by-7 matrix. Notice that you need two for loops.


x = zeros(6,7); disp(x)
[rows, cols] = size(x);
for i = 1:rows
    for j = 1:cols
        x(i, j) = i * j;
    end
end
disp(x)


%% Exericse 7
% Use a while loop to count the number of uniformly distributed
% realizations (use the function rand(.)) between 0 and 1 that it takes to
% add up to 20 (or more).

my_sum = 0.0;
unif_randoms = [];

while (my_sum < 20)
    temp = rand();
    my_sum = my_sum +temp;
    unif_randoms = [unif_randoms, temp ];
end

disp(unif_randoms)
disp(my_sum)


%% Exericse 8
% Create a function called myabs(.) that returns the absolute value of the
% argument. To get |n|, you can also use MATLAB’s predefined function abs(n).

% see myabs.m
myabs(-10)

%% Exericse 9
% Create a function called myabs(.) that returns the absolute value of the
% argument. To get |n|, you can also use MATLAB’s predefined function abs(n).

% see myfact.m
myfact(10)


%% Exericse 10
% Create a function called stats(.) that returns the maximum, the minimum
% and the average of a vector of numbers. Create two different implementations;
% one that returns the three values as individual numbers and one that returns the
% three values in a single vector.

x = [1,2,3,4,5];
[a, b, c] = stats_1(x)
res = stats_2(x)

disp([a, b, c])
disp(res)


%% Exericse 11
% Download the file stock.xls from HUB. Open the file in Excel and observe
% how the data is stored. Read the data into MATLAB using the xlsread()
% function in a matrix called data. Store the first column of data in a variable
% called stock_price_1 and the second column of data in a variable called
% stock_price_2. Compute the returns of each price process and write the
% results into the original stock.xls file into two new sheets with the names
% returns_1 and returns_2 respectively.

data = xlsread('Stock.xls', 'Stock');

stock_price_1 = data(:,1);
stock_price_2 = data(:,2);

% calculate return
stock_return_1 = diff(log(stock_price_1));
stock_return_2 = diff(log(stock_price_2));

xlswrite('Stock.xls', stock_return_1, 'return_1');
xlswrite('Stock.xls', stock_return_2, 'return_2');



%% Exercise 12

csv_read_format = '%{yyyy-mm-dd}D%f%f%f%f%d%f';
aapl = readtable('AAPL.csv', 'Format', csv_read_format);

aapl_ret = [0; diff(log(aapl.AdjClose))];
aapl.Return = aapl_ret;

writetable(aapl, 'updated_AAPL.csv');
