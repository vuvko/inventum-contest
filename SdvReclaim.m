function price = SdvReclaim(price, alpha = 0.9, beta = 0.85, gamma = 0.25, first = 1)

% так формировалось обучение!!!
N = 8; % # кусков
n = size(price,1); % # точек
k = 2000; % # точек прогноза

t = price(:,1:4)*[60*60 60 1 1/1000]'; % время в секундах

I = round(linspace(1,length(t),N+2)); % поделить на куски
Ibeg = [1 I(2:end-2)+1]; % номера начал
Iend = [I(2:end-2) n]; % номера концов

alpha_min = 0.6;
alpha_max = 1;
alpha_step = 0.03;
beta_min = 0.8;
beta_max = 1;
beta_step = 0.05;
gamma_min = 0.15;
gamma_max = 0.55;
gamma_step = 0.03;

eps = 0.01;

% сделать прогнозы
for i=1:N
    fprintf("Number %3d\n", i);
    fflush(1);
    
    th = t(Ibeg(i):(Iend(i)-k));
    yh = price(Ibeg(i):(Iend(i)-k), end);
    
    tf = t(Iend(i)-(k-1):Iend(i));
    
    l = length(tf);
    thc = th(1 : end - l);
    yhc = yh(1 : end - l);
    tfc = th(end - l + 1 : end);
    
    last = zeros(size(yh));
    last(end - l + 1 : end) = yh(end - l);
    
    Err_l = 100000;
    Err_min = Err_l;
    
    p = yh;
    
    alpha_opt = alpha;
    beta_opt = beta;
    gamma_opt = gamma;
    alpha_new = alpha;
    beta_new = beta;
    gamma_new = gamma;
    
    p(end - l + 1 : end) = ...
        SdvForecast2(thc, yhc, tfc, alpha_opt, beta_opt, gamma_opt);
    Err = Evaluate(p, yh, last);
    
    %while abs(Err_l - Err) > eps
    
        Err_l = Err;
    
        for alpha1 = alpha_max:-alpha_step:alpha_min
            p(end - l + 1 : end) = ...
                SdvForecast2(thc, yhc, tfc, alpha1, beta_opt, gamma_opt);
            Err = Evaluate(p, yh, last);
            if (Err < Err_min) 
                alpha_new = alpha1;
                Err_min = Err;
            end
        end
        
        Err_alpha = Err_min;
        Err_min = Err_l;
        alpha_opt = alpha_new;
        
        for beta1 = beta_max:-beta_step:beta_min
            p(end - l + 1 : end) = ...
                SdvForecast2(thc, yhc, tfc, alpha_opt, beta1, gamma_opt);
            Err = Evaluate(p, yh, last);
            if (Err < Err_min) 
                beta_new = beta1;
                Err_min = Err;
            end
        end
        
        Err_beta = Err_min;
        Err_min = Err_l;
        beta_opt = beta_new;
        
        for gamma1 = gamma_max:-gamma_step:gamma_min
            p(end - l + 1 : end) = ...
                SdvForecast2(thc, yhc, tfc, alpha_opt, beta_opt, gamma1);
            Err = Evaluate(p, yh, last);
            if (Err < Err_min) 
                gamma_new = gamma1;
                Err_min = Err;
            end
        end
        
        Err_gamma = Err_min;
        Err_min = min([Err_alpha, Err_beta, Err_gamma])
        
        alpha_opt = alpha_new;
        beta_opt = beta_new;
        gamma_opt = gamma_new;
        
        p(end - l + 1 : end) = ...
                SdvForecast2(thc, yhc, tfc, alpha_opt, beta_opt, gamma_opt);
        
        Err = Evaluate(p, yh, last);
        printf("Err - %.4f with params: %.2f %.2f %.2f\n", ...
            Err, alpha_opt, beta_opt, gamma_opt);
        printf("Min - %.4f\n", Err_min);
        fflush(1);
    
    %Err = Evaluate(p, yh, last);
    
    %end
    
    price(Iend(i)-(k-1):Iend(i), end) = ...
        ... %SdvForecast(th, yh, tf, 500);
        SdvForecast2(th, yh, tf, alpha, beta, gamma, first);
end;

% функция прогнозирования
function yf = SdvForecast(thi, yhi, tfi, remainder)

th = thi(:);
minth = min(th);
th = th - minth;
maxth = max(th);
th = th./maxth;
yh = yhi(:);
tf = tfi(:)-minth;
tf = tf./maxth;

if remainder <= 0
    remainder = 10;
end

l = length(yh);
tail = floor(l / remainder);

lm = mean(yh(end - tail:end));

y1 = yh(end);
y2 = lm;
x1 = th(end);
x2 = tf(end);

yf = zeros(size(tf));

k = (y1 - y2) / (x1 - x2);
b = (x1 * y2 - x2 * y1) / (x1 - x2);

for x = 1:length(tf)
    yf(x) = k * tf(x) + b;
end

%Visualize(thi, yhi, tfi, yf, remainder);

function yf = SdvForecast2(thi, yhi, tfi, alpha = 1, beta = 1, gamma = 0.35, first = 1)

th = thi(:);
minth = min(th);
th = th - minth;
maxth = max(th);
th = th./maxth;
yh = yhi(:);
tf = tfi(:)-minth;
tf = tf./maxth;

%block_size = length(tf);
block_size = 3;
l = length(th);
block_num = floor(l / block_size);
s_prev = yh(1);
s = yh(1);
z_prev = yh(1 + block_size);
z = z_prev;
b_prev = 0;
b = 0;
eps = 0;
d = 1;
filter = normpdf(-1:1/d:1);
filter = filter / sum(filter);
%t = length(tf) / block_size;
for i = first:block_num-1
    tmp = i * block_size + 1;
    z_prev = filter * yh(tmp-d:tmp+d);
    b_prev = b;
    b = gamma * (s - s_prev) + (1 - gamma) * b_prev;
    s_prev = s;
    eps = beta * eps + (1 - beta) * (s_prev - z_prev);
    s = alpha * z_prev + (1 - alpha) * (s_prev - b_prev);
end

yf = zeros(size(tf));
eps = mean(eps);
z = s + b - eps;

x1 = th(end);
x2 = tf(end);
y1 = yh(end);
y2 = z;

k = (y1 - y2) / (x1 - x2);
b = (x1 * y2 - x2 * y1) / (x1 - x2);

for x = 1:length(tf)
    yf(x) = k * tf(x) + b;
end

%Visualize(thi, yhi, tfi, yf, 500);
