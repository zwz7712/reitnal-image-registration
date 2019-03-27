function [ lastIndex ] = determinateCellPointsNum( keypoints, scaleSpace, octaveDoGStack, weightE, weightN, pointNum, layPiexlCellInddex, mask,image )
%   function: ����ÿ��������еĵ���
%   Input��
%           keypoints: ��ֵ����Ϣ
%           octavesStack: �߶ȿռ�ͼ��
%           octaveDoGStack: ��ָ�˹�ռ�ͼ��
%           weightE: E��Ȩֵ
%           weightN: N��Ȩֵ
%           pointNum: ÿ��octaveÿ���ϵĵ���
%           gridSize: ÿ���߶��ϵ��������
%
%   Output:
%           lastIndex: ѡȡ��������ľ��� 6*N'   N'<=pointNum

widthNums = size(unique(layPiexlCellInddex{2}));
widthNum = max(widthNums(1,1),widthNums(1,2));
highNums = size(unique(layPiexlCellInddex{1}));
highNum = max(highNums(1,1),highNums(1,2));
clear widthNums
clear highNums
cellNum = keypoints{4}; % ÿ���ץȡ���ļ�ֵ�����
octave = size(keypoints{1},1);
layer = size(keypoints{1},2);
avaliableFea = cell(octave,layer); 
m=0;
lastFeaMatrix = zeros(8,0);
% feaEntro = zeros(2,0);
sigma = scaleSpace{2};

%% ÿ��ķ���ĵ������ڵ�ǰ��ץȡ���ĵ�������
extracredExtreme = zeros(octave,layer);
for i = 1:octave
    for j = 1:layer
        extracredExtreme(i,j) = cellNum{i}(j);
    end
end
% size(pointNum)
% size(extracredExtreme)
pointNum = inAdequacyAssign(pointNum,extracredExtreme);
%% ÿ���ÿ��cell�еĵ��������ж�
for oct = 1:octave
    
    for lay = 1:layer
        % ȫΪ0 ���迼��
        if pointNum(oct,lay) ~= 0
            
            
            % ��ȡ�ؾ���ͼ ȡ�ֲ��ص�����Ϊ�뾶Ϊ3�ҵ�Բ
            se = strel('disk',ceil(3*sigma(oct,lay)));
            Nhood = getnhood(se);
            entropyImage = entropyfilt(scaleSpace{1}{oct}(:,:,:,lay),Nhood);
            
            
            %�˲�ͼ��������
            avaliableFea{oct,lay}.cellContrastSort = cell(highNum,widthNum);
            avaliableFea{oct,lay}.cellContrastSortInd = cell(highNum,widthNum);
            % ��ǰ�����������������
            row = scaleSpace{3}{oct};
            column = scaleSpace{4}{oct};
            for i = 1:highNum
                % ��ǰcell��������
                rows = find(layPiexlCellInddex{1}(row)==i);
                
                for j = 1:widthNum
                    %�����ڴ�cell����������
                    % ��ǰcell��������
                    columns = find(layPiexlCellInddex{2}(column)==j);
                    %                 size(columns)
                    %%
                    %ͳ��ÿ���ÿ��cell�Ŀ�����������
                    temp = keypoints{1}{oct,lay}(rows,columns);
                    avaliableFea{oct,lay}.cellFeatureNum(i,j) = sum( temp(:) ~= 0);
                    
                    %����cell��������ֵ�㣬ֱ�ӽ�����ʹ�ø�cell��ֵΪ0
                    if avaliableFea{oct,lay}.cellFeatureNum(i,j) == 0
                        avaliableFea{oct,lay}.cellGrayEntropy(i,j)=0;
                        avaliableFea{oct,lay}.cellMeanContrast(i,j)=0;
                        continue;
                    end
                    
                    
                    %%
                    %ͳ��ÿ���ÿ��cell�еĻҶ���
                    %�Ҷ��ظߵ������ܷ�˵������������Ϣ������򣿣�����������������������
                    %�ܷ�ͨ���������һ���̶ȵ�����³���ԣ���������������������������
                    % �������صļ���뾶Ϊ3�ҵ�Բ������
                    % ��Ϊ 1 ���������������صľ�ֵ
                    %      2 �������ͼ����
                    %% 2��
