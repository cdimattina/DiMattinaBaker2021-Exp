
load circle_grid_LR_256_20.mat

imSize  = 256;
pWL     = 0.90;
ori     = +45;
phase   = 0; 
dens    = 0.75;
mpSize  = 8;
sigma   = 2;
jitter  = 4;
dodots  = 1; 

LLMask  = tril(ones(imSize,imSize)) - eye(imSize); LRMask = fliplr(LLMask);
URMask  = triu(ones(imSize,imSize)) - eye(imSize); ULMask = fliplr(URMask);

for i=1:1
    stimTex = makeGaussBlobStimLR(imSize,pWL,ori,phase,dens,mpSize,sigma,jitter,dodots,gridStruct);
  
    imagesc(stimTex); colormap('gray'); axis square off; 
    pause(0.1); 
    
    lumL = sum(sum(LRMask.*stimTex));
    lumR = sum(sum(ULMask.*stimTex));
    
    disp(sprintf('dL = %.3f',lumL-lumR));
    
end