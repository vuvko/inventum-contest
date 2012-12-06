% ������� ������� ��� ������������
% price - ��� ���������� ����� ��������
% realprice - ��������� ����
% lastprice - ��������� ���� (����� ��� �������� ��������)
% �����: �������� ���������

function [price realprice lastprice] = DeletePoints(price)
N = 8; % �� ������� ������ ������
n = size(price,1); % ����� �����
k = 2000; % ������� ����� ��������������

t = price(:,1:4)*[60*60 60 1 1/1000]'; % ����� � ��������

I = round(linspace(1,length(t),N+2)); % �������� �� �����
Ibeg = [1 I(2:end-2)+1]; % ������ �����
Iend = [I(2:end-2) n]; % ������ ������

realprice = price(:,end);
lastprice = zeros(size(realprice));

% ������ ������������ ����������
for i=1:N
    delta = 300*randn(); % ��������� �������� ��� ����� �����
    realprice(Ibeg(i):Iend(i)) = realprice(Ibeg(i):Iend(i)) + delta;
    price(Ibeg(i):Iend(i),end) = price(Ibeg(i):Iend(i),end)  + delta;
    
    price(Iend(i)-(k-1):Iend(i), end) = NaN;
    lastprice(Iend(i)-(k-1):Iend(i)) = price(Iend(i)-k, end);
    
    %disp(sprintf('������� %g �����\n',(t(Iend(i))-t(Iend(i)-(k-1)))/60));
end;
