function dc_table = get_dc_table(seg_huff_dc)
%GEN_HUFF_DC_TABLE parse the DHT segment of DC and obtain huffman table of DC.
num_cat = seg_huff_dc(6:21);    % codeword of DCs for each category.
num_total = sum(num_cat);
code_len = zeros(num_total+1,1);
cat= seg_huff_dc(22:22 + num_total-1,1);
ind = 1;
for i = 1:16
    num_tmp = num_cat(i,1);
    while num_tmp > 0
        num_tmp = num_tmp - 1;
        code_len(ind) = i;
        ind = ind + 1;
    end
end
tmp_code = 0;
tmp_len_code = code_len(1);
dc_code_dec = zeros(num_total,1);
ind = 1;
% The code assignment is followed as Canonical Huffman coding.
while ind <= num_total
    while code_len(ind) == tmp_len_code
        dc_code_dec(ind) = tmp_code;
        ind = ind + 1;
        tmp_code = tmp_code + 1;
    end
    tmp_code = bitshift(tmp_code,1);
    tmp_len_code = tmp_len_code + 1;
end
code_len(end) = [];
code = zeros(num_total,9);
for i = 1 : num_total
    dc_code_bin = dec2bin(dc_code_dec(i),code_len(i));
    for j = 1 : code_len(i)
        code(i,j) = str2double(dc_code_bin(j));
    end
end
dc_table = [cat code_len code];
end

