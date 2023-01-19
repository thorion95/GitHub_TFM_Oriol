function scan_all_info(numSubject,numVar,numReg,A,type)
    if strcmp(type,"control") == 1
        variable_row = 2;
    elseif strcmp(type,"gifted") == 1
        variable_row = 3;
    end
    
    for m = 1:numVar
        for r = 1:numReg
            serie = squeeze(A(r,m,:));
    %         listOfOutliers(r,m,:) = isoutlier(serie);
             listOfOutliers(r,m,:) = isoutlier(serie, 'mean');
        end
    end
%     listOfOutliers = isoutlier(A,"ThresholdFactor",3);
    
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
    grid on
    title('Number of outliers per feature (all subjects)')
    pause
    figure
    imagesc(numOutliersSubjectAndMeasure)
    title('Number of outliers per feature (all subjects)')
    [Outliers1, Measure] = sort(sum(numOutliersSubjectAndMeasure,1));
    pause
    
    figure
    bar(sum(numOutliersRegionAndMeasure,2))
    grid on
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
        subplot(variable_row,7,f)
        imagesc(im2(:,:,f))
        title(['Subject # ',num2str(f)])
        numOutliersMeasuresAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),1);
        numOutliersRegionAndSubjects(:,f) = sum(squeeze(im2(:,:,f)),2);
        pause
    end
    
    figure
    bar(sum(numOutliersMeasuresAndSubjects,1))
    grid on
    title('Number of outliers per subject')
    pause
    figure
    imagesc(numOutliersMeasuresAndSubjects)
    title('Number of outliers per subject')
    [Outliers3, Subject] = sort(sum(numOutliersMeasuresAndSubjects,1));
    pause
    
    figure
    bar(sum(numOutliersRegionAndSubjects,2))
    grid on
    title('Number of outliers per region')
    pause
    figure
    imagesc(numOutliersRegionAndSubjects)
    title('Number of outliers per region')
    [Outliers4, Region] = sort(sum(numOutliersRegionAndSubjects,2));
end

