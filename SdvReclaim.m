function price = SdvReclaim(price)

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
    
    price(Iend(i)-(k-1):Iend(i), end) = SdvForecast(th, yh, tf, 200);
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
