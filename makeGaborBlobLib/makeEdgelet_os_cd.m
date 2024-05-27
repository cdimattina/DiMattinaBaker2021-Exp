%FUNCTION: makeEdgelet_os(type, s, o, scrmp, scrmo)
%
% function called by makeEdgeletLib, to create a single micropattern
%
% output = makaeEdgelet(type, s, o, scrmp, scrmo)
%
%  type  = 'broadband' OR 'narrowband' OR 'gabor'
%          'broadband' for all spatial frequencies to nyquist limit
%          'narrowband' for two spatial frequencies
%          'gabor' for one spatial frequency
%  s     = micropattern size (in pixels, image edge length, s^2 = number of
%          pixels
%  o     = micropattern orientation (between 0 and 360)
%  scrmp = scramble phases; 0 = no scramble, 1 = scramble
%  scrmo = scramble orientations;   "            "
%
% OUTPUT: A -1 to 1 mean = 0 micropattern of size s and orientation o. 


% TO DO:
%   optional values of parameters (bandwidth, aspect ratio etc)
%   other micropattern types:  log-Gabor, DOG


% written by Elizabeth Arsenault (now Zavitz), 2012-2013
% recent changes:
% 11 Sept 2013 - CB: display image of final (windowed) edgelet, not "visualize"
% 18 Sept 2013 - CB: option for types = 'pos_gaussian' and 'neg_gaussian'


% needs to run:
%   stimMakeGausWindow.m

% see also:
%   makeEdgeletLib_os.m


function edgelet = makeEdgelet_os_cd(type, s, o, scrmp, scrmo)

edge = zeros(s);
[x y] = meshgrid(-s/2:s/2-1,-s/2:s/2-1);               % s^2 matrices
lambda = s;     % one cycle of lowest frequency




% figure out how many harmonics to add
if strcmp (type, 'broadband')
    n = (s/4);
elseif strcmp (type, 'narrowband')
    n = 2;
elseif strcmp (type, 'gabor')
    n = 1;
elseif strcmp (type, 'pos_gaussian')
    n = 1;
elseif strcmp (type, 'neg_gaussian')
    n = 1;
end

visualize = zeros(n,s);

% figure out the sigma of the gaussian window
sigma = s/6;  % <-- here 8 is an arbitrary scaling factor

%winMask = stimMakeCosTaper(s,1);                           % create cosine taper window
winMask = stimMakeGausWindow2(s,sigma);                      % create gaussian window

pshift = 0; % default, no phase scramble or shift


for i = 1:2:(n*2) % only add odd-numbered harmonics

    if scrmo % scramble orientations of components
        o = 360*rand(1);
    end

    if scrmp % scramble phases of components
        pshift = 2*pi*rand(1);
    end

    a = cos(o*pi/180) * 2*pi/(lambda/i);                      
    b = sin(o*pi/180) * 2*pi/(lambda/i); 

    w = sin((a*x + b*y)+pshift);

    w = w ./ i;      % scale based on harmonic number

    visualize(i, :) = w(1,:);

    edge = edge + w;
end

edgelet = edge;

if strcmp (type, 'pos_gaussian')
    edgelet = 0.5 * winMask;  % use Gaussian window itself as the micropattern
elseif strcmp (type,'neg_gaussian')
    edgelet = -0.5 * winMask;
else                         % normally, e.g. broadband edgelet, gabor etc
    edgelet = edgelet.* winMask;  % edgelet, etc with gaussian window

end
% 
% figure(1);
% imagesc(edgelet,[-1 +1]); colormap('gray');  axis image; colorbar;    % ##-added by CB, 11 Sept 2013
% pause(0.1);
	