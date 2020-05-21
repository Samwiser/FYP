%A Large portion of the code is atributed to FELIX BAlADO who created
%optimum EHS. Thank you.
clearvars;
  close all;

  %% read original image
  im_z=imread(sprintf('%s','./images/stones.png')); 
  im_z_info=imfinfo(sprintf('%s','./images/stones.png'));
   
  n=im_z_info.Width*im_z_info.Height;
imhist(im_z);
  
  im_z=im_z';
  z=double(im_z(:));
  im_z=im_z';
  
  v=[0:2^im_z_info.BitDepth-1]; % handier than v=unique(z) in this problem;
                                % just take into account that some histogram 
                                % bins can be zero
  q=length(v);
  hz=histc(z,v);

  %% histogram equalisation and wartermarking
  
  
  % information bits to be embedded 
  b=(rand(q/2,1)>.5); % we reserve q/2 bins to adjust the histogram change for more bins if required
  Delta=4; % quantisation step for QIM
  hx=zeros(size(hz));
  
  hx(2:2:q)=2*Delta*round((hz(2:2:q)-b*Delta)/(2*Delta))+b*Delta; % watermarked histogram using QIM change value 2 for more bins if required
    
  diff=hx(2:2:q)-hz(2:2:q);
  hx(1:2:q-1)=hz(1:2:q-1)-diff;
    
  % now we need to fix negative values, as they make no sense in a histogram!
  i=(hx<0);
  fix=ceil(abs(hx(i)/Delta))*Delta;
  hx(i)=hx(i)+fix; % fixe
  [~,k]=max(hx(1:2:q-1));
  hx(2*k-1)=hx(2*k-1)-sum(fix); % now we subtract overal fix to maximum
  if hx(2*k-1)<0
      error('fix has failed, try a better way...');
  end
  
  % find xs
  x=[];
  for k=1:q
      x=[x; v(k)*ones(hx(k),1)];
  end
  xs=x;

  %% find closest equalization using minimum distance decoder
  [zs,indexz]=sort(z,'ascend'); % find Πz using stable sorting
  
  y(indexz)=xs; % y=(Πz')xs 
  y=y(:);
  
  hy=histc(y,v);
  im_y=uint8(reshape(y(:),size(im_z,1),size(im_z,2)));
  im_y=im_y';
  
  %for rotation if you want to change rotation change the int and change
  %the im_y in imwrite to rotated
  rotated = imrotate(im_y,-5,'nearest','crop');
  imwrite(im_y,'watermarked.png','png');
  
  %imhist(im_y);
  %% EHS performance
  
  % PSNR
  mse=mean((y(:)-z(:)).^2);
  psnr=10*log10(255^2/mse);
  
  
 
 
    
    

