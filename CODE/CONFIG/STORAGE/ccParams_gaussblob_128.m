% ccParams_template
%
% An outline of the parameters for generating the stimuli for 
% PsyCCMAIN. This is a template that can be modified for different
% observers and conditions and then saved and archived. 


% Carrier textures are not pre-computed
stim.preComp        = 0;                                                    % <<< SET pre-computed flag

% Save images generated in experiment
stim.saveImages     = 1;                                                    % <<< SET save images flag 

% Run experiment in make training set mode
stim.makeTrainMode  = 0;                                                    % <<< SET make training set mode

% envelope properties
stim.env.type     = 'halfDisc';
stim.env.taper    = 0.2;

scr.bitsplusplus    = 1;

flag.diagnostics    = 0;
flag.break          = 0; 

task.mirror         = 0;            % 1 to reverse response keys, when viewing in a mirror
task.viewDist       = 132;
task.dvaStim        = 4;            % degrees of visual angle for the stimulus
task.feedback       = 1;
task.date           = date;
task.datetime       = datestr(now);
task.iconMsec       = 200;          % Duration of fixation point prompt (and, error icon)
task.itiMsec        = 10;           % Wait-time, after last button-press, before prompting for next stimulus

% repetitions for each grid point
task.nReps          = 50;                                                   % <<< SET number of repetitions

% Set maximum stimulus michealson contrast to < 1 to prevent clipping
stim.carrMCon       = 0.7;          % scales stimulus contrast

% Set RMS contrast to fixed value
stim.fixRMSCon      = 1; 
stim.RMSConVal      = 0.05;  % value to set RMS contrast 

% Stimuli are either Gabors with added localized Gaussian micro-patterns
% or Gabors with added global luminance edge
%
% 'gabStep'   - Gabors with global step edge
% 'gabGauss'  - Gabors with local added Gaussians (black and white)
%               This creates a 'texture' luminance edge
% 'gaussBlob' - Gaussian blob only - no Gabor
%

stim.category   = 'gaussBlob'; 

stim.modDepth   = 100; 
stim.mpsize     = 32;
stim.npatt      = [128];                      % Level for density: one level only
                                              % config file

stim.orB        = 0;                          % Fixed orientation
stim.orALevs    = [0];                        % Variable orientation
task.nOrLev     = length(stim.orALevs);       % Number of orientation levels

stim.lumConAddLevs  = [];                     % Levels for step luminance edge
stim.pWALevs        = [0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7];       % Used for texture luminance edge

if(strcmp(stim.category,'gabStep'))           % Number of luminance levels
    stim.lumLevs = stim.lumConAddLevs;  
else
    stim.lumLevs = stim.pWALevs;  
end
task.nLumLev    = length(stim.lumLevs);

% Load micro-pattern library
isThere = who('mpLibrary');  %check for micropattern library
if isempty(isThere)          %load mplibrary if not in workspace
    global mpLibrary s o nVari;
    fprintf(1,'\n\n\n\n\n\n -- LOADING MICROPATTERN LIBRARY -- \n\n');
    load 'mplibrary_os_12.mat'
end

stim.size       = 256;            % must be <= screen height, in pixels     % << SET stimulus size
win.size        = stim.size;      % must be <= stim.size
win.type        = 'cosCircle';
win.taperProportion = 0.2;


stim.win        = win; 
stim.durMsec    = 100;                                                      % <<< SET stim duration in msec
 
% Set up keyboard
KbName('UnifyKeyNames');    % enable unified mode of KbName, for OS-independence 
% keyboard:                             % Kensington keypad:
key.right  = KbName('RightArrow');      key.pagedown = KbName('pagedown'); % right-oblique
key.left   = KbName('LeftArrow');       key.end      = KbName('end');      % left-oblique
key.down   = KbName('DownArrow');       % (also DownArrow, for keypad)     % initial trial
key.escape = KbName('ESCAPE');          key.home     = KbName('home');     % abort experiment
key.four = KbName('4');                 key.five= KbName('5');
% key.comma= KbName('comma');                                              % CD's desktop PC does not like comma for some reason   
key.six = KbName('6');                                                     % So I commented it out ( ) 

