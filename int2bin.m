function b = int2bin(x,n)
%INT2BIN convert decimal representation to its binary representation (double vector).
% Example int2bin(4) returns [1 0 0].
if nargin == 2 % the number of variable
    if max(x) >= 2^n
        error('x must be smaller than 2^n')
    end
elseif nargin==1
    n = max(floor(log2(abs(x)))+1);
end
b = [];
x = abs(x); % work on magnitude only from now on.
idx = diag(2^(diag((n-1:-1:0))));
for j=1:n
    tmp = x - sign(x)*idx(j).*[x~=0];
    % if x > 0, tmp = x - 2^(n-j), if x < 0, tmp=x+2^(n-j)
    b= [b [tmp >= 0].*[x~=0]];
    x=tmp;
end
end
