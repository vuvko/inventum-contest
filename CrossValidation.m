% init
clear;
clc;
load contestinventumdata.mat;
% погрешность
eps = 0.1;

% лог-файл
fid = fopen("cv.log", "a");

% устанавливаем границы
alpha_min = 1.0;
alpha_max = 1.0;

beta_min = 1.0;
beta_max = 1.0;

gamma_min = 0.35;
gamma_max = 0.35;
% устанавливаем шаг
alpha_step = 0.05;

beta_step = 0.05;

gamma_step = 0.05;

alpha = 0.915; % 0.99
beta = 0.875; % 0.89
gamma = 0.17; % 0.35
first = 5000;

alpha_opt = -1;
beta_opt = -1;
gamma_opt = -1;

run Test.m;
E_min = E
E_mins = zeros(100000, length(E));
pars = zeros(100000, 3);
i = 1;

fprint_time(1, time());
printf("Starting cross-validation.\n");
fprint_time(fid, time());
fprintf(fid, "Starting cross-validation.\n");
fflush(1);
fflush(fid);


for beta = beta_max:-beta_step:beta_min
    for alpha = alpha_max:-alpha_step:alpha_min
        for gamma = gamma_min:gamma_step:gamma_max
        for first = 100:10:5000
            fprint_time(1, time());
            printf("parameters: %.2f %.2f %.2f\n", alpha, beta, gamma);
            %start_time = time();
            run Test.m;
            %end_time= time();
            fflush(1);
            
            if (mean(E) < mean(E_min) - eps)
                E_min = E;
                alpha_opt = alpha;
                beta_opt = beta;
                gamma_opt = gamma;
                fprint_time(1, time());
                printf("New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
                fprint_time(fid, time());
                fprintf(fid, "New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
                
                fflush(1);
                fflush(fid);
            end
        end
        end
    end
end

fclose(fid);
