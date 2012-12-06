% нарисовать график цены
% пример использования: PlotPrice(price10, 'r')
% автор: Дьяконов Александр

function PlotPrice(price, col)

if ~exist('col','var')
    col = 'k'; % по умолчанию - чёрный цвет
end;

% время
t = price(:,1:4)*[60*60 60 1 1/1000]';
% цена
y = price(:,end);
% рисовать
plot(t,y, col)
