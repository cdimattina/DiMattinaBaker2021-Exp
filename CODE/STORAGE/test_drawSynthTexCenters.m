% test_drawSythTex12.m
%

% This directory contains code to make a plain 
% luminance disc
addpath ../makeGaborBlobLib


global mpLibrary o s
load ./CONFIG/mpLibrary_os_12

gaussBlobMax = 0.75;
fTSize      = 256; 
windowMask  = stimMakeCosTaper2(fTSize, 0.2);  
lumDiscRaw  = makeLumDisc(fTSize, 0, 45, 0.1,0.2);

lumLevel    = 0.025;

npatt       = 1024;
mpSize      = 16;
doGauss     = 1;
doGabor     = 0;
propBright  = 0.7;

xCents = round(1 + (fTSize)*rand(npatt,1));%randomize position
yCents = round(1 + (fTSize)*rand(npatt,1));

[~,gaussTex1]   = drawSynthTexCenters(fTSize, npatt,mpSize,doGauss,doGabor,propBright,xCents,yCents);
[~,gaussTex2]           = drawSynthTexCenters(fTSize, npatt,mpSize,doGauss,doGabor,1-propBright,xCents,yCents) ;

xCents = round(1 + (fTSize)*rand(npatt,1));%randomize position
yCents = round(1 + (fTSize)*rand(npatt,1));
% 
% [gaborMask2,~]   = drawSynthTexCenters(fTSize, npatt,mpSize,doGauss,doGabor,propBright,xCents,yCents);
% 
% % Zero-mean gaborMask
% gaborMask   = gaborMask - mean(mean(gaborMask));
% gaborMask   = windowMask.*gaborMask; 
% 
% gaborMask2   = gaborMask2 - mean(mean(gaborMask2));
% gaborMask2   = windowMask.*gaborMask2;
% 
% % Make a series of luminance discs with Gabor mask
% maskRMS     = RMScontrast2(gaborMask);
% %stim.mask.RMSlev 
% 
% RMSLev      = [0 0.01 0.02 0.04 0.08 0.16];



% disp(RMScontrast2(lumLevel*lumDiscRaw))
% 
% for i = 1:length(RMSLev)
%     gaborMaskPlot = (RMSLev(i)/maskRMS)*gaborMask + lumLevel*lumDiscRaw;    
%     gaborMaskPlot = 127.5 + 127.5*gaborMaskPlot;
%     
%     % draw the texture
%     v    = (0:255)';
%     cmap = (1/255)*repmat(v,1,3);
% 
%     figure(i);
%     colormap(cmap);
% 
%     
%     image(round(gaborMaskPlot)); axis square off;
%     title(RMSLev(i))
% end

% Now create a gaussBlob stimulus
stim.size      = fTSize;
stim.env.type = 'halfDisc';
stim.env.taper = 0.2;
stim.env.phase = 0;
stim.env.shift = 0; 
stim.env.ori   = 45; 
stim.modDepth  = 100; 
stim.carrPattA = gaussTex1;
stim.carrPattB = gaussTex2;
stim.winMask   = windowMask;

thisGaussBlob = stimMakeTexQuilt(stim);

% scale down to middle 50% of range
thisGaussBlob = gaussBlobMax*thisGaussBlob;

figure(1); colormap('gray');

thisGaussBlobPlot = 127.7 + 127.5*thisGaussBlob;
v    = (0:255)';
cmap = (1/255)*repmat(v,1,3);
colormap(cmap);

image(thisGaussBlobPlot); axis square off;

% Set RMS contrast of thisGaussBlob
% 
% for i = 1:length(RMSLev)
%     gaborMaskPlot = (RMSLev(i)/maskRMS)*gaborMask + thisGaussBlob;    
%     gaborMaskPlot = 127.5 + 127.5*gaborMaskPlot;
%     
%     % draw the texture
%     v    = (0:255)';
%     cmap = (1/255)*repmat(v,1,3);
%     colormap(cmap);
% 
%     subplot(3,length(RMSLev),i + length(RMSLev));
%     image(round(gaborMaskPlot)); axis square off;
% end
% 
% % Add incoherent Gabor mask
% for i = 1:length(RMSLev)
%     gaborMaskPlot = (RMSLev(i)/maskRMS)*gaborMask2 + thisGaussBlob;    
%     gaborMaskPlot = 127.5 + 127.5*gaborMaskPlot;
%     
%     % draw the texture
%     v    = (0:255)';
%     cmap = (1/255)*repmat(v,1,3);
%     colormap(cmap);
% 
%     subplot(3,length(RMSLev),i + 2*length(RMSLev));
%     image(round(gaborMaskPlot)); axis square off;
% end
% 
