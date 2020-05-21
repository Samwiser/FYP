img_y=imread('watermarked.png');

% data extraction algorthim
[img_x,extract_bits]=hist_extract(img_y,max_px,min_px);

error=find(add_bits~=extract_bits);


psnr(double(img_y),double(img_z))
psnr(double(img_x),double(img_z))