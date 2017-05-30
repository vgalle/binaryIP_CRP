## This script has 6 functions, each generating a table from Galle et al. (2017)
## generateTable_i generates table i in the same output folder as the results from main.jl in a csv file called Table_i.csv

function generateTable_1(outputFolder)
    listOfClasses = [3 3;3 4;3 5;3 6;3 7;3 8;
                     4 4;4 5;4 6;4 7;
                     5 4;5 5;5 6;5 7;5 8;5 9;5 10;
                     6 6;6 10;10 6;10 10];
    nClasses = size(listOfClasses)[1];
    df = DataFrame(Class = Vector{AbstractString}(nClasses), Num_Containers = Vector{Int64}(nClasses), Average_Lower_Bound = Vector{Float64}(nClasses), Average_Upper_Bound = Vector{Float64}(nClasses), Average_Gap = Vector{Float64}(nClasses), Num_Trivial = Vector{Int64}(nClasses));
    for cla = 1:nClasses
        file = string(outputFolder,listOfClasses[cla,1], "-", listOfClasses[cla,2],"_Results.csv");
        inputData = readtable(file,header=true,nrows = 1);
        df[:Class][cla] = string("(",listOfClasses[cla,1],",",listOfClasses[cla,2],")");
        df[:Num_Containers][cla] = listOfClasses[cla,1]*listOfClasses[cla,2];
        df[:Average_Lower_Bound][cla] = round(inputData[:Lower_Bound][1],3);
        df[:Average_Upper_Bound][cla] = round(inputData[:Upper_Bound][1],3);
        df[:Average_Gap][cla] = round(inputData[:Gap][1],3);
        df[:Num_Trivial][cla] = inputData[:Trivial_Instance][1];
    end
    outputFileName = string(outputFolder,"Table_1.csv");
    writetable(outputFileName, df, separator = ',', header = true);
end

function generateTable_2(outputFolder)
    listOfClasses = [3 3;3 4;3 5;3 6;3 7;3 8;
                     4 4;4 5;4 6;4 7;
                     5 4;5 5;5 6;5 7;5 8;5 9;5 10;
                     6 6;6 10;10 6;10 10];
    nClasses = size(listOfClasses)[1];
    df = DataFrame(Class = Vector{AbstractString}(nClasses), Num_Trivial = Vector{Int64}(nClasses), Num_Solved_Non_Trivial = Vector{AbstractString}(nClasses), Average_CPU_Time = Vector{Float64}(nClasses), Standard_Deviation_CPU_Time = Vector{Float64}(nClasses), Num_Time_Limit = Vector{AbstractString}(nClasses), Num_Memory_Limit = Vector{AbstractString}(nClasses));
    Num_Non_Trivial_Zehendneretal = [13;14;12;4;7;8;32;29;29;31;36;38;31;19;5;2;0;7;0;0;0];
    Num_Time_Out_Zehendneretal = [0;0;0;0;0;0;0;0;0;0;0;1;6;2;0;0;0;10;0;0;0];
    Num_Memory_Out_Zehendneretal = [0;0;0;0;0;0;0;0;0;0;0;0;0;14;31;35;38;23;38;40;40];
    for cla = 1:nClasses
        file = string(outputFolder,listOfClasses[cla,1], "-", listOfClasses[cla,2],"_Results.csv");
        inputData = readtable(file,header=true);
        df[:Class][cla] = string("(",listOfClasses[cla,1],",",listOfClasses[cla,2],")");
        df[:Num_Trivial][cla] = parse(Int64,inputData[:Trivial_Instance][1]);
        df[:Num_Solved_Non_Trivial][cla] = string(parse(Int64,inputData[:Opt_Solved][1])," (",Num_Non_Trivial_Zehendneretal[cla],")");
        if parse(Int64,inputData[:Opt_Solved][1]) > 0
            df[:Average_CPU_Time][cla] = round(inputData[:Solving_Time][1],1);
            solvingTimesNoNA = inputData[!isna(inputData[:Solving_Time]),:Solving_Time];
            solvingTimesNoNA = solvingTimesNoNA[2:length(solvingTimesNoNA)];
            df[:Standard_Deviation_CPU_Time][cla] = round(std(solvingTimesNoNA),1);
        else
            df[:Average_CPU_Time][cla] = NA;
            df[:Standard_Deviation_CPU_Time][cla] = NA;
        end
        df[:Num_Time_Limit][cla] = string(parse(Int64,inputData[:Timed_Out][1])," (",Num_Time_Out_Zehendneretal[cla],")");
        df[:Num_Memory_Limit][cla] = string(parse(Int64,inputData[:Memory_Out][1])," (",Num_Memory_Out_Zehendneretal[cla],")");
    end
    outputFileName = string(outputFolder,"Table_2.csv");
    writetable(outputFileName, df, separator = ',', header = true);
