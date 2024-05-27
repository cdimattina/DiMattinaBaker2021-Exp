% FUNCTION: drawSynthTexNatCD - draw a single micropattern texture
%  
% usage:  littletex = drawSynthTexNat(fTSize, npatt, mpCode, mpOris, mpSizes)
%
% args:  fTsize -- final texture size (480)
%        nPatt  -- number of micropatterns (some multiple of 85)
%        mpType -- numerical index for micropattern type (same as mpCode)
%                       3 - gabor,         intact
%                       10- pos_gaussian   intact ("light_blob")
%                       11- neg_gaussian   intact ("dark_blob", negative of #10)
%        mpOris  -- micropattern orientation
%        mpSizes -- micropattern size
%
% global:
%       mpLibrary - micropattern library (produced by makeEdgeletLib_os)
%       s - index for which size of micropattern
%       o - index for which orientation of micropattern
%
% textures are [0-255] with mean/background = 127.5
% textures are NOT rms-normalized; and for gaussian textures, not luminance-equated

% written by Elizabeth Arsenault (now Zavitz), 2012-2013

% recent changes:
% 16 Sept 2013, CB: changed RandSample to randsample
% 20 Sept 2013, CB: modify final "normalization" to ensure zero-background for gaussians
% 
% CD is Chris DiMattina, visitor from FGCU (cdimattina@fgcu.edu)
% 23 May  2016, CD: added ability to handle single micro-pattern sizes 
%
%

% needs to run:
% (PsychToolbox - for RandSample, which is NOT same as Matlab's randsample !)

% see also:
%   test_drawSynthTexNat.m 


function [gaborTex,gaussTex] = drawSynthTexCenters(fTSize, npatt,mpSize,doGauss,doGabor,propBright,xCents,yCents)

% mpLibrary variables:
% mpLibrary -- the library itself
% s         -- index for mp by size
% o         -- index for mp by orientation
% nVari     -- number of variations of scrambled micropatterns in library

global mpLibrary o s

tSize    = fTSize + mpSize;           % texture size
gaborTex = zeros(tSize);              % initialize texture canvas
gaussTex = zeros(tSize);
            

% obtain library indicies for size
si   = find(s == mpSize);
nori = length(o);


for i = 1:npatt 
    
    % centers
    posx = xCents(i);
    posy = yCents(i);
    
    % random orientation
    oi = randi(nori);
    
    if(doGauss)
        if(rand < propBright)
            gaussCode = 2;
        else
            gaussCode = 3; 
        end
        micropatternGauss = mpLibrary{gaussCode, si, oi}; %look up micropattern
        
        gaussTex(posx:posx+mpSize-1, posy:posy+mpSize-1) = ...  %place micropattern in position   
        gaussTex(posx:posx+mpSize-1, posy:posy+mpSize-1) + micropatternGauss;   
    end
    
    if(doGabor)
        micropatternGabor = mpLibrary{1,si,oi};
        gaborTex(posx:posx+mpSize-1, posy:posy+mpSize-1) = ...  %place micropattern in position   
        gaborTex(posx:posx+mpSize-1, posy:posy+mpSize-1) + micropatternGabor;  
    end
        
end

% trim and window
trim        = (tSize-fTSize)/2;
gaborTex    = gaborTex(trim:end-trim-1, trim:end-trim-1);
gaussTex    = gaussTex(trim:end-trim-1, trim:end-trim-1);

if(doGabor)
     gaborTex = gaborTex - mean(mean(gaborTex));
end
 
gaborTex = gaborTex./max(max(abs(gaborTex)));  % range between -1 and +1
gaussTex = gaussTex./max(max(abs(gaussTex)));  % range between -1 and +1

end
 
 