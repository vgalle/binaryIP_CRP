## This function creates the binary encoding described in Galle et al. (2017)
## The input is the matrix representations of a configuration named Config of size T tiers, S stacks and with C containers

function binaryEncodingFunction(Config,T,S,C)
    R = C+S;
    binaryEncoding = zeros(Int16,R,C);
    for s = 1:S
        for t = 1:T
            if Config[t,s] != 0
                c = Config[t,s];
                for u = t+1:T
                    d = Config[u,s];
                    binaryEncoding[d,c] = 1;
                end
                binaryEncoding[s+C,c] = 1;
            end
        end
    end
    return binaryEncoding;
end