end

function generateTable_3(outputFolder)
    listOfClasses = [3 3;3 4;3 5;3 6;3 7;3 8;
                     4 4;4 5;4 6;4 7;
                     5 4;5 5;5 6;5 7;5 8;5 9;5 10;
                     6 6;6 10;10 6;10 10];
    nClasses = size(listOfClasses)[1];
    df = DataFrame(Class = Vector{AbstractString}(nClasses), Average_Num_Binary_Variables = Vector{AbstractString}(nClasses), Average_Num_Constraints = Vector{Float64}(nClasses), Average_Nodes_Iterations = Vector{Float64}(nClasses));
    Average_Num_Binary_Variables_Zehendneretal = [546.8;2140.1;5236.0;16170.8;25576.0;37248.0;5755.5;19380.2;32718.8;72055.6;15161.6;42530.7;112706.7;198902.1;352122.7;583790.6;884834.6;243620.9;2058673.2;Inf;Inf];
    for cla = 1:nClasses
        file = string(outputFolder,listOfClasses[cla,1], "-", listOfClasses[cla,2],"_Results.csv");
        inputData = readtable(file,header=true,nrows = 1);
        df[:Class][cla] = string("(",listOfClasses[cla,1],",",listOfClasses[cla,2],")");
        if Average_Num_Binary_Variables_Zehendneretal[cla] != Inf
            df[:Average_Num_Binary_Variables][cla] = string(inputData[:Num_Variables][1]," (",Average_Num_Binary_Variables_Zehendneretal[cla],")");
        else
            df[:Average_Num_Binary_Variables][cla] = string(inputData[:Num_Variables][1]," (-)");
        end
        df[:Average_Num_Constraints][cla] = round(inputData[:Num_Constraints][1],1);
        df[:Average_Nodes_Iterations][cla] = round(inputData[:Nodes_Iterations][1],1);
    end
    outputFileName = string(outputFolder,"Table_3.csv");
    writetable(outputFileName, df, separator = ',', header = true);
end

function generateTable_4(outputFolder)
    listOfClasses = [3 3;3 4;3 5;3 6;3 7;3 8;
                     4 4;4 5;4 6;4 7;
                     5 4;5 5;5 6;5 7;5 8;5 9;5 10;
                     6 6];
    nClasses = size(listOfClasses)[1];
    df = DataFrame(Class = Vector{AbstractString}(nClasses), Num_Solved_Non_Trivial = Vector{Int64}(nClasses), Average_Optimal_Value = Vector{Float64}(nClasses), Average_Gap_UB_with_Optimal = Vector{Float64}(nClasses), Num_UB_Optimal = Vector{Int64}(nClasses));
    for cla = 1:nClasses
        file = string(outputFolder,listOfClasses[cla,1], "-", listOfClasses[cla,2],"_Results.csv");
        inputData = readtable(file,header=true);
        df[:Class][cla] = string("(",listOfClasses[cla,1],",",listOfClasses[cla,2],")");
        df[:Num_Solved_Non_Trivial][cla] = parse(Int64,inputData[:Opt_Solved][1]);
        if df[:Num_Solved_Non_Trivial][cla] > 0
            avgOptValue = 0;
            avgGap = 0;
            nUBOpt = 0;
            nInstances = size(inputData)[1];
            for i = 2:nInstances
                if !isna(inputData[:Opt_Solved][i]) && (inputData[:Opt_Solved][i] == "TRUE" || inputData[:Opt_Solved][i] == "true")
                    avgOptValue += Int64(inputData[:Opt_Value][i])/df[:Num_Solved_Non_Trivial][cla];
                    avgGap += (Int64(inputData[:Upper_Bound][i]) - Int64(inputData[:Opt_Value][i]))/df[:Num_Solved_Non_Trivial][cla];
                    nUBOpt += ((Int64(inputData[:Upper_Bound][i]) - Int64(inputData[:Opt_Value][i])) == 0);
                end
            end
            df[:Average_Optimal_Value][cla] = round(avgOptValue,2);
            df[:Average_Gap_UB_with_Optimal][cla] = round(avgGap,2);
            df[:Num_UB_Optimal][cla] = Int64(nUBOpt);
        else
            df[:Average_Optimal_Value][cla] = NA;
            df[:Average_Gap_UB_with_Optimal][cla] = NA;
            df[:Num_UB_Optimal][cla] = NA;
        end
    end
    outputFileName = string(outputFolder,"Table_4.csv");
    writetable(outputFileName, df, separator = ',', header = true);
