%% exploring possible outliers in the morphometric data extracted from FreeSurfer

clear all
close all
clc

%% CONTROL group
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\working_area\GitHub_TFM_Oriol\Set_of_data_to_modify\';
% cal escollir un dels dos sets de dades (A o B)
load([cami, 'A-morphoTensorCoG.mat'])
% load([cami, 'B-morphoTensorCoG.mat'])
[numReg, numVar, numSub] = size(morphoTensor);

% explore the values across subjects for each specific region and measure
for m = 1:numVar
    for r = 1:numReg
        serie = squeeze(morphoTensor(r,m,:));
%         listOfOutliers(r,m,:) = isoutlier(serie);
         listOfOutliers(r,m,:) = isoutlier(serie, 'mean');
    end
end

%%%% exploring what happens for each feature

% figure('Name','Outliers, all regions and subjects')
% figure('Name','Stemplot for all subjects')
% figure('Name','Stemplot for all regions')

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
[Outliers1, Measure] = sort(sum(numOutliersSubjectAndMeasure,1)),
pause

figure
bar(sum(numOutliersRegionAndMeasure,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndMeasure)
title('Number of outliers per region')
[Outliers2, Region] = sort(sum(numOutliersRegionAndMeasure,2)),
pause

%%%% exploring what happens for each subject

figure
% for f = 1:numSub
%     im2(:,:,f) = squeeze(listOfOutliers(:,:,f));
%     imagesc(im2(:,:,f))
%     title('Number of outliers for each subject')
%     numOutliersMeasuresAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),1);
%     numOutliersRegionAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),2);
%     pause
% end

figure
for f = 1:numSub
    im2(:,:,f) = squeeze(listOfOutliers(:,:,f));
    subplot(2,7,f)
    imagesc(im2(:,:,f))
    title(['Number of outliers for subject # ',num2str(f)])
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
[Outliers3, Subject] = sort(sum(numOutliersMeasuresAndSubjects,1)),
pause

figure
bar(sum(numOutliersRegionAndSubjects,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndSubjects)
title('Number of outliers per region')
[Outliers4, Region] = sort(sum(numOutliersRegionAndSubjects,2)),

disp('CONTROLS DONE!!!')
pause

%% GIFTED

clear all
close all
clc

% GIFTED group
cami = 'c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\Oriol\Oriol\';
% cal escollir un dels dos sets de dades (A o B)
load([cami, 'A-morphoTensorGiG.mat'])
% load([cami, 'B-morphoTensorGiG.mat'])
[numReg, numVar, numSub] = size(morphoTensor);

% explore the values across subjects for each specific region and measure
for m = 1:numVar
    for r = 1:numReg
        serie = squeeze(morphoTensor(r,m,:));
%         listOfOutliers(r,m,:) = isoutlier(serie);
         listOfOutliers(r,m,:) = isoutlier(serie, 'mean');
    end
end

%%%% exploring what happens for each feature

% figure('Name','Outliers, all regions and subjects')
% figure('Name','Stemplot for all subjects')
% figure('Name','Stemplot for all regions')

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
[Outliers1, Measure] = sort(sum(numOutliersSubjectAndMeasure,1)),
pause

figure
bar(sum(numOutliersRegionAndMeasure,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndMeasure)
title('Number of outliers per region')
[Outliers2, Region] = sort(sum(numOutliersRegionAndMeasure,2)),
pause

%%%% exploring what happens for each subject

figure
% for f = 1:numSub
%     im2(:,:,f) = squeeze(listOfOutliers(:,:,f));
%     imagesc(im2(:,:,f))
%     title('Number of outliers for each subject')
%     numOutliersMeasuresAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),1);
%     numOutliersRegionAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),2);
%     pause
% end

figure
for f = 1:numSub
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
[Outliers3, Subject] = sort(sum(numOutliersMeasuresAndSubjects,1)),
pause

figure
bar(sum(numOutliersRegionAndSubjects,2))
title('Number of outliers per region')
pause
figure
imagesc(numOutliersRegionAndSubjects)
title('Number of outliers per region')
[Outliers4, Region] = sort(sum(numOutliersRegionAndSubjects,2)),

disp('GIFTED DONE!!!')
pause

%% Comparació entre els dos sets de dades
% si les dades fossin molt iguals, el núvol de punts s'hauria d'aproximar a
% una recta de 45º

load('c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\Oriol\Oriol\A-morphoTensorCoG.mat')
A=morphoTensor;
load('c:\Users\orica\Desktop\Oriol\0_MASTER\3_any\TFM\Oriol\Oriol\B-morphoTensorCoG.mat')
B=morphoTensor;

% plots
f = 1; % feature (pot anar de 1 a 7)
s = 1; % subject (pot anar de 1 a 14 o 15, depenent del grup)
figure
plot(A(:,f,s),B(:,f,s),'.');
xlabel('Dades A - antigues')
ylabel('Dades B - noves')


