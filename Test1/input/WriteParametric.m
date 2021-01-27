clc; close all; clear all;

LoadFactors = [1e4 2e4 4e4 6e4 8e4 1e5 2e5 4e5 6e5 8e5 1e6 1.5e6 2e6 2.5e6 3e6 4e6 6e6 8e6 1e7];
FileName = 'Parametric.txt';


fileIn = fopen(FileName,'w');

for iFile=1:length(LoadFactors)
    fprintf(fileIn,'# PARAMETRIC number %i \n',iFile);
    fprintf(fileIn,'BeginParametricString : 1 ;\n');
    fprintf(fileIn,'         ScalingFactor :  %+1.2e  ;\n',LoadFactors(iFile));
    fprintf(fileIn,'EndParametricString : 1 ;\n\n\n');
end

fclose(fileIn);

