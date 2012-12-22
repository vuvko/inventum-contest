function price = SdvReclaim(price, alpha = 0.99, beta = 0.01, gamma = 0.3)

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
    fprintf("Number %3d\n", i);
    fflush(1);
    
    th = t(Ibeg(i):(Iend(i)-k));
    yh = price(Ibeg(i):(Iend(i)-k), end);
    
    tf = t(Iend(i)-(k-1):Iend(i));
    
    price(Iend(i)-(k-1):Iend(i), end) = ...
        ... %SdvForecast(th, yh, tf, 500);
        SdvForecast2(th, yh, tf, alpha, beta, gamma);
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

function yf = SdvForecast2(thi, yhi, tfi, alpha = 1, beta = 1, gamma = 0.35)

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
points = 1;
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

for x = 1:l
    bg = max(1, x - d);
    ed = min(l, x + d);
    z(x) = mean(yh(bg:ed));
end

for i = 1 : length(I) - 1
    for j = 1 : points
        z_prev(j) = z(I(i) + j);
    end
    b_prev = b;
    b = gamma * (s - s_prev) + (1 - gamma) * b_prev;
    s_prev = s;
    eps = beta * (s_prev - z_prev) + (1 - beta) * eps;
    s = alpha * z_prev + (1 - alpha) * (s_prev - b_prev);
end

z = s + b - eps;
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
