function winMask = stimMakeGausWindow2 (s, sigma)


% written by Elizabeth Arsenault (now Zavitz), 2012-2013

% Modified by CD to make perfectly symmetric Gaussians

winMask = fspecial('gaussian',s,sigma);  % make 2d gaussian filter

winMask = winMask ./ max(winMask(:));  % Make the maximum window value be 1.
radSq = (s/2)^2;    
	
cenX = round(s/2) + 0.5;		% note posn.x, posn.y handled in run_csm
cenY = round(s/2) + 0.5;
	
% $$- should vectorize this:
for iy=1:s
    for ix=1:s
        if (((ix-cenX)^2+(iy-cenY)^2)>radSq)
                winMask(ix,iy)=0; % clip outside the circle in case it hasn't settled to zero 
        end
    end
end
    
clear radSq;  clear cenX;  clear cenY;  clear ix;  clear iy;
