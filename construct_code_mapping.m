function [new_tbl_ac,opt_solution] = construct_code_mapping(freq_rsv,data)
%% Constrcut the VLC Mapping Relationship according to frequencies and payload
% Count the RSVs according to the corresponding ac huffman table.
freq_rsv = freq_rsv(freq_rsv(:,1)>0,:); % for default Huffman table.
% Solver: Genetic Algorithm.
payload = numel(data);
r_c = 0.8;
r_m = 0.3;
opt_solution = GA(freq_rsv, payload,r_c,r_m);
% opt_solution = correct_capacity(opt_solution,freq_rsv(:,1),payload);
new_freq_rsv = freq_rsv;
for i=1:numel(opt_solution)
    if opt_solution(i)
        curFreq = new_freq_rsv(i,1)/(2^opt_solution(i));
        new_freq_rsv(i,1) = curFreq;
        new_freq_rsv = [new_freq_rsv;repmat(new_freq_rsv(i,:),2^opt_solution(i)-1,1)];
    end
end
new_freq_rsv = sortrows(new_freq_rsv, -1);
code_size = cal_code_size(new_freq_rsv(:,1));
new_tbl_ac = get_opt_huff_table(code_size,new_freq_rsv(:,2));
end

