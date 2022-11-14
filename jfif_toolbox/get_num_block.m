function num_block = get_num_block(dec_jpg)
%GET_IMG_SIZE get the JPEG image size by parsing the SOF0 (Start of Frame)
%segment, which begins with FFC2.
loc_ff = find(dec_jpg == 255);	% record the positions of FF.
a = find(dec_jpg(loc_ff+1,1)==192);
b = loc_ff(a,1);
height = dec_jpg((b+5),1)*16*16 + dec_jpg((b+6),1);
width = dec_jpg((b+7),1)*16*16 + dec_jpg((b+8),1);
num_block = ceil(height * width/64);
end