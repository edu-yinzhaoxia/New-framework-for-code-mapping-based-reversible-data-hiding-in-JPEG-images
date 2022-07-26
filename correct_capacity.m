function solution = correct_capacity(solution,freq,payload)
capacity = sum(freq.*solution');
% fprintf("capacity:%d\n",capacity);
for i=length(freq):-1:1
    if solution(i)~=0
        capacity = capacity - solution(i)*freq(i);
%         fprintf("capacity:%d,i=%d\n",capacity,i); 
        if capacity>=payload
            solution(i) = 0;
            continue;
        else
            capacity = capacity + solution(i)*freq(i);
            break;
        end
    end
end
% fprintf("final capacity:%d\n",capacity);
end


