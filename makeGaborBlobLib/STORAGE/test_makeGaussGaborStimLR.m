% this is the test program for makeGaussGaborStimLR.m

    load circle_grid_LR_256_20.mat  

    gaussGaborInStruct.imSize   = 256;
    gaussGaborInStruct.pWL      = 0.5; 
    if(rand < 0.5)
        gaussGaborInStruct.ori      = +45;
    else
        gaussGaborInStruct.ori      = -45;  
    end
    gaussGaborInStruct.phase    = 0;
    gaussGaborInStruct.mpSize   = 10;
    gaussGaborInStruct.mpSizeGab = 10;
    gaussGaborInStruct.sigma    = 2;
    gaussGaborInStruct.jitter   = 4;
    gaussGaborInStruct.dodots   = 0;
    
    gaussGaborInStruct.maxdotlum = 0.2; 
    
    gaussGaborInStruct.doGauss      = 0;
    gaussGaborInStruct.doGabor      = 1;
    gaussGaborInStruct.overLap      = 0;
    gaussGaborInStruct.densGauss    = 0.25;
    gaussGaborInStruct.densGabor    = 0.25;
    
    gaussGaborInStruct.muORL        = 0;
    gaussGaborInStruct.muORR        = 90;
    
    gaussGaborInStruct.sdORL    = 0;
    gaussGaborInStruct.sdORR    = 0; 
    
    stimTex = makeGaussGaborStimLR(gaussGaborInStruct, gridStruct);
    
  
    figure(1);
    imagesc(stimTex); axis square off; colormap('gray'); 