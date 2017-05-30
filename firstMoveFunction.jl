## This function computes the first retrieval where each container is moved (either relocated or retrieved)
## firstMove[c] is the first target container for which container c is moved

function firstMoveFunction(binaryEncoding,C);
    firstMove = zeros(Int16,C);
    for c = 1:C
        n = 1;
        reloc = 0;
        while reloc == 0
            if n == c || binaryEncoding[n,c] == 1
                reloc = n;
            end
            n = n + 1;
        end
        firstMove[c] = reloc;
    end
    return firstMove;
end