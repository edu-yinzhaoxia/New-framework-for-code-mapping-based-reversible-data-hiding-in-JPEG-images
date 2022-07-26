function P = Crossover( P, r_c, N)
len_ind = length(P{1});    %染色体长度
for i = 1:2:N-3        %最优位保留
    if rand < r_c         %交换标记位 
        pos = randi([1,len_ind]);
        temp = P{i}(1:pos);
      	P{i}(1:pos) = P{i+1}(1:pos);
     	P{i+1}(1:pos) = temp;
    end
end
end

