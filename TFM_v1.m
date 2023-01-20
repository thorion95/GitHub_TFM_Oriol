close all
clear all
clc
%% funcions / paths
addpath('my_functions')
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol';

%% menú opcions internes
mostrar_plots = 'no';
guardar_resultats = 'yes';
loop_var = 3;
outlier_rang = 0.40 %0.25 corr 0.72641 ---- 0.35 corr 0.73224 ---- 0.40 corr 0.73246 ---- 0.40 corr 0.7278

action = menu()
%% codi switchos
if strcmp(action,"mask") == 1
    action = menu3()
    if strcmp(action,"isoutlier") == 1
        %% métode 1 Obtenció de mascara is outlier funcio
        fprintf('Selecciona dades inicials per carregar i generar-ne la màscara\n')
        [file, path] = uigetfile('*.mat');
        data = load(fullfile(path, file));
        fprintf('Loaded: %s\n',file)
        A=data.morphoTensor;
        [numReg, numVar, numSubject] = size(A)
        %     B = isoutlier(A, 'mean');
        B = isoutlier(A,"ThresholdFactor",3);
        mask = ~B;
        if strcmp(mostrar_plots,"yes") == 1
            figure()
            for f = 1:numVar
                for s = 1:numSubject
                    plot(A(:,f,s))
                    title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                    grid on
                    hold on
                    m = mean(A(:,f,s));
                    yline(m,'--','mean    ')
                    for p = 1:numReg
                        if mask(p,f,s)==0
                            scatter(p,A(p,f,s),'x','SizeData', 60,'MarkerEdgeColor','R')
                        end
                    end
                    pause
                    hold off
                end
            end
        end
        fprintf('Guardant mascara generada, selecciona on vols guardar-la\n')
        fprintf('Fitxer emprat: %s\n',file)
        save_file(guardar_resultats,mask);
        
    elseif strcmp(action,"quartils") == 1
        %% métode 2 Obtenció de mascara per quartils
        % carrega 1 variable
        fprintf('Selecciona dades inicials per carregar i generar-ne la màscara\n')
        [file, path] = uigetfile('*.mat');
        data = load(fullfile(path, file));
        fprintf('Loaded: %s\n',file)
        A=data.morphoTensor;
        [numReg, numVar, numSubject] = size(A)
        maskA = A;
        maskA(abs(maskA) > 0) = 1;
        h = waitbar(0,'Procesando...');
        for refinament = 1:loop_var 
            fprintf('-------------------PASSADA %s-------------------\n',num2str(refinament))
            for f = 1:numVar
                for s = 1:numSubject
                    if strcmp(mostrar_plots,"yes") == 1 
                        figure
                        plot(A(:,f,s))
                        hold on
                    end
                    m = mean(A(:,f,s)); %MITJANA
                    ds = std(A(:,f,s));  %DESVIACIÓ ESTÀNDARD
                    med = median(A(:,f,s)); %MEDIANA
                    Q = quantile(A(:,f,s),[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]); %QUARTILS del 1 al 11
                    if strcmp(mostrar_plots,"yes") == 1 
                        yline(m,'--','mean    ')
                        for q = 1:length(Q)
                            yline(Q(q),':','Q')
                        end
                    end
                    
                    yOutlier_sup = ((-Q(10))/(outlier_rang-1)); % EL LIMIT SUPERIOR SERA EL VALOR DEFINIT COM A UMBRAL MULTIPLICAT PEL VALOR MES ALT + EL SEGON VALOR MES PETIT
                    yline(yOutlier_sup,'--','Outlier rang SUP    ')

                    Q1m = ((m-abs(Q(1)))+m);
                    Q2m = ((m-abs(Q(2)))+m);
                    yOutlier_inf = m-(((-Q2m)/(outlier_rang-1))-m);
                    
                    if strcmp(mostrar_plots,"yes") == 1 
                        yline(yOutlier_inf,'--','Outlier rang INF    ')
                    end

                    Otl_sup =(Q(11)-Q(10))/Q(11);
                    Otl_inf = ((Q1m-Q2m)/Q1m); % TROBEM LA DIFERENCIA AMB LA MITJANA I LI SUMEM LA MITJANA PER POSAR-HO PER LA PART DE DALT (IGUALTAT DE CONDICIONS)

                    if ((Q(11)-Q(10))/Q(11))> outlier_rang %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT
                        index = find(A(:,f,s) >= ((-Q(10))/(outlier_rang-1)));
                        if strcmp(mostrar_plots,"yes") == 1 
                            fprintf('HI HA OUTLIER SUPERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s));
                            for ind = 1:length(index)
                                fprintf(' Index: %i',index(ind))
                                scatter(index(ind),yOutlier_sup,'x','SizeData', 60,'MarkerEdgeColor','R')
                            end
                            fprintf('\n')
                            xline(index,'--','Outlier X')
                            title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                        end
                        A(index,f,s) = m;
                        maskA(index,f,s) = 0;
%                         if strcmp(mostrar_plots,"yes") == 1 
%                             pause
%                         end
                    end
                    
                    resta = (Q1m-Q2m)/Q1m;
                    if resta > outlier_rang %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT A LA PART SUPERIOR DE LA MITJANA
                        index = find(A(:,f,s) < m-(((-Q2m)/(outlier_rang-1))-m));
                        if strcmp(mostrar_plots,"yes") == 1 
                            fprintf('HI HA OUTLIER INFERIOR Caracteristica: %s Subjecte: %s',num2str(f),num2str(s));
                            for ind = 1:length(index)
                                fprintf(' Index: %i',index(ind))
                                scatter(index(ind),yOutlier_inf,'x','SizeData', 60,'MarkerEdgeColor','R')
                            end
                            fprintf('\n')
                            xline(index,'--','Outlier X')
                            title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                        end
                        A(index,f,s) = m;
                        maskA(index,f,s) = 0;

%                         if strcmp(mostrar_plots,"yes") == 1 
%                             pause
%                         end
                    end
                    title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                    axis padded
                    hold off
                    if strcmp(mostrar_plots,"yes") == 1 
                        pause
                    else
                        close all
                    end
                end
            end
            waitbar(refinament/loop_var,h);
            outlier_rang = outlier_rang - 0.02;
        end
        close(h)
        mask = maskA;
        fprintf('Guardant mascara generada, selecciona on vols guardar-la\n')
        fprintf('Fitxer emprat: %s\n',file)
        save_file(guardar_resultats,mask);
        
    elseif strcmp(action,"correlacions") == 1
        %% opcio per correlar 3 sets de dades
        % carrega 2 variables
        fprintf('Hauràs de seleccionar 3 dades per carregar A B i C per treuren la correlació A-C i B-C\nSelecciona les dades reconstruides com a A, les dades originals com a B i les dades C com les originals del set b\n')
        [file, path] = uigetfile('*.mat');
        file_split = strsplit(file, '.');
        file_name = file_split{1};
        fprintf('Carregat %s com a set A\n',file_name)
        data = load(fullfile(path, file));
        test_data = fieldnames(data);
        TF = contains(test_data,'morphoTensor'); %si 1 es morphoTensor si 0 no
        if TF == 1
            A = data.morphoTensor
            var = 'morphoTensor';
        else
            A = data.data;
            var = 'data';
        end
        [numReg, numVar, numSubject] = size(A);
        % numReg = 308; f numVar = 7; s numSubject = 14

        fprintf('Selecciona set de dades B per comparar\n')
        [file, path] = uigetfile('*.mat');
        file_split = strsplit(file, '.');
        file_name2 = file_split{1};
        fprintf('Carregat %s com a set B\n',file_name2)
        data2 = load(fullfile(path, file));
        test_data2 = fieldnames(data2);
        TF2 = contains(test_data2,'morphoTensor');
        if TF2 == 1
            B = data2.morphoTensor;
            var2 = 'morphoTensor';
        else
            B = data2.data;
            var2 = 'data';
        end
        [numReg2, numVar2, numSubject2] = size(B);

        if numSubject ~= numSubject2
            disp('No has seleccionat valors per comparar adequats, sisplau compara CoG amb CoG i GiG amb GiG')
            error()
        elseif numSubject == 14
            disp('Selecciona un set de dades de CoG amb el que desitgis comparar A i B')
            [file, path] = uigetfile('*.mat');
            file_split = strsplit(file, '.');
            file_name3 = file_split{1};
            fprintf('Carregat %s com a set C\n',file_name3)
            data3 = load(fullfile(path, file));
            test_data3 = fieldnames(data3);
            TF3 = contains(test_data3,'morphoTensor');
            if TF3 == 1
                C = data3.morphoTensor;
                var2 = 'morphoTensor';
            else
                C = data3.data;
                var2 = 'data';
            end
            [numReg2, numVar2, numSubject2] = size(C);
        elseif numSubject == 15
            disp('Selecciona un set de dades de GiG amb el que desitgis comparar A i B')
            [file, path] = uigetfile('*.mat');
            file_split = strsplit(file, '.');
            file_name3 = file_split{1};
            fprintf('Carregat %s com a set C\n',file_name3)
            data3 = load(fullfile(path, file));
            test_data3 = fieldnames(data3);
            TF3 = contains(test_data3,'morphoTensor');
            if TF3 == 1
                C = data3.morphoTensor;
                var2 = 'morphoTensor';
            else
                C = data3.data;
                var2 = 'data';
            end
            [numReg2, numVar2, numSubject2] = size(C);
        end
        fprintf('Comparant %s i %s amb %s\n',file_name,file_name2,file_name3)
        
        for f = 1:numVar
            for s = 1:numSubject
                corr_aux = corrcoef(C(:,f,s),A(:,f,s)); %C = dades B, A = dades carregades reconstruides
                corr_vect(f,s) = corr_aux(1,2);
                corr_aux_2 = corrcoef(C(:,f,s),B(:,f,s)); %C = dades B, B = dades inicials
                corr_vect2(f,s) = corr_aux_2(1,2);
            end
        end
        fprintf('\nCorrelació %s amb %s, guarda els resultats de la correlació entre A i C\n',file_name,file_name3)
        corr_vect
        save_file(guardar_resultats,corr_vect);
        fprintf('\nCorrelació %s amb %s, guarda els resultats de la correlació entre B i C\n',file_name2,file_name3)
        corr_vect2
        save_file(guardar_resultats,corr_vect2);
    end
elseif strcmp(action,"compare") == 1
    action = menu2()
    if strcmp(action,"outliers") == 1
        %% opcio per veure els outliers de les dades 
        % carrega 1 variable
        fprintf('Selecciona set de dades per analitzar els outliers\n')
        [file, path] = uigetfile('*.mat');
        file_split = strsplit(file, '.');
        file_name = file_split{1};
        fprintf('Carregat %s com a set A\n',file_name)
        data = load(fullfile(path, file));
        test_data = fieldnames(data);
        TF = contains(test_data,'morphoTensor'); %si 1 es morphoTensor si 0 no
        if TF == 1
            A = data.morphoTensor
            var = 'morphoTensor';
        else
            A = data.data;
            var = 'data';
        end
        [numReg, numVar, numSubject] = size(A);
        if numSubject == 14
            type = 'control'
        else
            type = 'gifted'
        end
        % escaneja les dades
        scan_all_info(numSubject,numVar,numReg,A,type)
    
    elseif strcmp(action,"dades") == 1
        %% opcio per comparar 3 sets de dades
        % carrega 2 variables
        fprintf('Es generarà el núvol de punts resultat de la comparació entre les dades A, B i C.\nSelecciona les dades A (la que vulguis de les reconstruides per comparar), les dades inicials B (dades_a sense tocar) i les dades finals C (dades_b del mateix grup)\n')
        [file, path] = uigetfile('*.mat');
        file_split = strsplit(file, '.');
        file_name = file_split{1};
        fprintf('Carregat %s com a set A\n',file_name)
        data = load(fullfile(path, file));
        test_data = fieldnames(data);
        TF = contains(test_data,'morphoTensor'); %si 1 es morphoTensor si 0 no
        if TF == 1
            A = data.morphoTensor
            var = 'morphoTensor';
        else
            A = data.data;
            var = 'data';
        end
        [numReg, numVar, numSubject] = size(A);
        % numReg = 308; f numVar = 7; s numSubject = 14

        fprintf('Selecciona set de dades que direm B per comparar (set_inicial set A CoG/GiG)\n')
        [file, path] = uigetfile('*.mat');
        file_split = strsplit(file, '.');
        file_name2 = file_split{1};
        fprintf('Carregat %s com a set B\n',file_name2)
        data2 = load(fullfile(path, file));
        test_data2 = fieldnames(data2);
        TF2 = contains(test_data2,'morphoTensor');
        if TF2 == 1
            B = data2.morphoTensor;
            var2 = 'morphoTensor';
        else
            B = data2.data;
            var2 = 'data';
        end
        [numReg2, numVar2, numSubject2] = size(B);

        if numSubject ~= numSubject2
            disp('No has seleccionat valors per comparar adequats, sisplau compara CoG amb CoG i GiG amb GiG')
            error()
        elseif numSubject == 14
            disp('Selecciona un set de dades de CoG amb el que desitgis comparar A i B')
            [file, path] = uigetfile('*.mat');
            file_split = strsplit(file, '.');
            file_name3 = file_split{1};
            fprintf('Carregat %s com a set C\n',file_name3)
            data3 = load(fullfile(path, file));
            test_data3 = fieldnames(data3);
            TF3 = contains(test_data3,'morphoTensor');
            if TF3 == 1
                C = data3.morphoTensor;
                var2 = 'morphoTensor';
            else
                C = data3.data;
                var2 = 'data';
            end
            [numReg2, numVar2, numSubject2] = size(C);
        elseif numSubject == 15
            disp('Selecciona un set de dades de GiG amb el que desitgis comparar A i B')
            [file, path] = uigetfile('*.mat');
            file_split = strsplit(file, '.');
            file_name3 = file_split{1};
            fprintf('Carregat %s com a set C\n',file_name3)
            data3 = load(fullfile(path, file));
            test_data3 = fieldnames(data3);
            TF3 = contains(test_data3,'morphoTensor');
            if TF3 == 1
                C = data3.morphoTensor;
                var2 = 'morphoTensor';
            else
                C = data3.data;
                var2 = 'data';
            end
            [numReg2, numVar2, numSubject2] = size(C);
        end


        fprintf('Comparant %s i %s amb %s\n',file_name,file_name2,file_name3)

        for f = 1:numVar
            fprintf('numVar: %i\n',numVar)
            for s = 1:numSubject
                figure(1)
                subplot(1,2,1)
                plot(C(:,f,s),A(:,f,s),'.');
                grid on
                p = polyfit(C(:,f,s),A(:,f,s),1);
                inclinacion = atand(p(1));
                corr_CA = corrcoef(C(:,f,s),A(:,f,s));
                corr_CA = corr_CA(1,2);

                yfit = polyval(p,C(:,f,s));
                hold on
                plot(C(:,f,s),yfit);
                xlabel(['Dades ',num2str(file_name3)])
                ylabel(['Dades ',num2str(file_name)])
                title(['Deg: ',num2str(inclinacion),' | Corr: ',num2str(corr_CA)])
                hold off

                subplot(1,2,2)
                plot(C(:,f,s),B(:,f,s),'.');
                grid on
                p2 = polyfit(C(:,f,s),B(:,f,s),1);
                inclinacion2 = atand(p2(1));
                corr_CB = corrcoef(C(:,f,s),B(:,f,s));
                corr_CB = corr_CB(1,2);

                yfit2 = polyval(p2,C(:,f,s));
                hold on
                plot(C(:,f,s),yfit2); 
                xlabel(['Dades ',num2str(file_name3)])
                ylabel(['Dades ',num2str(file_name2)])
                title(['Deg: ',num2str(inclinacion2),' | Corr: ',num2str(corr_CB)])
                sgtitle(['Subject: ',num2str(s),' | Feature: ',num2str(f)])
                hold off
                fprintf('--------------------\n')
                correlacio_CA(f,s) = corr_CA;
                correlacio_CB(f,s) = corr_CB;
                fprintf('Correlación %s y %s: %f\n',file_name3,file_name, corr_CA);
                fprintf('Correlación %s y %s: %f\n',file_name3,file_name2, corr_CB);

                figure(2)
                if (C(:,f,s) ~= A(:,f,s))
                    plot(C(:,f,s),A(:,f,s),'r.');
                    grid on
                    hold on
                else
                    plot(C(:,f,s),A(:,f,s),'.');
                    grid on
                    hold on
                end
                if (C(:,f,s) ~= B(:,f,s))
                    plot(C(:,f,s),B(:,f,s),'g.');
                    grid on
                    hold off
                else
                    plot(C(:,f,s),B(:,f,s),'.');
                    grid on
                    hold off
                end
                title(['Comparació entre ',file_name3,'-',file_name,' i ',file_name3,'-',file_name])
                pause
            end
        end
        for f = 1:numVar
            correlacio_CA(f,:)'
        end
        for f = 1:numVar
            correlacio_CB(f,:)'
        end
    elseif strcmp(action,"compcorrelacions") == 1
        % carrega 2 variables
        fprintf('Selecciona set de correlacions a carregar\n')
        [file, path] = uigetfile('*.mat');
        file_split = strsplit(file, '.');
        file_name = file_split{1};
        fprintf('Carregat correlacions %s com a corr A\n',file_name)
        data = load(fullfile(path, file));
        corr = data.data
        
        fprintf('Selecciona set de correlacions a comparar\n')
        [file2, path] = uigetfile('*.mat');
        file_split = strsplit(file2, '.');
        file_name2 = file_split{1};
        fprintf('Carregat correlacions %s com a corr B\n',file_name2)
        data2 = load(fullfile(path, file2));
        corr2 = data2.data
        
        figure()
        subplot(2,1,1)
        plot(corr)
        ylim([0 1])
        grid on
        correlacioA = mean(corr)
        mitjana_correlacio = mean(correlacioA)
        title(['Corr dades: ',file_name, ' | Corr: ', num2str(mean(correlacioA))])
        
        subplot(2,1,2)
        plot(corr2)
        ylim([0 1])
        grid on
        correlacioB = mean(corr2)
        mitjana_correlacio = mean(correlacioB)
        title(['Corr dades: ',file_name2, ' | Corr: ', num2str(mean(correlacioB))])
        sgtitle(['Correlació contra les dades B de: ',file_name,' i ',file_name2])      
    end
elseif strcmp(action,"reconstruct") == 1
    %% execució del .m per reconstruir les dades 
    % carregar mascara
    run('MainTensorCompletion_2022.m')
end




