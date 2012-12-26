% init
%clear;
%clc;
%load contestinventumdata.mat;
% погрешность
eps = 0.1;

alpha_min = 0.65;
alpha_max = 1;
alpha_step = 0.05;

prices = [1:8];

params = struct();
params_opt = struct();
Err = 0;
Err_min = 0;
Err_CV = zeros(1, length(prices));

for i = 1:length(prices)
    price_test = prices(i); % test
    prices_train = [prices(1:i-1) prices(i+1:end)];
    
    params.alpha = 0.8;
    Err = Test(prices_train, params);
    Err_min = Err;
    
    for params.alpha = alpha_max:-alpha_step:alpha_min
        Err = Test(prices_train, params);
        if (Err < Err_min)
            params_opt.alpha = params.alpha;
            Err_min = Err;
        end
    end
    
    Err_CV(i) = Test(price_test, params_opt);
    printf("Err %.4f with params %.3f\n", Err_CV(i), params_opt.alpha);
    fflush(1);
end

mean(Err_CV)
