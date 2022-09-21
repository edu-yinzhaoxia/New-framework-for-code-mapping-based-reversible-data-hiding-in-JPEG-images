function c = gray2dec(a,L)
a = reshape(a,L,[])';
[n,~] = size(a);
for i=1:n
    b(i,1) = a(i,1);
    for j=1:L-1
        m = bin2dec(b(i,j));
        n = bin2dec(a(i,j+1));
        b(i,j+1) = dec2bin(xor(m,n));
    end
end
c = reshape(bin2dec(b),1, []);
end

