function [tbl_dc, tbl_ac] = parse_dht(bits_jpg,fidorg)
loc_ff = find(bits_jpg == 255);	% record the positions of FF.
loc_c4 = find(bits_jpg(loc_ff+1,1) == 196);
if length(loc_c4)>1
    %% parse DC huffman table.
    pos_dc = loc_ff(loc_c4(1,1),1);
    len_dc_data = bits_jpg((pos_dc+2),1)*256 + bits_jpg((pos_dc+3),1);
    status = fseek(fidorg,pos_dc-1,'bof');
    data_dc = fread(fidorg, len_dc_data+2, 'uint8');
    tbl_dc = get_dc_table(data_dc);
    %% parse AC huffman table.
    pos_ac = loc_ff(loc_c4(2,1),1);
    len_ac_data = bits_jpg((pos_ac+2),1)*256 + bits_jpg((pos_ac+3),1);
    status = fseek(fidorg,pos_ac-1,'bof');
    data_ac = fread(fidorg, len_ac_data+2, 'uint8');
    tbl_ac = get_ac_table(data_ac);    
else
    error('The number of Huffman table specifications is smaller than 2!');
end
end
