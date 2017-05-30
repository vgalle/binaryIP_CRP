## This function counts the total number of blocking containers in Config with T tiers, S stacks and C containers.
## A container is blocking when there is at least one container below it with a higher priority (a lower ID).
## LB is a boolean vector of size C s.t. LB[c] = 1 if container c is blocking.

function blockingCount(Config,T,S,C)
    M = binaryEncodingFunction(Config,T,S,C);
    LB = zeros(Int16,C);
    counted = zeros(Int16,C);
    for c = 1:C-1
        for d = c+1:C
            if M[c,d] == 1 && counted[d] == 0
                counted[d] = 1;
                LB[c] = LB[c] + 1;
            end
        end
    end
    return sum(LB);
end
