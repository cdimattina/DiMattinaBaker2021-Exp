% makeRandThrowGaussStim.m
% 
% DESCRIPTION
% -------------------------------------------------------------------------
% This is a control (or better version of) Aim 1, and 
% will be used in Aim 2 as well for the Gauss-Gabors. 
% The basic idea is that with the jittered grid stimulus,
% there is a potential cue of whether or not there are stimuli
% on the diagonal or anti-diagonal. This stimulus eliminates 
% the jittered grid and places stimuli so that there are no micropatterns
% touching either the diagonal or anti-diagonal. This allows for much
% denser patterns than the jittered grid stimulus, does not create a 
% potential additional cue which observers could use, but still ensures
% that dL remains constant for all stimuli having the same number of
% black/white micropatterns on each side
%
% phase = 0 implies whiter side on left, black on right
% phase = 180 implies opposite
%
% Assume micro-pattern sizes are even
% 

    
function [stimTex,nWL,nBL]  = makeRandThrowGaussStim(gaussInStruct)

    quadStruct  = gaussInStruct.quadStruct; 
    imSize      = gaussInStruct.imSize;
    mpSize      = gaussInStruct.mpSize;      
    nPattSide   = gaussInStruct.nPattSide;
    pWL         = gaussInStruct.pWL;
    ori         = gaussInStruct.ori;
    phase       = gaussInStruct.phase;
    sigma       = gaussInStruct.sigma;
    dodots      = gaussInStruct.dodots;

    % Initialize texture
    stimTex     = zeros(imSize,imSize); 
    
    % Define positive and negative stimuli
    gaussPos    = stimMakeGausWindow2(mpSize,sigma);
    if(dodots)
       gaussPos = ceil(gaussPos); 
    end
    gaussNeg    = -1*gaussPos;
    
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
    
    nWL = round(pWL*nPattSide); 
    nBL  = nPattSide - nWL;
    
    if(rem(nWL,2))      % make sure number of white patterns is even 
        nWL = nWL + 1;  
    end
    if(rem(nBL,2))      % make sure number of black patterns is even
        nBL = nBL - 1; 
    end
    
    % Symmetry
    nBR = nWL; 
    nWR = nBL; 
    
    % Throw white patterns on left side 
    
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
           stimTex(rindTex,cindTex) = gaussPos; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussNeg;
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
           stimTex(rindTex,cindTex) = gaussPos; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussNeg;
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
           stimTex(rindTex,cindTex) = gaussNeg; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussPos;
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
           stimTex(rindTex,cindTex) = gaussNeg; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussPos;
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
           stimTex(rindTex,cindTex) = gaussPos; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussNeg;
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
           stimTex(rindTex,cindTex) = gaussPos; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussNeg;
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
           stimTex(rindTex,cindTex) = gaussNeg; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussPos;
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
           stimTex(rindTex,cindTex) = gaussNeg; 
        elseif(phase==180)
           stimTex(rindTex,cindTex) = gaussPos;
        else
            error('invalid phase');
        end
        
    end
    
    

end


