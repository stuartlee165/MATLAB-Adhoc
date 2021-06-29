function ll = loglike_normal(parameters,x)
% read initial guess of parameter
mu = parameters(1);
sigma = parameters(2);

% calculate the loglikelihood 
lls = log(1/sqrt(2*pi))-log(sigma)-((x-mu).^2/(2*sigma^2));
ll = -1*sum(lls);