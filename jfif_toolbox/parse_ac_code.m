function [pos_next_dc, ac_code] = parse_ac_code(bits_sos, table_huff_ac, pos_dc)
%PARSE_AC parse all the ac code for each DCT block by parsing the
%entropy-coded data. ac code consists of vlc and appended bits.
table = table_huff_ac;
num_code = length(table(:,1));
idx_code = 5;
flag = false;
num_ac = 0;
num_zrv = 1;
pos_next_dc = pos_dc;
tmp = ones(num_code,1); 
ac_code = cell(63,5);
while flag == false && num_ac < 63
    tmp = tmp.*(table(:,idx_code) == bits_sos(pos_next_dc));
    if sum(tmp) == 1  
        len_vlc_cur = idx_code - 5 + 1;
        idx_code = 5;   % reset the pointer.
        row = find(tmp);
        tmp = ones(num_code,1); % reset the temp vector.
        run = table(row, 1); 
        cat = table(row, 2);
        len_vlc = table(row, 4);    
        if len_vlc~=len_vlc_cur
            pos_next_dc = pos_next_dc + len_vlc - len_vlc_cur;
        end
        ac_vlc = table(row,5:5+len_vlc-1);
        ac_code{num_zrv,1} = row;
        ac_code{num_zrv,2} = [run,cat];
        ac_code{num_zrv,3} = run * 16 + cat;
        ac_code{num_zrv,4} = ac_vlc;
        ac_code{num_zrv,5} = bits_sos(pos_next_dc + 1 : pos_next_dc + cat);
        num_zrv = num_zrv + 1;
        if run == 15 && cat == 0
            num_ac = num_ac + 16;
        elseif run == 0 && cat == 0
            flag = true;
        else
            num_ac = num_ac + 1 + run;
        end
        pos_next_dc = pos_next_dc + cat;
    else
        idx_code = idx_code + 1;
    end
    pos_next_dc = pos_next_dc + 1;
end
ac_code = ac_code(1:num_zrv-1,:);
end

