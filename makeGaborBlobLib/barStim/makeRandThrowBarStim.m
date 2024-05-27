% makeRandThrowBarStim.m
% 
% DESCRIPTION
% -------------------------------------------------------------------------
% Same as makeRandThrowGaussStim except here the gabors/dots have 
% been replaced with vertical and horizonal bars 
%
% phase = 0 implies whiter side on left, black on right
% phase = 180 implies opposite
%
% Assume micro-pattern sizes are even
% 
% 
    
function [stimTex,nWL,nBL,nVL,nHL]  = makeRandThrowBarStim(barInStruct)

    quadStruct  = barInStruct.quadStruct; 
    imSize      = barInStruct.imSize;
    mpSize      = barInStruct.mpSize;      
    nPattSide   = barInStruct.nPattSide;
    pWL         = barInStruct.pWL;
    ori         = barInStruct.ori;
    phase       = barInStruct.phase;
    
    % Proportion of bars vertical on left half
    pVL         = barInStruct.pVL;
    barW        = barInStruct.barW;
    barL        = barInStruct.barL;
     
    % Initialize texture
    stimTex     = zeros(imSize,imSize); 
    
    barVPos = makeVBar(mpSize,barW,barL);
    barVNeg = -1*barVPos;

    barHPos = barVPos';
    barHNeg = barVNeg';
    
    if(ori==45)
        UL = quadStruct.NMask;
        LL = quadStruct.WMask;
        UR = quadStruct.EMask;
        LR = quadStruct.SMask;
    elseif(ori==-45)
        UL = quadStruct.WMask;
        LL = quadStruct.SMask;
        UR = quadStruct.NMask;
        LR = quadStruct.EMask;
    else
        error('phase must be +45 or -45');  
    end
    
    % if nPattSide is even, we always get even nWL, nBL
    nWL = round(pWL*nPattSide);  
    if(rem(nWL,2))      % make sure number of white patterns is a multiple of 2 
        nWL = nWL + 1;  
    end
    nBL = nPattSide - nWL;
    
    % If nPattSide is even, we always get even nVL, nBL
    nVL = round(pVL*nPattSide); 
    if(rem(nVL,2))
        nVL = nVL + 1; 
    end
    nHL = nPattSide - nVL; 
    
    % Symmetry
    nBR = nWL; 
    nWR = nBL; 
    
    nHR = nVL;
    nVR = nHL; 
    
    % Throw white patterns on left side 
    
    % Number of patterns is even
    vbarULVec = zeros(nPattSide/2,1); 
    vbarLLVec = zeros(nPattSide/2,1); 
    
    vbarURVec = zeros(nPattSide/2,1); 
    vbarLRVec = zeros(nPattSide/2,1); 
    
    % Designate nVL/2 spots on the left side as containing a vertical bar
    % All other spots will contain a horizontal bar
    
    tempRP    = randperm(nPattSide/2); 
    vbarULVec(tempRP(1:(nVL/2))) = 1;  
    
    tempRP    = randperm(nPattSide/2); 
    vbarLLVec(tempRP(1:(nVL/2))) = 1; 
    
    tempRP    = randperm(nPattSide/2); 
    vbarURVec(tempRP(1:(nVR/2))) = 1; 
    
    tempRP    = randperm(nPattSide/2); 
    vbarLRVec(tempRP(1:(nVR/2))) = 1; 
    
         
    % upper left
    for i=1:(nWL/2)   
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
        
        if(phase==0)
            if(vbarULVec(i))
                stimTex(rindTex,cindTex) = barVPos; 
            else
                stimTex(rindTex,cindTex) = barHPos; 
            end
        elseif(phase==180)
            if(vbarULVec(i))
                stimTex(rindTex,cindTex) = barVNeg;
            else
                stimTex(rindTex,cindTex) = barHNeg;
            end
        else
            error('invalid phase');
        end  
    end
    
    % lower left
    for i=1:(nWL/2)
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
        
        if(phase==0)
            if(vbarLLVec(i))
                stimTex(rindTex,cindTex) = barVPos; 
            else
                stimTex(rindTex,cindTex) = barHPos; 
            end
        elseif(phase==180)
            if(vbarLLVec(i))
                stimTex(rindTex,cindTex) = barVNeg;
            else
                stimTex(rindTex,cindTex) = barHNeg;
            end
        else
            error('invalid phase');
        end  
        
    end
    
    % Throw black patterns on left side
 
    % upper left
    for i=1:(nBL/2)   
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
        
        if(phase==0)
            if(vbarULVec(i + nWL/2))
                stimTex(rindTex,cindTex) = barVNeg; 
            else
                stimTex(rindTex,cindTex) = barHNeg; 
            end
        elseif(phase==180)
            if(vbarULVec(i + nWL/2))
                stimTex(rindTex,cindTex) = barVPos;
            else
                stimTex(rindTex,cindTex) = barHPos;
            end
        else
            error('invalid phase');
        end  

    end

    % lower left
    for i=1:(nBL/2)
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
        
        if(phase==0)
            if(vbarLLVec(i + nWL/2))
                stimTex(rindTex,cindTex) = barVNeg; 
            else
                stimTex(rindTex,cindTex) = barHNeg; 
            end
        elseif(phase==180)
            if(vbarLLVec(i + nWL/2))
                stimTex(rindTex,cindTex) = barVPos;
            else
                stimTex(rindTex,cindTex) = barHPos;
            end
        else
            error('invalid phase');
        end  
        
    end
    
    % Throw white patterns on the right side
    
    % upper right
    for i=1:(nWR/2)   
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
        
        if(phase==0)
            if(vbarURVec(i))
                stimTex(rindTex,cindTex) = barVPos; 
            else
                stimTex(rindTex,cindTex) = barHPos; 
            end
        elseif(phase==180)
            if(vbarURVec(i))
                stimTex(rindTex,cindTex) = barVNeg;
            else
                stimTex(rindTex,cindTex) = barHNeg;
            end
        else
            error('invalid phase');
        end  
        
    end
    
    % lower right
    for i=1:(nWR/2)
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
        
        if(phase==0)
            if(vbarLRVec(i))
                stimTex(rindTex,cindTex) = barVPos; 
            else
                stimTex(rindTex,cindTex) = barHPos; 
            end
        elseif(phase==180)
            if(vbarLRVec(i))
                stimTex(rindTex,cindTex) = barVNeg;
            else
                stimTex(rindTex,cindTex) = barHNeg;
            end
        else
            error('invalid phase');
        end  
        
    end
    
    % Throw black patterns on the right side
    
    % upper right
    for i=1:(nBR/2)   
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
        
        if(phase==0)
            if(vbarURVec(i + nWR/2))
                stimTex(rindTex,cindTex) = barVNeg; 
            else
                stimTex(rindTex,cindTex) = barHNeg; 
            end
        elseif(phase==180)
            if(vbarURVec(i + nWR/2))
                stimTex(rindTex,cindTex) = barVPos;
            else
                stimTex(rindTex,cindTex) = barHPos;
            end
        else
            error('invalid phase');
        end  
    end
    
    % lower right
    for i=1:(nBR/2)
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
        
        if(phase==0)
            if(vbarLRVec(i + nWR/2))
                stimTex(rindTex,cindTex) = barVNeg; 
            else
                stimTex(rindTex,cindTex) = barHNeg; 
            end
        elseif(phase==180)
            if(vbarLRVec(i + nWR/2))
                stimTex(rindTex,cindTex) = barVPos;
            else
                stimTex(rindTex,cindTex) = barHPos;
            end
        else
            error('invalid phase');
        end  

        
    end
    
    

end


