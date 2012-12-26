function PlotResult(price, params = struct())

clf
hold on;
[test realprice lastprice] = DeletePoints(price); % просто приводим к тому виду, в котором test9 и test10
test = SdvReclaim(test, params); % прогноз
PlotPrice(test, "b;forecast;") % прогноз
test(:,end) = realprice;
PlotPrice(test, "r;real value;") % настоящие значения
hold off;
