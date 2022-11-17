%% exploring possible outliers in the morphometric data extracted from FreeSurfer

clear all
close all
clc

%% CONTROL group A 2016
outlier_rang = 0.4
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\Set_of_data_to_modify\';
% cal escollir un dels dos sets de dades (A o B)
load([cami, 'A-morphoTensorCoG.mat'])
% load([cami, 'A-morphoTensorGiG.mat'])
A_initial = morphoTensor;
A = morphoTensor;
% load([cami, 'B-morphoTensorCoG.mat'])
[numReg, numVar, numSubject] = size(morphoTensor)
% numReg = 308; numVar = 7; numSubject = 14

figure

for refinament = 1:4  %QUANTITAT DE VEGADES QUE ES REFINARA LA PART POSITIVA DE LA SEÑAL
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
                disp('HI HA OUTLIER SUPERIOR')
                index = find(A(:,f,s) >= ((-Q(10))/(outlier_rang-1)));
                A(index,f,s) = m;
                xline(index,'--','Outlier X')
                title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
%                 pause
            end
            if ((Q1m-Q2m)/Q1m)> outlier_rang + 0.1 %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT A LA PART SUPERIOR DE LA MITJANA
                disp('HI HA OUTLIER INFERIOR')
                index = find(A(:,f,s) < m-(((-Q2m)/(outlier_rang-1))-m));
                A(index,f,s) = m;
                xline(index,'--','Outlier X')
                title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
                pause
            end

            title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
            axis padded
            hold off
%             pause
        end
    end
    outlier_rang = outlier_rang - 0.05;
end

for m = 1:numVar
    for r = 1:numReg
        serie = squeeze(A(r,m,:));
%         listOfOutliers(r,m,:) = isoutlier(serie);
         listOfOutliers(r,m,:) = isoutlier(serie, 'mean');
    end
end

for f = 1:numVar
    im(:,:,f) = squeeze(listOfOutliers(:,f,:));
    figure()
    imagesc(squeeze(im(:,:,f)))
    title(['Number of outliers for feature # ',num2str(f)])
    %figure(2)
    numOutliersSubjectAndMeasure(:,f) = sum(squeeze(im(:,:,f)),1)';
    %hold on
    %stem(numOutliersSubjectAndMeasure(:,f))
    %figure(3)
    numOutliersRegionAndMeasure(:,f) = sum(squeeze(im(:,:,f)),2);
    %hold on
    %stem(numOutliersRegionAndMeasure(:,f))
    pause
end

figure
bar(sum(numOutliersSubjectAndMeasure,1))
title('Number of outliers per feature (all subjects)')
pause
figure
imagesc(numOutliersSubjectAndMeasure)
title('Number of outliers per feature (all subjects)')
[Outliers1, Measure] = sort(sum(numOutliersSubjectAndMeasure,1));
pause

figure
bar(sum(numOutliersRegionAndMeasure,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndMeasure)
title('Number of outliers per region')
[Outliers2, Region] = sort(sum(numOutliersRegionAndMeasure,2));
pause

figure
for f = 1:numSubject
    im2(:,:,f) = squeeze(listOfOutliers(:,:,f));
    subplot(3,7,f)
    imagesc(im2(:,:,f))
    title(['Subject # ',num2str(f)])
    numOutliersMeasuresAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),1);
    numOutliersRegionAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),2);
    pause
end

figure
bar(sum(numOutliersMeasuresAndSubjects,1))
title('Number of outliers per subject')
pause
figure
imagesc(numOutliersMeasuresAndSubjects)
title('Number of outliers per subject')
[Outliers3, Subject] = sort(sum(numOutliersMeasuresAndSubjects,1));
pause

