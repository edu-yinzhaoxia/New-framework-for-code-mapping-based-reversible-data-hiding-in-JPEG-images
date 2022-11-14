function ac_table = get_ac_table(seg_huff_ac)
%GEN_HUFF_AC_TABLE parse the DHT segment of AC and obtain huffman table of AC.
num_cat = seg_huff_ac(6:21);    % codeword of ACs for each category.
num_total = sum(num_cat);
huff_code_size = zeros(num_total+1,1);
huff_val = seg_huff_ac(22:22 + num_total-1,1);
ind = 1;
for i = 1:16
    num_tmp = num_cat(i,1);
    while num_tmp > 0
        num_tmp = num_tmp - 1;
        huff_code_size(ind) = i;
        ind = ind + 1;
    end
end
tmp_code = 0;
tmp_len_code = huff_code_size(1);
ac_code_dec = zeros(num_total,1);
ind = 1;
% The code assignment is followed as Canonical Huffman coding.
while ind <= num_total
    while huff_code_size(ind) == tmp_len_code
        ac_code_dec(ind) = tmp_code;
        ind = ind + 1;
        tmp_code = tmp_code + 1;
    end
    tmp_code = bitshift(tmp_code,1);
    tmp_len_code = tmp_len_code + 1;
end
huff_code_size(end) = [];
code = zeros(num_total,16);
for i = 1:num_total 
    for j = 1:huff_code_size(i)
        code(i,j) = rem(ac_code_dec(i),2);
        ac_code_dec(i) = fix(ac_code_dec(i)/2);
    end
    code(i,1:huff_code_size(i)) = fliplr(code(i,1:huff_code_size(i)));
end
ac_order = [huff_val huff_code_size code];
run = floor(ac_order(:,1)/16);
size = mod(ac_order(:,1),16);
ac_table = [run size huff_val ac_order(:,2:end)];
end