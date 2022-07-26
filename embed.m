function [name_stego,fi,run_time,opt_solution] = embed(name_cover,data)
t1 = clock;
%% Read JPEG image.
fidorg = fopen(name_cover);
stream_cover = fread(fidorg);
%% Parse the Huffman table (DHT segment, started from FFC4).
[tbl_dc,tbl_ac] = parse_dht(stream_cover,fidorg);
%% Parse the entropy-coded data.
[len_ecs, code_dc, code_ac] = parse_ecs(stream_cover,fidorg,tbl_dc,tbl_ac);
%% Constrcut the VLC Mapping Relationship according to frequencies and payload
freq_rsv = count_rsv(code_ac,tbl_ac);
[new_tbl_ac,opt_solution] = construct_code_mapping(freq_rsv,data);
%% Embed data by replacing ac huff code using the new huff table.
new_code_ac = replace_ac_code(data,new_tbl_ac,code_ac);
%% Generate the stego JPEG bitstream.
new_header = gen_new_header(stream_cover,new_tbl_ac);
new_ecs = gen_new_ecs(len_ecs,code_dc,new_code_ac);
stream_stego = [new_header;new_ecs];
name_stego = strcat('stego_',name_cover);
fid = fopen(name_stego, 'w+');
fwrite(fid,stream_stego,'uint8');
%% Embedding is over.
fi = (length(stream_stego) - length(stream_cover))*8;
fclose('all');
t2 = clock;
run_time = etime(t2,t1);
end
