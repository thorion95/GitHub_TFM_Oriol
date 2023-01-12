close all
clear all
clc

addpath('my_functions')

%% selecciona el que vols fer
mostrar_plots = 'no';
guardar_resultats = 'yes';
action = menu()

if strcmp(action,"mask") == 1
    % carrega 1 variable
    fprintf('Selecciona dades inicials per carregar\n')
    [file, path] = uigetfile('*.mat');
    data = load(fullfile(path, file));
    fprintf('Loaded: %s',file)
    A=data.morphoTensor;
    [numReg, numVar, numSubject] = size(A)
    % aplica el metode de busqueda de outliers
    B = isoutlier(A,"ThresholdFactor",3);
    mask = ~B;
    figure()
    if strcmp(mostrar_plots,"yes") == 1
        for f = 1:numVar
            for s = 1:numSubject
                plot(A(:,f,s))
                hold on
                for p = 1:numReg
                    if mask(p,f,s)==0
                        altura = A(p,f,s);
                        scatter(p,A(p,f,s),'x','SizeData', 60,'MarkerEdgeColor','R')
                    end
                end
                pause
                hold off
            end
        end
    end
    fprintf('Guardant mascara generada\n')
    save_file(guardar_resultats,mask);
    
elseif strcmp(action,"compare") == 1
    % carrega 2 variables
    fprintf('Selecciona set de dades 1 per comparar\n')
    [file, path] = uigetfile('*.mat');
    data = load(fullfile(path, file));
    
    fprintf('Selecciona set de dades 2 per comparar\n')
    [file, path] = uigetfile('*.mat');
    data2 = load(fullfile(path, file));
    
elseif strcmp(action,"reconstruct") == 1
    % carregar mascara
    run('MainTensorCompletion_2022.m')
end




