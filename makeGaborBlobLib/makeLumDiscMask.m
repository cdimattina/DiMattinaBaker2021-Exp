% makeNoiseMask.m
% 
% Description:  This program makes a luminance disc 
% 

function noiseMask = makeLumDiscMask(noiseType, sz, thisLev, RMSCont, normRMS, ori, phase, maskstruct)
    
    gr          = 0.5; 
    inc         = 0.5; 
    
    if(nargin < 8)
        taperMask   = stimMakeCosTaper2(sz,0); % always taper 0.2 on edge
        LLMask = tril(ones(sz,sz)) - 0.5*diag(ones(sz,1));
        URMask = triu(ones(sz,sz)) - 0.5*diag(ones(sz,1));    
        LRMask = fliplr(LLMask);
        ULMask = fliplr(URMask);
    else
        taperMask = maskstruct.circleMask;
        LLMask    = maskstruct.LLMask;
        URMask    = maskstruct.URMask;
        LRMask    = maskstruct.LRMask;
        ULMask    = maskstruct.ULMask;
    end
        
    
    if(ori==45)
        % Upper left and lower right
        LMask = ULMask;
        RMask = LRMask;
    elseif(ori==-45)
        % Lower left and upper right 
        LMask = LLMask;
        RMask = URMask;
    else
        error('orientation not supported!'); 
    end
        
    lumH     = gr + inc*thisLev; 
    lumL     = gr - inc*thisLev;
   
    sigmaH   = lumH*RMSCont;
    sigmaL   = (lumL/lumH)*sigmaH;
    
    % Use midpoint luminance for setting RMS contrast
    if(~normRMS)
        sigmaL = gr*RMSCont;
        sigmaH = gr*RMSCont;
    end  
    
    noiseFieldH = randn(sz,sz);
    noiseFieldL = randn(sz,sz);
    
    if(strcmp(noiseType,'white'))
        
        if(phase==0)
           ILeft    = taperMask.*LMask.*(sigmaH*noiseFieldH + inc*thisLev);
           IRight   = taperMask.*RMask.*(sigmaL*noiseFieldL - inc*thisLev);    
        elseif(phase==180)
           ILeft    = taperMask.*LMask.*(sigmaL*noiseFieldL - inc*thisLev);
           IRight   = taperMask.*RMask.*(sigmaH*noiseFieldH + inc*thisLev);  
        end

    else
       error('Noise type not supported!');  
    end
    
   
    noiseMask = gr + ILeft + IRight;    
       
    I = noiseMask;
    
    mx = max(max(I));
    mn = min(min(I)); 
    mC = (mx-mn)/(mx + mn);
    
    disp('RMS Contrasts');
    disp(sprintf('H = %.2f',RMScontrast(lumH + sigmaH*noiseFieldH)));
    disp(sprintf('L = %.2f',RMScontrast(lumL + sigmaL*noiseFieldL))); 
    disp('Scale');
    disp(sprintf('max = %.4f, min = %.4f',mx,mn))
%     
% 
%   
%     figure; 
%     imagesc(I); colormap('gray'); 
%     axis off square; 

  
    
end