figure
bar(sum(numOutliersRegionAndSubjects,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndSubjects)
title('Number of outliers per region')
[Outliers4, Region] = sort(sum(numOutliersRegionAndSubjects,2));

disp('CONTROL DONE!!!')
pause


%% CONTROL group B 2019
outlier_rang = 0.4
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\Set_of_data_to_modify\';
% cal escollir un dels dos sets de dades (A o B)
load([cami, 'B-morphoTensorCoG.mat'])
% load([cami, 'B-morphoTensorGiG.mat'])
B_initial = morphoTensor;
B=morphoTensor;
% load([cami, 'B-morphoTensorCoG.mat'])
[numReg, numVar, numSubject] = size(morphoTensor);
% numReg = 308; numVar = 7; numSubject = 14
figure

for refinament = 1:2
    for f = 1:numVar
        for s = 1:numSubject
            plot(B(:,f,s))
            hold on
            m = mean(B(:,f,s)); %MITJANA
            ds = std(B(:,f,s));  %DESVIACIÓ ESTÀNDARD
            med = median(B(:,f,s)); %MEDIANA
            Q = quantile(B(:,f,s),[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]); %QUARTILS
            yline(m,'--','mean')
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
                disp('HI HA OUTLIER SUPERIOR')
                index = find(B(:,f,s) >= ((-Q(10))/(outlier_rang-1)));
                B(index,f,s) = m;
                xline(index,'--','Outlier X')
                title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
%                 pause
            end
            if ((Q1m-Q2m)/Q1m)> outlier_rang %SI SUPERA LA NORMALITZACIÓ DE LA DIFERÉNCIA DELS DOS ÚLTIMS QUARTILS SOTA UN MINIM APLICAT A LA PART SUPERIOR DE LA MITJANA
                disp('HI HA OUTLIER INFERIOR')
                index = find(B(:,f,s) < m-(((-Q2m)/(outlier_rang-1))-m));
                B(index,f,s) = m;
                xline(index,'--','Outlier X')
                title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
%                 pause
            end

            title(['Caracteristica: ',num2str(f),' Subjecte: ',num2str(s)])
            axis padded
            hold off
%             pause
        end
    end
end


for m = 1:numVar
    for r = 1:numReg
        serie = squeeze(B(r,m,:));
%         listOfOutliers(r,m,:) = isoutlier(serie);
         listOfOutliers(r,m,:) = isoutlier(serie, 'mean');
    end
end

for f = 1:numVar
    im(:,:,f) = squeeze(listOfOutliers(:,f,:));
    figure(1)
    imagesc(squeeze(im(:,:,f)))
    title(['Number of outliers for feature # ',num2str(f)])
    %figure(2)
    numOutliersSubjectAndMeasure(:,f) = sum(squeeze(im(:,:,f)),1)';
    %hold on
    %stem(numOutliersSubjectAndMeasure(:,f))
    %figure(3)
    numOutliersRegionAndMeasure(:,f) = sum(squeeze(im(:,:,f)),2);
    %hold on
    %stem(numOutliersRegionAndMeasure(:,f))
    pause
end

figure
bar(sum(numOutliersSubjectAndMeasure,1))
title('Number of outliers per feature (all subjects)')
pause
figure
imagesc(numOutliersSubjectAndMeasure)
title('Number of outliers per feature (all subjects)')
[Outliers1, Measure] = sort(sum(numOutliersSubjectAndMeasure,1));
pause

figure
bar(sum(numOutliersRegionAndMeasure,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndMeasure)
title('Number of outliers per region')
[Outliers2, Region] = sort(sum(numOutliersRegionAndMeasure,2));
pause

figure
for f = 1:numSubject
    im2(:,:,f) = squeeze(listOfOutliers(:,:,f));
    subplot(3,7,f)
    imagesc(im2(:,:,f))
    title(['Subject # ',num2str(f)])
    numOutliersMeasuresAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),1);
    numOutliersRegionAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),2);
    pause
end

figure
bar(sum(numOutliersMeasuresAndSubjects,1));
title('Number of outliers per subject')
pause
figure
imagesc(numOutliersMeasuresAndSubjects)
title('Number of outliers per subject')
[Outliers3, Subject] = sort(sum(numOutliersMeasuresAndSubjects,1));
pause

figure
bar(sum(numOutliersRegionAndSubjects,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndSubjects)
title('Number of outliers per region')
[Outliers4, Region] = sort(sum(numOutliersRegionAndSubjects,2));

disp('GIFTED DONE!!!')
pause

for f = 1:numVar
    for s = 1:numSubject
        figure(1)
        subplot(3,1,1)
        plot(A_initial(:,f,s))
        title(['Dades A inicials: ',num2str(f),' Subjecte: ',num2str(s)])
        subplot(3,1,2)
        plot(A(:,f,s))
        title('Dades A sense outliers')
        subplot(3,1,3)
        plot(A_initial(:,f,s) - A(:,f,s))
        title('Dif A in - A out')
        
        figure(2)
        subplot(3,1,1)
        plot(B_initial(:,f,s))
        title(['Dades B inicials: ',num2str(f),' Subjecte: ',num2str(s)])
        subplot(3,1,2)
        plot(B(:,f,s))
        title('Dades B sense outliers')
        subplot(3,1,3)
        plot(B_initial(:,f,s) - B(:,f,s))
        title('Dif B in - B out')
        
        figure(3)
        subplot(3,1,1)
        plot(A_initial(:,f,s)-B_initial(:,f,s))
        title(['Dades (A - B) inicials: ',num2str(f),' Subjecte: ',num2str(s)])
        subplot(3,1,2)
        plot(A(:,f,s)-B(:,f,s))
        title('Dades (A - B) sense outliers')
        subplot(3,1,3)
        plot((A_initial(:,f,s)-B_initial(:,f,s))-(A(:,f,s)-B(:,f,s)))
        title('Dades (A - B) - (A - B)')
        pause
    end
end

pause
%% Comparació entre els dos sets de dades
% si les dades fossin molt iguals, el núvol de punts s'hauria d'aproximar a
% una recta de 45º


% plots
for f = 1:numVar
    for s = 1:numSubject
        figure(4)
        subplot(1,2,1)
        plot(A(:,f,s),B(:,f,s),'.');
        xlabel('Dades A - retocades')
        ylabel('Dades B - retocades')
        subplot(1,2,2)
        plot(A_initial(:,f,s),B_initial(:,f,s),'.');
        xlabel('Dades A - inicials')
        ylabel('Dades B - inicials')
        title(['Dades : ',num2str(f),' Subjecte: ',num2str(s)])
        figure(5)
        plot(A(:,f,s)-A_initial(:,f,s),B(:,f,s)-B_initial(:,f,s),'.')
        xlabel('Dades A - A inicials')
        ylabel('Dades B - B inicials')
        title(['Dades (A - Ai),(B - Bi) ',num2str(f),' Subjecte: ',num2str(s)])
        pause
    end
end
