%% exploring possible outliers in the morphometric data extracted from FreeSurfer

clear all;close all;clc

addpath('my_functions')
addpath('my_variable')

%% MENU OPTIONS
% SHOW OUTLIERS FROM OWN SOLUTION? (show graphics with outliers)
show_outliers_oriol = 'no';              %yes/no/all  (all: graphic by graphic/yes: only show outliers/no: dont show anything)
% SHOW OUTLIERS FROM FUNCTION? (show outliers classification)
show_outliers_function = 'yes';          %yes/no/setA/setB  (yes: both/no: none/setA: only first/setB: only second)
% MASK OPTIONS
save_to_file = 'yes';                     %yes/no yes to save, no to do not save the mask generated
generate_masked_values = 'yes';          %yes/no yes to generated mask of 1 and 0 merged with initial values matrix
outlier_rang = 0.45                      %rang stipulated to select where is an outlier (com + alt + amunt es situa el llindar)
% DATA SET TO LOAD
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\Set_of_data_to_modify\';
% load([cami, 'A-morphoTensorCoG.mat']);file_name_mask_1='my_variable/mask_A_CO.mat';file_name_mask_merged_1='my_variable/mask_A_CO_merged.mat';type='control';dataset='A';
% load([cami, 'A-morphoTensorGiG.mat']);file_name_mask_1='my_variable/mask_A_Gi.mat';file_name_mask_merged_1='my_variable/mask_A_Gi_merged.mat';type='gifted';dataset='A';
load([cami, 'B-morphoTensorCoG.mat']);file_name_mask_1='my_variable/mask_B_CO.mat';file_name_mask_merged_1='my_variable/mask_B_CO_merged.mat';type='control';dataset='B';
% load([cami, 'B-morphoTensorGiG.mat']);file_name_mask_1='my_variable/mask_B_Gi.mat';file_name_mask_merged_1='my_variable/mask_B_Gi_merged.mat';type='gifted';dataset='B';

A_initial = morphoTensor;
A = morphoTensor;
maskA = A;
maskA(maskA > 0) = 1;
[numReg, numVar, numSubject] = size(morphoTensor)
% numReg = 308; f numVar = 7; s numSubject = 14

%% Outliers per feature BEFORE CORRECTION
fprintf("Scanning %s group of %s data set\n",type,dataset)
if strcmp(show_outliers_function,"yes") == 1
    scan_all_info(numSubject,numVar,numReg,A,type)
    fprintf('DONE %s %s!!!\n',type,dataset)
    pause
end

%% OWN SOLUTION

% CONTROL group A 2016

