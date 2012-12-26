% init
%clear;
%clc;

% погрешность
eps = 0.0001;

alpha_min = 0.75;
alpha_max = 0.99;
alpha_step = 0.05;

first_min = 1;
first_max = 2001;
first_step = 50;

prices = [5:12];

params = struct();
params.alpha = 1;
params.first = 1;
params_opt = params;
save_params = {};
Err = 0;
Err_min = 0;
Err_CV = zeros(1, length(prices));

for i = 1:length(prices)
    price_test = prices(i); % test
    prices_train = [prices(1:i-1) prices(i+1:end)];
    
    params.alpha = 0.8;
    params.first = 1;
    Err = mean(Test(prices_train, params));
    Err_min = Err;
    
    for params.first = first_min:first_step:first_max
    for params.alpha = alpha_max:-alpha_step:alpha_min
        printf("\nParams: %d %.3f\n", params.first, params.alpha);
        fflush(1);
        Err = mean(Test(prices_train, params))
        if (Err < Err_min - eps)
            params_opt.alpha = params.alpha;
            Err_min = Err;
            printf("\nNew minimum - %.4f with params %d %.3f\n\n", Err_min, params.first, params.alpha);
            fflush(1);
        end
    end
    end
    
    Err_CV(i) = Test(price_test, params_opt);
    save_params(i) = params_opt;
    printf("++++\n\n|=== Err %.4f on %d with params %d %.3f\n\n++++\n", Err_CV(i), prices(i), params.first, params_opt.alpha);
    fflush(1);
end

mean(Err_CV)
