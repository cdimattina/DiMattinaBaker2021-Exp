% 
% This program makes either a left-oblique or right-oblique boundary
% stimulus. This does not require that the stimulus be rotated, which
% distorts the stimulus slightly
%
% This variant places both black and white Gaussians as well as oriented
% Gabor functions having specified orientation mean and variance on each
% side of the disc. 
%
%
% gaussGaborInStruct fields:
%
% <muORL>       - Gabor mean L
% <muORR>       - Gabor mean R
% <sdORL>       - Gabor sd L
% <sdORR>       - Gabor sd R
%
% <overLap>     - 1: patterns overlap, 0: separate locations 
% <densGauss>   - density of Gauss patterns
% <densGabor>   - density of Gabor patterns 
%

function stimTex = makeGaussGaborStimLR(gaussGaborInStruct, gridStruct)
%function stimTex = makeGaussGaborStimLR(imSize,pWL,ori,phase,dens,mpSize,sigma,jitter,gridStruct)

    imSize      = gaussGaborInStruct.imSize;
    pWL         = gaussGaborInStruct.pWL; 
    ori         = gaussGaborInStruct.ori;
    phase       = gaussGaborInStruct.phase;
    mpSize      = gaussGaborInStruct.mpSize;
    mpSizeGab   = gaussGaborInStruct.mpSizeGab;
    sigma       = gaussGaborInStruct.sigma;
    jitter      = gaussGaborInStruct.jitter;
    dodots      = gaussGaborInStruct.dodots;
    maxdotlum   = gaussGaborInStruct.maxdotlum;
    
    doGauss     = gaussGaborInStruct.doGauss;
    doGabor     = gaussGaborInStruct.doGabor;
    overLap     = gaussGaborInStruct.overLap;
    densGauss   = gaussGaborInStruct.densGauss;
    densGabor   = gaussGaborInStruct.densGabor;
    
    muORL       = gaussGaborInStruct.muORL;
    muORR       = gaussGaborInStruct.muORR;
    sdORL       = gaussGaborInStruct.sdORL;
    sdORR       = gaussGaborInStruct.sdORR;
 
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

    nPointsHalf     = length(gridCL);
    stimTex         = zeros(imSize,imSize);
    
    nGaussHalf      = 0;
    nGaborHalf      = 0;
    
    if(doGauss)
        gaussPos        = stimMakeGausWindow2(mpSize,sigma);
        if(dodots)
           gaussPos = ceil(gaussPos); 
        end
        gaussNeg        = -1*gaussPos;
        
        nGaussHalf      = floor(densGauss*nPointsHalf); 
        
        nWhiteL         = round(pWL*nGaussHalf);
        nBlackL         = nGaussHalf - nWhiteL;
        nWhiteR         = round((1-pWL)*nGaussHalf);
        nBlackR         = nGaussHalf - nWhiteR;
    end

    if(doGabor)
        nGaborHalf      = floor(densGabor*nPointsHalf);
    end
  
    % find occupied spots on left half
    permIndL        = randperm(nPointsHalf);
    
    if(doGauss)
        permIndLGauss   = permIndL(1:nGaussHalf);
        permIndLW       = permIndLGauss(1:nWhiteL);
        permIndLB       = permIndLGauss((nWhiteL + 1):end);
    end
    
    if(doGabor)
        if(overLap)
            permIndLGabor   = permIndLGauss; 
        else    
            permIndLGabor   = permIndL((nGaussHalf + 1):(nGaussHalf + nGaborHalf));
        end
    end
    
    % In case the gauss and gabors overlap, we need to record the jitter
    % for each of the gabors we thow down
    jitRLVec = [];
    jitCLVec = [];
    
    if(doGauss)
        % throw down white patterns - left
        for i=1:nWhiteL

            jitR = randi([-jitter,jitter]); 
            jitC = randi([-jitter,jitter]); 

            if(overLap)
                jitRLVec = [jitRLVec; jitR];
                jitCLVec = [jitCLVec; jitC];
            end
            
            stR = gridRL(permIndLW(i)) - mpSize/2 + 1   + jitR; 
            spR = gridRL(permIndLW(i)) + mpSize/2       + jitR;
            stC = gridCL(permIndLW(i)) - mpSize/2 + 1   + jitC; 
            spC = gridCL(permIndLW(i)) + mpSize/2       + jitC;

            if(phase==0)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussPos; 
            elseif(phase==180)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussNeg; 
            else
                error('phase must be 0 or 180!'); 
            end

        end

        % throw down black patterns - left
        for i=1:nBlackL

            jitR = randi([-jitter,jitter]);
            jitC = randi([-jitter,jitter]); 
            
            if(overLap)
                jitRLVec = [jitRLVec; jitR];
                jitCLVec = [jitCLVec; jitC];
            end
            

            stR = gridRL(permIndLB(i)) - mpSize/2 + 1   + jitR; 
            spR = gridRL(permIndLB(i)) + mpSize/2       + jitR;
            stC = gridCL(permIndLB(i)) - mpSize/2 + 1   + jitC; 
            spC = gridCL(permIndLB(i)) + mpSize/2       + jitC;

            if(phase==0)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussNeg; 
            elseif(phase==180)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussPos; 
            end

        end
    end
    
    % Throw down Gabor patterns on the left side (if applicable)
    if(doGabor)
        for i=1:nGaborHalf
                
            % Choose orientation 
            thisOR = muORL + sdORL*randn;

            % Synethsize odd-phase Gabor with this orientation
            edgelet = makeEdgelet_os_cd('gabor', mpSizeGab, thisOR, 0, 0);
            
            % Overlap
            if(overLap)
                jitR = jitRLVec(i);
                jitC = jitCLVec(i);
            else
                jitR = randi([-jitter,jitter]);
                jitC = randi([-jitter,jitter]);
            end
                
            stR = gridRL(permIndLGabor(i)) - mpSizeGab/2 + 1   + jitR; 
            spR = gridRL(permIndLGabor(i)) + mpSizeGab/2       + jitR;
            stC = gridCL(permIndLGabor(i)) - mpSizeGab/2 + 1   + jitC; 
            spC = gridCL(permIndLGabor(i)) + mpSizeGab/2       + jitC;
            
            stimTex(stR:spR,stC:spC) = stimTex(stR:spR,stC:spC) + maxdotlum*edgelet;
            
        end   
    end
    
    % find occupied spots on right half
    permIndR = randperm(nPointsHalf);
    
     if(doGauss)
        permIndRGauss   = permIndR(1:nGaussHalf);
        permIndRW       = permIndRGauss(1:nWhiteR);
        permIndRB       = permIndRGauss((nWhiteR + 1):end);
    end
    
    if(doGabor)
        if(overLap)
            permIndRGabor   = permIndRGauss; 
        else    
            permIndRGabor   = permIndR((nGaussHalf + 1):(nGaussHalf + nGaborHalf));
        end
    end
    
    % In case the gauss and gabors overlap, we need to record the jitter
    % for each of the gabors we thow down
    jitRRVec = [];
    jitCRVec = [];
    
    if(doGauss)  
        
        % throw down white patterns - right
        for i=1:nWhiteR

            jitR = randi([-jitter,jitter]);
            jitC = randi([-jitter,jitter]); 
            
            if(overLap)
                jitRRVec = [jitRRVec; jitR];
                jitCRVec = [jitCRVec; jitC];
            end
            
            stR = gridRR(permIndRW(i)) - mpSize/2 + 1   + jitR; 
            spR = gridRR(permIndRW(i)) + mpSize/2       + jitR;
            stC = gridCR(permIndRW(i)) - mpSize/2 + 1   + jitC; 
            spC = gridCR(permIndRW(i)) + mpSize/2       + jitC;

            if(phase==0)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussPos; 
            elseif(phase==180)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussNeg; 
            end

        end

        % throw down black patterns - right
        for i=1:nBlackR

            jitR = randi([-jitter,jitter]);
            jitC = randi([-jitter,jitter]); 
            
            if(overLap)
                jitRRVec = [jitRRVec; jitR];
                jitCRVec = [jitCRVec; jitC];
            end

            stR = gridRR(permIndRB(i)) - mpSize/2 + 1   + jitR; 
            spR = gridRR(permIndRB(i)) + mpSize/2       + jitR;
            stC = gridCR(permIndRB(i)) - mpSize/2 + 1   + jitC; 
            spC = gridCR(permIndRB(i)) + mpSize/2       + jitC;

            if(phase==0)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussNeg; 
            elseif(phase==180)
                stimTex(stR:spR,stC:spC) = maxdotlum*gaussPos; 
            end

        end

    end
    
     % Throw down Gabor patterns on the right side (if applicable)
    if(doGabor)
        for i=1:nGaborHalf
                
            % Choose orientation 
            thisOR = muORR + sdORR*randn;

            % Synethsize odd-phase Gabor with this orientation
            edgelet = makeEdgelet_os_cd('gabor', mpSizeGab, thisOR, 0, 0);
            
            % Overlap
            if(overLap)
                jitR = jitRRVec(i);
                jitC = jitCRVec(i);
            else
                jitR = randi([-jitter,jitter]);
                jitC = randi([-jitter,jitter]);
            end
                
            stR = gridRR(permIndRGabor(i)) - mpSizeGab/2 + 1   + jitR; 
            spR = gridRR(permIndRGabor(i)) + mpSizeGab/2       + jitR;
            stC = gridCR(permIndRGabor(i)) - mpSizeGab/2 + 1   + jitC; 
            spC = gridCR(permIndRGabor(i)) + mpSizeGab/2       + jitC;
            
            stimTex(stR:spR,stC:spC) = stimTex(stR:spR,stC:spC) + maxdotlum*edgelet;
            
        end   
    end
    
    
    
    
end