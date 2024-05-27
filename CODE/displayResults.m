
%%
% THIS PROGRAM WILL BE INTEGRATED INTO PsyCPLAB (CD, 12-05-22)
%%

%
% Usage: displayResults(resultsMat,lumLevs,orALevs,stimCategory)
%
% <resultsMat> : lum levels in rows, orientation levels in columns
%

function displayResults(resultsMat, nTrialsVec, varLevs, stimCategory, stimVary)
        
    lumStep   = strcmp(stimCategory,'lumDisc') || strcmp(stimCategory,'lumDiscMask') || strcmp(stimCategory,'natTextDiscMask') ...
             || strcmp(stimCategory,'natTexLTB') || strcmp(stimCategory,'natTexLSB') || strcmp(stimCategory,'lumDiscDL') || strcmp(stimCategory,'lumDisclumMaskDL');
    varypW    = strcmp(stimVary,'pW');
    varydens  = strcmp(stimVary,'dens');
    varymaxlum = strcmp(stimVary,'maxlum');
    
    ormod    = strcmp(stimCategory,'ormod');
    
    if(lumStep)
       disp('1D PF: Luminance step edge');
    elseif(ormod)
       disp('1D PF: Orientation modulation'); 
    else
       if(varypW) 
            disp('1D PF: Luminance texture edge - pW');
       elseif(varydens)
            disp('1D PF: Luminance texture edge - dens');
       elseif(varymaxlum)
            disp('1D PF: Luminance texture edge - maxlum');
       else
            disp('1D PF: Luminance texture edge - nCL');
       end
    end
    
    nStim  = length(varLevs);
    levVec = varLevs; 

    pcorrVec = resultsMat;
    disp(sprintf('\n%s \t%s \t%s','Level','N','% Correct'));

    for i=1:nStim
        disp(sprintf('%.4f \t%d \t%.2f',levVec(i),nTrialsVec(i),pcorrVec(i)));
    end
                       
end