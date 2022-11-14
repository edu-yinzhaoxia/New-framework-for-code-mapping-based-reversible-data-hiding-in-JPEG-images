function [pos_next_ac, cat, dc_code] = parse_dc_code(bits_sos, table_huff_dc, pos_dc)
%PARSE_DC parse all the dc code for each DCT block by parsing the
%entropy-coded data. dc code consists of vlc and appended bits.
% len_dc_apd - length of the appended bits of DC coeffcient.
table = table_huff_dc;
num_code = length(table(:,1));
flag = false;
tmp = ones(num_code,1);
pos_next_ac = pos_dc;
idx_code = 3;
while flag ~= true
    tmp = tmp.*(table(:,idx_code) == bits_sos(pos_next_ac));
    if sum(tmp) == 1
        len_dc_code_cur = idx_code - 2;
        if len_dc_code_cur~=table(find(tmp),2)
            pos_next_ac = pos_next_ac + table(find(tmp),2) - len_dc_code_cur;
        end
        cat = table(find(tmp),1);
        flag = true;
        pos_next_ac = pos_next_ac + cat;
    else
        idx_code = idx_code + 1;
    end
    pos_next_ac = pos_next_ac + 1;
end
dc_code = bits_sos(pos_dc:pos_next_ac-1);
end

