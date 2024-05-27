

    addpath ../ANALYSIS

    clear all; 
    
    gaussInStruct.imSize        = 256;
    gaussInStruct.mpSize        = 24;
    gaussInStruct.quadStruct    = makeQuadrantMap(gaussInStruct.imSize, gaussInStruct.mpSize); 
    gaussInStruct.nPattSide     = 16;
    
    gaussInStruct.pWL           = (26/32);
    
    gaussInStruct.ori           = 45;
    gaussInStruct.phase         = 0;
    gaussInStruct.sigma         = 6;
    gaussInStruct.dodots        = 0;
    
    [stimTex,nWL,nBL]               = makeRandThrowGaussStim(gaussInStruct);       
    [URMask,LLMask,ULMask,LRMask]   = makeRegionMasks(gaussInStruct.imSize);
    
%     deltaBW = 2*(nWL - nBL);   
%     gaussPos = stimMakeGausWindow2(gaussInStruct.mpSize ,gaussInStruct.sigma);
%     blobLum  = sum(sum(abs(gaussPos)));
%     
%     deltaBWdesired  = floor(0.2*gaussInStruct.nPattSide); 
%     dL_desired      = deltaBWdesired*blobLum; 
%     dL_actual       = deltaBW*blobLum; 
%     stimTex_dLFix   = (dL_desired/dL_actual)*stimTex; 
%     
%     dL_R = abs( sum(sum(ULMask.*stimTex_dLFix)) - sum(sum(LRMask.*stimTex_dLFix) ));
%     dL_L = abs( sum(sum(LLMask.*stimTex_dLFix)) - sum(sum(URMask.*stimTex_dLFix) )); 
%     disp(sprintf(' nWL = %d, nBL = %d, dL_R = %.2f, dL_L = %.2f', nWL, nBL, dL_R, dL_L));
    
    figure(1); 
    cmap = (1/255)* [(0:255)',(0:255)',(0:255)'];
    colormap(cmap);
    
    gray   = 127.5;
    inc    = 127.5;       
    I      = gray + 0.25*inc*stimTex;
    
    dL_R = abs( sum(sum(ULMask.*I)) - sum(sum(LRMask.*I) ));
    dL_L = abs( sum(sum(LLMask.*I)) - sum(sum(URMask.*I) )); 
    disp(sprintf(' RMS = %.4d, nWL = %d, nBL = %d, dL_R = %.2f, dL_L = %.2f', RMScontrast(I), nWL, nBL, dL_R, dL_L));
    
%     I      = uint8(round(I));
%     subplot(2,2,1); 
%     image(I); axis square off; 
      
%     lumDiscCon  = makeLumDisc(gaussInStruct.imSize   , gaussInStruct.phase , gaussInStruct.ori    , 0.0, 0.2);
%     lumDiscInCon = makeLumDisc(gaussInStruct.imSize , gaussInStruct.phase , -1*gaussInStruct.ori , 0.0, 0.2);
%     lumDiscOutPhase = makeLumDisc(gaussInStruct.imSize   , 180-gaussInStruct.phase , gaussInStruct.ori    , 0.0, 0.2);
%     
%     IText   = I;
%     IDiscCon   = gray + 0.05*inc*lumDiscCon;
%     IDiscInCon = gray + 0.05*inc*lumDiscInCon;
%     IDiscOutPhase = gray + 0.05*inc*lumDiscOutPhase;

    
    subplot(2,2,1)
    image(uint8(I));
    axis square off;
    
%     subplot(2,2,1);
%     image(uint8(IDiscCon));
%     axis square off; 
%     
%     subplot(2,2,3);
%     image(uint8(IDiscCon + (IText-gray)));
%     axis square off; 
%     
%     subplot(2,2,2);
%     image(uint8(IDiscOutPhase + (IText-gray)));
%     axis square off; 
%     
%     subplot(2,2,4);
%     image(uint8(IDiscInCon + (IText-gray)));
%     axis square off; 
    
    
    
    
    
    
%     % Scale from 0-255 and compute RMS contrast
%     
%     maxLum  = 0.2; 
%     gray    = 127.5;
%     inc     = 127.5;
%     
%     I       = gray + maxLum*inc*stimTex; 
%     % disp(sprintf('RMS init = %.4f',RMScontrast(I)));
%     
%     RMS_I   = RMScontrast(I);  
%     
%     RMS_desired = 0.02; 
%     c = (RMS_desired/RMS_I); 
%     
%     I_FixRMS   = gray + c*maxLum*inc*stimTex;  
%     % disp(sprintf('RMS fix = %.4f',RMScontrast(I_FixRMS)));
%     
%     figure(1); 
%     colormap('gray'); 
%     imagesc(I_FixRMS); axis square off; 
    
%     % Compute luminance difference
%     dL_R = abs( sum(sum(ULMask.*I_FixRMS)) - sum(sum(LRMask.*I_FixRMS) ));
%     dL_L = abs( sum(sum(LLMask.*I_FixRMS)) - sum(sum(URMask.*I_FixRMS) )); 
%     disp(sprintf('dL_R = %.2f, dL_L = %.2f',dL_R, dL_L));
    
    
%     gray   = 127.5; 
%     inc    = 127.5; 
%     maxlumVec = [0.5];
%     
% 
%     RPlane = zeros(gaussInStruct.imSize,gaussInStruct.imSize);
%     GPlane = zeros(gaussInStruct.imSize,gaussInStruct.imSize);
%     BPlane = zeros(gaussInStruct.imSize,gaussInStruct.imSize);
%     
%     IColTex   = zeros(gaussInStruct.imSize , gaussInStruct.imSize , 3);
%     wind   = find(stimTex > 0);
%     bind   = find(stimTex < 0);  
%     
%     RPlane(wind)    = stimTex(wind);
%     GPlane(bind)    = -1*stimTex(bind);
%     IColTex(:,:,1)  = RPlane;
%     IColTex(:,:,2)  = GPlane; 
%     
%     IBWTex    = zeros(gaussInStruct.imSize , gaussInStruct.imSize , 3);
%     IBWTex(:,:,1)  = stimTex2;
%     IBWTex(:,:,2)  = stimTex2;
%     IBWTex(:,:,3)  = stimTex2;
%     
%     lumDisc = makeLumDisc(gaussInStruct.imSize, gaussInStruct.phase, -gaussInStruct.ori, 0.2,0.2);
%     IBWDisc = zeros(gaussInStruct.imSize , gaussInStruct.imSize , 3);
%     IBWDisc(:,:,1) = lumDisc;
%     IBWDisc(:,:,2) = lumDisc;
%     IBWDisc(:,:,3) = lumDisc;
%     
%     IBWDisc = inc*0.07*IBWDisc;
%     
%     
%     RPlane = zeros(gaussInStruct.imSize,gaussInStruct.imSize);
%     GPlane = zeros(gaussInStruct.imSize,gaussInStruct.imSize);
%     BPlane = zeros(gaussInStruct.imSize,gaussInStruct.imSize);
%     
%     
%     colDisc = makeLumDisc(gaussInStruct.imSize, gaussInStruct.phase, gaussInStruct.ori, 0.2,0.2);
%     IColDisc = zeros(gaussInStruct.imSize , gaussInStruct.imSize , 3);
%     wind   = find(colDisc > 0);
%     bind   = find(colDisc < 0);  
%     
%     RPlane(wind)    = colDisc(wind);
%     GPlane(bind)    = -1*colDisc(bind);
%     
%     IColDisc(:,:,1)  = RPlane;
%     IColDisc(:,:,2)  = GPlane; 
%     
%     IColDisc = inc*0.07*IColDisc;
%     
%     
%     figure(1); 
%     cmap = (1/255)* [(0:255)',(0:255)',(0:255)'];
%     colormap(cmap);
%     
%    
%         
%     I      = gray + maxlumVec*inc*IColTex + IBWDisc;
%     I      = uint8(round(I));
%     subplot(2,2,1); 
%     image(I); axis square off; 
% 
%     I      = gray + maxlumVec*inc*IBWTex + IColDisc;
%     I      = uint8(round(I));
%     subplot(2,2,2); 
%     image(I); axis square off; 
%     
%     I      = gray + IBWDisc + IColDisc;
%     I      = uint8(round(I));
%     subplot(2,2,3); 
%     image(I); axis square off; 
%     
%     I      = gray + maxlumVec*inc*IBWTex + maxlumVec*inc*IColTex;
%     I      = uint8(round(I));
%     subplot(2,2,4); 
%     image(I); axis square off; 
    
