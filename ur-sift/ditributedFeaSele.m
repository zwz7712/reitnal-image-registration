function  [finalLocat,pointEntropy,I]  = ditributedFeaSele( feaLocatMatrix, n_cell, minDisPiexl,pointEntropy,I )
%   function :
%               input:
%                     feaLocatMatrix  �����������صĽ����������ԭͼ�ϵ�������� 2 X 4*n_cell
%                     n_cell  ��ǰcell�е�Ԥ���䵽�ĵ���
%                     minDisPiexl  ��С�������ŷʽ�����׼
%               output:
%                     finalLocat   ����ѡ������������ԭͼ��������� 2 X n_cell
feaNum = size(feaLocatMatrix,2);
index = 1;
if feaNum==1
    finalLocat = feaLocatMatrix;
elseif n_cell==1
    finalLocat = feaLocatMatrix(:,1);
else
    finalLocat(:,1) = feaLocatMatrix(:,1);
    num = 1;
    for i=2:feaNum
        distan = finalLocat - repmat(feaLocatMatrix(:,i),[1 num]);
        eudDistan = sum(distan.*distan);
        if isempty(find(eudDistan<minDisPiexl))
            num = num+1;
            index = [index i];
            finalLocat(:,num) = feaLocatMatrix(:,i);
        end
        if num == n_cell
            break;
        end
    end
end
pointEntropy = pointEntropy(index);
I = I(index);
end

