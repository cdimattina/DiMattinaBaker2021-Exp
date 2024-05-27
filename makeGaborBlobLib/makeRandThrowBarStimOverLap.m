% makeRandThrowBarStimOverLap.m
% 
% DESCRIPTION
% -------------------------------------------------------------------------
% Same as makeRandThrowBarStim except in this version, the orientaion cue
% and luminance cue can have independent orientations and phases
% 
 
function [stimTex]  = makeRandThrowBarStimOverLap(barInStruct)
    
    quadStruct  = barInStruct.quadStruct; 
    imSize      = barInStruct.imSize;
    mpSize      = barInStruct.mpSize;      
    nPattSide   = barInStruct.nPattSide;
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
    
    % determine luminance boundary proportions
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
        
    
    
    % Compute for the upper-left quadrant the proportion of each
    n_w_v_UL = round((prop_w_UL)*(prop_v_UL)*nPattQuad);
    n_w_h_UL = round((prop_w_UL)*(1-prop_v_UL)*nPattQuad);
    n_b_v_UL = round((1-prop_w_UL)*(prop_v_UL)*nPattQuad);
    n_b_h_UL = round((1-prop_w_UL)*(1-prop_v_UL)*nPattQuad);
    
    n_UL = n_w_v_UL + n_w_h_UL + n_b_v_UL + n_b_h_UL;
    
    disp(sprintf('UPPER-LEFT-QUADRANT (%d): n_w_v: %d, n_w_h: %d, n_b_v: %d, n_b_h: %d',n_UL,n_w_v_UL,n_w_h_UL,n_b_v_UL,n_b_h_UL));
    
    % Compute for the lower-left quadrant the proportion of each
    n_w_v_LL = round((prop_w_LL)*(prop_v_LL)*nPattQuad);
    n_w_h_LL = round((prop_w_LL)*(1-prop_v_LL)*nPattQuad);
    n_b_v_LL = round((1-prop_w_LL)*(prop_v_LL)*nPattQuad);
    n_b_h_LL = round((1-prop_w_LL)*(1-prop_v_LL)*nPattQuad);
    
    n_LL = n_w_v_LL + n_w_h_LL + n_b_v_LL + n_b_h_LL;
    
    disp(sprintf('LOWER-LEFT-QUADRANT (%d): n_w_v: %d, n_w_h: %d, n_b_v: %d, n_b_h: %d',n_LL,n_w_v_LL,n_w_h_LL,n_b_v_LL,n_b_h_LL));
    
    % Compute for the upper-right quadrant the proportion of each
    n_w_v_UR = round((prop_w_UR)*(prop_v_UR)*nPattQuad);
    n_w_h_UR = round((prop_w_UR)*(1-prop_v_UR)*nPattQuad);
    n_b_v_UR = round((1-prop_w_UR)*(prop_v_UR)*nPattQuad);
    n_b_h_UR = round((1-prop_w_UR)*(1-prop_v_UR)*nPattQuad);
    
    n_UR = n_w_v_UR + n_w_h_UR + n_b_v_UR + n_b_h_UR;
    
    disp(sprintf('UPPER-RIGHT-QUADRANT (%d): n_w_v: %d, n_w_h: %d, n_b_v: %d, n_b_h: %d',n_UR, n_w_v_UR,n_w_h_UR,n_b_v_UR,n_b_h_UR));
     
    % Compute for the lower-right quadrant the proportion of each
    n_w_v_LR = round((prop_w_LR)*(prop_v_LR)*nPattQuad);
    n_w_h_LR = round((prop_w_LR)*(1-prop_v_LR)*nPattQuad);
    n_b_v_LR = round((1-prop_w_LR)*(prop_v_LR)*nPattQuad);
    n_b_h_LR = round((1-prop_w_LR)*(1-prop_v_LR)*nPattQuad);
    
    n_LR = n_w_v_LR + n_w_h_LR + n_b_v_LR + n_b_h_LR;
    
    disp(sprintf('LOWER-RIGHT-QUADRANT (%d): n_w_v: %d, n_w_h: %d, n_b_v: %d, n_b_h: %d',n_LR,n_w_v_LR,n_w_h_LR,n_b_v_LR,n_b_h_LR));
    
  
    % Throw micro-patterns
    
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
    
    % UR quadrant
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
    
    
    
    
end




