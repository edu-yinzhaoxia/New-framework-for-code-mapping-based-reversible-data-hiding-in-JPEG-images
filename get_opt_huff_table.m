function ac_table = get_opt_huff_table(code_size,huff_val)
%GETOPTHUFFTABLE 此处显示有关此函数的摘要
num_total = numel(huff_val);
tmp_code = 0;
tmp_len_code = code_size(1);
ac_code_dec = zeros(num_total,1);
ind = 1;
% The code assignment is followed as Canonical Huffman coding.
code_size = [code_size;0];
while ind <= num_total
    while code_size(ind) == tmp_len_code
        ac_code_dec(ind) = tmp_code;
        ind = ind + 1;
        tmp_code = tmp_code + 1;
    end
    tmp_code = bitshift(tmp_code,1);
    tmp_len_code = tmp_len_code + 1;
end
code_size(end) = [];
code = zeros(num_total,16);
for i = 1:num_total 
    for j = 1:code_size(i)
        code(i,j) = rem(ac_code_dec(i),2);
        ac_code_dec(i) = fix(ac_code_dec(i)/2);
    end
    code(i,1:code_size(i)) = fliplr(code(i,1:code_size(i)));
end
ac_order = [huff_val code_size code];
run = floor(ac_order(:,1)/16);
size = mod(ac_order(:,1),16);
ac_table = [run size huff_val ac_order(:,2:end)];
end

