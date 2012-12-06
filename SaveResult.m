clear
load contestinventumdata.mat test9 test10
test9 = DjBenchmark1(test9);
test9 = test9(:,end); % для экономии памяти допускается присылка только целевого вектора
test10 = DjBenchmark1(test10);
test10 = test10(:,end); % для экономии памяти допускается присылка только целевого вектора
name = 'Шадриков Андрей';
save solution.mat name test9 test10
