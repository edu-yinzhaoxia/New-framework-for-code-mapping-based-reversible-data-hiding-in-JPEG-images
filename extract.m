function [name_restored,data,run_time] = extract(name_stego, payload)
t1 = clock;
%% Read JPEG image.
fidorg = fopen(name_stego);
stream_stego = fread(fidorg);
%% Parse the Huffman table (DHT segment, started from FFC4).
[tbl_dc,tbl_ac] = parse_dht(stream_stego,fidorg);
%% Parse the entropy-coded data.
[len_ecs, dc_code, ac_code] = parse_ecs(stream_stego,fidorg,tbl_dc,tbl_ac);
%% Construct the mapping relationship
a = tabulate(tbl_ac(:,3));
mapping_rsv(:,1) = a(find(a(:,2)>1),1);
mapping_rsv(:,2) = a(find(a(:,2)>1),2);
mapping_code = cell(length(mapping_rsv(:,1)),1);
for i=1:length(mapping_rsv(:,1))
    ind = find(mapping_rsv(i,1)==tbl_ac(:,3));
    mapping_code{i} = cell(mapping_rsv(i,2),1);
    for j=1:mapping_rsv(i,2)
        mapping_code{i}{j} = tbl_ac(ind(j),5:5+tbl_ac(ind(j),4)-1);
    end
end
%% Extract secret data.
ptr_data = 0;   % The pointer when scanning the data.
data = zeros(1,payload+8);
num_blocks = size(ac_code);
for i = 1:num_blocks
    [num_zrv,~] = size(ac_code{i,1});
    for j = 1:num_zrv
        cur_rsv = ac_code{i,1}{j, 3};
        ind = find(cur_rsv == mapping_rsv(:,1));
        if ~isempty(ind) && ptr_data < payload 
            len_bit = log2(mapping_rsv(ind,2));  
            for k = 1:mapping_rsv(ind,2)
                if isequal(ac_code{i,1}{j, 4},mapping_code{ind}{k})
                    data(ptr_data+1:ptr_data+len_bit) = int2bin(k-1,len_bit);
                    break;
                end
            end
            ptr_data = ptr_data + len_bit;
        end
        if ptr_data > payload
            break;
        end
    end
    if ptr_data > payload
        break;
    end
end
data = data(1:payload);
%% Restore the VLCs.
freq_rsv = count_rsv(ac_code,tbl_ac);
statistic = unique(freq_rsv(:,2));
freq_rsv_cover = zeros(length(statistic),2);
for i=1:length(statistic)
    ind = find(statistic(i)==freq_rsv(:,2));
    freq_rsv_cover(i,1) = sum(freq_rsv(ind,1));
    freq_rsv_cover(i,2) = statistic(i);
end
freq_rsv_cover = sortrows(freq_rsv_cover, -1);
code_size = cal_code_size(freq_rsv_cover(:,1));
new_tbl_ac = get_opt_huff_table(code_size,freq_rsv_cover(:,2));
rst_ac_code = ac_code;
for i = 1:num_blocks
    [num_zrv,~] = size(ac_code{i,1});
    for j = 1:num_zrv
        ind = find(ac_code{i,1}{j, 3} == new_tbl_ac(:,3));
    	rst_ac_code{i,1}{j, 4} = new_tbl_ac(ind,5:5+new_tbl_ac(ind,4)-1); 
    end   
end
%% Reconstruct the cover JPEG bitstream.
new_header = gen_new_header(stream_stego,new_tbl_ac);
new_ecs = gen_new_ecs(len_ecs,dc_code,rst_ac_code);
stream_restored = [new_header;new_ecs];
name_restored = strcat('restored_',name_stego);
fid = fopen(name_restored, 'w+');
fwrite(fid,stream_restored,'uint8');
%% Extraction and restoration are over.
fclose('all');
t2 = clock;
run_time = etime(t2,t1);
end

