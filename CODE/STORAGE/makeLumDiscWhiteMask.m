% makeLumDiscGaborMask.m
% by
% Christopher DiMattina @ FGCU
% 
% 

function thisStimImage = makeLumDiscWhiteMask(stim,thisLumLevel,maskRMS,normRMS )

    circMask  = stimMakeCosTaper2(stim.size,stim.env.taper);
    lumDisc   = stimMakeEnvPattPsy(stim.env,stim.size).*circMask;

  %  maskRaw   = drawSynthTexNatRaw(stim.size, stim.mask.dens, 1, o);
   
    maskRaw   = randn(stim.size/stim.mask.grain,stim.size/stim.mask.grain);
    maskRaw   = imresize(maskRaw,stim.mask.grain);
    
    maskRaw   = maskRaw - mean2(maskRaw);
    sigmaA    = std2(maskRaw);      % empirical SD of mask pattern

    gry       = 0.5; 
    inc       = 0.5;

    if(normRMS)

        lumH    = gry + thisLumLevel*inc; 
        lumL    = gry - thisLumLevel*inc; 

        sigmaDH = lumH*maskRMS;
        sigmaDL = lumL*maskRMS;

        maskH   = (sigmaDH/sigmaA)*maskRaw;
        maskL   = (sigmaDL/sigmaA)*maskRaw;

        if(stim.env.phase==0)
            stim.carrPattA = maskH;
            stim.carrPattB = maskL;
        else
            stim.carrPattA = maskL;
            stim.carrPattB = maskH;
        end

        stim.modDepth = 100; 
        stim.winMask  = circMask; 

        quiltMask     = stimMakeTexQuilt(stim); 

        thisStimImage = gry + (thisLumLevel*inc*lumDisc + quiltMask);

    else

        sigmaD        = gry*maskRMS;
        thisMask      = (sigmaD/sigmaA)*maskRaw; 


        thisStimImage     = gry + (thisLumLevel*inc*lumDisc + thisMask).*circMask;

    end

    % figure; imagesc(thisStimImage); axis square off; colormap('gray');

end