figure
for refinament = 1:6  %QUANTITAT DE VEGADES QUE ES REFINARA LA PART POSITIVA DE LA SEÑAL
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
                fprintf('HI HA OUTLIER SUPERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s))
                index = find(A(:,f,s) >= ((-Q(10))/(outlier_rang-1)));
                for ind = 1:length(index)
                    fprintf(' Index: %i',index(ind))
                end
                fprintf('\n')
                A(index,f,s) = m;
                maskA(index,f,s) = 0;
                xline(index,'--','Outlier X')
                title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                
                if strcmp(show_outliers_oriol,"yes") == 1 
                    pause
                end
            end
            if ((Q1m-Q2m)/Q1m)> outlier_rang + 0.1 %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT A LA PART SUPERIOR DE LA MITJANA
                fprintf('HI HA OUTLIER INFERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s))
                index = find(A(:,f,s) < m-(((-Q2m)/(outlier_rang-1))-m));
                for ind = 1:length(index)
                    fprintf(' Index: %i',index(ind))
                end
                fprintf('\n')
                A(index,f,s) = m;
                maskA(index,f,s) = 0;
                xline(index,'--','Outlier X')
                title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                
                if strcmp(show_outliers_oriol,"yes") == 1 
                    pause
                end
            end
            title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
            axis padded
            hold off
            if strcmp(show_outliers_oriol,"all") == 1 
                pause
            end
        end
    end
    outlier_rang = outlier_rang - 0.03;
end
aux = maskA;
merged_matrix = generate_mask_plus_initial_values(generate_masked_values,maskA,A);
save_file(save_to_file,file_name_mask_1,aux,file_name_mask_merged_1,merged_matrix);

%% Outliers per AFTER CORRECTION

if strcmp(show_outliers_function,"yes") == 1
    scan_all_info(numSubject,numVar,numReg,A,type)
    fprintf('DONE %s %s!!!\n',type,dataset)
    pause
end


% file_name_mask_2 = 'my_variable/mask_B_CO.mat'      %name of file for mask B
% file_name_mask_merged_2 = 'my_variable/mask_B_CO_merged.mat'      %name of file for mask merged with data set
% %% CONTROL group B 2019
% cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\Set_of_data_to_modify\';
% % cal escollir un dels dos sets de dades (A o B)
% load([cami, 'B-morphoTensorCoG.mat'])
% % load([cami, 'B-morphoTensorGiG.mat'])
% B_initial = morphoTensor;
% B=morphoTensor;
% maskB = B;
% maskB(maskB > 0) = 1;
% % load([cami, 'B-morphoTensorCoG.mat'])
% [numReg, numVar, numSubject] = size(morphoTensor);
% % numReg = 308; numVar = 7; numSubject = 14
% 
% 
% disp('GIFTED GROUP')
% figure
% 
% for refinament = 1:2
%     for f = 1:numVar
%         for s = 1:numSubject
%             plot(B(:,f,s))
%             hold on
%             m = mean(B(:,f,s)); %MITJANA
%             ds = std(B(:,f,s));  %DESVIACIÓ ESTÀNDARD
%             med = median(B(:,f,s)); %MEDIANA
%             Q = quantile(B(:,f,s),[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]); %QUARTILS
%             yline(m,'--','mean')
%             for q = 1:length(Q)
%                 yline(Q(q),':','Q')
%             end
%             yOutlier_sup = ((-Q(10))/(outlier_rang-1)); % EL LIMIT SUPERIOR SERA EL VALOR DEFINIT COM A UMBRAL MULTIPLICAT PEL VALOR MES ALT + EL SEGON VALOR MES PETIT
%             yline(yOutlier_sup,'--','Outlier rang SUP    ')
%             
%             Q1m = ((m-Q(1))+m);
%             Q2m = ((m-Q(2))+m);
%             yOutlier_inf = m-(((-Q2m)/(outlier_rang-1))-m);
%             yline(yOutlier_inf,'--','Outlier rang INF    ')
%             
%             Otl_sup =(Q(11)-Q(10))/Q(11);
%             Otl_inf = ((Q1m-Q2m)/Q1m); % TROBEM LA DIFERENCIA AMB LA MITJANA I LI SUMEM LA MITJANA PER POSAR-HO PER LA PART DE DALT (IGUALTAT DE CONDICIONS)
% 
%             if ((Q(11)-Q(10))/Q(11))> outlier_rang %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT
%                 fprintf('HI HA OUTLIER SUPERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s))
%                 index = find(B(:,f,s) >= ((-Q(10))/(outlier_rang-1)));
%                 for ind = 1:length(index)
%                     fprintf(' Index: %i',index(ind))
%                 end
%                 fprintf('\n')
%                 B(index,f,s) = m;
%                 maskB(index,f,s) = 0;
%                 xline(index,'--','Outlier X')
%                 title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
% %                 pause
%             end
%             if ((Q1m-Q2m)/Q1m)> outlier_rang %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT A LA PART SUPERIOR DE LA MITJANA
%                 fprintf('HI HA OUTLIER INFERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s))
%                 index = find(B(:,f,s) < m-(((-Q2m)/(outlier_rang-1))-m));
%                 for ind = 1:length(index)
%                     fprintf(' Index: %i',index(ind))
%                 end
%                 fprintf('\n')
%                 B(index,f,s) = m;
%                 maskB(index,f,s) = 0;
%                 xline(index,'--','Outlier X')
%                 title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
% %                 pause
%             end
% 
%             title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
%             axis padded
%             hold off
% %             pause
%         end
%     end
%     fprintf('-------------------PASSADA %s-------------------\n',num2str(refinament))
% end
% 
% aux = maskB;
% merged_matrix = generate_mask_plus_initial_values(generate_masked_values,maskB,B);
% save_file(save_to_file,file_name_mask_2,aux,file_name_mask_merged_2,merged_matrix);
% 
% if strcmp(show_outliers_function,"yes") == 1
%     scan_all_info_gifted(numSubject,numVar,numReg,B)
%     disp('GIFTED DONE!!!')
%     pause
% end
% 
% 
% for f = 1:numVar
%     for s = 1:numSubject
%         figure(1)
%         subplot(3,1,1)
%         plot(A_initial(:,f,s))
%         title(['Dades A inicials: ',num2str(f),' Subjecte: ',num2str(s)])
%         subplot(3,1,2)
%         plot(A(:,f,s))
%         title('Dades A sense outliers')
%         subplot(3,1,3)
%         plot(A_initial(:,f,s) - A(:,f,s))
%         title('Dif A in - A out')
%         
%         figure(2)
%         subplot(3,1,1)
%         plot(B_initial(:,f,s))
%         title(['Dades B inicials: ',num2str(f),' Subjecte: ',num2str(s)])
%         subplot(3,1,2)
%         plot(B(:,f,s))
%         title('Dades B sense outliers')
%         subplot(3,1,3)
%         plot(B_initial(:,f,s) - B(:,f,s))
%         title('Dif B in - B out')
%         
%         figure(3)
%         subplot(3,1,1)
%         plot(A_initial(:,f,s)-B_initial(:,f,s))
%         title(['Dades (A - B) inicials: ',num2str(f),' Subjecte: ',num2str(s)])
%         subplot(3,1,2)
%         plot(A(:,f,s)-B(:,f,s))
%         title('Dades (A - B) sense outliers')
%         subplot(3,1,3)
%         plot((A_initial(:,f,s)-B_initial(:,f,s))-(A(:,f,s)-B(:,f,s)))
%         title('Dades (A - B) - (A - B)')
% %         pause
%     end
% end
% 
% % pause
% %% Comparació entre els dos sets de dades
% % si les dades fossin molt iguals, el núvol de punts s'hauria d'aproximar a
% % una recta de 45º
% 
% 
% % plots
% for f = 1:numVar
%     for s = 1:numSubject
%         figure(4)
%         subplot(1,2,1)
%         plot(A(:,f,s),B(:,f,s),'.');
%         xlabel('Dades A - retocades')
%         ylabel('Dades B - retocades')
%         subplot(1,2,2)
%         plot(A_initial(:,f,s),B_initial(:,f,s),'.');
%         xlabel('Dades A - inicials')
%         ylabel('Dades B - inicials')
%         title(['Dades : ',num2str(f),' Subjecte: ',num2str(s)])
%         figure(5)
%         plot(A(:,f,s)-A_initial(:,f,s),B(:,f,s)-B_initial(:,f,s),'.')
%         xlabel('Dades A - A inicials')
%         ylabel('Dades B - B inicials')
%         title(['Dades (A - Ai),(B - Bi) ',num2str(f),' Subjecte: ',num2str(s)])
% %         pause
%     end
% end
