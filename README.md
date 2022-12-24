# ImageCompressionDCT
Using Discrete Cosine Transform in MATLAB to compress an image by taking the DCT for 8x8 blocks of the image and saving mxm number
of coefficients from the 8x8 block.

Steps for image compression:

1- read image file.

2- splitting the image into its RGB components.

3- Getting DCT for each color channel.

4- Select the number of coefficients based on the value of m.


Steps for decompressing the image:

1- Create 3 arrays of type UINT8 to store the inverse DCT values in
Variables of type unsigned integer of 8 bits because when getting the inverse DCT the value will be from 0~255 which is the peak value for each pixel.

2- Create 3 blocks of zeros of dimensions 8x8.

3- Making 2 for loops going over rows and columns
The for loop goes over rows and columns to get the top [mxm] left square and store it in the block of zeros variable then we store this block in the UINT8 array created this way we make sure that the top left [mxm] DCT coefficients are placed in their place correctly and the rest of the block is zeros. 

4- Applying the Inverse DCT
The same way we applied the DCT we apply the inverse DCT using 2 for loops and the function
‘blockproc’ to apply the inverse DCT to each 8x8 block.
After applying the inverse DCT to each color channel we concatenate the 3 color channels retrieved to form the decompressed image and save the image and view it.


Compare the size of the compressed images and the original image

obtain the PSNR (Peak Signal to Noise Ratio) for each value of m
