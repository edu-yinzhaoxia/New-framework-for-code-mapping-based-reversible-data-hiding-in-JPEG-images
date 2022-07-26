clear;clc;dbstop if error
addpath(genpath(pwd));
name_cover = 'Baboon_70.jpg';
payload = 10000;
rng('default');
data = round(rand(1,payload)*1);
is_default = 1;
if ~is_default
    % generate the JPEG image s compressed by optimized Huffman table.
    jpg_object = jpeg_read(name_cover);
    jpg_object.optimize_coding = 1;
    name_opt = strcat('opt_',name_cover);
    jpeg_write(jpg_object,name_opt);
    name_cover = name_opt;
end
[name_stego,fi,runtime_embed,opt_solution] = embed(name_cover,data);
% [name_restored,data_extracted,runtime_extract] = extract(name_stego, payload);
% is_extracted = isequal(data,data_extracted);
% if is_extracted
%     fprintf('The secret data is extracted correctly!\n');
% end















