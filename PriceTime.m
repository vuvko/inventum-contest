function t = PriceTime(price)

t = price(:,1:4)*[60*60 60 1 1/1000]';

end;
