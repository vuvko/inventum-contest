%clear
%load contestinventumdata.mat
test1 = SdvReclaim(test1, params);
test1 = test1(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
test2 = SdvReclaim(test2, params);
test2 = test2(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
test3 = SdvReclaim(test3, params);
test3 = test3(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
test4 = SdvReclaim(test4, params);
test4 = test4(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������

test13 = SdvReclaim(test13, params);
test13 = test13(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
test14 = SdvReclaim(test14, params);
test14 = test14(:,end); % ��� �������� ������ ����������� �������� ������ �������� �������
name = '�������� ������';
save -V7 solution.mat name test1 test2 test3 test4 test13 test14
