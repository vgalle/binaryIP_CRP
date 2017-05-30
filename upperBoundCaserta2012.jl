## This function computes the upper bound from Caserta et al. (2012) in Config with T tiers, S stacks and C containers (for details of the computation see Caserta et al. (2012))
## nReloc is the total number of relocation performed by the heuristic also known as minmax heuristic.

function upperBoundCaserta2012(Config,T,S,C)
    nReloc = 0;
    B = zeros(Int16,T,S)
    for t = 1:T
        for s = 1:S
            B[t,s] = Config[t,s];
        end
    end
    height = zeros(Int16,S);
    minVector = (C+1).*ones(Int16,S);
    for s = 1:S
        height[s] = sum(B[:,s].!=0);
        if height[s] != 0
            minVector[s] = minimum(B[T-height[s]+1:T,s]);
        end
    end
    for n = 1:C
        index = find(B.==n)[1];
        targetStack = Int16(ceil(index/T));
        targetTier = Int16(index - T*(targetStack-1));
        while targetTier > T - height[targetStack] + 1
            nReloc = nReloc + 1;
            r = B[T-height[targetStack]+1,targetStack];
            goodMove = false;
            for s = 1:S
                if s != targetStack && height[s] < T && minVector[s] > r
                    goodMove = true;
                end
            end
            destinationStack = 0;
            if goodMove
                for s = 1:S
                    if s != targetStack && height[s] < T && minVector[s] > r && (destinationStack == 0 || minVector[s] < minVector[destinationStack])
                        destinationStack = s;
                    end
                end
            else
                for s = 1:S
                    if s != targetStack && height[s] < T && (destinationStack == 0 || minVector[s] > minVector[destinationStack])
                        destinationStack = s;
                    end
                end
            end
            B[T-height[targetStack]+1,targetStack] = 0;
            height[targetStack] = height[targetStack] - 1;
            B[T-height[destinationStack],destinationStack] = r;
            height[destinationStack] = height[destinationStack] + 1;
            minVector[destinationStack] = minimum(B[T-height[destinationStack]+1:T,destinationStack]);
        end
        B[targetTier,targetStack] = 0;
        height[targetStack] = height[targetStack] - 1;
        if height[targetStack] != 0
            minVector[targetStack] = minimum(B[T-height[targetStack]+1:T,targetStack]);
        else
            minVector[targetStack] = C + 1;
        end
    end
    return nReloc;
end
