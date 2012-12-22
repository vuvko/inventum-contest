
E = zeros([1 8]); % ошибки
for i=1:8
    printf("---- Price %d\n", i);
    fflush(1);
    eval(['price = price' int2str(i) ';']);
    [test realprice lastprice] = DeletePoints(price); % просто приводим к тому виду, в котором test9 и test10
    test = SdvReclaim(test); % прогноз
    E(i)  = Evaluate(test(:,end),  realprice,  lastprice);
    printf("==== Error: %.4f\n", E(i));
    fflush(1);
end;
mean(E) % средняя ошибка
