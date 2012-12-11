
E = zeros([1 8]); % ошибки
for i=1:8
    eval(['price = price' int2str(i) ';']);
    [test realprice lastprice] = DeletePoints(price); % просто приводим к тому виду, в котором test9 и test10
    test = SdvReclaim(test, alpha, beta, gamma); % прогноз
    E(i)  = Evaluate(test(:,end),  realprice,  lastprice);
end;
mean(E) % средняя ошибка
