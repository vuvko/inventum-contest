% оценить ошибку прогноза в соревновании <INVENTUM>
% автор: ƒь€конов јлександр

% ansprice - ответ
% realprice - насто€щи€ значени€ цены
% lastprice - р€д последних известных цен, нул€ми помечены известные цены

function e = Evaluate(ansprice, realprice, lastprice)

% оставить лишь прогнозные точки
ansprice = ansprice(lastprice~=0);
realprice = realprice(lastprice~=0);
lastprice = lastprice(lastprice~=0);

delta = abs(ansprice-realprice);

% где ошиблись в тренде
I = ((realprice>lastprice)&(ansprice>lastprice))|((realprice<lastprice)&(ansprice<lastprice));
I = ~I;
delta(I) = delta(I).^2;

% ошибка прогноза
e = mean(delta);
