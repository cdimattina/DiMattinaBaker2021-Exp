function stimTex = makeGaussBlobStim(imSize,pWL,phase,dens,gridRL,gridRR,gridCL,gridCR,mpSize,sigma,jitter)
     
    gaussPos        = stimMakeGausWindow2(mpSize,sigma);
    gaussNeg        = -1*gaussPos;
    
    nPointsHalf     = length(gridCL);
    nOccupiedHalf   = round(dens*nPointsHalf); 

    nWhiteL         = round(pWL*nOccupiedHalf);
    nBlackL         = nOccupiedHalf - nWhiteL;
    
    nWhiteR         = round((1-pWL)*nOccupiedHalf);
    nBlackR         = nOccupiedHalf - nWhiteR;
    
    stimTex = zeros(imSize,imSize);
    
    % find occupied spots on left half
    permIndL = randperm(nPointsHalf);
    permIndL = permIndL(1:nOccupiedHalf);
    permIndLW = permIndL(1:nWhiteL);
    permIndLB = permIndL((nWhiteL + 1):end);
    
    % throw down white patterns - left
    for i=1:nWhiteL
        
        jitR = randi([-jitter,jitter]);
        jitC = randi([-jitter,jitter]); 
       
        stR = gridRL(permIndLW(i)) - mpSize/2 + 1   + jitR; 
        spR = gridRL(permIndLW(i)) + mpSize/2       + jitR;
        stC = gridCL(permIndLW(i)) - mpSize/2 + 1   + jitC; 
        spC = gridCL(permIndLW(i)) + mpSize/2       + jitC; 
        
        stimTex(stR:spR,stC:spC) = gaussPos; 
    end
    % throw down black patterns - left
    for i=1:nBlackL
        
        jitR = randi([-jitter,jitter]);
        jitC = randi([-jitter,jitter]); 
        
        stR = gridRL(permIndLB(i)) - mpSize/2 + 1   + jitR; 
        spR = gridRL(permIndLB(i)) + mpSize/2       + jitR;
        stC = gridCL(permIndLB(i)) - mpSize/2 + 1   + jitC; 
        spC = gridCL(permIndLB(i)) + mpSize/2       + jitC;
        stimTex(stR:spR,stC:spC) = gaussNeg; 
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
        stimTex(stR:spR,stC:spC) = gaussPos; 
    end
    % throw down black patterns - right
    for i=1:nBlackR
        
        jitR = randi([-jitter,jitter]);
        jitC = randi([-jitter,jitter]); 
        
        stR = gridRR(permIndRB(i)) - mpSize/2 + 1   + jitR; 
        spR = gridRR(permIndRB(i)) + mpSize/2       + jitR;
        stC = gridCR(permIndRB(i)) - mpSize/2 + 1   + jitC; 
        spC = gridCR(permIndRB(i)) + mpSize/2       + jitC;
        stimTex(stR:spR,stC:spC) = gaussNeg; 
    end
    
    
    if phase == 180
        stimTex = fliplr(stimTex);
    end
 
    
end