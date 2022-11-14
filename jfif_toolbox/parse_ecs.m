function [len_ecs,dc_code,ac_code] = parse_ecs(dec_jpg,fidorg,tbl_dc,tbl_ac)
% GET_ECS - get the entropy-coded data (from FFDA to FFD9(EOI)).
% data_ecs - the entropy-coded data.
loc_ff = find(dec_jpg == 255);	% record the positions of FF.
ind_sos = find(dec_jpg(loc_ff+1) == 218);
ind_sos = loc_ff(ind_sos,1);  % the position of FFDA
length_sos = dec_jpg((ind_sos+2),1)*16*16 + dec_jpg((ind_sos+3),1);
ind_eoi = find(dec_jpg(loc_ff+1)==217);
length_ecs = loc_ff(ind_eoi,1) - ind_sos - length_sos - 2;
status = fseek(fidorg, ind_sos + length_sos + 1,'bof');
data_ecs = fread(fidorg, length_ecs, 'uint8');
ind_ff = find(data_ecs==255);
num_ff = length(ind_ff);
i=0;
for j=1:num_ff
    data_ecs(ind_ff(j,1)+1-i)=[];
    i=i+1;
end
bin_ecs = int2bin(data_ecs,8);
[m,n] = size(bin_ecs);
bin_ecs = reshape(bin_ecs.',[1 m*n]);
flag = 1;
num_block = get_num_block(dec_jpg);
dc_app_len = zeros(num_block,1);
dc_code = cell(num_block,1);  % dc_code includes huffman bits and appended bits.
ac_code = cell(num_block,1);  % ac_code includes huffman bits and appended bits.
dc_pos = ones(num_block+1,1); % dc_pos includes the position of dc_code.
ac_pos = ones(num_block+1,1); % ac_pos includes the position of ac_code.
while flag <= num_block
    [ac_pos(flag),dc_app_len(flag,1),dc_code{flag}] = parse_dc_code(bin_ecs, tbl_dc, dc_pos(flag));
    [dc_pos(flag+1), ac_code{flag}] = parse_ac_code(bin_ecs, tbl_ac, ac_pos(flag));
    flag = flag + 1;
end
len_ecs = length(bin_ecs);
end

