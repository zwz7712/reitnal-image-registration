function  [FeaMatrix,currSize,image]  = ursift(imageName, format,scaleSize,opinion,visible )

% ��ɫ����ͼ��mask
% ��ɫ����ͼ��Ѫ��
image = imread(imageName);
    
% image1 = imnoise(image1,'salt',0.3);
if nargin >=3
    image=imresize(image,scaleSize);
end
currSize = size(image);
if ndims(image)>2
    imageGreen = image(:,:,2);
    imageRed = image(:,:,1);
    if opinion.showGreen 
        figure
        imshow(image);
        title('�̷�ɫͼ');
    end
else
    imageGreen = image;
    imageRed = image;
     figure('visible',visible);
     imshow(image);
     title('ԭͼ');
end
switch format
    
    case 'colored'
       %%
        %ͼ��Ԥ����
        imagered = double(imageRed);
        imagered = imagered/max(imagered(:))*255;
%%
        [msk,~] = rr_msk(imagered,30);
%%
        
        
%%
        if opinion.showMask
            figure;
            imshow(msk);
            title('mask');
        end
%         
        % 2D-GaborС���任Ԥ����
%         imagePreTreatExtension ���ź��ͼ��
%         imagePreTreat ��msk1��Χ�ڵ�ͼ
%         [imagePreTreatExtension,imagePreTreat,~,~] = generatefeaturescolored(image,msk,4,5,opinion.showExtend,opinion.showImageInMask);
%         
%         imageToTre=imagePreTreatExtension;
% 
% % local-phase Ԥ����
%         imageToTre =local_phase(imageGreen,msk);
%         imagePreTreat = imageToTre;
imageToTre=imageGreen;
imagePreTreat=imageGreen;
    case 'angiogram'
        %%
        [msk,~] = rr_msk(double(imageGreen),5);
        imageToTre = imageGreen;
        if opinion.showMask
            figure
            imshow(msk)
            title('mask');
        end
        imagePreTreat = imageToTre;
    case 'redfree'
        %%
%         
%         
%         
%         
%         
end
octaves = 4;
GaussPry = scaleSpace(imageToTre,octaves,3,1.6);


octaveDoGStack1 = calculateDog(GaussPry);
% keypoints1 = calculateKeypoints(octaveDoGStack1, image1,image1name);
keypoints = calculateKeypoints2(octaveDoGStack1, msk, GaussPry);
drawFeature(keypoints,GaussPry,imagePreTreat,visible);



% �û�����Nֵ
disp(['The features total num in ' imageName ' is ' num2str(keypoints{3})])
N = round(keypoints{3}*0.75);
disp(['The chosen features num is:' num2str(N)]);
% N = input('how many features do you want: ');
[pointNum, layPiexlCellInddex] = determinateLayerPointsNum(keypoints{3},GaussPry,N,[50;50],imageName);
FeaMatrix= determinateCellPointsNum(keypoints,GaussPry,octaveDoGStack1,0.2,0.5,pointNum,layPiexlCellInddex,msk,image);

% figure;imshow(imageGreen)
% hold on;
% plot(keyIndex(:,2),keyIndex(:,1),'ro')
% hold off





end

