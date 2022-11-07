%% exploring possible outliers in the morphometric data extracted from FreeSurfer

clear all
close all
clc

%% CONTROL group
outlier_rang = 0.35
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\Set_of_data_to_modify\';
% cal escollir un dels dos sets de dades (A o B)
load([cami, 'A-morphoTensorCoG.mat'])
% load([cami, 'B-morphoTensorCoG.mat'])
A=morphoTensor;
% load([cami, 'B-morphoTensorCoG.mat'])
[numReg, numVar, numSubject] = size(morphoTensor)
% numReg = 308; numVar = 7; numSubject = 14
figure

for f = 1:numVar
    for s = 1:numSubject
        plot(A(:,f,s))
        hold on
        m = mean(A(:,f,s)) %MITJANA
        ds = std(A(:,f,s))  %DESVIACIÓ ESTÀNDARD
        med = median(A(:,f,s)) %MEDIANA
        Q = quantile(A(:,f,s),[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]); %QUARTILS
        yline(m,'--','mean')
        for q = 1:length(Q)
            yline(Q(q),':','Q')
        end
        yOutlier = outlier_rang*Q(11)+Q(10)
        yline(yOutlier,'--','Outlier rang')
        diff = Q(11)-Q(10)
        Q(11)
        Q(10)
        Otl=(Q(11)-Q(10))/Q(11)
        
        if ((Q(11)-Q(10))/Q(11))> outlier_rang
            disp('HI HA OUTLIER')
            index = find(A(:,f,s) == Q(11))
            xline(index,':','Outlier')
            yOutlier = outlier_rang*Q(11)+Q(10)
            yline(yOutlier,'--','Outlier rang')
            title(['Caracteristica: ',num2str(f),' Jambo: ',num2str(s)])
            pause
        end
        
        title(['Caracteristica: ',num2str(f),' Jambo: ',num2str(s)])
        axis padded
        hold off
    end
    pause
end