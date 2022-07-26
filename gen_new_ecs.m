function jpg_ecs = gen_new_ecs(len_ecs,dc_code,ac_code)
%gen_new_ecs generate the entropy coded data and the eoi.
% preallocate more space to improve the speed.
new_bin_ecs = zeros(len_ecs*1.5,1);    
num_block = size(ac_code);
flag = 1;
for i = 1:num_block
    len_dc = length(dc_code{i, 1});
    new_bin_ecs(flag:flag+len_dc-1) = dc_code{i, 1};
    flag = flag + len_dc;
    [num_zrv,~] = size(ac_code{i,1});
    for j = 1:num_zrv
        len_ac_huff = length(ac_code{i,1}{j,4});
        len_ac_apd = length(ac_code{i,1}{j,5});
        new_bin_ecs(flag:flag+len_ac_huff+len_ac_apd-1) = [ac_code{i,1}{j,4} ac_code{i,1}{j,5}];
        flag = flag + len_ac_huff + len_ac_apd;
    end
end
flag = flag - 1;
new_bin_ecs = new_bin_ecs(1:flag);
num_pad = 8 - mod((flag),8);
if num_pad ~= 8
    new_bin_ecs(flag+1:flag+num_pad) = ones(num_pad,1);
    flag = flag + num_pad;
end
new_bin_ecs = reshape(new_bin_ecs, [8 flag/8]);
new_bin_ecs = new_bin_ecs';
dec_ecs = zeros(flag/8,1);
for i = 1:flag/8
    dec_ecs(i,1) = bin2int(new_bin_ecs(i,:));
end 
ind_ff = find(dec_ecs==255);
m = length(ind_ff);
for i = 1:m
    tmp1 = dec_ecs(1:ind_ff(m-i+1));
    tmp2 = dec_ecs(ind_ff(m-i+1)+1:end);
    dec_ecs = [tmp1;0;tmp2];
end
jpg_ecs = [dec_ecs;255;217];
end

