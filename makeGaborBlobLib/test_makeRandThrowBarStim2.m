

    addpath ../ANALYSIS

    clear all; 
    
    barInStruct.imSize        = 256;
    barInStruct.mpSize        = 12; 
    barInStruct.quadStruct    = makeQuadrantMap(barInStruct.imSize, barInStruct.mpSize); 
    
    barInStruct.nPattSide     = 64;
    
 
    barInStruct.pWL           = 32/32;
    barInStruct.ori           = 45;
    barInStruct.phase         = 0;

    barInStruct.pVL           = 32/32;
    barInStruct.barW          = 3; 
    barInStruct.barL          = barInStruct.mpSize - 2;
    
    
    stimTex  = makeRandThrowBarStim(barInStruct);
    
    colormap('gray'); 
    figure(1); 
    subplot(1,2,1)
    imagesc(stimTex); axis square off; 
    
    [URMask,LLMask,ULMask,LRMask] = makeRegionMasks(barInStruct.imSize);
    
    dL_R = abs( sum(sum(ULMask.*stimTex)) - sum(sum(LRMask.*stimTex) ));
    dL_L = abs( sum(sum(LLMask.*stimTex)) - sum(sum(URMask.*stimTex) ));
    
    disp(sprintf('dL_R = %.2f, dL_L = %.2f',dL_R, dL_L));
    
    figure(1); 
    subplot(1,2,2)
    stimTex64 = imresize(stimTex,0.25);
    imagesc(stimTex64); axis square off; 
    
    
    % Also plot this stimulus with added luminance disc
%     
%     lumDisc = makeLumDisc(barInStruct.imSize, barInStruct.phase, barInStruct.ori, 0.2,0.2);
%     
%     ccTex = stimTex + 0.2*lumDisc;
%     
%     figure(1); 
%     imagesc(ccTex); axis square off; 
    
    
    
    
    
    
    
    