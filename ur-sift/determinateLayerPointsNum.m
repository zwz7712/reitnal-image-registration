function  [ pointNum, cellNum]  = determinateLayerPointsNum(totalKeyNum, scaleSpace, N, cell_size, imageName)
%   function:   ����ÿ��ļƻ����������cell���С�����������
%   Input:
%               scaleSpace �߶ȿռ�
%               N:  �ܵĵ���
%               cell_size ����ߴ�
%   Output:
%               pointNum �߶ȿռ���ÿ��ÿ���߶��ϵĵ���
%               gridSize ÿ���߶��ϵ��������
%% ���� �� ǿ�д��˸���������Ϊ1 ������ÿ��ʵ����ȡ����������
%   ������룺    �����ͳ߶�ϵ���ɸ���� �ɷ�ʹ��һ������ʹ�ó߶�ϵ��ԽСʱ����仯�ٶ�Խ��
%% ���� �� ��������Ĥͼ�� ÿ��octave��ÿ��ʵ��ץȡ�������ֵ͡��ߡ������� ���Ǹߡ��С�������
%   ������룺�ı�ϵ��������߶�ϵ��accumSigma��oct,lay)�Ĺ�ϵ octave����
%% ������������ܼ�⵽�ļ�ֵ����ʱ����
if N>totalKeyNum
   error(['Error: You can not input the features number larger than the total number ' num2str(totalKeyNum)]) 
end
%% 
% fp = fopen([imageName '�ĳ߶�ϵ����keypoints����ϵ.txt'],'a');
% str=[char(13,10)' '�û����������������ÿ���Ԥ��ֵ' char(13,10)'];
% fprintf(fp,'%s',str);
%%
accumSigma = scaleSpace{2};

oct = size(accumSigma,1);
lay = size(accumSigma,2);
pointProportion  = zeros(oct,lay);
k = 2^(1/lay);
f0 = countf0(oct,lay,k);
for octave = 1:oct
    for layer = 1:lay
        pointProportion(octave,layer) = accumSigma(1,1)^2/accumSigma(octave,layer)^2*f0;
%         str =['Octave ' num2str(octave) ' Layer ' num2str(layer) ' Key point num ' num2str(pointProportion(octave,layer)*N),char(13,10)'];
%         fprintf(fp,'%s',str);
    end
end
% sum(sum(pointProportion))
pointNum = pointProportion*N;
% fclose(fp);
% %% ����ͼ���ÿ�����ض�Ӧ��cell���
highNum = floor(size(scaleSpace{3}{1},2)/cell_size(1));
cellNum{1} = zeros(1,size(scaleSpace{3}{1},2));
redu = mod(size(scaleSpace{3}{1},2),cell_size(1));
addToNum = floor(redu/highNum);
restPot = mod(redu,highNum)/2;
addRest = cell_size(1)+addToNum;
comIndexHead = floor(restPot)*(addRest+1);
comIndexRear = ceil(restPot)*(addRest+1);
cellNum{1}(1:comIndexHead) = ceil(scaleSpace{3}{1}(1:comIndexHead)/(addRest+1));
cellNum{1}(comIndexHead+1:end-comIndexRear) = ceil(scaleSpace{3}{1}(comIndexHead+1:end-comIndexRear)/(addRest));
cellNum{1}(end-comIndexRear+1:end) = ceil(scaleSpace{3}{1}(end-comIndexRear+1:end)/(addRest+1));


widthNum= floor(size(scaleSpace{4}{1},2)/cell_size(2));
cellNum{2} = zeros(1,size(scaleSpace{4}{1},2));
redu = mod(size(scaleSpace{4}{1},2),cell_size(2));
addToNum = floor(redu/widthNum);
restPot = mod(redu,widthNum)/2;
addRest = cell_size(2)+addToNum;
comIndexHead = floor(restPot)*(addRest+1);
comIndexRear = ceil(restPot)*(addRest+1);
cellNum{2}(1:comIndexHead) = ceil(scaleSpace{4}{1}(1:comIndexHead)/(addRest+1));
cellNum{2}(comIndexHead+1:end-comIndexRear) = ceil(scaleSpace{4}{1}(comIndexHead+1:end-comIndexRear)/(addRest));
cellNum{2}(end-comIndexRear+1:end) = ceil(scaleSpace{4}{1}(end-comIndexRear+1:end)/(addRest+1));
% widthNum = floor(size(scaleSpace{4}{1},2)/cell_size(2));
% cellNum{2} = zeros(1,size(scaleSpace{4}{1},2));
% redu = mod(size(scaleSpace{4}{1},2),cell_size(2))
% completeCell = widthNum-redu;
% comIndex = (completeCell)*cell_size(2);
% cellNum{2}(1:comIndex) = ceil(scaleSpace{4}{1}(1:comIndex)/cell_size(2));
% comIndex
% cellNum{2}(comIndex+1:end) = ceil(scaleSpace{4}{1}(comIndex+1:end)/(cell_size(2)+1));
end

