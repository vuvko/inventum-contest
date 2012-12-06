function PlotResult(price)

clf
hold on;
[test realprice lastprice] = DeletePoints(price); % просто приводим к тому виду, в котором test9 и test10
test = SdvReclaim(test); % прогноз
PlotPrice(test, 'b') % прогноз
test(:,end) = realprice;
PlotPrice(test, 'r') % настоящие значения
hold off;
