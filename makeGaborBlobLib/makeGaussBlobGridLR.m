function makeGaussBlobGridLR(imSize,gridSpace)
 
    gridStart   = gridSpace; 
    gridInd     = gridStart:gridSpace:imSize;
    gridDim     = length(gridInd);

    circleMask  = stimMakeCosTaper2(imSize,0);

    URMaskPlot  = zeros(imSize,imSize); 
    LLMaskPlot  = zeros(imSize,imSize);

    ULMaskPlot  = zeros(imSize,imSize); 
    LRMaskPlot  = zeros(imSize,imSize);

    % Masks for left-oblique stimuli
    URMask      = triu(ones(imSize,imSize)) - eye(imSize,imSize); 
    LLMask      = tril(ones(imSize,imSize)) - eye(imSize,imSize); 

    % Restrict to circular region
    URMask      = URMask.*circleMask; 
    LLMask      = LLMask.*circleMask;

    gridRUR = []; gridCUR = [];
    gridRLL = []; gridCLL = []; 

    gridRUL = []; gridCUL = [];
    gridRLR = []; gridCLR = [];

    % Save the list of valid grid points for this size and spacing
    for i = 1:gridDim
       for j = 1:gridDim 

           if(LLMask(gridInd(i),gridInd(j))==1 )
                gridRLL = [gridRLL,gridInd(i)];
                gridCLL = [gridCLL,gridInd(j)];            
                LLMaskPlot(gridInd(i),gridInd(j)) = 1;
           end
           
           gridRLR = gridRLL;
           gridCLR = imSize - gridCLL + 1;
           
           
           if(URMask(gridInd(i),gridInd(j))==1)
                gridRUR = [gridRUR,gridInd(i)];
                gridCUR = [gridCUR,gridInd(j)];            
                URMaskPlot(gridInd(i),gridInd(j)) = 1;
           end
            
           gridRUL = gridRUR;
           gridCUL = imSize - gridCUR + 1;
               
       end
    end

    gridStruct.gridRLL = gridRLL;
    gridStruct.gridCLL = gridCLL; 
    
    gridStruct.gridRUR = gridRUR;
    gridStruct.gridCUR = gridCUR;
    
    gridStruct.gridRUL = gridRUL;
    gridStruct.gridCUL = gridCUL;
    
    gridStruct.gridRLR = gridRLR;
    gridStruct.gridCLR = gridCLR; 
    
    LRMaskPlot = zeros(imSize,imSize);
    for k =1:length(gridRLR)
       LRMaskPlot(gridRLR(k),gridCLR(k)) =1;  
    end
    
    ULMaskPlot = zeros(imSize,imSize);
    for k =1:length(gridRUL)
       ULMaskPlot(gridRUL(k),gridCUL(k)) =1;  
    end
    
    figure; 
    subplot(2,2,1);
    imagesc(LLMaskPlot);
    subplot(2,2,2);
    imagesc(LRMaskPlot);
    
    subplot(2,2,3);
    imagesc(ULMaskPlot);
    subplot(2,2,4);
    imagesc(URMaskPlot);
    
    
    
    outfname = sprintf('circle_grid_LR_%d_%d.mat',imSize,gridSpace);
    save(outfname,'gridStruct');

end