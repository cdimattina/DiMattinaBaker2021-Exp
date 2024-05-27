% makeRandThrowBarStimOverLap.m
% 
% DESCRIPTION
% -------------------------------------------------------------------------
% Same as makeRandThrowBarStim except in this version, the orientaion cue
% and luminance cue can have independent orientations and phases
% 
 
function [stimTex]  = makeRandThrowBarStimNoOverLap(barInStruct)
    
    quadStruct  = barInStruct.quadStruct; 
    imSize      = barInStruct.imSize;
    mpSize      = barInStruct.mpSize;  
    blobSize    = barInStruct.blobSize;
    sigma       = barInStruct.blobSigma; 
    nPattSide   = barInStruct.nPattSide;
    
    % Here the luminance imbalance only applies to the dot micropatterns
    % Bars are fixed to have pWL = 0.5 
    pWL         = barInStruct.pWL;
    
    % Make sure nPattSide is a multiple of four
    if(rem(nPattSide,4)~=0)
       error('nPattSide must be a multiple of 4...'); 
    end
    
    % Number of patterns per quadrant
    nPattQuad   = nPattSide/2; 
    
    % Luminance and texture orientation
    lumori      = barInStruct.lumori;
    texori      = barInStruct.texori;
    
    % Luminance and texture phase
    lumphase    = barInStruct.lumphase;
    texphase    = barInStruct.texphase;
    
    % Proportion of bars vertical on left (or top if lumori ~= texori)
    pVL         = barInStruct.pVL;
    barW        = barInStruct.barW;
    barL        = barInStruct.barL;
     
    % Initialize texture micropatterns
    stimTex     = zeros(imSize,imSize); 
    
    barVPos = makeVBar(mpSize,barW,barL);
    barVNeg = -1*barVPos;

    barHPos = barVPos';
    barHNeg = barVNeg';
    
     % Define positive and negative stimuli
    gaussPos    = stimMakeGausWindow2(barInStruct.blobSize,sigma);
    gaussNeg    = -1*gaussPos;
     
    if(lumori==45)
        UL = quadStruct.NMask;
        LL = quadStruct.WMask;
        UR = quadStruct.EMask;
        LR = quadStruct.SMask;
    elseif(lumori==-45)
        UL = quadStruct.WMask;
        LL = quadStruct.SMask;
        UR = quadStruct.NMask;
        LR = quadStruct.EMask;
    else
        error('orientation must be +45 or -45');  
    end
    
    cues_congruent = (lumori==texori);
    
    % Determine luminance boundary proportions
    % Here this only applies to the Gabors since pW_bar = 0.5
    
    if(lumphase==0)
       prop_w_UL = pWL; 
       prop_w_LL = pWL;
    elseif(lumphase==180)
       prop_w_UL = 1-pWL;
       prop_w_LL = 1-pWL;
    else
       error('<lumphase> must be 0 or 180'); 
    end
    
    % set proportions for right side
    prop_w_UR = 1-prop_w_UL;
    prop_w_LR = 1-prop_w_LL;

    % determine orientation boundary
    if(cues_congruent)
        % left-right
        if(texphase==0)
            prop_v_UL = pVL;
            prop_v_LL = pVL; 
        elseif(texphase==180)
            prop_v_UL = 1-pVL;
            prop_v_LL = 1-pVL; 
        else
            error('<texphase> must be 0 or 180');
        end
        % set proportions for right side
        prop_v_UR = 1-prop_v_UL;
        prop_v_LR = 1-prop_v_LL;
    else
        % upper-lower
        if(texphase==0)
            prop_v_UL = pVL;
            prop_v_UR = pVL;
        elseif(texphase==180)
            prop_v_UL = 1-pVL;
            prop_v_UR = 1-pVL;
        else
            error('<texphase> must be 0 or 180');
        end
        % set proportions for lower half
        prop_v_LL = 1 - prop_v_UL;
        prop_v_LR = 1 - prop_v_UR; 
    end
        
    prop_w_bar = 0.5;
    
    % Compute for the upper-left quadrant the proportion of each
    n_w_v_UL = round((prop_w_bar)*(prop_v_UL)*nPattQuad);
    n_w_h_UL = round((prop_w_bar)*(1-prop_v_UL)*nPattQuad);
    n_b_v_UL = round((1-prop_w_bar)*(prop_v_UL)*nPattQuad);
    n_b_h_UL = round((1-prop_w_bar)*(1-prop_v_UL)*nPattQuad);
    
    n_w_blob_UL = round((prop_w_UL)*nPattQuad);
    n_b_blob_UL = round((1-prop_w_UL)*nPattQuad);
    
    n_UL = n_w_v_UL + n_w_h_UL + n_b_v_UL + n_b_h_UL + n_w_blob_UL + n_b_blob_UL;
    disp(sprintf('UPPER-LEFT-QUADRANT (%d): n_v: %d, n_h: %d, n_w: %d, n_b: %d',n_UL,n_w_v_UL + n_b_v_UL,n_w_h_UL + n_b_h_UL, n_w_blob_UL, n_b_blob_UL));
    
    % Compute for the lower-left quadrant the proportion of each
    n_w_v_LL = round((prop_w_bar)*(prop_v_LL)*nPattQuad);
    n_w_h_LL = round((prop_w_bar)*(1-prop_v_LL)*nPattQuad);
    n_b_v_LL = round((1-prop_w_bar)*(prop_v_LL)*nPattQuad);
    n_b_h_LL = round((1-prop_w_bar)*(1-prop_v_LL)*nPattQuad);
    
    n_w_blob_LL = round((prop_w_LL)*nPattQuad);
    n_b_blob_LL = round((1-prop_w_LL)*nPattQuad);
    
    n_LL = n_w_v_LL + n_w_h_LL + n_b_v_LL + n_b_h_LL + n_w_blob_LL + n_b_blob_LL;
    disp(sprintf('LOWER-LEFT-QUADRANT (%d): n_v: %d, n_h: %d, n_w: %d, n_b: %d',n_LL,n_w_v_LL + n_b_v_LL, n_w_h_LL + n_b_h_LL,n_w_blob_LL , n_b_blob_LL));
    
    % Compute for the upper-right quadrant the proportion of each
    n_w_v_UR = round((prop_w_bar)*(prop_v_UR)*nPattQuad);
    n_w_h_UR = round((prop_w_bar)*(1-prop_v_UR)*nPattQuad);
    n_b_v_UR = round((1-prop_w_bar)*(prop_v_UR)*nPattQuad);
    n_b_h_UR = round((1-prop_w_bar)*(1-prop_v_UR)*nPattQuad);
   
    n_w_blob_UR = round((prop_w_UR)*nPattQuad);
    n_b_blob_UR = round((1-prop_w_UR)*nPattQuad);
    
    n_UR = n_w_v_UR + n_w_h_UR + n_b_v_UR + n_b_h_UR + n_w_blob_UR + n_b_blob_UR;
    disp(sprintf('UPPER-RIGHT-QUADRANT (%d): n_v: %d, n_h: %d, n_w: %d, n_b: %d',n_UR, n_w_v_UR + n_b_v_UR,n_w_h_UR + n_b_h_UR,n_w_blob_UR, n_b_blob_UR));
   
    % Compute for the lower-right quadrant the proportion of each
    n_w_v_LR = round((prop_w_bar)*(prop_v_LR)*nPattQuad);
    n_w_h_LR = round((prop_w_bar)*(1-prop_v_LR)*nPattQuad);
    n_b_v_LR = round((1-prop_w_bar)*(prop_v_LR)*nPattQuad);
    n_b_h_LR = round((1-prop_w_bar)*(1-prop_v_LR)*nPattQuad);
    
    n_w_blob_LR = round((prop_w_LR)*nPattQuad);
    n_b_blob_LR = round((1-prop_w_LR)*nPattQuad);
    
    n_LR = n_w_v_LR + n_w_h_LR + n_b_v_LR + n_b_h_LR + n_w_blob_LR + n_b_blob_LR;  
    disp(sprintf('LOWER-RIGHT-QUADRANT (%d): n_v: %d, n_h: %d, n_w: %d, n_b: %d',n_LR,n_w_v_LR + n_b_v_UR,n_w_h_LR + n_b_h_LR,n_w_blob_LR,n_b_blob_LR));
    
    % ----------------------------------------------------------------------------------------------------------
    % Throw bar micro-patterns only
    
    % use the following codes
    % 1 - white vertical
    % 2 - white horizontal
    % 3 - black vertical
    % 4 - black horizontal
    
    w_v_code = 1;
    w_h_code = 2;
    b_v_code = 3;
    b_h_code = 4; 
    
    stimCodes_UL = [ w_v_code*ones(1,n_w_v_UL), w_h_code*ones(1,n_w_h_UL), b_v_code*ones(1,n_b_v_UL), b_h_code*ones(1,n_b_h_UL)];
    stimCodes_LL = [ w_v_code*ones(1,n_w_v_LL), w_h_code*ones(1,n_w_h_LL), b_v_code*ones(1,n_b_v_LL), b_h_code*ones(1,n_b_h_LL)];
    
    stimCodes_UR = [ w_v_code*ones(1,n_w_v_UR), w_h_code*ones(1,n_w_h_UR), b_v_code*ones(1,n_b_v_UR), b_h_code*ones(1,n_b_h_UR)];
    stimCodes_LR = [ w_v_code*ones(1,n_w_v_LR), w_h_code*ones(1,n_w_h_LR), b_v_code*ones(1,n_b_v_LR), b_h_code*ones(1,n_b_h_LR)];
    
    % UL quadrant
    for i=1:length(stimCodes_UL)
        % Find an acceptable location to put a micropattern
        gdInd   = find(UL);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
        cindTex     = (c-mpSize/2 + 1):(c + mpSize/2);
        
        rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
        cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
        
        UL(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_UL(i),
            case 1, % white vertical
                stimTex(rindTex,cindTex) = barVPos; 
            case 2, % white horizontal
                stimTex(rindTex,cindTex) = barHPos; 
            case 3, % black vertical
                stimTex(rindTex,cindTex) = barVNeg;
            case 4, % black horizontal 
                stimTex(rindTex,cindTex) = barHNeg;
        end
          
    end
    
    
    % LL quadrant
    for i=1:length(stimCodes_LL)
        % Find an acceptable location to put a micropattern
        gdInd   = find(LL);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
        cindTex     = (c-mpSize/2 + 1):(c + mpSize/2);
        
        rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
        cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
        
        LL(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_LL(i),
            case 1, % white vertical
                stimTex(rindTex,cindTex) = barVPos; 
            case 2, % white horizontal
                stimTex(rindTex,cindTex) = barHPos; 
            case 3, % black vertical
                stimTex(rindTex,cindTex) = barVNeg;
            case 4, % black horizontal 
                stimTex(rindTex,cindTex) = barHNeg;
        end
          
    end
    
   % UR quadrant
    for i=1:length(stimCodes_UR)
        % Find an acceptable location to put a micropattern
        gdInd   = find(UR);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
        cindTex     = (c-mpSize/2 + 1):(c + mpSize/2);
        
        rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
        cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
        
        UR(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_UR(i),
            case 1, % white vertical
                stimTex(rindTex,cindTex) = barVPos; 
            case 2, % white horizontal
                stimTex(rindTex,cindTex) = barHPos; 
            case 3, % black vertical
                stimTex(rindTex,cindTex) = barVNeg;
            case 4, % black horizontal 
                stimTex(rindTex,cindTex) = barHNeg;
        end
          
    end
    
    % LR quadrant
    for i=1:length(stimCodes_LR)
        % Find an acceptable location to put a micropattern
        gdInd   = find(LR);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
        cindTex     = (c-mpSize/2 + 1):(c + mpSize/2);
        
        rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
        cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
        
        LR(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_LR(i),
            case 1, % white vertical
                stimTex(rindTex,cindTex) = barVPos; 
            case 2, % white horizontal
                stimTex(rindTex,cindTex) = barHPos; 
            case 3, % black vertical
                stimTex(rindTex,cindTex) = barVNeg;
            case 4, % black horizontal 
                stimTex(rindTex,cindTex) = barHNeg;
        end
          
    end
    
    
    % ----------------------------------------------------------------------------------------------------------
    % Now throw the gauss blob micro-patterns only
    
    % use the following codes
    % 1 - white blob
    % 2 - black blob
    
    blob_w_code = 1;
    blob_b_code = 2;

    stimCodes_UL = [ blob_w_code*ones(1,n_w_blob_UL), blob_b_code*ones(1,n_b_blob_UL) ];
    stimCodes_LL = [ blob_w_code*ones(1,n_w_blob_LL), blob_b_code*ones(1,n_b_blob_LL) ];
    
    stimCodes_UR = [ blob_w_code*ones(1,n_w_blob_UR), blob_b_code*ones(1,n_b_blob_UR) ];
    stimCodes_LR = [ blob_w_code*ones(1,n_w_blob_LR), blob_b_code*ones(1,n_b_blob_LR) ];
    
    % UL quadrant
    for i=1:length(stimCodes_UL)
        % Find an acceptable location to put a micropattern
        gdInd   = find(UL);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-blobSize/2 + 1):(r + blobSize/2);
        cindTex     = (c-blobSize/2 + 1):(c + blobSize/2);
        
        rindBlank   = max((r-blobSize),1):min((r+blobSize),imSize);
        cindBlank   = max((c-blobSize),1):min((c+blobSize),imSize);
        
        UL(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_UL(i),
            case 1, % white blob
                stimTex(rindTex,cindTex) = gaussPos; 
            case 2, % black blob
                stimTex(rindTex,cindTex) = gaussNeg; 
        end
          
    end
    
    % LL quadrant
    for i=1:length(stimCodes_LL)
        % Find an acceptable location to put a micropattern
        gdInd   = find(LL);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-blobSize/2 + 1):(r + blobSize/2);
        cindTex     = (c-blobSize/2 + 1):(c + blobSize/2);
        
        rindBlank   = max((r-blobSize),1):min((r+blobSize),imSize);
        cindBlank   = max((c-blobSize),1):min((c+blobSize),imSize);
        
        LL(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_LL(i),
            case 1, % white blob
                stimTex(rindTex,cindTex) = gaussPos; 
            case 2, % black blob
                stimTex(rindTex,cindTex) = gaussNeg; 
        end
          
    end
    
    % UR quadrant
    for i=1:length(stimCodes_UR)
        % Find an acceptable location to put a micropattern
        gdInd   = find(UR);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-blobSize/2 + 1):(r + blobSize/2);
        cindTex     = (c-blobSize/2 + 1):(c + blobSize/2);
        
        rindBlank   = max((r-blobSize),1):min((r+blobSize),imSize);
        cindBlank   = max((c-blobSize),1):min((c+blobSize),imSize);
        
        UR(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_UR(i),
            case 1, % white blob
                stimTex(rindTex,cindTex) = gaussPos; 
            case 2, % black blob
                stimTex(rindTex,cindTex) = gaussNeg; 
        end
          
    end
    
    % LR quadrant
    for i=1:length(stimCodes_LR)
        % Find an acceptable location to put a micropattern
        gdInd   = find(LR);
        thisInd = gdInd(randi(length(gdInd)));
        [r, c]  = ind2sub([imSize,imSize],thisInd);
        
        % Place micropattern centered at that location and blank out a
        % radius of 1 mp width on all sides
        rindTex     = (r-blobSize/2 + 1):(r + blobSize/2);
        cindTex     = (c-blobSize/2 + 1):(c + blobSize/2);
        
        rindBlank   = max((r-blobSize),1):min((r+blobSize),imSize);
        cindBlank   = max((c-blobSize),1):min((c+blobSize),imSize);
        
        LR(rindBlank,cindBlank) = 0; 
        
        switch stimCodes_LR(i),
            case 1, % white blob
                stimTex(rindTex,cindTex) = gaussPos; 
            case 2, % black blob
                stimTex(rindTex,cindTex) = gaussNeg; 
        end
          
    end
    
    
    
end




