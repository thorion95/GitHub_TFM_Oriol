% Simulation for tensor completion
% Trying several algorithms...

close all;
clear all;
clc;
addpath(genpath(pwd));
addpath('my_variable');
addpath('my_mask');
%%  Data
disp('Load data to correct')
[file, path] = uigetfile('*.mat');
data = load(fullfile(path, file));
X = data.morphoTensor;
clear morphoTensor;

disp('Load mask to use')
[file, path] = uigetfile('*.mat');
data2 = load(fullfile(path, file));

Mask = data2.data;
O = Mask;
Y = X.*O; % observed data 

%%  TC

% inicialitzacions
DIM = size(Y);
Performance = zeros(3, 1);  %AJUSTAR el valor 3 als mètodews probats
Temps = zeros(3, 1);        %AJUSTAR el valor 3 als mètodews probats

%%% HaLRTC
if 1
    tStart = tic;
    % rho = 1e-6;   % (User defined), algorithm very sensitive to this value
    rho = 1e0;    % (User defined), algorithm very sensitive to this value
    
    T = Y./norm(Y(:));
    alpha = [1, 1, 1];
    alpha = alpha / sum(alpha);
    maxIter = 500;
    epsilon = 1e-5;
    [X_H, errList_H] = HaLRTC(T,logical(O),alpha,rho,maxIter,epsilon);
    X_hat1 = X_H.* norm(Y(:));
    % We maintain the original (non-missing) entries...
    X_hat1 = X.*Mask+X_hat1.*not(Mask); 
    % Calculation time
    Temps(3,1) = toc(tStart);
    % Performance
    err = X_hat1(:) - X(:);
    rrse = sqrt(sum(err(O==0).^2)/sum(X(O==0).^2));
    Performance(3,1) = rrse;
end

%%% FaLRTC
if 1
    tStart = tic;
    alpha = [1, 1, 1];
    alpha = alpha / sum(alpha);
    maxIter = 500;
    mu =  5 * alpha ./ sqrt(size(Y));  % (User defined)
    %  mu =  0.01 * alpha ./ sqrt(size(Y));
    C =  0.6;
    L0 = 1e-5;
    epsilon = 1e-5;
    [X_hat2, errList_F] = FaLRTC(Y,logical(O),alpha,mu,L0,C,maxIter,epsilon);
    % We maintain the original (non-missing) entries...
    X_hat2 = X.*Mask+X_hat2.*not(Mask); 
    % Calculation time
    Temps(4,1) = toc(tStart);
    % Performance
    err = X_hat2(:) - X(:);
    rrse = sqrt(sum(err(O==0).^2)/sum(X(O==0).^2));
    Performance(4,1) = rrse;
end

%%% STDC-PAMI
if 1
    tStart = tic;
    para_Lx.print_mode = boolean(0);
    para_Lx.maxitr = 100;
    para_Lx.tau = 0.1;
    para_Lx.omega = 10^0.4;
    [~,~,~,X_STDC] = STDC(Y,logical(O==0),para_Lx,0,Y);
    % We maintain the original (non-missing) entries...
    X_STDC = X.*Mask+X_STDC.*not(Mask); 
    % Calculation time
    Temps(5,1) = toc(tStart);
    % Performance
    err = X_STDC(:) - X(:);
    rrse = sqrt(sum(err(O==0).^2)/sum(X(O==0).^2));
    Performance(5,1) = rrse;
end

%% save results
disp('Save tensor generated')
save_file('yes',X_STDC);
% save resultats_Mask
fprintf('======================Done 1 ======================================= \n');
