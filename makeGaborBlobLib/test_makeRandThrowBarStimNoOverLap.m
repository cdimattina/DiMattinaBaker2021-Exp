
    addpath ../ANALYSIS

    clear all; 
   
    barInStruct.imSize        = 256;
    barInStruct.mpSize        = 12; 
    barInStruct.blobSize      = 8; 
    barInStruct.blobSigma     = 1.5; 
    barInStruct.quadStruct    = makeQuadrantMap(barInStruct.imSize, barInStruct.mpSize);
    barInStruct.nPattSide     = 32;    
   

    barInStruct.pWL           = 16/32;
    barInStruct.pVL           = 16/32;

    barInStruct.lumori        = +45;
    barInStruct.lumphase      = 0;

    barInStruct.texori        = +45;
    barInStruct.texphase      = 0;
    
    barInStruct.barW          = 3; 
    barInStruct.barL          = barInStruct.mpSize - 2;
    
    
    stimTex  = makeRandThrowBarStimNoOverLap(barInStruct);
    
    colormap('gray'); 
    figure(1); 
    imagesc(stimTex); axis square off; 
    
%     [URMask,LLMask,ULMask,LRMask] = makeRegionMasks(barInStruct.imSize);
%     
%     dL_R = abs( sum(sum(ULMask.*stimTex)) - sum(sum(LRMask.*stimTex) ));
%     dL_L = abs( sum(sum(LLMask.*stimTex)) - sum(sum(URMask.*stimTex) ));
%     
%     disp(sprintf('dL_R = %.2f, dL_L = %.2f',dL_R, dL_L));
    
    
    % Also plot this stimulus with added luminance disc
%     
%     lumDisc = makeLumDisc(barInStruct.imSize, barInStruct.phase, barInStruct.ori, 0.2,0.2);
%     
%     ccTex = stimTex + 0.2*lumDisc;
%     
%     figure(1); 
%     imagesc(ccTex); axis square off; 
    
    
    
    
    
    
    
    