function [URMask,LLMask,ULMask,LRMask] = makeRegionMasks(stimSize)
    
    % Path for code
    addpath ..\makeGaborBlobLib\;

    circleMask = stimMakeCosTaper2(stimSize,0); 
       
    URMask      = triu(ones(stimSize,stimSize)) - eye(stimSize,stimSize); 
    LLMask      = tril(ones(stimSize,stimSize)) - eye(stimSize,stimSize); 
    ULMask      = fliplr(URMask);
    LRMask      = fliplr(LLMask);

    
end