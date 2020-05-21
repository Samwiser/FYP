close all;
clearvars;

img_z=imread('./images/stones.png');

%creates a string of random bits equal to 
%the length of the peak point of the histogram
[counts,binLocations] = imhist(img_z);
add_bits=randi([0 1],max(counts),1);


    % using only one pair of maximum and minimum point
    [m,n]=size(img_z);
    len_m=length(num2str(m));
    len_n=length(num2str(n));
    
    [counts,binLocations] = imhist(img_z);
    
    [~,max_ind]=max(counts);
    max_px=binLocations(max_ind);
    
    [min_val,min_ind]=min(counts);
    
    
    min_indexes=find(counts==min_val);    
    % find the minimum point that is the closest to the maximum point
    interval=numel(binLocations);% maximum possible index difference
    if numel(min_indexes)~=1
       for i=1:numel(min_indexes) 
           temp=abs(min_indexes(i)-max_ind);
           if(temp<interval)
               interval=temp;
               min_ind=min_indexes(i);
           end
       end
    end
    min_px=binLocations(min_ind);
    
    img_y=img_z;
   
    add_ind=1;
    if(counts(min_ind)~=0)     
        % h(b)~=0
        b_indexes=find(img_z==min_px);
        overhead='';
        for i=1:numel(b_indexes)
            [xi,yi]=ind2sub([m,n],b_indexes(i));
            sxi=num2str(xi);
            syi=num2str(yi);
            while(length(sxi)<len_m) 
                sxi=strcat('0',sxi);
            end
            while(length(syi)<len_m) 
                syi=strcat('0',syi);
            end
            overhead=strcat(overhead,sxi,syi);
        end
        overhead=strcat(overhead,num2str(min_px));
        
        overnum=zeros(numel(overhead),1);
        for i=1:numel(overhead)
            overnum(i)=str2num(overhead(i));
        end
        
    end
    
    % embed additional bits to pixels with value max_px
    % determine the histogram shift direction based on where max point is
    % to minimum point
    if max_px<min_px
        between=(img_y>max_px)&(img_y<min_px);
        img_y(between)=img_y(between)+1;
        for i=1:m*n
            if img_y(i)==max_px
                if add_bits(add_ind)==1
                    img_y(i)=img_y(i)+1;
                end
                add_ind=add_ind+1;
            end
        end
    else
        between=(img_y>min_px)&(img_y<max_px);
        img_y(between)=img_y(between)-1;
        for i=1:m*n
            if img_y(i)==max_px
                if add_bits(add_ind)==1
                    img_y(i)=img_y(i)-1;
                end
                add_ind=add_ind+1;
            end
        end
    end
      
    imwrite(img_y,'watermarked.png','png');
    
