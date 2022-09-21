function int = bin2int(bin)
%BIN2INT convert binary representation(double vector) to its decimal representation.
% Example bin2int([1 0 0]) returns 4.
n = length(bin);
% idx = diag(2^(diag((n-1:-1:0))));
idx = [128 64 32 16 8 4 2 1];
int = sum(idx(9-n:end).*bin);
end

