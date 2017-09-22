## IMPORTANT: The current directory should be the one containing main.jl
## in which the subfolder CRPTestcases_Caserta/ should be in to access the instances
## and the output folder is created if it does not exists.
## It is required to have Gurobi solver installed with a valid license as well as packages JuMP, Gurobi, DataFrames installed in Julia

###################################################################################
################################### CHANGE HERE ###################################
###################################################################################
## SET THE NAME OF YOUR OUTPUT FOLDER
outputFolder = "Results/";

## SET THE INPUTS FOR YOUR EXPERIMENTS
T_2 = 3; ## Number of containers per stack in the instances from Caserta et al. (2009)

S = 3; ## Number of stacks

limitOfTime = 3600; ## Time limit given to Gurobi to solve one instance

memoryLimit = 8*10^10; ## Memory limit defined as a bound on the product of the number of variables and constraints of the binary IP CRP-I

useGap = true; ## If true then the absolute gap is set to 0.99 for the IP, 0 otherwise

useIncumbent = true; ## if true, provide the upper bound as incumbent to the solver

PreProcessingOn = true; ## If true, adds constraints to set some variables to zeros

printSolution = false; ## If true, can set the sequence of relocations for each instance

###################################################################################
######################## DO NOT CHANGE ANY CODE FROM THERE ########################
###################################################################################
## Load the three main packages for this program
using JuMP, Gurobi, DataFrames
## Create path for outputs
if !ispath(outputFolder)
    mkpath(outputFolder);
end
## Load all auxilary functions
include("readInstanceCaserta.jl"); ## function to read input files
include("blockingCount.jl"); ## function to compute the number of blocking containers
include("lowerBoundZhu2012.jl"); ## function to compute the lower bound from Zhu et al. (2012)
include("upperBoundCaserta2012.jl"); ## function to compute the feasible solution providing an upper bound from Caserta et al. (2012)
include("binaryEncodingFunction.jl"); ## function to compute the binary encoding of a configuration as explained in Galle et al. (2017)
include("reverseBinaryEncoding.jl"); ## function to reverse previous operator
include("firstMoveFunction.jl"); ## function to compute the first retrieval where each container is moved
include("incumbent.jl"); ## function to create incumbent for binary IP using same heuristic as Caserta et al. (2012)
include("binaryIPSolver.jl"); ## function to solve the binary IP formulation
include("LPSolver.jl"); ## function to solve the linear relaxation of the binary IP
## Load the sub routine function to perform the experiment with the inputs defined above by the user
include("subRoutine.jl");
subRoutine(outputFolder, T_2, S, limitOfTime, memoryLimit, useGap, useIncumbent, PreProcessingOn, printSolution);
