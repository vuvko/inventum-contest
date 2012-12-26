function price = SdvReclaim(price, params = struct())

% так формировалось обучение!!!
N = 8; % # кусков
n = size(price,1); % # точек
k = 2000; % # точек прогноза

t = price(:,1:4)*[60*60 60 1 1/1000]'; % время в секундах

I = round(linspace(1,length(t),N+2)); % поделить на куски
Ibeg = [1 I(2:end-2)+1]; % номера начал
Iend = [I(2:end-2) n]; % номера концов

% сделать прогнозы
for i=1:N
    %fprintf("Number %3d\n", i);
    %fflush(1);
    
    th = t(Ibeg(i):(Iend(i)-k));
    yh = price(Ibeg(i):(Iend(i)-k), end);
    
    tf = t(Iend(i)-(k-1):Iend(i));
    
    plot([tf(1) tf(end)], [yh(end) yh(end)], 'm');
    price(Iend(i)-(k-1):Iend(i), end) = ...
        ... %SdvForecast(th, yh, tf, params);
        SdvForecastAR(th, yh, tf, params);
end;

% функция прогнозирования

% модель Хольта-Брауна
function yf = SdvForecast(thi, yhi, tfi, params)

if (isfield(params, "alpha"))
    alpha = params.alpha;
else
    alpha = 0.95;
end

if (isfield(params, "first"))
    first = params.first;
else
    first = 1;
end

th = thi(:);
minth = min(th);
th = th - minth;
maxth = max(th);
th = th./maxth;
yh = yhi(:);
tf = tfi(:)-minth;
tf = tf./maxth;

points = 1;

s_prev = zeros(points, 1) + yh(1);
s = zeros(points, 1) + yh(1);
z_prev = zeros(points, 1) + yh(1);
z = zeros(points, 1) + yh(1);
b_prev = zeros(points, 1);
b = zeros(points, 1);
eps = zeros(points, 1);
d = 10;
step = 5;
l = length(th(1:step:end));
first = min(first, l);
z = zeros(size(yh(1:step:end)));

% smoothing

A = zeros(l, d);
for i = 1:d
    A(:, i) = shift(yh(1:step:end), i - 1);
end
filter = zeros(d, 1) + 1 / d;
z = A * filter;

I = round(linspace(first, l, floor(l / points)));

for i = 2 : length(I)
    z_prev = z(I(i) - points + 1 : I(i));
    %b_prev = b;
    %b = gamma * (s - s_prev) + (1 - gamma) * b_prev;
    s_prev = s;
    %eps = beta * (s_prev - z_prev) + (1 - beta) * eps;
    s = alpha * z_prev + (1 - alpha) * (s_prev - b_prev);
end

yf = zeros(size(tf)) + yh(end);

Idx = round(linspace(1, length(yf), points + 1));
bg = Idx(1:end-1);
ed = Idx(2:end);

ans = s;

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


function yf = SdvForecastAR(th, yh, tf, params)
% AR
if (isfield(params, "p"))
    p = params.p;
else
    p = 10;
end

if (isfield(params, "coeff") && length(params.coeff(:)) == p)
    coeff = params.coeff(:);
else
    coeff = zeros(p, 1) + 0.1;
end

if (isfield(params, "const"))
    c = params.const;
else
    c = 0;
end

step = 10;
d = 3;
l = length(th(1:step:end));
z = zeros(size(yh(1:step:end)));

% smoothing
A = zeros(l, d);
for i = 1:d
    A(:, i) = shift(yh(1:step:end), i - 1);
end
filter = zeros(d, 1) + 1 / d;
z = A * filter;

ans = z(end - p + 1 : end)' * coeff + c;
yf = zeros(size(tf)) + ans;
