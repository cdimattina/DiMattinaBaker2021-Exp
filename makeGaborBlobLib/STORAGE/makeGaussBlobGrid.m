
% addpath ../makeEdgeletLib-cuecomb

imSize     = 128; 
gridSpace  = 8;

gridStart  = gridSpace; 
gridInd    = gridStart:gridSpace:(imSize-gridSpace);
gridDim    = length(gridInd);

gridR      = [];
gridC      = [];

circleMask = stimMakeCosTaper2(imSize,0);
gridPlot   = zeros(imSize,imSize); 

% Save the list of valid grid points for this size and spacing
for i = 1:gridDim
   for j = 1:gridDim 
        if(circleMask(gridInd(i),gridInd(j))==1)
            gridR = [gridR,gridInd(i)];
            gridC = [gridC,gridInd(j)];            
            gridPlot(gridInd(i),gridInd(j)) = 1;
        end
   end
end

% find and save left and right indices
Lind   = find(gridC < imSize/2);
Rind   = find(gridC >= imSize/2);

gridCL = gridC(Lind);
gridCR = gridC(Rind);
gridRL = gridR(Lind);
gridRR = gridR(Rind);

imagesc(gridPlot); axis square off; 
outfname = sprintf('circle_grid_%d_%d.mat',imSize,gridSpace);
save(outfname,'gridR','gridC','gridCL','gridCR','gridRL','gridRR')