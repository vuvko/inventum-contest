% ћожно загрузить данные командой
load contestinventumdata.mat
% визуализаци€
PlotPrice(price1, 'r')
PlotPrice(test9, 'b')

% DeletePoints - просто чтобы знали, как формировалось обучение

% так метод прогон€етс€ на контроле

E = zeros([1 8]); % ошибки
for i=1:8
    eval(['price = price' int2str(i) ';']);
    [test realprice lastprice] = DeletePoints(price); % просто приводим к тому виду, в котором test9 и test10
    test = DjBenchmark1(test); % прогноз
    E(i)  = Evaluate(test(:,end),  realprice,  lastprice);
end;
mean(E) % средн€€ ошибка

% ≈сли надо визуализировать прогноз
clf
hold on;
[test realprice lastprice] = DeletePoints(price1); % просто приводим к тому виду, в котором test9 и test10
test = SdvReclaim(test); % прогноз
PlotPrice(test, 'b') % прогноз
test(:,end) = realprice;
PlotPrice(test, 'r') % насто€щие значени€

% получение решени€ - первый бенчмарк
clear
load contestinventumdata.mat test9 test10
test9 = DjBenchmark1(test9);
test9 = test9(:,end); % дл€ экономии пам€ти допускаетс€ присылка только целевого вектора
test10 = DjBenchmark1(test10);
test10 = test10(:,end); % дл€ экономии пам€ти допускаетс€ присылка только целевого вектора
name = 'Ўадриков јндрей';
save solution.mat name test9 test10
