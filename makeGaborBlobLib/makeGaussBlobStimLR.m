% 
% This program makes either a left-oblique or right-oblique boundary
% stimulus. This does not require that the stimulus be rotated, which
% distorts the stimulus slightly
%
%

function stimTex = makeGaussBlobStimLR(imSize,pWL,ori,phase,dens,mpSize,sigma,jitter,dodots,gridStruct)
  
    if(ori==-45)        % left-oblique  : left side bottom (LL), right side top (UR) 
       gridRL = gridStruct.gridRLL;
       gridCL = gridStruct.gridCLL;
       
       gridRR = gridStruct.gridRUR;
       gridCR = gridStruct.gridCUR;
       
    elseif(ori == 45)   % right-oblique : left side top (UL), right side bottom (LR)
       gridRL = gridStruct.gridRUL;
       gridCL = gridStruct.gridCUL;
       
       gridRR = gridStruct.gridRLR;
       gridCR = gridStruct.gridCLR;
    else
        error('Orientation must be either +45 (right-oblique) or -45 deg (left-oblique)'); 
    end

    gaussPos        = stimMakeGausWindow2(mpSize,sigma);
    if(dodots)
       gaussPos = ceil(gaussPos); 
    end
    
    gaussNeg        = -1*gaussPos;
    
    nPointsHalf     = length(gridCL);
    nOccupiedHalf   = round(dens*nPointsHalf); 

    nWhiteL         = round(pWL*nOccupiedHalf);
    nBlackL         = nOccupiedHalf - nWhiteL;
    
    nWhiteR         = round((1-pWL)*nOccupiedHalf);
    nBlackR         = nOccupiedHalf - nWhiteR;
    
    stimTex         = zeros(imSize,imSize);
    
    % find occupied spots on left half
    permIndL        = randperm(nPointsHalf);
    permIndL        = permIndL(1:nOccupiedHalf);
    permIndLW       = permIndL(1:nWhiteL);
    permIndLB       = permIndL((nWhiteL + 1):end);
    
    % throw down white patterns - left
    for i=1:nWhiteL
        
        jitR = randi([-jitter,jitter]);
        jitC = randi([-jitter,jitter]); 
       
        stR = gridRL(permIndLW(i)) - mpSize/2 + 1   + jitR; 
        spR = gridRL(permIndLW(i)) + mpSize/2       + jitR;
        stC = gridCL(permIndLW(i)) - mpSize/2 + 1   + jitC; 
        spC = gridCL(permIndLW(i)) + mpSize/2       + jitC;
    
        if(phase==0)
            stimTex(stR:spR,stC:spC) = gaussPos; 
        elseif(phase==180)
            stimTex(stR:spR,stC:spC) = gaussNeg; 
        else
            error('phase must be 0 or 180!'); 
        end
        
    end
    
    % throw down black patterns - left
    for i=1:nBlackL
        
        jitR = randi([-jitter,jitter]);
        jitC = randi([-jitter,jitter]); 
        
        stR = gridRL(permIndLB(i)) - mpSize/2 + 1   + jitR; 
        spR = gridRL(permIndLB(i)) + mpSize/2       + jitR;
        stC = gridCL(permIndLB(i)) - mpSize/2 + 1   + jitC; 
        spC = gridCL(permIndLB(i)) + mpSize/2       + jitC;
        
        if(phase==0)
            stimTex(stR:spR,stC:spC) = gaussNeg; 
        elseif(phase==180)
            stimTex(stR:spR,stC:spC) = gaussPos; 
        end
    
    end
    
    % find occupied spots on right half
    permIndR = randperm(nPointsHalf);
    permIndR = permIndR(1:nOccupiedHalf);
    permIndRW = permIndR(1:nWhiteR);
    permIndRB = permIndR((nWhiteR + 1):end);
    
    % throw down white patterns - right
    for i=1:nWhiteR
        
        jitR = randi([-jitter,jitter]);
        jitC = randi([-jitter,jitter]); 
        
        stR = gridRR(permIndRW(i)) - mpSize/2 + 1   + jitR; 
        spR = gridRR(permIndRW(i)) + mpSize/2       + jitR;
        stC = gridCR(permIndRW(i)) - mpSize/2 + 1   + jitC; 
        spC = gridCR(permIndRW(i)) + mpSize/2       + jitC;
        
        if(phase==0)
            stimTex(stR:spR,stC:spC) = gaussPos; 
        elseif(phase==180)
            stimTex(stR:spR,stC:spC) = gaussNeg; 
        end
        
    
    end
    
    % throw down black patterns - right
    for i=1:nBlackR
        
        jitR = randi([-jitter,jitter]);
        jitC = randi([-jitter,jitter]); 
        
        stR = gridRR(permIndRB(i)) - mpSize/2 + 1   + jitR; 
        spR = gridRR(permIndRB(i)) + mpSize/2       + jitR;
        stC = gridCR(permIndRB(i)) - mpSize/2 + 1   + jitC; 
        spC = gridCR(permIndRB(i)) + mpSize/2       + jitC;
        
        if(phase==0)
            stimTex(stR:spR,stC:spC) = gaussNeg; 
        elseif(phase==180)
            stimTex(stR:spR,stC:spC) = gaussPos; 
        end
        
    end
    
   
end