%                     [~,~,grayPro] = histRate(scaleSpace{1}{oct}(rows,columns,:,lay));
%                     avaliableFea{oct,lay}.cellGrayEntropy(i,j) = -sum(grayPro.*log2(grayPro));
                    %% 1��
                    [x,y] = find(temp);
                    
                    cellFeatureIndexInLay = rows(x)+(columns(y)-1)*size(row,2);
                    featureEntropy = entropyImage(cellFeatureIndexInLay);
                    avaliableFea{oct,lay}.cellGrayEntropy(i,j) = sum(featureEntropy(:))/avaliableFea{oct,lay}.cellFeatureNum(i,j);
                    
                    
                    %%
                    %ͳ��ÿ��ÿ��cell�ļ�ֵ���ƽ���Աȶ�
                    %�Աȶȸߵ������ܷ�˵������������Ϣ������򣿣�����������������������
                    %�ܷ�ͨ���������һ���̶ȵ�����³���ԣ���������������������������
                    cellij = octaveDoGStack{oct}(rows,columns,:,lay);
                    cellFeatureIndexInCell = size(rows,2);
                    cellFeatureInd = x+(y-1)*cellFeatureIndexInCell;
                    cellij = cellij(cellFeatureInd);
                    avaliableFea{oct,lay}.cellMeanContrast(i,j) = sum(abs(cellij(:)))/numel(cellij);
                    %sum(abs(cellij(:)))/numel(cellij)
                    
                    % cellContrastSortInd ��cell�е��������ڵ�ǰ��cell�е�һά����
                    avaliableFea{oct,lay}.cellFeatureInd{i,j} = cellFeatureInd;
                    clear grayPro
                end
                
            end
            % ÿ���ÿ��cell��ȡ�����
            % Ϊ�ο�����ɷֵ���cell�����ȸò���ܵĹؼ���������??????????????????????????????????????
            % ����ɷ���ֵ����ʵ����ץȡ����ֵ
            avaliableFea{oct,lay}.cell = pointNum(oct,lay)*(weightE*avaliableFea{oct,lay}.cellGrayEntropy/sum(avaliableFea{oct,lay}.cellGrayEntropy(:))...
                + weightN*avaliableFea{oct,lay}.cellFeatureNum/(sum(avaliableFea{oct,lay}.cellFeatureNum(:)))...
                + (1-weightE-weightN)*avaliableFea{oct,lay}.cellMeanContrast/sum(avaliableFea{oct,lay}.cellMeanContrast(:)));
            
            %         avaliableFea{oct,lay}.cell
            
            %% ���ڵ���������cell�ڵ�ǰ����д���
            cellExtracted = zeros(highNum,widthNum);
            for cellHighInade = 1:highNum
                rowInade = find(layPiexlCellInddex{1}(row) == cellHighInade);
                for cellWidthInade = 1:widthNum
                    columnInade = find(layPiexlCellInddex{2}(column) == cellWidthInade);
                    cellExtracted(cellHighInade,cellWidthInade) = sum(sum(keypoints{1}{oct,lay}(rowInade,columnInade) ~= 0));
                end
            end
            avaliableFea{oct,lay}.cell = inAdequacyAssign(avaliableFea{oct,lay}.cell, cellExtracted);
            %% ���ڵ�ǰ���cell��ѡ��Աȶ�����3��n_cell�����ĵ�
            for cellit = 1:highNum
                % ��ǰcell���ڸò��������
                rowsi = find(layPiexlCellInddex{1}(row)==cellit);
                cellRow = size(rowsi,2);
                for celljt = 1:widthNum
                    % ��ǰcell�ڸò��������
                    columnsi = find(layPiexlCellInddex{2}(column) == celljt);
                    % ��ǰcell����=0
                    if(round(avaliableFea{oct,lay}.cell(cellit,celljt)) == 0)
                        continue;
                        % ��ǰcell��������>0 <=3*n_cell
                    elseif 0 < cellExtracted(cellit,celljt) &&...
                            avaliableFea{oct,lay}.cell(cellit,celljt)*3 >= cellExtracted(cellit,celljt)
                        allowIndNum = round(cellExtracted(cellit,celljt));
                        % ��ǰcell��������>3*n_cell
                    elseif avaliableFea{oct,lay}.cell(cellit,celljt)*3 < cellExtracted(cellit,celljt)
                        allowIndNum = round(avaliableFea{oct,lay}.cell(cellit,celljt)*3);
                    end
                    curCellFeaInd = avaliableFea{oct,lay}.cellFeatureInd{cellit,celljt};
                    dotRegion = octaveDoGStack{oct}(rowsi,columnsi,:,lay);
                    % �Աȶ���ߵ�allowIndNum����
                    [~,I1] = sort(dotRegion(curCellFeaInd));
                    curCellFeaInd = curCellFeaInd(I1);
                    curCellFeaInd = curCellFeaInd(1:allowIndNum);
                    
                    % �ڸ�cell��Χ�ڵ���������
                    y = ceil(curCellFeaInd/cellRow);
                    x = mod(curCellFeaInd,cellRow);
                    x(x==0)=cellRow;
                    
                    cellIndex = rowsi(x)+(columnsi(y)-1)*size(row,2);
                    featureEntropy = entropyImage(cellIndex);
                    [pointEntropy,I] = sort(featureEntropy,'descend');
                    pointEntropy = pointEntropy(1:round(avaliableFea{oct,lay}.cell(cellit,celljt)));
                    I = I(1:round(avaliableFea{oct,lay}.cell(cellit,celljt)));
                    
                    % ��cell������ѡȡ��n_cell�����ڵ�ǰ���λ��
                    finalKeypointIndex = cellIndex(I);
                    rowsize = size(row,2);
                    realKeypointColumn = column(ceil(finalKeypointIndex/rowsize));
                    % ��ʵ����λ��
                    realKeypointRow = mod(finalKeypointIndex,rowsize);
                    realKeypointRow(realKeypointRow==0) = rowsize;
                    realKeypointRow = row(realKeypointRow);
                    [finalLocat,pointEntropy,I] =  ditributedFeaSele([realKeypointRow;realKeypointColumn], round(avaliableFea{oct,lay}.cell(cellit,celljt)),6,pointEntropy,I);
