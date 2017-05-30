
## This sub routine is the function used to perform the experiment with the inputs defined in main.jl by the user

function subRoutine(outputFolder, T_2, S, limitOfTime, memoryLimit, useGap, useIncumbent, PreProcessingOn, printSolution)

## Number of instances in each class
    nInstances = 40;
## Define the data structure to save the results for the experiments. The attributes are:
## Blocking: the number of blocking containers
## Lower_Bound: a lower bound computed from Zhu et al. (2012)
## Upper_Bound: an upper bound coming from a feasible solution from Caserta et al. (2012)
## Gap: difference between Upper_Bound and Lower_Bound
## Trivial_Instance: if Gap = 0, the problem is trivial and the binary IP does not need to be solved
## Opt_Solved: if true and Trivial_Instance is false, means that the binary IP has been solved optimally with the given inputs (time and memory limits)
## Timed_out: if true and Trivial_Instance is false, means the binary IP could not been solved optimally and reached the time limit
## Memory_Out: if true and Trivial_Instance is false, means the binary IP could not been solved optimally and reached the memory limit
##### Only available if Opt_Solved is true or Trivial_Instance is true
## Opt_Value: the optimal value (minimum number of relocations).
##### Only available if Opt_Solved is true
## Num_Variables: the number of variables in the binary IP
## Num_Constraints: the number of constraints in the binary IP
## Solving_Time: the time it took Gurobi to solve the binary IP
## Nodes_Iterations: the number of nodes iterations made by Gurobi to solve the IP
## UB_Opt: true if the upper bound is optimal
    df = DataFrame(Instance = ["Average";collect(1:nInstances)], Blocking = Vector{Float64}(nInstances+1), Lower_Bound = Vector{Float64}(nInstances+1), Upper_Bound = Vector{Float64}(nInstances+1), Gap = Vector{Float64}(nInstances+1), Trivial_Instance = Vector{Any}(nInstances+1), Opt_Solved = Vector{Any}(nInstances+1), Timed_Out = Vector{Any}(nInstances+1), Memory_Out = Vector{Any}(nInstances+1), Opt_Value = Vector{Float64}(nInstances+1), Num_Variables = Vector{Float64}(nInstances+1), Num_Constraints = Vector{Float64}(nInstances+1), Solving_Time = Vector{Float64}(nInstances+1), Nodes_Iterations = Vector{Float64}(nInstances+1), UB_Opt = Vector{Any}(nInstances+1));
## Declare the first line (the average of each attribute) and initialize it to 0
    df[1, filter(x -> x != :Instance, names(df))] = 0;
## Define the number of tiers
    T = T_2 +2;
## Loop for all instances in the class given T_2 and S
    for instanceID = 1:nInstances
        println("T' = ", T_2, " , S = ", S, " , inst = ", instanceID);
## Read the input file and set the initial configuration of the problem
        Config = readInstanceCaserta(T_2,S,instanceID);
## Compute C, the number of containers in the configuration
        C = sum(Config.!=0);
## Compute the number of blocking containers and compute the average number of blocking containers for this class
        df[:Blocking][instanceID+1] = blockingCount(Config,T,S,C);
        df[:Blocking][1] = df[:Blocking][1] + df[:Blocking][instanceID+1]/nInstances;
## Compute the lower bound from Zhu et al. (2012) and the average lower bound for this class
        df[:Lower_Bound][instanceID+1] = df[:Blocking][instanceID+1] + lowerBoundZhu2012(Config,T,S,C);
        df[:Lower_Bound][1] = df[:Lower_Bound][1] + df[:Lower_Bound][instanceID+1]/nInstances;
## Compute the upper bound from Caserta et al. (2012) and the average upper bound for this cass
        df[:Upper_Bound][instanceID+1] = upperBoundCaserta2012(Config,T,S,C);
        df[:Upper_Bound][1] = df[:Upper_Bound][1] + df[:Upper_Bound][instanceID+1]/nInstances;
## Compute the gap between the upper and lower bound and its average
        df[:Gap][instanceID+1] = df[:Upper_Bound][instanceID+1] - df[:Lower_Bound][instanceID+1];
        df[:Gap][1] = df[:Gap][1] + df[:Gap][instanceID+1]/nInstances;
## Determine if instance is trivial (gap is null) and count the total number of trivial instances in this class
        df[:Trivial_Instance][instanceID+1] = (df[:Gap][instanceID+1] == 0);
        df[:Trivial_Instance][1] = df[:Trivial_Instance][1] + df[:Trivial_Instance][instanceID+1];
## If this instance is not trivial
        if !df[:Trivial_Instance][instanceID+1]
