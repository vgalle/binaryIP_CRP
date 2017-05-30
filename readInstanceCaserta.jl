## This function reads the input file corresponding to instance T_2-S-ID placed in the sub-folder "CRPTestcases_Caserta\"" which has to be in the directory of main.jl
## It ouputs Config, the matrix reprentation of the inital configuration.
## For the structure of the input files see "Data Format.docx" in the subfolder.

function readInstanceCaserta(T_2,S,instanceID)
    file = string("CRPTestcases_Caserta/data", T_2,"-",S,"-",instanceID,".dat");
    inputData = readtable(file,header=false);
    Config = zeros(Int16,T_2+2,S);
    for s = 1:S
        sta = map(x->parse(Int16,x),split(inputData[:x1][s+1]));
        for t = 1:T_2
            Config[T_2-t+3,s] = sta[t+1];
        end
    end
    return Config;
end