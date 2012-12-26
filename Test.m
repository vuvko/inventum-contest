function E = Test(varargin)

n = nargin();

if n == 0
    E = Test_two([1:8], struct());
elseif n == 1
    E = Test_one(varargin{1});
else
    E = Test_two(varargin{1}, varargin{2});
end



function E_m = Test_two(indecies, params)

load contestinventumdata.mat;

E = zeros([1 length(indecies)]); % ошибки
for i=1:length(indecies)
    printf("---- Price %d\n", indecies(i));
    fflush(1);
    eval(['price = price' int2str(indecies(i)) ';']);
    [test realprice lastprice] = DeletePoints(price); % просто приводим к тому виду, в котором test9 и test10
    test = SdvReclaim(test, params); % прогноз
    E(i)  = Evaluate(test(:,end),  realprice,  lastprice);
    printf("==== Error: %.4f\n", E(i));
    fflush(1);
end;
E_m = mean(E) % средняя ошибка

function E = Test_one(param)

if isstruct(param)
    E = Test_two([1:8], param);
else
    E = Test_two(param, struct());
end
