function PlotResult(price, params = struct())

clf
hold on;
[test realprice lastprice] = DeletePoints(price); % ������ �������� � ���� ����, � ������� test9 � test10
test = SdvReclaim(test, params); % �������
PlotPrice(test, "b;forecast;") % �������
test(:,end) = realprice;
PlotPrice(test, "r;real value;") % ��������� ��������
hold off;
