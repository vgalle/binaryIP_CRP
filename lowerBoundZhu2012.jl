## This function computes the lower bound from Zhu et al. (2012) in Config with T tiers, S stacks and C containers (for details of the computation see Zhu et al. (2012))
## LBf is a boolean vector of size C s.t. LBf[c] = 1 if container c cannot avoid a ``bad'' relocation.

function lowerBoundZhu2012(Config,T,S,C)
    B = zeros(Int16,T,S)
    for t = 1:T
        for s = 1:S
            B[t,s] = Config[t,s];
        end
    end
    height = zeros(Int16,S);
    LBf = zeros(Int16,C);
    minVector = (C+1).*ones(Int16,S);
    for s = 1:S
        height[s] = sum(B[:,s].!=0);
        if height[s] != 0
            minVector[s] = minimum(B[T-height[s]+1:T,s]);
        end
    end
    for n = 1:C-S
        Listindex = find(B.==n)
        if length(Listindex) > 0
            index = Listindex[1];
            targetStack = Int16(ceil(index/T));
            targetTier = Int16(index - T*(targetStack-1));
            while targetTier > T - height[targetStack] + 1
                r = B[T-height[targetStack]+1,targetStack];
                goodMove = false;
                for s = 1:S
                    if s != targetStack && height[s] < T && minVector[s] > r
                        goodMove = true;
                    end
                end
                if !goodMove
                    LBf[n] = LBf[n] + 1;
                end
                B[T-height[targetStack]+1,targetStack] = 0;
                height[targetStack] = height[targetStack] - 1;
            end
            B[targetTier,targetStack] = 0;
            height[targetStack] = height[targetStack] - 1;
            if height[targetStack] != 0
                minVector[targetStack] = minimum(B[T-height[targetStack]+1:T,targetStack]);
            else
                minVector[targetStack] = C + 1;
            end
        end
    end
    return sum(LBf);
end