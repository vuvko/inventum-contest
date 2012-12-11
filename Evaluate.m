% ������� ������ �������� � ������������ <INVENTUM>
% �����: �������� ���������

% ansprice - �����
% realprice - ��������� �������� ����
% lastprice - ��� ��������� ��������� ���, ������ �������� ��������� ����

function e = Evaluate(ansprice, realprice, lastprice)

% �������� ���� ���������� �����
ansprice = ansprice(lastprice~=0);
realprice = realprice(lastprice~=0);
lastprice = lastprice(lastprice~=0);

delta = abs(ansprice-realprice);

% ��� �������� � ������
I = ((realprice>lastprice)&(ansprice>lastprice))|((realprice<lastprice)&(ansprice<lastprice));
I = ~I;
delta(I) = delta(I).^2;

% ������ ��������
e = mean(delta);
