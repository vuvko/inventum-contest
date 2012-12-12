% init
%clear;
%clc;
%load contestinventumdata.mat;
% погрешность
eps = 0.1;

% лог-файл
fid = fopen("cv2.log", "a");

% устанавливаем границы
alpha_min = 0.5;
alpha_max = 0.99;

beta_min = 0.5;
beta_max = 0.99;

gamma_min = 0.001;
gamma_max = 0.5;
% устанавливаем шаг
alpha_step = 0.001;

beta_step = 0.001;

gamma_step = 0.010;

alpha = alpha_min;
beta = beta_min;
gamma = gamma_min;

alpha_opt = 0.917; % 0.99
beta_opt = 0.871; % 0.913
gamma_opt = 0.175; % 0.39

run Test.m;
E_min = E
E1 = E;
E_prev = 100000000;
iter = 1;

fprint_time(1, time());
printf("Starting cross-validation.\n");
fprint_time(fid, time());
fprintf(fid, "Starting cross-validation.\n");
fflush(1);
fflush(fid);

while abs(mean(E_prev) - mean(E_min)) > eps

fprint_time(1, time());
printf("Iteration: %d\n", iter);
fprint_time(fid, time());
fprintf(fid, "Iteration: %d\n", iter);

iter = iter + 1

fflush(1); fflush(fid);

E_prev = E_min;

beta = beta_opt;
gamma = gamma_opt;

for alpha = alpha_max:-alpha_step:alpha_min
    
    fprint_time(1, time());
    printf("parameters: %.2f %.2f %.2f\n", alpha, beta, gamma);
    
    run Test.m;
    
    fflush(1);
    
    if (mean(E) < mean(E_min) - eps)
        E_min = E;
        alpha_opt = alpha;
        fprint_time(1, time());
        printf("New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
        fprint_time(fid, time());
        fprintf(fid, "New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
                
        fflush(1);
        fflush(fid);
    end
    
end

alpha = alpha_opt;

for beta = beta_max:-beta_step:beta_min
    
    fprint_time(1, time());
    printf("parameters: %.2f %.2f %.2f\n", alpha, beta, gamma);
    
    run Test.m;
    
    fflush(1);
    
    if (mean(E) < mean(E_min) - eps)
        E_min = E;
        beta_opt = beta;
        fprint_time(1, time());
        printf("New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
        
        fflush(1);
        fflush(fid);
    end
    
end

beta = beta_opt;

for gamma = gamma_max:-gamma_step:gamma_min
    
    fprint_time(1, time());
    printf("parameters: %.2f %.2f %.2f\n", alpha, beta, gamma);
    
    run Test.m;
    
    fflush(1);
    
    if (mean(E) < mean(E_min) - eps)
        E_min = E;
        gamma_opt = gamma;
        fprint_time(1, time());
        printf("New minimum: %.3f\n On parameters: %.2f %.2f %.2f\n", mean(E), alpha, beta, gamma);
        
        fflush(1);
        fflush(fid);
    end
    
end

end

fclose(fid);