%                     if ~isempty(finalLocat)
%                         m = figure();
%                         imshow(image);
%                         hold on
%                         plot(finalLocat(2,:),finalLocat(1,:),'r+');
%                         hold off
%                         saveas(m,['E:\ѧϰ\ur-sift\��layer��������ȡ���\oct ' num2str(octave) '-lay ' num2str(layer) '-cellH ' num2str(it) '-cellW ' num2str(jt) '.bmp']);
%                         lastIndex = [lastIndex finalLocat];
                        dotRegion = octaveDoGStack{oct}(:,:,:,lay);
                        % ����8ά������2άͼ��ռ����꣬2ά�߶ȿռ����꣬2άcell������ͼ���أ�ͼ��Աȶȣ���ǰcell��ȡ����������������ǰ����������
                        lastFeaMatrix = [lastFeaMatrix [finalLocat;repmat([oct;lay],1,length(I));repmat([cellit;celljt],1,length(I));...
                            pointEntropy;dotRegion(cellIndex(I)); ...
                            repmat(avaliableFea{oct,lay}.cell(cellit,celljt),1,length(I));repmat(pointNum(oct,lay),1,length(I))]];         
%                     end
                end
            end
   
        end
        
    end
end

[~,lastFeaInd,~] = unique(lastFeaMatrix(1:4,:)','rows');
lastFeaMatrix = lastFeaMatrix(:,lastFeaInd);
% lastIndex = GlobalPointSelect(lastFeaMatrix,5);  % �������ڵ�Ĵ���
lastIndex = lastFeaMatrix;
 
