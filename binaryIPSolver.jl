## This function solves the binary integer program introduced in Galle et al. (2017)
## Variables and constraints are introduced in the same order as in the paper
## Post-processing of the solution is after the solve function which calls Gurobi

function binaryIPSolver(binaryEncoding,T,S,C,limitOfTime,memoryLimit,useGap,PreProcessingOn,printSolution,useIncumbent)

## Compute the value N: we only consider the first N-1 retrievals and then count the number of blocking containers.
    N = C-S+1;
## The gap is taken to be 0 is useGap is false, 0.99 otherwise.
    gap = 0.99*useGap;
## We create the Gurobi model with the associated parameters (OutputFlag = 0 indicates that we do not want any output printed)
    m = Model(solver = GurobiSolver(OutputFlag = 0, TimeLimit = limitOfTime, MIPGapAbs = gap));
## Variables a (also defines Constraint (13))
    @variable(m, a[n = 1:N, c = n:C+S, d = n:C], Bin);
## Variables b (also defines Constraint (14))
    @variable(m, b[d = N+1:C], Bin);
## Define the objective as the sum of all relocations to empty the configuration
    @objective(m, Min, sum(a[n,n,d] for n = 1:N-1 for d = n+1:C) + sum(b[d] for d = N+1:C));
## Constraint (1)
    for c = 1:C+S
        for d = 1:C
            @constraint(m, a[1,c,d] == binaryEncoding[c,d]);
        end
    end
## Constraint (2)
    for n = 2:N
        for c = n:C
            @constraint(m, sum(a[n,C+s,c] for s = 1:S) == 1);
        end
    end
## Constraint (3)
    for n = 2:N
        for c = n:C
            @constraint(m, a[n,c,c] == 0);
        end
    end
## Constraint (4)
    for n = 2:N
        for c = n:C
            for d = n:C
                if d != c
                    @constraint(m, a[n,c,d] + a[n,d,c] <= 1);
                end
            end
        end
    end
## Constraint (5) and (6)
    for n = 2:N
        for s = 1:S
            for c = n:C
                for d = n:C
                    if d != c
                        @constraint(m, a[n,c,d] + a[n,d,c] - a[n,C+s,c] - a[n,C+s,d] >= -1);
                        @constraint(m, a[n,c,d] + a[n,d,c] + a[n,C+s,c] + sum(a[n,C+r,d] for r = 1:S if r!=s) <= 2);
                    end
                end
            end
        end
    end
## Constraint (7)
    for n = 2:N
        for s = 1:S
            @constraint(m, sum(a[n,C+s,d] for d = n:C) <= T);
        end
    end
## Constraint (8)
    for d = N+1:C
        for c = N:d-1
            @constraint(m, b[d] - a[N,c,d] >= 0);
        end
    end
## Constraint (9) and (10)
    for n = 1:N-1
        for c = n+1:C
            for d = n+1:C+S
                if d != c
                    @constraint(m, a[n+1,d,c] - a[n,d,c] - a[n,n,c] <= 0);
                    @constraint(m, a[n+1,d,c] - a[n,d,c] + a[n,n,c] >= 0);
                end
            end
        end
    end
## Constraint (11)
    for n = 1:N-1
        for c = n+1:C
            for s = 1:S
                @constraint(m, a[n,n,c] + a[n,C+s,c] + a[n+1,C+s,c] <= 2);
            end
        end
    end
## Constraint (12)
    for n = 1:N-1
        for c = n+1:C
            for d = n+1:C
                if d != c
                    @constraint(m, a[n,n,c] + a[n,n,d] + a[n,c,d] + a[n+1,c,d] <= 3);
                end
            end
        end
    end
## Pre-processing step
    if PreProcessingOn
        firstMove = firstMoveFunction(binaryEncoding,C);
        for c = 1:C
            for n = 2:min(firstMove[c],N)
                for d = n:C+S
                    @constraint(m, a[n,d,c] == binaryEncoding[d,c]);
                end
            end
        end
    end
## Use the upper bound of Caserta et al. (2012) to provide a feasible solution as first incumbent for Gurobi
    if useIncumbent
        (Aincumbent,Bincumbent) = incumbent(binaryEncoding,T,S,C);
        for n = 1:N
            for c = n:C+S
                for d = n:C
                    setvalue(a[n,c,d],Aincumbent[n,c,d]);
                end
            end
        end
        for d = N+1:C
            setvalue(b[d],Bincumbent[d-N]);
        end
    end
## We count the number of variables and contraint
    nVariables = Int64(MathProgBase.numvar(m));
    nConstraints = Int64(MathProgBase.numconstr(m));
## memoryOut is a boolean which is true if the condition to be ``out of memory'' is true.
    memoryOut = (nVariables * nConstraints >= memoryLimit);
## If the condition is not verified, solve the binary IP
    if !memoryOut
        status = solve(m)
## If the IP was solved optimally, we record the optimal value, the solving time and the nodes iterations made by Gurobi
        if status ==:Optimal
            IPSolved = true;
            timeOut = false;
            ObjOpt = Int64(round(getobjectivevalue(m)));
            solveTime = round(getsolvetime(m),3);
            nNodesIter = Int64(round(getnodecount(m)));
## If the option printSolution is true, we print every state after each retrieval for the first N-1 retrievals
            if printSolution
                for n = 1:N
                    println("-------------------------")
                    newBinaryEncoding = zeros(Int64,C+S,C);
                    for c = n:C+S
                        for d = n:C
                            newBinaryEncoding[c,d] = getvalue(a[n,c,d]);
                        end
                    end
                    newConfig = reverseBinaryEncoding(newBinaryEncoding,T,S,C);
                    for t = 1:T
                        for s = 1:S-1
                            print(string(newConfig[t,s],"\t"));
                        end
                        println(string(newConfig[t,S]));
                    end
                    println("-------------------------")
                end
            end
## If the IP was solved not solved optimally
        elseif status ==:UserLimit || status==:NotSolved
            IPSolved = false;
            timeOut = true;
            ObjOpt = NA;
            solveTime = NA;
            nNodesIter = NA;
        end
## If the condition is verified, the IP is not solved and nothing gets recorded.
    else
        IPSolved = false;
        timeOut = false;
        ObjOpt = NA;
        solveTime = NA;
        nNodesIter = NA;
    end
    return (IPSolved, timeOut, memoryOut, ObjOpt, nVariables, nConstraints, solveTime, nNodesIter);
end
