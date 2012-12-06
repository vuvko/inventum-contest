% удалить участки для тестирования
% price - что получилось после удаления
% realprice - настоящая цена
% lastprice - последняя цена (нужна для подсчёта качества)
% автор: Дьяконов Александр

function [price realprice lastprice] = DeletePoints(price)
N = 8; % на сколько кусков делить
n = size(price,1); % число точек
k = 2000; % сколько точек прогнозировать

t = price(:,1:4)*[60*60 60 1 1/1000]'; % время в секундах

I = round(linspace(1,length(t),N+2)); % поделить на куски
Ibeg = [1 I(2:end-2)+1]; % номера начал
Iend = [I(2:end-2) n]; % номера концов

realprice = price(:,end);
lastprice = zeros(size(realprice));

% забить неизвестными значениями
for i=1:N
    delta = 300*randn(); % случайное смещение для этого куска
    realprice(Ibeg(i):Iend(i)) = realprice(Ibeg(i):Iend(i)) + delta;
    price(Ibeg(i):Iend(i),end) = price(Ibeg(i):Iend(i),end)  + delta;
    
    price(Iend(i)-(k-1):Iend(i), end) = NaN;
    lastprice(Iend(i)-(k-1):Iend(i)) = price(Iend(i)-k, end);
    
    %disp(sprintf('Удалено %g минут\n',(t(Iend(i))-t(Iend(i)-(k-1)))/60));
end;
