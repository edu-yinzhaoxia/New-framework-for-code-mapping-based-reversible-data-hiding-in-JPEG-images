function new_P = Select(P,N,q)
new_P = P;
for i = 1:N-1
	r = rand;
	tmp = find(r <= q);
    new_P{i} = P{tmp(1)};
end
end