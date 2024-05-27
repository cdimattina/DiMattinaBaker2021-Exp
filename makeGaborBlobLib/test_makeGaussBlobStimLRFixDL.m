
load circle_grid_LR_256_20.mat

imSize  = 256;
ori     = 45;
phase   = 0; 
dens    = 0.75;
mpSize  = 8;
sigma   = 2;
jitter  = 4;
dodots  = 0; 

nWL = 8;
nCL = 8; 

LLMask  = tril(ones(imSize,imSize)) - eye(imSize); LRMask = fliplr(LLMask);
URMask  = triu(ones(imSize,imSize)) - eye(imSize); ULMask = fliplr(URMask);

% stimTex = makeGaussBlobStimLRFixDL(imSize,nWL,nCL,ori,phase,mpSize,sigma,jitter,dodots,gridStruct)

for i=1:1
    stimTex = makeGaussBlobStimLRFixDL(imSize,nWL,nCL,ori,phase,mpSize,sigma,jitter,dodots,gridStruct);
  
    imagesc(stimTex); colormap('gray'); axis square off; 
    pause(0.1); 
    
    lumL = sum(sum(LRMask.*stimTex));
    lumR = sum(sum(ULMask.*stimTex));
    
    disp(sprintf('dL = %.3f',lumL-lumR));
    
end