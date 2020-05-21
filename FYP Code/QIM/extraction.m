im_q=imread(sprintf('%s','watermarked.png'));
yy=double(im_q(:));
  hyy=histc(yy,v);
imhist(im_q);
  % watermark information recovery just requires quantising hyy (sample by sample) to the two possible lattices and seeing which one give smaller error

  hh=hyy(2:2:q); % take only the samples that carry bits of information
  hh=repmat(hh',2,1);
  bt=[zeros(1,q/2);ones(1,q/2)];
  e=hh-(2*Delta.*round((hh-bt.*Delta)./(2*Delta))+bt.*Delta);
  [kk i]=min(e.^2,[],1);
  bb=i-1;
  bb=bb';
  
  if sum(bb~=b)==0
      fprintf('%i bits recovered with no errors\n',q/2);
      fprintf('%f\n',mean(bb~=b));
  else
      fprintf('Decoding errors: bit error rate=%f\n',mean(bb~=b));
  end