% init
clear;
clc;
load contestinventumdata.mat;
% погрешность
eps = 0.1;

% лог-файл
fid = fopen("cv.log", "w");

% устанавливаем границы
alpha_min = 0;
alpha_max = 1;

beta_min = 0;
beta_max = 1;

gamma_min = 0;
gamma_max = 1;
% устанавливаем шаг
alpha_step = 0.05;

beta_step = 0.05;

gamma_step = 0.05;

alpha = alpha_min;
beta = beta_min;
gamma = gamma_min;

alpha_opt = -1;
beta_opt = -1;
gamma_opt = -1;

run Test.m;
E_min = E

printf("Starting cross-validation.\n");
fprintf(fid, "Starting cross-validation.\n");
fflush(1);
fflush(fid);

for alpha = alpha_max:-alpha_step:alpha_min
    for beta = beta_max:-beta_step:beta_min
        for gamma = gamma_min:gamma_step:gamma_max
            run Test.m;
            
            if (mean(E) < mean(E_min) - eps)
                E_min = E;
                alpha_opt = alpha;
                beta_opt = beta;
                gamma_opt = gamma;
                printf("New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
                fprintf(fid, "New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
                
                fflush(1);
                fflush(fid);
            end
        end
    end
end

fclose(fid);
