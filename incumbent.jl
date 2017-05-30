## This function is the analog of upperBoundCaserta2012.
## However here, the ouput is not the number of relocation but the associated decision variable of the heuristic Aincumbent and Bincumbent

function incumbent(binaryEncoding,T,S,C)
    Config = reverseBinaryEncoding(binaryEncoding,T,S,C);
    N = C-S+1;
    Aincumbent = zeros(Int16,N,C+S,C);
    Bincumbent = zeros(Int16,C-N);
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
    Aincumbent[1,:,:] = binaryEncodingFunction(B,T,S,C);
    for n = 1:N-1
        index = find(B.==n)[1];
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
        Aincumbent[n+1,:,:] = binaryEncodingFunction(B,T,S,C);
    end
    for d = N+1:C
        for c = N:d-1
            if Aincumbent[N,c,d] == 1
                Bincumbent[d-N] = 1;
            end
        end
    end
    return (Aincumbent,Bincumbent);
end