end

function generateTable_5(outputFolder)
    listOfClasses = [3 3;3 4;3 5;3 6;3 7;3 8;
                     4 4;4 5;4 6];
    nClasses = size(listOfClasses)[1];
    df = DataFrame(Class = Vector{AbstractString}(6*nClasses), Instance = Vector{AbstractString}(6*nClasses), Optimal_Value = Vector{Float64}(6*nClasses),
    time_CRPI = Vector{AbstractString}(6*nClasses), time_BRPIIstar = Vector{AbstractString}(6*nClasses), time_BandB = Vector{AbstractString}(6*nClasses), time_BRP2ci = Vector{AbstractString}(6*nClasses));
    time_BRPIIstar_input = [1.18;1.39;1.00;1.09;1.06;3.6;4.76;18.39;11.71;16.06;18.04;13.79;83.09;75.95;100.71;95.31;65.32;84.11;124.11;113.29;89.06;93.12;96.50;103.22;182.14;;284.29;119.20;472.32;277.97;267.26;84.66;14403.33;8298.85;250.33;6384.65;5884.36;71.96;228.91;71.99;65.25;89.36;105.49;3544.86;326.54;1023.98;119.86;2656.67;1534.38;4077.08;18985.03;1706.75;2376.86;8564.20;7141.98];
    time_BandB_input = [0.007;0.007;0.006;0.007;0.007;0.007;0.008;0.007;0.006;0.007;0.007;0.008;0.010;0.007;0.013;0.008;0.026;0.013;0.086;0.008;0.019;0.016;0.007;0.027;0.009;0.011;0.011;0.010;0.038;0.016;0.021;0.055;0.012;0.013;0.022;0.025;0.017;0.025;0.009;0.008;0.013;0.014;0.540;0.043;0.018;0.014;0.579;0.239;17.476;0.030;0.069;0.315;0.076;3.593];
    time_BRP2ci_input = [0.11;0.11;0.08;0.09;0.06;0.09;0.28;0.22;0.34;0.26;0.27;0.274;0.72;1.2;0.91;0.8;1.59;1.044;5.35;1.59;3.09;1.78;1.23;2.608;2.89;3.29;3.34;3.35;7.97;4.168;7.25;9.31;6.57;11.03;11.06;9.044;1.25;0.95;1.56;0.78;1.15;1.138;61.62;5.27;8.28;2.96;81.26;31.878;Inf;5.23;12.86;23.4;45.22;Inf];
    counter = 1;
    for cla = 1:nClasses
        file = string(outputFolder,listOfClasses[cla,1], "-", listOfClasses[cla,2],"_Results.csv");
        inputData = readtable(file,header=true,nrows=6);
        df[:Class][6*(cla-1)+1:6*cla] = string("(",listOfClasses[cla,1],",",listOfClasses[cla,2],")");
        optAvg = 0;
        nSolved = 0;
        avgTimeCRPI = 0;
        for i = 1:5
            df[:Instance][6*(cla-1)+i] = string(i);
            df[:Optimal_Value][6*(cla-1)+i] = inputData[:Opt_Value][i+1];
            optAvg += inputData[:Opt_Value][i+1]/5;
            if inputData[:Trivial_Instance][i+1] == "TRUE" || inputData[:Trivial_Instance][i+1] == "true"
                df[:time_CRPI][6*(cla-1)+i] = string('*');
            elseif inputData[:Opt_Solved][i+1] == "TRUE" || inputData[:Opt_Solved][i+1] == "true"
                df[:time_CRPI][6*(cla-1)+i] = string(inputData[:Solving_Time][i+1]);
                nSolved += 1;
                avgTimeCRPI += inputData[:Solving_Time][i+1];
            end
            df[:time_BRPIIstar][6*(cla-1)+i] = string(time_BRPIIstar_input[counter]);
            df[:time_BandB][6*(cla-1)+i] = string(time_BandB_input[counter]);
            df[:time_BRP2ci][6*(cla-1)+i] = string(time_BRP2ci_input[counter]);
            counter += 1;
        end
        df[:Instance][6*cla] = string("Avg");
        df[:Optimal_Value][6*cla] = round(optAvg,1);
        if nSolved == 0
            df[:time_CRPI][6*cla] = string('*');
        else
            df[:time_CRPI][6*cla] = string(round(avgTimeCRPI/nSolved,3));
        end
        df[:time_BRPIIstar][6*cla] = string(time_BRPIIstar_input[counter]);
        df[:time_BandB][6*cla] = string(time_BandB_input[counter]);
        df[:time_BRP2ci][6*cla] = string(time_BRP2ci_input[counter]);
        counter += 1;
    end
    outputFileName = string(outputFolder,"Table_5.csv");
    writetable(outputFileName, df, separator = ',', header = true);
