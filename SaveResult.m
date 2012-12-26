%clear
%load contestinventumdata.mat
test1 = SdvReclaim(test1, params);
test1 = test1(:,end); % для экономии памяти допускается присылка только целевого вектора
test2 = SdvReclaim(test2, params);
test2 = test2(:,end); % для экономии памяти допускается присылка только целевого вектора
test3 = SdvReclaim(test3, params);
test3 = test3(:,end); % для экономии памяти допускается присылка только целевого вектора
test4 = SdvReclaim(test4, params);
test4 = test4(:,end); % для экономии памяти допускается присылка только целевого вектора

test13 = SdvReclaim(test13, params);
test13 = test13(:,end); % для экономии памяти допускается присылка только целевого вектора
test14 = SdvReclaim(test14, params);
test14 = test14(:,end); % для экономии памяти допускается присылка только целевого вектора
name = 'Шадриков Андрей';
save -V7 solution.mat name test1 test2 test3 test4 test13 test14
