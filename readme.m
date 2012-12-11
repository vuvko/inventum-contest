% ����� ��������� ������ ��������
load contestinventumdata.mat
% ������������
PlotPrice(price1, 'r')
PlotPrice(test9, 'b')

% DeletePoints - ������ ����� �����, ��� ������������� ��������

% ��� ����� ����������� �� ��������

E = zeros([1 8]); % ������
for i=1:8
    eval(['price = price' int2str(i) ';']);
    [test realprice lastprice] = DeletePoints(price); % ������ �������� � ���� ����, � ������� test9 � test10
    test = DjBenchmark1(test); % �������
    E(i)  = Evaluate(test(:,end),  realprice,  lastprice);
end;
mean(E) % ������� ������

% ���� ���� ��������������� �������
clf
hold on;
[test realprice lastprice] = DeletePoints(price1); % ������ �������� � ���� ����, � ������� test9 � test10
test = SdvReclaim(test); % �������
PlotPrice(test, 'b') % �������
test(:,end) = realprice;
PlotPrice(test, 'r') % ��������� ��������

% ��������� ������� - ������ ��������
clear
load contestinventumdata.mat test9 test10
test9 = DjBenchmark1(test9);
test9 = test9(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
test10 = DjBenchmark1(test10);
test10 = test10(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
name = '�������� ������';
save solution.mat name test9 test10
