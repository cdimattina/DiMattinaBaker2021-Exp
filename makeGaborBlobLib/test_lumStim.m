function test_lumStim
    
    % This program examines properties of our noise-free luminance defined
    % boundary stimuli, both step edges and gridded gaussian blobs
    
    % For instance, we want to plot a series of luminance discs having
    % different luminance differences between the halves. For each disc
    % we want to quantify both its luminance and RMS contrast
    
    % We also want to plot gaussian luminance textures having similar (or
    % the same)luminance differences and RMS contrast values. 
    
    load circle_grid_256_16.mat
    
    imSize   = 256; 
    phase    = 0;
    taperEdge = 0.1;
    taperMask = 0.2;
    ori        = 0; 
    jitter   = 4; 
    
    sigma    = 2;
    mpSize   = 8;
   
    
    cmap8bit = (1/255)*[(0:255)', (0:255)', (0:255)'];
    colormap(cmap8bit); 
    gray      = 0.5;
    inc       = 0.5; 
    
    deltaLConst  = 0.007;
    densVec      = [0.75];
    nplotD       = length(densVec); 
    pWLVec       = [0.6, 0.65, 0.7, 0.75, 0.8]; 
    nplotP       = length(pWLVec); 
    k            = 1; 
    
    for i=1:nplotD
        for j=1:nplotP

            lumGaussT    = makeGaussBlobStim(256,pWLVec(j),phase,densVec(i),gridRL,gridRR,gridCL,gridCR,mpSize,sigma,jitter);
            dLTemplate   = mean2(lumGaussT(:,1:128)) - mean2(lumGaussT(:,129:end));

            c = deltaLConst/dLTemplate;
            I = gray + c*lumGaussT;

            dL  = mean2(I(:,1:128)) - mean2(I(:,129:end)); 
            RMS = RMScontrast2(I); 

            I8bit = uint8(round(255*I));
            subplot(nplotD,nplotP,k); 
            k = k + 1; 
            image(I8bit); axis square off; 
             title(sprintf('%.3f, %.3f', dL, max(max(abs(I-gray))) ));
           % title(sprintf('%.2f',max(max(abs(I-gray)))));
        end
    end
    
    
%     cvec      = [0.005, 0.01, 0.025, 0.05];
%     nplotD    = length(cvec);
%     
%     lumDiscT  = makeLumDisc(imSize,phase,ori,taperEdge,taperMask);
%     
%     figure(1); colormap(cmap8bit); 
%     for i=1:nplotD
%         I   = gray + cvec(i)*inc*lumDiscT;
%         dL  = mean2(I(:,1:128)) - mean2(I(:,129:end)); 
%         RMS = RMScontrast2(I); 
%         
%         I8bit = uint8(round(255*I));
%         subplot(nplotD,1,i);
%         image(I8bit); axis square off; 
%         title(sprintf('dL = %.3f, RMS = %.3f', dL, RMS));
%     end
%    
%     
%     pWLVec = [0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85]; 
%     nWG    = length(pWLVec);
%     dens   = [0.5 0.7 0.9]; nDn = length(dens);
%     k      = 1;
%     
%     cmax   = 0.4;
%     
%     figure(2);  colormap(cmap8bit); 
%     for i=1:nWG
%         for j=1:nDn
%             lumGaussT = makeGaussBlobStim(imSize,pWLVec(i),phase,dens(j),gridRL,gridRR,gridCL,gridCR,mpSize,sigma);
%             I   = gray + inc*cmax*lumGaussT;
%             dL  = mean2(I(:,1:128)) - mean2(I(:,129:end)); 
%             RMS = RMScontrast2(I); 
% 
%             I8bit = uint8(round(255*I));
%             subplot(nWG,nDn,k); k = k + 1;
%             image(I8bit); axis square off; 
%             title(sprintf('dL:%.3f,RMS:%.3f', dL, RMS));
%         end
%     end
    
    
end