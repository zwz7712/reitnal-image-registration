function octavesNum = calculateOctaves( image, des)
%   function:
%            Input:
%                   image: Դͼ��
%                   topSize�� ��������ͼ���С
%            Output:
%                   octavesNum: ������octaves��

    size_im = size(image);
    min_size = min(size_im(1),size_im(2));
    octavesNum = floor(log2(min_size)-log2(topSize));
end

