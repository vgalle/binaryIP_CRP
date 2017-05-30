## This function is the reverse function of binaryEncodingFunction.jl
## From a binary encoding binaryEncoding described in Galle et al. (2017), it ouputs the corresponding matrix representation Config of size T tiers, S stacks and with C containers

function reverseBinaryEncoding(binaryEncoding,T,S,C)
    Config = zeros(Int16,T,S);
    for s = 1:S
        contInStack = find(binaryEncoding[C+s,:]);
        height = length(contInStack);
        for c = contInStack
            contAbove = length(find(binaryEncoding[c,:]));
            Config[T-height+1+contAbove,s] = c;
        end
    end
    return Config;
end