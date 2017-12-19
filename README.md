# binaryIP_CRP

[![DOI](https://zenodo.org/badge/91832914.svg)](https://zenodo.org/badge/latestdoi/91832914)

This directory contains the computational results from *A new binary integer program for the restricted container relocation problem, Galle et al. (2017)*. These experiments show the efficiency of the binary integer program CRP-I proposed in this paper. The purpose of this repository is to be able to reproduce the experiments made in this paper, check their truthfulness and potentially use the code in further studies. If you have any question please email [Virgile Galle](vgalle@mit.edu).

## Benchmark of 840 instances

Instances were taken from previous studies are in the subfolder CRPTestcases_Caserta/. This dataset has 21 classes with 40 instances in each class for a total of 840 instances. A class is defined by the pair (T',S) where T' is the number of containers per stack and S is the number of stack. The classes are the following: (3,3), (3,4), (3,5), (3,6), (3,7), (3,8), (4,4), (4,5), (4,6), (4,7), (5,4), (5,5), (5,6), (5,7), (5,8), (5,9), (5,10), (6,6), (6,10), (10,6) and (10,10).

## Run CRP-I on one class of the benchmark

In order to run CRP-I on the 40 instances of a given instances, first make sure that *[Julia](https://julialang.org) (at least version 0.5.0)* is installed as well as *[Gurobi solver](http://www.gurobi.com) (at least version 7.0.1)* with a valid license. Moreover, make sure that packages *JuMP, Gurobi, DataFrames* are installed in Julia. Respectively, versions should be at least 0.16.2, 0.3.2 and 0.9.1. In order to so, run in Julia:
```julia
Pkg.add("JuMP")
Pkg.add("Gurobi")
Pkg.add("DataFrames")
```
Once this is done, open *main.jl* and under the section highlighted as CHANGE HERE, enter:
* *outputFolder*: the name of the output folder (default Results/)
* *T_2* and *S*: defining the class to be considered
* *limitOfTime*: time limit in seconds given to Gurobi to solve one instance (default 3600)
* *memoryLimit*: memory limit defined as a bound on the product of the number of variables and constraints of CRP-I (default 8.10e10)
* *useGap*: if true then the absolute gap is set to 0.99 for the IP, 0 otherwise (default true)
* *useIncumbent*: if true, provide the upper bound as incumbent to the solver (default true)
* *PreProcessingOn*: if true, adds constraints to set some variables to zeros (default true)
* *printSolution*: if true, can set the sequence of relocations for each instance (default false)

After setting these parameters, run in the directory
```
julia main.jl
```

## Generate tables

**After running the previous step for all 21 class ONLY**, the script generateTables.jl allows to generate all 6 tables presented in *A new binary integer program for the restricted container relocation problem, Galle et al. (2017)*. In order to do so, open the script and set the following parameters:
* *outputFolder*: the name of the output folder where the results of the previous step are (default Results/)
* *generate_Table_i* for i = 1,...,6: if true, regenerate Table i in a csv file in outputFolder (default true)

After setting these parameters, run in the directory
```
julia generateTables.jl
```
