function P = Mutation( P, r_m, N )
len_ind = length(P{1});
for i = 1:N-1
    if rand < r_m
        pos = randi([1,len_ind]);
        if P{i}(pos) == '1'
            P{i}(pos) = '0';
        elseif P{i}(pos) == '0'
            P{i}(pos) = '1';
        end
    end
end
end

