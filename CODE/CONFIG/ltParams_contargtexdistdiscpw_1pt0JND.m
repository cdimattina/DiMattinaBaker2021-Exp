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
stim.env.taper      = 0.0;
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


% Get the JND for maxlum and lumlev
% lumLevJNDval    = str2num(input('enter luminance disc JND: ','s'));
% pwJNDval = str2num(input('enter texture pW JND: ','s'));


% Get the JND for luminance disc and PW for luminance texture
load(sprintf('../../ANALYSIS/RESULTS/lumDiscSharp_%s.mat',subj)); 
% Find the appropriate luminace level for this d-prime
[~,cue1ind] = min((threshstruct.dlPc - 0.75).^2);
stim.pedestal.lumLev = threshstruct.dlStimLevelsPlot(cue1ind); 
clear threshstruct

stim.category               = 'gaussBlobPedestal';  

% Pedestal is a luminance disc
stim.pedestal.category      = 'lumDisc';
stim.pedestal.env.type      = 'halfDisc';
stim.pedestal.env.circtaper = 0.2;       % boundary of disc
stim.pedestal.env.edgetaper = 0.0;       % edge
stim.pedestal.lumLevJNDunits= 1; 
stim.pedestal.lumLev        = stim.pedestal.lumLev*stim.pedestal.lumLevJNDunits;        % luminance level of disc. Will be set 
                                         % at various multiples of JND                                        

stim.lumLevels      = stim.pedestal.lumLev;    
                                         
stim.method         = 'staircase';                                                                               
stim.stairNDown     = 2;        

% Get the parameters for computing d-prime for the luminance texture
load(sprintf('../../ANALYSIS/RESULTS/gaussBlobRandProp_%s.mat',subj)); 
% Find the appropriate pw for this d-prime
[~,cue2ind] = min((threshstruct.pwPc -0.75).^2); 
stim.blob.pW        = 0.5*(threshstruct.pwStimLevelsPlot(cue2ind)) + 0.5; 
clear threshstruct

% Details of the gaussBlob stimulus
stim.blob.vary      = 'pW';     % 'pW' or 'dens'
% stim.blob.pW        = [1];
stim.blob.dens      = [0.5];
stim.blob.pwJNDunits = 1;            % Set maxlum at or slightly above JND
stim.blob.maxlum    = 0.25;
stim.blob.pW    = stim.blob.pW*stim.blob.pwJNDunits;       

stim.blob.nPattSide = 32; 
stim.blob.mpSize    = 8;
stim.blob.jitter    = 4; 
stim.blob.sigma     = 2; 
stim.blob.gridspace = 20; 
stim.blob.dodots    = 0;    % 0 - gaussians, 1 - polka-dots

if(strcmp(stim.blob.vary,'pW'))
    stim.nLevels    = length(stim.blob.pW); 
elseif(strcmp(stim.blob.vary,'dens'))
    stim.nLevels    = length(stim.blob.dens);
elseif(strcmp(stim.blob.vary,'maxlum'))
    stim.nLevels    = length(stim.blob.maxlum); 
end

% For future masking/sub-threshold summation studies 
stim.doMask         = 0;
stim.mask.cateogry  = '';

% Requested number of trials
stim.nTrials        = 600;

if(~(rem(stim.nTrials,6)==0))
    error('number of trials must be a multiple of 6');
end

trialsOverThree     = stim.nTrials/3;
trialsOverSix       = stim.nTrials/6;
stim.conVec         = [1*ones(trialsOverThree,1); 2*ones(trialsOverThree,1); 3*ones(trialsOverThree,1)];
stim.phaseVec       = repmat([zeros(trialsOverSix,1); ones(trialsOverSix,1)] ,3,1);

permind             = randperm(stim.nTrials);
stim.conVec         = stim.conVec(permind);
stim.phaseVec       = stim.phaseVec(permind); 

stim.trial.thisVal  = zeros(stim.nTrials,1);
stim.trial.resp     = zeros(stim.nTrials,1);
stim.trial.trialdur = zeros(stim.nTrials,1); 

stim.size           = 256;          % must be <= screen height, in pixels     % << SET stimulus size
win.size            = stim.size;    % must be <= stim.size
win.type            = 'cosCircle';
win.taperProportion = 0.2;

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

