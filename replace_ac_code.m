function code_ac = replace_ac_code(data,tbl_ac, code_ac)
ptr_data = 1;
num_block = size(code_ac);
payload = numel(data);
for i = 1:num_block
    [num_zrv,~] = size(code_ac{i,1});
    for j = 1:num_zrv
        ind = find(code_ac{i,1}{j, 3} == tbl_ac(:,3));
        if numel(ind) > 1
            if ptr_data > payload
                len_code = tbl_ac(ind(1),4);
                code_ac{i,1}{j, 4} = tbl_ac(ind(1), 5:5+len_code-1);
                continue;
            end
            len_bit = log2(numel(ind));
            if ptr_data+len_bit-1 > payload
                data(payload+1:ptr_data+len_bit-1) = zeros(ptr_data+len_bit-1-payload,1);
            end
            cur_bits = data(ptr_data:ptr_data+len_bit-1);
            ind_vlc = ind(bin2int(cur_bits)+1);
            len_code = tbl_ac(ind_vlc,4);
            code_ac{i,1}{j, 4} = tbl_ac(ind_vlc, 5:5+len_code-1);
            ptr_data = ptr_data + len_bit;
        else
            len_code = tbl_ac(ind,4);
            code_ac{i,1}{j, 4} = tbl_ac(ind, 5:5+len_code-1);
        end
    end
end
end

