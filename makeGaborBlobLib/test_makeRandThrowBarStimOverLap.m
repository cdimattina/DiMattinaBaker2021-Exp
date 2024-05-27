
    addpath ../ANALYSIS

    clear all; 
   
    barInStruct.imSize        = 256;
    barInStruct.mpSize        = 10; 
    barInStruct.quadStruct    = makeQuadrantMap(barInStruct.imSize, barInStruct.mpSize);
    barInStruct.nPattSide     = 48;    
    
    % 12/24 : 12, 14, 16, 18, 20, 22, 24
    % 14/24 : 12, 14, 16,     20, 22, 24
    % 16/24 : 12, 14, 16, 18, 20, 22, 24
    % 18/24 : 12,     16,     20,     24
    % 20/24 : 12, 14, 16, 18, 20, 22, 24 
    % 22/24 : 12, 14, 16,     20, 22, 24
    % 24/24 : 12, 14, 16, 18, 20, 22, 24

    barInStruct.pWL           = 12/24;
    barInStruct.pVL           = 24/24;

    barInStruct.lumori        = +45;
    barInStruct.lumphase      = 0;

    barInStruct.texori        = +45;
    barInStruct.texphase      = 0;
    
    barInStruct.barW          = 2; 
    barInStruct.barL          = barInStruct.mpSize - 2;
    
    
    stimTex  = makeRandThrowBarStimOverLap(barInStruct);
    
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
    
    
    
    
    
    
    
    