clear
load contestinventumdata_old.mat test9 test10
test9 = SdvReclaim(test9);
test9 = test9(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
test10 = SdvReclaim(test10);
test10 = test10(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
name = '�������� ������';
save -V7 solution.mat name test9 test10
