function price = SdvReclaim(price, alpha = 0.78, beta = 0.2, gamma = 0.35)

% так формировалось обучение!!!
N = 8; % # кусков
n = size(price,1); % # точек
k = 2000; % # точек прогноза

t = price(:,1:4)*[60*60 60 1 1/1000]'; % время в секундах

I = round(linspace(1,length(t),N+2)); % поделить на куски
Ibeg = [1 I(2:end-2)+1]; % номера начал
Iend = [I(2:end-2) n]; % номера концов

alpha_min = 0.75;
alpha_max = 0.95;
beta_min = 0.3;
beta_max = 0.2;
gamma_min = 0.15;
gamma_max = 0.35;
points_min = 1;
points_max = 9;

alpha_step = 0.05;
beta_step = 0.05;
gamma_step = 0.05;
points_step = 2;

points = 1;

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
    points_opt = points;
    alpha_new = alpha;
    beta_new = beta;
    gamma_new = gamma;
    points_new = points;

    p(end - l + 1 : end) = ...
        SdvForecast2(thc, yhc, tfc, alpha_opt, beta_opt, gamma_opt, points_opt);
    Err = Evaluate(p, yh, last);
    
    %while abs(Err_l - Err) > eps
    
        Err_l = Err;
    
        for alpha1 = alpha_max:-alpha_step:alpha_min
            p(end - l + 1 : end) = ...
                SdvForecast2(thc, yhc, tfc, alpha1, beta_opt, gamma_opt, points_opt);
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
                SdvForecast2(thc, yhc, tfc, alpha_opt, beta1, gamma_opt, points_opt);
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
                SdvForecast2(thc, yhc, tfc, alpha_opt, beta_opt, gamma1, points_opt);
            Err = Evaluate(p, yh, last);
            if (Err < Err_min) 
                gamma_new = gamma1;
                Err_min = Err;
            end
        end
        
        Err_gamma = Err_min;
        Err_min = Err_l;
        gamma_opt = gamma_new;
        
        for points1 = points_max:-points_step:points_min
            p(end - l + 1 : end) = ...
                SdvForecast2(thc, yhc, tfc, alpha_opt, beta_opt, gamma_opt, points1);
            Err = Evaluate(p, yh, last);
            if (Err < Err_min) 
                points_new = points1;
                Err_min = Err;
            end
        end
        
        Err_points = Err_min;
        
        Err_min = min([Err_alpha, Err_beta, Err_gamma, Err_points]);
        
        alpha_opt = alpha_new;
        beta_opt = beta_new;
        gamma_opt = gamma_new;
        points_opt = points_new;
        
        p(end - l + 1 : end) = ...
               SdvForecast2(thc, yhc, tfc, alpha, beta, gamma, points);
        
        Err = Evaluate(p, yh, last);
        printf("Err - %.4f with params: %.2f %.2f %.2f %d\n", ...
            Err, alpha_opt, beta_opt, gamma_opt, points_opt);
        printf("Min - %.4f\n", Err_min);
        fflush(1);
    
    %Err = Evaluate(p, yh, last);
    
    %end
    
    
    
    price(Iend(i)-(k-1):Iend(i), end) = ...
        ... %SdvForecast(th, yh, tf, 500);
        SdvForecast2(th, yh, tf, alpha_opt, beta_opt, gamma_opt, points_opt);
end;

% функция прогнозирования

function yf = SdvForecast2(thi, yhi, tfi, alpha = 1, beta = 1, gamma = 0.35, points = 1)

th = thi(:);
minth = min(th);
th = th - minth;
maxth = max(th);
th = th./maxth;
yh = yhi(:);
tf = tfi(:)-minth;
tf = tf./maxth;

%block_size = length(tf);
%block_size = 3;
%points = length(tf);
%points = 2;
l = length(th);
I = round(linspace(1, l, floor(l / points)));
s_prev = zeros(points, 1) + yh(1);
s = zeros(points, 1) + yh(1);
z_prev = zeros(points, 1) + yh(1);
z = zeros(points, 1) + yh(1);
b_prev = zeros(points, 1);
b = zeros(points, 1);
eps = zeros(points, 1);
d = 5;
z = zeros(size(yh));

% smoothing

A = zeros(l, d);
for i = 1:d
    A(:, i) = shift(yh, i - 1);
end
filter = zeros(d, 1) + 1 / d;
z = A * filter;

for i = 2 : length(I)
    z_prev = z(I(i) - points + 1 : I(i));
    b_prev = b;
    b = gamma * (s - s_prev) + (1 - gamma) * b_prev;
    s_prev = s;
    eps = beta * (s_prev - z_prev) + (1 - beta) * eps;
    s = alpha * z_prev + (1 - alpha) * (s_prev - b_prev);
end

z = s;
yf = zeros(size(tf)) + yh(end);

Idx = round(linspace(1, length(yf), points + 1));
bg = Idx(1:end-1);
ed = Idx(2:end);

for j = 1 : points
    x1 = tf(bg(j));
    x2 = tf(ed(j));
    y1 = yf(bg(j));
    y2 = z(j);
    
    k = (y1 - y2) / (x1 - x2);
    b = (x1 * y2 - x2 * y1) / (x1 - x2);
    
    yf(bg(j) : ed(j)) = k * tf(bg(j) : ed(j)) + b;
end
