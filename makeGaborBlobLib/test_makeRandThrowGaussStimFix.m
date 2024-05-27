

    addpath ../ANALYSIS

    clear all; 
    
    gaussInStruct.imSize        = 256;
    gaussInStruct.mpSize        = 8; 
    gaussInStruct.quadStruct    = makeQuadrantMap(gaussInStruct.imSize, gaussInStruct.mpSize); 
    
    gaussInStruct.nPattSide     = 32;
    
    gaussInStruct.nWL           = 8; 
    gaussInStruct.nCL           = 0;
    
    gaussInStruct.nPattWL       = 1;
    gaussInStruct.ori           = 45;
    gaussInStruct.phase         = 180;
    gaussInStruct.sigma         = 2;
    gaussInStruct.dodots        = 0;
    
    stimTex  = makeRandThrowGaussStimFix(gaussInStruct);
    
    colormap('gray'); subplot(2,2,1); 
    imagesc(stimTex); axis square off; 
    
    [URMask,LLMask,ULMask,LRMask] = makeRegionMasks(gaussInStruct.imSize);
    
    dL_R = abs( sum(sum(ULMask.*stimTex)) - sum(sum(LRMask.*stimTex) ));
    dL_L = abs( sum(sum(LLMask.*stimTex)) - sum(sum(URMask.*stimTex) ));
    
    disp(sprintf('dL_R = %.2f, dL_L = %.2f',dL_R, dL_L));