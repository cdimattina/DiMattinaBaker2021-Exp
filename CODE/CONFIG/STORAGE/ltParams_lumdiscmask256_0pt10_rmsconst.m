% ltParams_template
%
% An outline of the parameters for generating the stimuli for 
% PsyLTMAIN.
%

% Carrier textures are not pre-computed
stim.preComp        = 0;                                                    % <<< SET pre-computed flag

% Save images generated in experiment
stim.saveImages     = 1;                                                    % <<< SET save images flag 

% Run experiment in make training set mode
stim.makeTrainMode  = 0;                                                    % <<< SET make training set mode

% Envelope properties
stim.env.type       = 'halfDisc';
stim.env.circtaper  = 0.0;
stim.env.edgetaper  = 0.0;         % This allows the edge to have different tapering than boundary

% CRS system (default)
scr.bitsplusplus    = 1;

flag.diagnostics    = 0;
flag.break          = 0; 

task.type           = '2afc';
task.mirror         = 0;            % 1 to reverse response keys, when viewing in a mirror
task.viewDist       = 132;
task.dvaStim        = 4;            % Degrees of visual angle for the stimulus
task.feedback       = 1;
task.date           = date;
task.datetime       = datestr(now);
task.iconMsec       = 200;          % Duration of fixation point prompt (and, error icon)
task.itiMsec        = 10;           % Wait-time, after last button-press, before prompting for next stimulus

                                    
% ---------- STIMULUS TYPES -----------------------------------------------                                   
% 'plainStep' - Plain luminance disc
% 'gaussBlob' - Gaussian blob stimulus
% -------------------------------------------------------------------------

stim.category       = 'lumDiscMask';  
stim.method         = 'staircase';                                                                               
stim.stairNDown     = 2;        

stim.lumLevels      = logspace(-2.7,-1.5,11);                   % for 'plainStep'
stim.nLevels        = length(stim.lumLevels); 

% For future masking/sub-threshold summation studies 
stim.doMask         = 1;
stim.mask.cateogry  = 'white';
stim.mask.RMScont   = 0.10;
stim.mask.normRMS   = 0; 

% Requested number of trials. 
stim.nTrials        = 250; 
stim.trial.thisVal  = zeros(stim.nTrials,1);
stim.trial.resp     = zeros(stim.nTrials,1);
stim.trial.trialdur = zeros(stim.nTrials,1); 

stim.size           = 256;          % must be <= screen height, in pixels     % << SET stimulus size
win.size            = stim.size;    % must be <= stim.size
win.type            = 'cosCircle';
win.taperProportion = 0.0;

stim.win            = win; 
stim.durMsec        = 100;                                                    % <<< SET stim duration in msec
 
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