## Create the binary encoding for the binary integer program
            binaryEncoding = binaryEncodingFunction(Config,T,S,C);
## Solve the integer program
            (df[:Opt_Solved][instanceID+1], df[:Timed_Out][instanceID+1], df[:Memory_Out][instanceID+1], df[:Opt_Value][instanceID+1], df[:Num_Variables][instanceID+1], df[:Num_Constraints][instanceID+1], df[:Solving_Time][instanceID+1], df[:Nodes_Iterations][instanceID+1]) = binaryIPSolver(binaryEncoding,T,S,C,limitOfTime,memoryLimit,useGap,PreProcessingOn,printSolution,useIncumbent);
## Count if the instance was solved optimally, if it timed out or went out of memory (product of number of variables and constraints greater than memory Limit) and the number of variables and contraints
            df[:Opt_Solved][1] = df[:Opt_Solved][1] + df[:Opt_Solved][instanceID+1];
            df[:Timed_Out][1] = df[:Timed_Out][1]+ df[:Timed_Out][instanceID+1];
            df[:Memory_Out][1] = df[:Memory_Out][1] + df[:Memory_Out][instanceID+1];
            df[:Num_Variables][1] = df[:Num_Variables][1] + df[:Num_Variables][instanceID+1];
            df[:Num_Constraints][1] = df[:Num_Constraints][1] + df[:Num_Constraints][instanceID+1];
## If the instance was solved optimally, we compute the average of available columns, i.e., optimal value, the solving time, the number of nodes iterations, and check if the upper bound was optimal or not
            if df[:Opt_Solved][instanceID+1]
                df[:Opt_Value][1] = df[:Opt_Value][1] + df[:Opt_Value][instanceID+1];
                df[:Solving_Time][1] = df[:Solving_Time][1] + df[:Solving_Time][instanceID+1];
                df[:Nodes_Iterations][1] = df[:Nodes_Iterations][1] + df[:Nodes_Iterations][instanceID+1];
                df[:UB_Opt][instanceID+1] = (df[:Opt_Value][instanceID+1] == df[:Upper_Bound][instanceID+1]);
                df[:UB_Opt][1] = df[:UB_Opt][1] + df[:UB_Opt][instanceID+1];
## If the instance was not solved optimally, we do not compute averages and we cannot determine if the upper bound was optimal (hence left as false by default)
            else
                df[:UB_Opt][instanceID+1] = false;
            end
## If this instance is trivial, the upper bound is optimal
        else
            df[:Opt_Solved][instanceID+1] = NA;
            df[:Timed_Out][instanceID+1] = NA;
            df[:Memory_Out][instanceID+1] = NA;
            df[:Opt_Value][instanceID+1] = df[:Upper_Bound][instanceID+1];
            df[:Opt_Value][1] = df[:Opt_Value][1] + df[:Opt_Value][instanceID+1];
            df[:Num_Variables][instanceID+1] = NA;
            df[:Num_Constraints][instanceID+1] = NA;
            df[:Solving_Time][instanceID+1] = NA;
            df[:Nodes_Iterations][instanceID+1] = NA;
            df[:UB_Opt][instanceID+1] = true;
            df[:UB_Opt][1] = df[:UB_Opt][1] + 1;
        end
    end
## When done with all the isntances in the class, compute the average optimal value over all the instances trivial and solved optimally (if there are some)
    if df[:Trivial_Instance][1] + df[:Opt_Solved][1] > 0
        df[:Opt_Value][1] = df[:Opt_Value][1]/(df[:Trivial_Instance][1] + df[:Opt_Solved][1]);
    else
        df[:Opt_Value][1] = NA;
    end
    if df[:Trivial_Instance][1] < nInstances
        df[:Num_Variables][1] = df[:Num_Variables][1]/(nInstances - df[:Trivial_Instance][1]);
        df[:Num_Constraints][1] = df[:Num_Constraints][1]/(nInstances - df[:Trivial_Instance][1]);
    end
    if df[:Opt_Solved][1] > 0
        df[:Solving_Time][1] = df[:Solving_Time][1]/df[:Opt_Solved][1];
        df[:Nodes_Iterations][1] = df[:Nodes_Iterations][1]/df[:Opt_Solved][1];
    else
        df[:Solving_Time][1] = NA;
        df[:Nodes_Iterations][1] = NA;
    end
## The name of the output file if T_2-S_Results.csv and is placed in the output folder. It is a csv file with headers.
    outputFileName = string(outputFolder,T_2, "-", S,"_Results.csv");
    writetable(outputFileName, df, separator = ',', header = true);

end
