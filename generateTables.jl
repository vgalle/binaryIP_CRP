## IMPORTANT: The outputFolder must contain all the files required to generate all the tables in Galle et al. (2017). Hence all the classes must have been run before running this script!
## Remember to set the outputFolder name as in the main.jl

###################################################################################
################################### CHANGE HERE ###################################
###################################################################################

## SET THE NAME OF YOUR OUTPUT FOLDER
outputFolder = "Results/";
##
generate_Table_1 = true;
generate_Table_2 = true;
generate_Table_3 = true;
generate_Table_4 = true;
generate_Table_5 = true;
generate_Table_6 = true;

###################################################################################
######################## DO NOT CHANGE ANY CODE FROM THERE ########################
###################################################################################

using DataFrames
include("generateTablePerTable.jl");
if generate_Table_1
    generateTable_1(outputFolder);
end
if generate_Table_2
    generateTable_2(outputFolder);
end
if generate_Table_3
    generateTable_3(outputFolder);
end
if generate_Table_4
    generateTable_4(outputFolder);
end
if generate_Table_5
    generateTable_5(outputFolder);
end
if generate_Table_6
    generateTable_6(outputFolder);
end
