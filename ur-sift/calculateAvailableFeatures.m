function [ cellNum, cellNums, availableFeatureNum, probality ] = calculateAvailableFeatures(matrix, gridSize)
%   function:
%               Input:
%                      matrix ��ͳ�ƵĲ�������
%                      gridSize �������
%               Output:
%                      cellNums ����ֵ
%                      availableFeatureNum ��Ӧ�����ھ����г��ֵĴ���
%                      probality ��Ӧ�����ھ�����ֵ�Ƶ��
    highNum = gridSize(1);
    widthNum = gridSize(2);
    widthSize = size(matrix,2)/widthNum;
    highSize = size(matrix,1)/highNum;
    [x,y] = find(matrix);
    % �������ݵĵ�ֵ���ɶ�Ӧcell�������±�ֵ
    xCell = ceil(x./highSize);
    yCell = ceil(y./widthSize);
    cellNum = xCell+(yCell-1)*highNum;
    % ����������ͳ��ÿ��cell����ֵ�ĳ��ָ�����Ƶ��
    [cellNums, availableFeatureNum, probality] = histRate(cellNum);
end