% function [stimTex,nWL,nBL,nVL,nHL]  = makeRandThrowBarStimOverLap(barInStruct)
% 
%     quadStruct  = barInStruct.quadStruct; 
%     imSize      = barInStruct.imSize;
%     mpSize      = barInStruct.mpSize;      
%     nPattSide   = barInStruct.nPattSide;
%     pWL         = barInStruct.pWL;
%     ori         = barInStruct.ori;
%     phase       = barInStruct.phase;
%     
%     % Proportion of bars vertical on left half (
%     pVL         = barInStruct.pVL;
%     barW        = barInStruct.barW;
%     barL        = barInStruct.barL;
%      
%     % Initialize texture
%     stimTex     = zeros(imSize,imSize); 
%     
%     barVPos = makeVBar(mpSize,barW,barL);
%     barVNeg = -1*barVPos;
% 
%     barHPos = barVPos';
%     barHNeg = barVNeg';
%     
%     if(ori==45)
%         UL = quadStruct.NMask;
%         LL = quadStruct.WMask;
%         UR = quadStruct.EMask;
%         LR = quadStruct.SMask;
%     elseif(ori==-45)
%         UL = quadStruct.WMask;
%         LL = quadStruct.SMask;
%         UR = quadStruct.NMask;
%         LR = quadStruct.EMask;
%     else
%         error('phase must be +45 or -45');  
%     end
%     
%     % if nPattSide is even, we always get even nWL, nBL
%     nWL = round(pWL*nPattSide);  
%     if(rem(nWL,2))      % make sure number of white patterns is a multiple of 2 
%         nWL = nWL + 1;  
%     end
%     nBL = nPattSide - nWL;
%     
%     % If nPattSide is even, we always get even nVL, nBL
%     nVL = round(pVL*nPattSide); 
%     if(rem(nVL,2))
%         nVL = nVL + 1; 
%     end
%     nHL = nPattSide - nVL; 
%     
%     % Symmetry
%     nBR = nWL; 
%     nWR = nBL; 
%     
%     nHR = nVL;
%     nVR = nHL; 
%     
%     % Throw white patterns on left side 
%     
%     % Number of patterns is even
%     vbarULVec = zeros(nPattSide/2,1); 
%     vbarLLVec = zeros(nPattSide/2,1); 
%     
%     vbarURVec = zeros(nPattSide/2,1); 
%     vbarLRVec = zeros(nPattSide/2,1); 
%     
%     % Designate nVL/2 spots on the left side as containing a vertical bar
%     % All other spots will contain a horizontal bar
%     
%     tempRP    = randperm(nPattSide/2); 
%     vbarULVec(tempRP(1:(nVL/2))) = 1;  
%     
%     tempRP    = randperm(nPattSide/2); 
%     vbarLLVec(tempRP(1:(nVL/2))) = 1; 
%     
%     tempRP    = randperm(nPattSide/2); 
%     vbarURVec(tempRP(1:(nVR/2))) = 1; 
%     
%     tempRP    = randperm(nPattSide/2); 
%     vbarLRVec(tempRP(1:(nVR/2))) = 1; 
%     
%          
%     % upper left
%     for i=1:(nWL/2)   
%         % Find an acceptable location to put a micropattern
%         gdInd   = find(UL);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         UL(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarULVec(i))
%                 stimTex(rindTex,cindTex) = barVPos; 
%             else
%                 stimTex(rindTex,cindTex) = barHPos; 
%             end
%         elseif(phase==180)
%             if(vbarULVec(i))
%                 stimTex(rindTex,cindTex) = barVNeg;
%             else
%                 stimTex(rindTex,cindTex) = barHNeg;
%             end
%         else
%             error('invalid phase');
%         end  
%     end
%     
%     % lower left
%     for i=1:(nWL/2)
%          % Find an acceptable location to put a micropattern
%         gdInd   = find(LL);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         LL(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarLLVec(i))
%                 stimTex(rindTex,cindTex) = barVPos; 
%             else
%                 stimTex(rindTex,cindTex) = barHPos; 
%             end
%         elseif(phase==180)
%             if(vbarLLVec(i))
%                 stimTex(rindTex,cindTex) = barVNeg;
%             else
%                 stimTex(rindTex,cindTex) = barHNeg;
%             end
%         else
%             error('invalid phase');
%         end  
%         
%     end
%     
%     % Throw black patterns on left side
%  
%     % upper left
%     for i=1:(nBL/2)   
%         % Find an acceptable location to put a micropattern
%         gdInd   = find(UL);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         UL(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarULVec(i + nWL/2))
%                 stimTex(rindTex,cindTex) = barVNeg; 
%             else
%                 stimTex(rindTex,cindTex) = barHNeg; 
%             end
%         elseif(phase==180)
%             if(vbarULVec(i + nWL/2))
%                 stimTex(rindTex,cindTex) = barVPos;
%             else
%                 stimTex(rindTex,cindTex) = barHPos;
%             end
%         else
%             error('invalid phase');
%         end  
% 
%     end
% 
%     % lower left
%     for i=1:(nBL/2)
%          % Find an acceptable location to put a micropattern
%         gdInd   = find(LL);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         LL(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarLLVec(i + nWL/2))
%                 stimTex(rindTex,cindTex) = barVNeg; 
%             else
%                 stimTex(rindTex,cindTex) = barHNeg; 
%             end
%         elseif(phase==180)
%             if(vbarLLVec(i + nWL/2))
%                 stimTex(rindTex,cindTex) = barVPos;
%             else
%                 stimTex(rindTex,cindTex) = barHPos;
%             end
%         else
%             error('invalid phase');
%         end  
%         
%     end
%     
%     % Throw white patterns on the right side
%     
%     % upper right
%     for i=1:(nWR/2)   
%         % Find an acceptable location to put a micropattern
%         gdInd   = find(UR);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         UR(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarURVec(i))
%                 stimTex(rindTex,cindTex) = barVPos; 
%             else
%                 stimTex(rindTex,cindTex) = barHPos; 
%             end
%         elseif(phase==180)
%             if(vbarURVec(i))
%                 stimTex(rindTex,cindTex) = barVNeg;
%             else
%                 stimTex(rindTex,cindTex) = barHNeg;
%             end
%         else
%             error('invalid phase');
%         end  
%         
%     end
%     
%     % lower right
%     for i=1:(nWR/2)
%          % Find an acceptable location to put a micropattern
%         gdInd   = find(LR);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         LR(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarLRVec(i))
%                 stimTex(rindTex,cindTex) = barVPos; 
%             else
%                 stimTex(rindTex,cindTex) = barHPos; 
%             end
%         elseif(phase==180)
%             if(vbarLRVec(i))
%                 stimTex(rindTex,cindTex) = barVNeg;
%             else
%                 stimTex(rindTex,cindTex) = barHNeg;
%             end
%         else
%             error('invalid phase');
%         end  
%         
%     end
%     
%     % Throw black patterns on the right side
%     
%     % upper right
%     for i=1:(nBR/2)   
%         % Find an acceptable location to put a micropattern
%         gdInd   = find(UR);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         UR(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarURVec(i + nWR/2))
%                 stimTex(rindTex,cindTex) = barVNeg; 
%             else
%                 stimTex(rindTex,cindTex) = barHNeg; 
%             end
%         elseif(phase==180)
%             if(vbarURVec(i + nWR/2))
%                 stimTex(rindTex,cindTex) = barVPos;
%             else
%                 stimTex(rindTex,cindTex) = barHPos;
%             end
%         else
%             error('invalid phase');
%         end  
%     end
%     
%     % lower right
%     for i=1:(nBR/2)
%          % Find an acceptable location to put a micropattern
%         gdInd   = find(LR);
%         thisInd = gdInd(randi(length(gdInd)));
%         [r, c]  = ind2sub([imSize,imSize],thisInd);
%         
%         % Place micropattern centered at that location and blank out a
%         % radius of 1 mp width on all sides
%         rindTex     = (r-mpSize/2 + 1):(r + mpSize/2);
%         cindTex     = (c-mpSize/2 + 1):(c + mpSize/2); 
%         
%         rindBlank   = max((r-mpSize),1):min((r+mpSize),imSize);
%         cindBlank   = max((c-mpSize),1):min((c+mpSize),imSize);
%         
%         LR(rindBlank,cindBlank) = 0; 
%         
%         if(phase==0)
%             if(vbarLRVec(i + nWR/2))
%                 stimTex(rindTex,cindTex) = barVNeg; 
%             else
%                 stimTex(rindTex,cindTex) = barHNeg; 
%             end
%         elseif(phase==180)
%             if(vbarLRVec(i + nWR/2))
%                 stimTex(rindTex,cindTex) = barVPos;
%             else
%                 stimTex(rindTex,cindTex) = barHPos;
%             end
%         else
%             error('invalid phase');
%         end  
% 
%         
%     end
%     
%     
% 
% end
% 

