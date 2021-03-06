function [img_x,add_bits]=hist_extract(img_y,max_px,min_px)
    N=numel(img_y);
    add_bits=zeros(N,1);
    add_ind=1;
    
    
    
    img_x=img_y;
    
    % determine the histogram reverse shift direction like in embed
    % function
    if max_px<min_px
        for i=1:N
            if img_y(i)==max_px+1
                add_bits(add_ind)=1;
                add_ind=add_ind+1;
            else if img_y(i)==max_px
                    add_ind=add_ind+1;
                end
            end
        end
        between=(img_x>max_px)&(img_x<=min_px);
        img_x(between)=img_x(between)-1;
    else
        for i=1:N
            if img_y(i)==max_px-1
                add_bits(add_ind)=1;
                add_ind=add_ind+1;
            else if img_y(i)==max_px
                    add_ind=add_ind+1;
                end
            end
        end
        between=(img_x>=min_px)&(img_x<max_px);
        img_x(between)=img_x(between)+1;
    end
    
    add_bits=add_bits(1:add_ind-1);
    
    
end