end

function generateTable_6(outputFolder)
    listOfClasses = [4 7;5 4;5 5];
    nClasses = size(listOfClasses)[1];
    df = DataFrame(Class = Vector{AbstractString}(6*nClasses), Instance = Vector{AbstractString}(6*nClasses), Optimal_Value = Vector{Float64}(6*nClasses),
    time_CRPI = Vector{AbstractString}(6*nClasses), time_BRP2ci = Vector{AbstractString}(6*nClasses));
    time_BRP2ci_input = [44.1;20.47;18.95;49.78;85.75;43.81;118.2;185.36;5.9;5.01;118.16;86.526;Inf;22.06;Inf;Inf;46.3;Inf];
    counter = 1;
    for cla = 1:nClasses
        file = string(outputFolder,listOfClasses[cla,1], "-", listOfClasses[cla,2],"_Results.csv");
        inputData = readtable(file,header=true,nrows=6);
        df[:Class][6*(cla-1)+1:6*cla] = string("(",listOfClasses[cla,1],",",listOfClasses[cla,2],")");
        optAvg = 0;
        nSolved = 0;
        avgTimeCRPI = 0;
        for i = 1:5
            df[:Instance][6*(cla-1)+i] = string(i);
            df[:Optimal_Value][6*(cla-1)+i] = inputData[:Opt_Value][i+1];
            optAvg += inputData[:Opt_Value][i+1]/5;
            if inputData[:Trivial_Instance][i+1] == "TRUE" || inputData[:Trivial_Instance][i+1] == "true"
                df[:time_CRPI][6*(cla-1)+i] = string('*');
            elseif inputData[:Opt_Solved][i+1] == "TRUE" || inputData[:Opt_Solved][i+1] == "true"
                df[:time_CRPI][6*(cla-1)+i] = string(inputData[:Solving_Time][i+1]);
                nSolved += 1;
                avgTimeCRPI += inputData[:Solving_Time][i+1];
            end
            df[:time_BRP2ci][6*(cla-1)+i] = string(time_BRP2ci_input[counter]);
            counter += 1;
        end
        df[:Instance][6*cla] = string("Avg");
        df[:Optimal_Value][6*cla] = round(optAvg,1);
        if nSolved == 0
            df[:time_CRPI][6*cla] = string('*');
        else
            df[:time_CRPI][6*cla] = string(round(avgTimeCRPI/nSolved,3));
        end
        df[:time_BRP2ci][6*cla] = string(time_BRP2ci_input[counter]);
        counter += 1;
    end
    outputFileName = string(outputFolder,"Table_6.csv");
    writetable(outputFileName, df, separator = ',', header = true);
end
