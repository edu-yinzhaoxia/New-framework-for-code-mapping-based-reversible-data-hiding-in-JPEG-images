function opt_solution = GA(freq_rsv, payload,r_c,r_m)
%% Paramater setting
G = 50;    %种群的代数
N = 200;    %种群的规模
% r_c = 0.8;   %交叉率
% r_m = 0.3;   %变异率
L = 2;  %每个RS可分配的未使用VLC个数种类（1，2，4，8）
%% Reduce solution size
N_used = 10;
freq = freq_rsv(:,1);
ind = find(freq>=payload);
if isempty(ind)
    fst_pos = 1; % first position of RSV
else
    fst_pos = ind(end);
end
if numel(freq)-fst_pos>=N_used
    n_max = N_used;%最大映射集合数目
else
    n_max = numel(freq)-fst_pos+1;
end
%% Initial
P = cell(N,1);
rng('shuffle');
for i=1:N
    P{i} = char((rand(1,n_max*L)>0.5)+'0');
end
%最优适应度初值 存储每代的最优适应度 最小文件膨胀量存储 每代的最小文件膨胀量
[list_fit,list_E,list_elite] = deal(zeros(G,1),zeros(G,1),cell(G,1));
%% 进化迭代
for i = 1:G
    %% 计算适应度
    [fits, prob, E] = Fitness(P, freq, fst_pos, payload, n_max, L);
    q = cumsum(prob);   %累加概率
    [max_fit, ind] = max(fits);  %求当代最佳个体
    p_elite = P{ind};    %到目前为止最佳位串
    list_E(i) = E(ind); % 存储每代的最优膨胀值
    list_fit(i) = max_fit;	% 存储每代的最优适应度
    list_elite{i} = p_elite;
    P{N} = p_elite; %最优保留(精英主义选择)
    %% 轮盘赌选择
    P = Select(P, N, q);
    %% 交叉
    P = Crossover(P, r_c, N);
    %% 变异
    P = Mutation(P, r_m, N);
end
% plot(list_E)%最小文件膨胀进化曲线
[~,ind] = min(list_E);
opt_solution = zeros(1,numel(freq));
opt_solution(fst_pos:fst_pos+n_max-1) = bin2ints(list_elite{ind}, L);

end
