%
% Usage: displayResults(resultsMat,lumLevs,orALevs,stimCategory)
%
% <resultsMat> : lum levels in rows, orientation levels in columns
%

function displayResults2(resultsMat, nTrialsVec)
        
    levVec = 1:length(nTrialsVec);

    pcorrVec = resultsMat;
    disp(sprintf('\n%s \t%s \t%s','Level','N','% Correct'));

    for i=1:length(nTrialsVec)
        disp(sprintf('%d \t%d \t%.2f',levVec(i),nTrialsVec(i),pcorrVec(i)));
    end
                       
end