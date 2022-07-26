function t = cal_entropy(freq)
p = freq/sum(freq);
t = sum(freq.*-log2(p));
end

