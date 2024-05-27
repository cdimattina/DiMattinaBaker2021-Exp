function quadStruct = makeQuadrantMap(imSize, mpSize)
    
    circleMask =stimMakeCosTaper2(imSize,0); 
    figure(1); 

    % augment image by 1 pixel in each dimension
    I                      = zeros(imSize+2, imSize+2); 
    I((2:end-1),(2:end-1)) = circleMask;
    
    nPeel                  = ceil(mpSize/2);
    
    % create matrix to mask diagonal and anti-diagonal
    diagMask     = (1-diag(ones(imSize+2,1)));
    antiDiagMask = fliplr(diagMask); 
    
    I = I.*diagMask.*antiDiagMask;
    
    % iteratively peel off boundary
    for i=1:nPeel
        B = bwperim(I,8); 
        I = I.*(1-B);
    end
   
   I = I((2:end-1),(2:end-1));
    
   % Define quadrants and save quadrants to file
   UTMask = triu(ones(imSize,imSize)) - eye(imSize); 
   LTMask = tril(ones(imSize,imSize)) - eye(imSize);
    
   WMask  = LTMask.*fliplr(UTMask);
   EMask  = UTMask.*fliplr(LTMask);
   NMask  = UTMask.*fliplr(UTMask);
   SMask  = LTMask.*fliplr(LTMask);
   
   quadStruct.WMask = I.*WMask;
   quadStruct.EMask = I.*EMask;
   quadStruct.NMask = I.*NMask;
   quadStruct.SMask = I.*SMask;
   

end