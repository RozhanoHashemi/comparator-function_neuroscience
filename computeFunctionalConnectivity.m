function FC_matrix = computeFunctionalConnectivity(data, method)
    % Inputs:
    %   data: 3D matrix (numRegions x numTimePoints x numSubjects)
    %   method: string specifying the similarity measure ('correlation', 'mse', 
    %           'rmse', 'euclidean', 'DTW', 'cross-correlation')

    % Validate method
    validMethods = {'correlation', 'mse', 'rmse', 'euclidean', 'DTW', 'cross-correlation'};
    if ~ismember(method, validMethods)
        error('Invalid method. Choose from: %s', strjoin(validMethods, ', '));
    end

    % Remove subjects which are all NaNs or zeros
    numSubjects = size(data, 3);
    validLayers = true(1, numSubjects);

    for k = 1:numSubjects
        if all(isnan(data(:, :, k)), 'all') || all(data(:, :, k) == 0, 'all')
            validLayers(k) = false;
        end
    end
    data = data(:, :, validLayers);
    numSubjects = size(data, 3);
    
    numRegions = size(data, 1);
    FC_matrix = zeros(numRegions, numRegions,numSubjects);

    % Loop over subjects to compute the FC matrix
    
        switch method
            case 'correlation'
                for subj = 1:numSubjects
                timeSeries = squeeze(data(:, :, subj))';  % Transpose to get time points x regions
                FC_matrix(:,:,subj) = corr(timeSeries, 'type', 'Pearson');
                end
            case 'mse'
                for subj = 1:numSubjects
                timeSeries = squeeze(data(:, :, subj));  % Transpose to get time points x regions
                 for Row = 1:numRegions
                    for Col = 1:numRegions
                        FC_matrix(Row, Col,subj) = immse(timeSeries(Row, :), timeSeries(Col, :));
                    end
                 end
                end 

            case 'rmse'
                for subj = 1:numSubjects
                timeSeries = squeeze(data(:, :, subj));  % Transpose to get time points x regions
                 for Row = 1:numRegions
                    for Col = 1:numRegions
                        FC_matrix(Row, Col,subj) = sqrt(immse(timeSeries(Row, :), timeSeries(Col, :)));
                    end
                 end
                end 

            case 'euclidean'
                for subj = 1:numSubjects
                timeSeries = squeeze(data(:, :, subj));  % Transpose to get time points x regions
                FC_matrix_l = pdist(timeSeries, 'euclidean');
                FC_matrix(:,:,subj) = squareform(FC_matrix_l);
                end
                
            case 'DTW'
                for subj = 1:numSubjects
                timeSeries = squeeze(data(:, :, subj));  % Transpose to get time points x regions
                for Row = 1:numRegions
                    for Col = 1:numRegions
                        FC_matrix(Row, Col,subj) = dtw(timeSeries(Row, :), timeSeries(Col, :));
                    end
                end

%             case 'cross-correlation'
%                 FC_matrix = xcorr(timeSeries, 'unbiased');
                
               end
        end
    
    % Display the averaged FC matrix
    figure;
    imagesc(mean(FC_matrix,3));
    colorbar;
    title(['Averaged Functional Connectivity Matrix - ', method]);

end