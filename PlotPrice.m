% ���������� ������ ����
% ������ �������������: PlotPrice(price10, 'r')
% �����: �������� ���������

function PlotPrice(price, col)

if ~exist('col','var')
    col = 'k'; % �� ��������� - ������ ����
end;

% �����
t = price(:,1:4)*[60*60 60 1 1/1000]';
% ����
y = price(:,end);
% ��������
plot(t,y, col)
