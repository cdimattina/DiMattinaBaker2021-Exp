% returns the RMS contrast of the image passed in
function myRMS = SDIm(img)
   
% OLD CODE FROM LIZ *******************************************************
%     imMax = max(img(:));
%     imMin = min(img(:));
%     
%     if imMin < 0 
%         img = img - imMin;
%     end

%     if imMax > 1
%         img = img/imMax;
%     end
    
%    myRMS = std2(img)/mean2(img);
%**************************************************************************
 
% NEW VERSION BY CD - calculates image standard deviation

% Set mean to zero 
 img = img - mean(img(:)); 

 [m,n]  = size(img);
 
 myRMS  = sqrt((1/(m*n))*sum(sum(img.^2)));

end