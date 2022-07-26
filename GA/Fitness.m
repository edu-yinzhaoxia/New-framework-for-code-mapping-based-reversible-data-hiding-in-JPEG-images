function [fits,prob,E] = Fitness(P, freq, fst_pos, payload, n_max,L)
N = length(P);   % polulation size
[E,fits] = deal(zeros(N,1));
for i=1:N
    n_codes = bin2ints(P{i},L);
    sum_codes = sum(2.^n_codes);
    capacity = sum(freq(fst_pos:fst_pos+n_max-1).*n_codes');
    if capacity>=payload && sum_codes<=256
        tmp_freq = freq;
        for j=1:n_max
            if n_codes(j)
                cur_freq = tmp_freq(fst_pos+j-1)/(2^n_codes(j));
                tmp_freq(fst_pos+j-1) = cur_freq;
                tmp_freq = [tmp_freq;ones(2^n_codes(j)-1,1)*cur_freq];
            end
        end
        tmp_freq = sort(tmp_freq,'descend');
        E(i) = cal_entropy(tmp_freq)+sum_codes*8;
    else
        E(i) = 0;
    end
end
E_max = max(E);
for i=1:N
    if E(i)~=0
        fits(i) = E_max - E(i);
    end
end
prob = fits./sum(fits);
end