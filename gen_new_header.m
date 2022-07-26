function jpg_header = gen_new_header(dec_jpg,new_tbl_huff_ac)
%gen_new_header Generate the new JPEG header by replacing the DHT segment.
loc_ff = find(dec_jpg == 255);	% record the positions of FF.
pos_c4 = find(dec_jpg(loc_ff+1,1) == 196);
pos_c4 = pos_c4(end,1);
loc_ac_table = loc_ff(pos_c4,1);
ind_sos = loc_ff(find(dec_jpg(loc_ff+1) == 218),1);  % the position of FFDA
length_sos = dec_jpg((ind_sos+2),1)*16*16 + dec_jpg((ind_sos+3),1);
bf_ac_dht = dec_jpg(1:loc_ac_table-1);
af_ac_dht = dec_jpg(ind_sos:ind_sos+length_sos+1);
ac_dht_bits = dec_jpg(loc_ac_table:loc_ac_table+20);
len_value = length(new_tbl_huff_ac(:,1));
ac_dht_bits(4) = len_value+19;
new_bits = tabulate(new_tbl_huff_ac(:,4));
bits = zeros(16,1);
bits(1:length(new_bits(:,2))) = new_bits(:,2);
ac_dht_bits(6:end) = bits;
ac_dht_value = zeros(len_value,1);
for i = 1:len_value
    ac_dht_value(i) = new_tbl_huff_ac(i,3);
end
jpg_header = [bf_ac_dht;ac_dht_bits;ac_dht_value;af_ac_dht];
end