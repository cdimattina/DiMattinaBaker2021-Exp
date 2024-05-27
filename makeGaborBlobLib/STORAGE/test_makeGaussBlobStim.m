
imSize = 256;
pWL    = 0.8;
dens   = 0.5;
mpSize = 8;
sigma  = 2;
jitter = 4; 

phase  = 0; 

load circle_grid_256_16.mat

stimTex = makeGaussBlobStim(imSize,pWL,phase,dens,gridRL,gridRR,gridCL,gridCR,mpSize,sigma,jitter);
stimTexRot45 = imrotate(stimTex,-45,'crop');
stimTexRotBack = imrotate(stimTexRot45,45,'crop');




figure(1);
subplot(1,2,1);
imagesc(stimTex); axis off square;
subplot(1,2,2);
imagesc(stimTexRotBack); axis off square;

dL_orig  = sum(sum(stimTex(:,1:imSize/2))) - sum(sum(stimTex(:,(imSize/2 + 1):imSize)));
dL_rot   = sum(sum(stimTexRotBack(:,1:imSize/2))) - sum(sum(stimTexRotBack(:,(imSize/2 + 1):imSize)));

disp(sprintf('dL_orig = %.2f, dL_rot = %.2f',dL_orig,dL_rot))