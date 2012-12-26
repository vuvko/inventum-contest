function price = SdvReclaim(price, params)

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

params.points = 1;

% сделать прогнозы
for i=1:N
    %fprintf("Number %3d\n", i);
    fflush(1);
    
    th = t(Ibeg(i):(Iend(i)-k));
    yh = price(Ibeg(i):(Iend(i)-k), end);
    
    tf = t(Iend(i)-(k-1):Iend(i));
    
    %plot([tf(1), tf(end)], [yh(end), yh(end)], 'm');
    price(Iend(i)-(k-1):Iend(i), end) = ...
        ... %SdvForecast(th, yh, tf, 500);
        SdvForecast2(th, yh, tf, params);
        %DjForecast4(th, yh, tf);
end;

% функция прогнозирования

function yf = SdvForecast2(thi, yhi, tfi, params)

if (isfield(params, "alpha"))
    alpha = params.alpha;
else
    alpha = 0.95;
end

if (isfield(params, "beta"))
    beta = params.beta;
else
    beta = 0.15;
end

if (isfield(params, "gamma"))
    gamma = params.gamma
else
    gamma = 0.35;
end

if (isfield(params, "points"))
    points = params.points;
else
    points = 1;
end

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
    %b_prev = b;
    %b = gamma * (s - s_prev) + (1 - gamma) * b_prev;
    s_prev = s;
    %eps = beta * (s_prev - z_prev) + (1 - beta) * eps;
    s = alpha * z_prev + (1 - alpha) * (s_prev - b_prev);
end

ans = s;
yf = zeros(size(tf)) + yh(end);

Idx = round(linspace(1, length(yf), points + 1));
bg = Idx(1:end-1);
ed = Idx(2:end);

for j = 1 : points
    %x1 = tf(bg(j));
    %x2 = tf(ed(j));
    %y1 = yf(bg(j));
    %y2 = ans(j);
    
    %k = (y1 - y2) / (x1 - x2);
    %b = (x1 * y2 - x2 * y1) / (x1 - x2);
    
    %yf(bg(j) : ed(j)) = k * tf(bg(j) : ed(j)) + b;
    yf(bg(j) : ed(j)) = ans(j);
end

function yf = DjForecast4(th, yh, tf)
t0 = min(th);
t1 = max(th);
 
X = [];
j = 1;
 
for ti = t0:5:t1
    yy = yh((th>=ti)&(th<(ti+5)));
    if isempty(yy)
        X(j) = X(j-1);
    else
        X(j) = mean(yy);
    end;
    j = j + 1;
end;
 
X = [X(end-3:end)];
 
C = [-0.0229    0.0862   -0.2936    1.2303]';
 
yf = tf*0 + X*C;
