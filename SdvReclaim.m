function price = SdvReclaim(price, alpha = 1, beta = 1, gamma = 0.35)

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

function yf = SdvForecast2(thi, yhi, tfi, alpha, beta, gamma)

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
for i = 1:block_num-1
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
