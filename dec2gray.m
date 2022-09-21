function c = dec2gray(a,L)
%DEC2GRAY Transform decimal into gray codes
[~,n] = size(a);
b = dec2bin(a,L);
for i=1:n
    c(i,1) = b(i,1);
    for j=1:L-1  
        m = bin2dec(b(i,j));
        n = bin2dec(b(i,j+1));
        c(i,j+1) = dec2bin(xor(m,n));
    end
end
c = reshape(c',1,[]);
end

