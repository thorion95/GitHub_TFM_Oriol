%% exploring possible outliers in the morphometric data extracted from FreeSurfer

clear all;close all;clc

addpath('my_functions')
addpath('my_variable')


%% MENU OPTIONS
%primera part CERCADOR OUTLIERS
buscar_outliers_metode_1 = 'no';         %yes/no   METODE PROPI
buscar_outliers_metode_2 = 'yes';        %yes/no
mostrar_outliers_procediment = 'no';     %yes/no/all
loop_var = 6;

%primera part COMPARAR PRIMERS RESULTATS
mostrar_outliers = 'no';                %yes/no/setA/setB  (yes: both/no: none/setA: only first/setB: only second)
guardar_resultats = 'yes';              %yes/no yes to save, no to do not save the mask generated
outlier_rang = 0.38;                    %rang stipulated to select where is an outlier (com + alt + amunt es situa el llindar)

%segona part COMPARACIO DE CORRECCIONS
compare_2_data_sets = 'no';            %yes/no/only
compare_nuvol_punts = 'yes';            %yes/no
compare_with = 'control_initial';       %control_initial/gifted_initial

%% DATA SET TO LOAD 1
% INITIAL SET
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol';
load([cami, '\my_variable\', 'A-morphoTensorCoG.mat']);file_name_mask_1='my_mask/mask_A_CO.mat';file_name_mask_2='my_mask/mask2_A_CO.mat';file_no_outliers='my_results/resultat_oriol_A_CO_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_A_CO_no_outliers.mat';load_var=morphoTensor;type='control';datasetA='INITIAL CO_A';
% load([cami, '\my_variable\', 'A-morphoTensorGiG.mat']);file_name_mask_1='my_mask/mask_A_Gi.mat';file_name_mask_2='my_mask/mask2_A_Gi.mat';file_no_outliers='my_results/resultat_oriol_A_Gi_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_A_Gi_no_outliers.mat';load_var=morphoTensor;type='gifted';datasetA='INITIAL Gi_A';
% load([cami, '\my_variable\', 'B-morphoTensorCoG.mat']);file_name_mask_1='my_mask/mask_B_CO.mat';file_name_mask_2='my_mask/mask2_B_CO.mat';file_no_outliers='my_results/resultat_oriol_B_CO_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_B_CO_no_outliers.mat';load_var=morphoTensor;type='control';datasetA='INITIAL CO_B';
% load([cami, '\my_variable\', 'B-morphoTensorGiG.mat']);file_name_mask_1='my_mask/mask_B_Gi.mat';file_name_mask_2='my_mask/mask2_B_Gi.mat';file_no_outliers='my_results/resultat_oriol_B_Gi_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_B_Gi_no_outliers.mat';load_var=morphoTensor;type='gifted';datasetA='INITIAL Gi_B';

% ORIOL SET
% load([cami, '\my_results\', 'resultat_oriol_A_CO_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='control';datasetA='ORIOL CO_A';load([cami, 'A-morphoTensorCoG.mat']);A_initial=morphoTensor;
% load([cami, '\my_results\', 'resultat_oriol_A_Gi_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='gifted';datasetA='ORIOL Gi_A';load([cami, 'A-morphoTensorGiG.mat']);A_initial=morphoTensor;
% load([cami, '\my_results\', 'resultat_oriol_B_CO_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='control';datasetA='ORIOL CO_B';load([cami, 'B-morphoTensorCoG.mat']);A_initial=morphoTensor;
% load([cami, '\my_results\', 'resultat_oriol_B_Gi_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='gifted';datasetA='ORIOL Gi_B';load([cami, 'B-morphoTensorGiG.mat']);A_initial=morphoTensor;

% RECONSTRUCTED SET
% load([cami, '\my_results\', 'resultat_reconstructed_A_CO.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetA='RECONSTRUCTED CO_A';load([cami, 'A-morphoTensorCoG.mat']);A_initial=morphoTensor;
% load([cami, '\my_results\', 'resultat_reconstructed_A_Gi.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetA='RECONSTRUCTED Gi_A';load([cami, 'A-morphoTensorGiG.mat']);A_initial=morphoTensor;
% load([cami, '\my_results\', 'resultat_reconstructed_B_CO.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetA='RECONSTRUCTED CO_B';load([cami, 'B-morphoTensorCoG.mat']);A_initial=morphoTensor;
% load([cami, '\my_results\', 'resultat_reconstructed_B_Gi.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetA='RECONSTRUCTED Gi_B';load([cami, 'B-morphoTensorGiG.mat']);A_initial=morphoTensor;

fprintf('CARREGAT: %s %s',type,datasetA)
pause
A = load_var;
maskA = A;
maskA(maskA > 0) = 1;
[numReg, numVar, numSubject] = size(A)
% numReg = 308; f numVar = 7; s numSubject = 14

%% PRIMERA PART CERCADOR DE OUTLIERS
if strcmp(mostrar_outliers,"yes") | strcmp(mostrar_outliers,"setA")==1 && strcmp(compare_2_data_sets,"only")~= 1
    scan_all_info(numSubject,numVar,numReg,A,type)
    fprintf('VALORS INICIALS DE: %s %s!!!\n',type,datasetA)
    pause
end

% CONTROL group A 2016

if strcmp(buscar_outliers_metode_1,"yes") == 1
    figure
    for refinament = 1:loop_var 
        fprintf('-------------------PASSADA %s-------------------\n',num2str(refinament))
        for f = 1:numVar
            for s = 1:numSubject
                plot(A(:,f,s))
                hold on
                m = mean(A(:,f,s)); %MITJANA
                ds = std(A(:,f,s));  %DESVIACIÓ ESTÀNDARD
                med = median(A(:,f,s)); %MEDIANA
                Q = quantile(A(:,f,s),[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]); %QUARTILS
                yline(m,'--','mean    ')
                for q = 1:length(Q)
                    yline(Q(q),':','Q')
                end
                yOutlier_sup = ((-Q(10))/(outlier_rang-1)); % EL LIMIT SUPERIOR SERA EL VALOR DEFINIT COM A UMBRAL MULTIPLICAT PEL VALOR MES ALT + EL SEGON VALOR MES PETIT
                yline(yOutlier_sup,'--','Outlier rang SUP    ')

                Q1m = ((m-Q(1))+m);
                Q2m = ((m-Q(2))+m);
                yOutlier_inf = m-(((-Q2m)/(outlier_rang-1))-m);
                yline(yOutlier_inf,'--','Outlier rang INF    ')

                Otl_sup =(Q(11)-Q(10))/Q(11);
                Otl_inf = ((Q1m-Q2m)/Q1m); % TROBEM LA DIFERENCIA AMB LA MITJANA I LI SUMEM LA MITJANA PER POSAR-HO PER LA PART DE DALT (IGUALTAT DE CONDICIONS)

                if ((Q(11)-Q(10))/Q(11))> outlier_rang %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT
                    fprintf('HI HA OUTLIER SUPERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s));
                    index = find(A(:,f,s) >= ((-Q(10))/(outlier_rang-1)));
                    for ind = 1:length(index)
                        fprintf(' Index: %i',index(ind))
                    end
                    fprintf('\n')
                    A(index,f,s) = m;
                    maskA(index,f,s) = 0;
                    xline(index,'--','Outlier X')
                    title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])

                    if strcmp(mostrar_outliers_procediment,"yes") == 1 
                        pause
                    end
                end
                if ((Q1m-Q2m)/Q1m)> outlier_rang + 0.1 %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT A LA PART SUPERIOR DE LA MITJANA
                    fprintf('HI HA OUTLIER INFERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s));
                    index = find(A(:,f,s) < m-(((-Q2m)/(outlier_rang-1))-m));
                    for ind = 1:length(index)
                        fprintf(' Index: %i',index(ind))
                    end
                    fprintf('\n')
                    A(index,f,s) = m;
                    maskA(index,f,s) = 0;
                    xline(index,'--','Outlier X')
                    title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])

                    if strcmp(mostrar_outliers_procediment,"yes") == 1 
                        pause
                    end
                end
                title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                axis padded
                hold off
                if strcmp(mostrar_outliers_procediment,"all") == 1 
                    pause
                else
                    close all
                end
            end
        end
        outlier_rang = outlier_rang - 0.01;
    end
    aux = maskA;
    no_outliers = maskA.*A;
    save_file(guardar_resultats,file_name_mask_1,aux,file_no_outliers,A);
end

%% isoutlier(morphoTensor,"ThresholdFactor",4)
% numReg = 308; f numVar = 7; s numSubject = 14

if strcmp(buscar_outliers_metode_2,"yes") == 1
 B = isoutlier(morphoTensor,"ThresholdFactor",3);
 aux = ~B;
 if strcmp(mostrar_outliers_procediment,"yes") == 1 
 figure()
 for f = 1:numVar
    for s = 1:numSubject
        plot(A(:,f,s))
        hold on
        for p = 1:numReg
            if aux(p,f,s)==0
                altura = A(p,f,s);
                scatter(p,A(p,f,s),'x','SizeData', 60,'MarkerEdgeColor','R')
            end
        end
        pause
        hold off
    end
 end
 end
 save_file(guardar_resultats,file_name_mask_2,aux,file2_no_outliers,A);
end


%% primera part COMPARAR PRIMERS RESULTATS

if strcmp(mostrar_outliers,"yes") | strcmp(mostrar_outliers,"setB")==1 | strcmp(compare_2_data_sets,"only")== 1
    scan_all_info(numSubject,numVar,numReg,A,type)
    fprintf('VALORS CORREGITS DE: %s %s!!\n',type,datasetA)
    pause
end

%% segona part COMPARAR RESULTATS

if (strcmp(compare_nuvol_punts,"yes") | strcmp(compare_2_data_sets,"yes")== 1)

    %% DATA SET TO LOAD 2 (to compare)
    % INITIAL SET
    % load([cami, '\my_variable\', 'A-morphoTensorCoG.mat']);file_name_mask_1='my_mask/mask_A_CO.mat';file_name_mask_2='my_mask/mask2_A_CO.mat';file_no_outliers='my_results/resultat_oriol_A_CO_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_A_CO_no_outliers.mat';load_var=morphoTensor;type='control';datasetA='INITIAL CO_A';
    % load([cami, '\my_variable\', 'A-morphoTensorGiG.mat']);file_name_mask_1='my_mask/mask_A_Gi.mat';file_name_mask_2='my_mask/mask2_A_Gi.mat';file_no_outliers='my_results/resultat_oriol_A_Gi_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_A_Gi_no_outliers.mat';load_var=morphoTensor;type='gifted';datasetA='INITIAL Gi_A';
    % load([cami, '\my_variable\', 'B-morphoTensorCoG.mat']);file_name_mask_1='my_mask/mask_B_CO.mat';file_name_mask_2='my_mask/mask2_B_CO.mat';file_no_outliers='my_results/resultat_oriol_B_CO_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_B_CO_no_outliers.mat';load_var=morphoTensor;type='control';datasetA='INITIAL CO_B';
    % load([cami, '\my_variable\', 'B-morphoTensorGiG.mat']);file_name_mask_1='my_mask/mask_B_Gi.mat';file_name_mask_2='my_mask/mask2_B_Gi.mat';file_no_outliers='my_results/resultat_oriol_B_Gi_no_outliers.mat';file2_no_outliers='my_results/resultat_matlab_B_Gi_no_outliers.mat';load_var=morphoTensor;type='gifted';datasetA='INITIAL Gi_B';

    % ORIOL SET
    % load([cami, '\my_results\', 'resultat_oriol_A_CO_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='control';datasetB='ORIOL CO_A';
    % load([cami, '\my_results\', 'resultat_oriol_A_Gi_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='gifted';datasetB='ORIOL Gi_A';
    % load([cami, '\my_results\', 'resultat_oriol_B_CO_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='control';datasetB='ORIOL CO_B';
    % load([cami, '\my_results\', 'resultat_oriol_B_Gi_no_outliers.mat']);load_var=no_outliers;type='resultat from reconstruction';type='gifted';datasetB='ORIOL Gi_B';

    % RECONSTRUCTED SET
    % load([cami, '\my_results\', 'resultat_reconstructed_A_CO_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED CO_A';
    % load([cami, '\my_results\', 'resultat_reconstructed_A_Gi_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED Gi_A';
    % load([cami, '\my_results\', 'resultat_reconstructed_B_CO_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED CO_B';
    % load([cami, '\my_results\', 'resultat_reconstructed_B_Gi_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED Gi_B';

    % RECONSTRUCTED SET 2
    load([cami, '\my_results\', 'resultat2_reconstructed_A_CO_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED CO_A';
    % load([cami, '\my_results\', 'resultat2_reconstructed_A_Gi_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED Gi_A';
    % load([cami, '\my_results\', 'resultat2_reconstructed_B_CO_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED CO_B';
    % load([cami, '\my_results\', 'resultat2_reconstructed_B_Gi_merged.mat']);load_var=X_STDC;type='resultat from reconstruction';type='control';datasetB='RECONSTRUCTED Gi_B';
    switch compare_with
        case "control_initial"
            cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\Set_of_data_to_modify\';
            load([cami, 'B-morphoTensorCoG.mat'])
        case "gifted_initial"
            cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\my_variable\';
            load([cami, 'B-morphoTensorGiG.mat'])
    end
    B_initial = morphoTensor;
    
    % %% CONTROL group B 2019
    B=load_var;
    fprintf('CARREGAT: %s %s\n',type,datasetB)
    [numReg, numVar, numSubject] = size(B)
    pause
    
    fprintf('COMPARANT %s AMB %s\n',datasetA,datasetB)
    
    if strcmp(compare_2_data_sets,"yes") ==1 
       scan_all_info(numSubject,numVar,numReg,B,type)
       fprintf('%s %s!!!\n',type,datasetA)
       pause

        for f = 1:numVar
            for s = 1:numSubject
                figure(1)
                subplot(3,1,1)
                plot(A_initial(:,f,s))
                title(['Dades A inicials: ',num2str(f),' Subjecte: ',num2str(s)])
                subplot(3,1,2)
                plot(A(:,f,s))
                title('Dades A oriol')
                subplot(3,1,3)
                plot(A_initial(:,f,s) - A(:,f,s))
                title('Dif A_initial - A oriol')

                figure(2)
                subplot(3,1,1)
                plot(A_initial(:,f,s))
                title(['Dades A inicials: ',num2str(f),' Subjecte: ',num2str(s)])
                subplot(3,1,2)
                plot(B(:,f,s))
                title('Dades A thermo')
                subplot(3,1,3)
                plot(A_initial(:,f,s) - B(:,f,s))
                title('Dif A_initial - A thermo')

                figure(3)
                subplot(3,1,1)
                plot(A_initial(:,f,s)-A(:,f,s))
                title(['Dades (A - Oriol): ',num2str(f),' Subjecte: ',num2str(s)])
                subplot(3,1,2)
                plot(A_initial(:,f,s)-B(:,f,s))
                title('Dades (A - Thermo)')
                subplot(3,1,3)
                plot(A(:,f,s)-B(:,f,s))
                title('Dades (Oriol - Thermo)')
                pause
            end
        end
        pause
    end
    
    % Comparació entre els dos sets de dades si les dades fossin molt iguals, el núvol de punts s'hauria d'aproximar a una recta de 45º plots
    if strcmp(compare_nuvol_punts,"yes") ==1
        fprintf('COMPARANT %s i %s AMB %s\n',datasetA,datasetB,compare_with)
        for f = 1:numVar
            for s = 1:numSubject
                figure(4)
                subplot(1,3,1)
                plot(B_initial(:,f,s),A(:,f,s),'.');
                title(['Subject: #',num2str(s)])
                xlabel('Dades B CoG')
                ylabel('Dades A Oriol')
                subplot(1,3,2)
                plot(B_initial(:,f,s),B(:,f,s),'.');
                title(['Feature: #',num2str(f)])
                xlabel('Dades B CoG')
                ylabel('Dades A Resultat')
                subplot(1,3,3)
                plot(B_initial(:,f,s),B_initial(:,f,s),'.');
                title(['Feature: #',num2str(f)])
                xlabel('Dades B CoG')
                ylabel('Dades B CoG')
                pause
            end
        end
    end

end
