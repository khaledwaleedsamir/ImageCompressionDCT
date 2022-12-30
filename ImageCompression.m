%arrays to store PSNR and m values for plot function
PSNRValues = [0,0,0,0];
mValues = [0,0,0,0];

%Reading Image
rgbImage= imread('image1.bmp'); 
[Rows ,Columns]=size(rgbImage);
Columns=Columns/3;

%Split the image to its RGB components
RChannel = rgbImage(:, :, 1);
GChannel = rgbImage(:, :, 2);
BChannel = rgbImage(:, :, 3);
%display the 3 color channels separatly
imshow(RChannel); figure;
imshow(GChannel); figure;
imshow(BChannel); figure;

%getting the DCT for each channel
for i = 1:8:Rows
    for j = 1:8:Columns
RDCT(i:i+7,j:j+7)= blockproc(RChannel(i:i+7,j:j+7),[8 8],@(block_struct) dct2(block_struct.data));
GDCT(i:i+7,j:j+7)= blockproc(GChannel(i:i+7,j:j+7),[8 8],@(block_struct) dct2(block_struct.data));
BDCT(i:i+7,j:j+7)= blockproc(BChannel(i:i+7,j:j+7),[8 8],@(block_struct) dct2(block_struct.data));
    end
end

%based on m we will see how many DCT coefficients we will take
for m = 1:4
    CompR = int16([]);
    CompG = int16([]);
    CompB = int16([]);
    c=1; %columns counter
    r=1; %rows counter
    for i=1:8:Rows
        for j=1:8:Columns
        BlockR = RDCT(i:i+7,j:j+7);
        CompR(r:r+m-1,c:c+m-1)=BlockR(1:m,1:m);
        BlockG = GDCT(i:i+7,j:j+7);
        CompG(r:r+m-1,c:c+m-1)=BlockG(1:m,1:m);
        BlockB = BDCT(i:i+7,j:j+7);
        CompB(r:r+m-1,c:c+m-1)=BlockB(1:m,1:m);
        c=c+m;
        end
    c=1;
    r=r+m;
   end
    

   compressedImage = cat(3,CompR,CompG,CompB);
   filename = sprintf('CompressedImage %i %s',m,'.bmp'); %to save the compressed images before uncompressing them again
   save(filename,"compressedImage");
fprintf('The Size of the Compressed image with m=%d is %d Pixels.\n',m,m^2*(Rows*Columns/64)*3);
   
idctUnCompR = uint8([]);
idctUnCompG = uint8([]);
idctUnCompB = uint8([]);
c=1; %columns counter
r=1; %rows counter
BlockR=zeros(8,8);
BlockG=zeros(8,8);
BlockB=zeros(8,8);
 
    for i=1:8:Rows
        for j=1:8:Columns
        BlockR(1:m,1:m) = CompR(r:r+m-1,c:c+m-1);
        UnCompR(i:i+7,j:j+7) = BlockR;
        BlockG(1:m,1:m) = CompG(r:r+m-1,c:c+m-1);
        UnCompG(i:i+7,j:j+7) = BlockG;
        BlockB(1:m,1:m) = CompB(r:r+m-1,c:c+m-1);
        UnCompB(i:i+7,j:j+7) = BlockB;
        c=c+m;
        end
    c=1;
    r=r+m;
    end
%getting the inverse DCT
for i = 1:8:Rows
    for j = 1:8:Columns
        idctUnCompR(i:i+7,j:j+7) = blockproc(UnCompR(i:i+7,j:j+7),[8 8],@(block_struct) idct2(block_struct.data));
        idctUnCompG(i:i+7,j:j+7) = blockproc(UnCompG(i:i+7,j:j+7),[8 8],@(block_struct) idct2(block_struct.data));
        idctUnCompB(i:i+7,j:j+7) = blockproc(UnCompB(i:i+7,j:j+7),[8 8],@(block_struct) idct2(block_struct.data));
    end
end
DecompressedImage = cat(3,idctUnCompR,idctUnCompG,idctUnCompB);
filename = sprintf('DecompressedImage %i %s',m,'.bmp');
imwrite(DecompressedImage,filename);
imshow(DecompressedImage);
figure
%calculating MSE for each color channel then calculating the MSE for the
%whole image
MSERed=sum(sum(((int16(RChannel)-int16(idctUnCompR)).^2)))/(Columns*Rows);
MSEGreen=sum(sum(((int16(GChannel)-int16(idctUnCompG)).^2)))/(Columns*Rows);
MSEBlue=sum(sum(((int16(BChannel)-int16(idctUnCompB)).^2)))/(Columns*Rows);
MSE=(MSERed+MSEBlue+MSEGreen)/3;
%calculating PSNR for each m
PSNR=10*log10((255^2)/MSE);
fprintf('The PSNR with m=%d is %d.\n',m,PSNR);
%storing the PSNR and m in their arrays for plot
PSNRValues(m) = PSNR;
mValues(m)= m;
end
plot(mValues,PSNRValues); title('PSNR plot'); ylabel('PSNR'); xlabel('m');  









