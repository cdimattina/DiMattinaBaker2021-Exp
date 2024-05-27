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
task.feedback       = 0;            % Do not give feedback for this task since there will be conflict trials
task.date           = date;
task.datetime       = datestr(now);
task.iconMsec       = 200;          % Duration of fixation point prompt (and, error icon)
task.itiMsec        = 10;           % Wait-time, after last button-press, before prompting for next stimulus
                                    
% ---------- STIMULUS TYPES -----------------------------------------------                                   
% 'plainStep' - Plain luminance disc
% 'gaussBlob' - Gaussian blob stimulus
% -------------------------------------------------------------------------

stim.category       = 'twoLumCue';  % both step and blob cues informative
stim.dprime1        = 1;            % d-prime for luminance disc
stim.dprime2        = 1;            % d-prime for luminance texture



% Pedestal is a luminance disc
stim.pedestal.category      = 'lumDisc';
stim.pedestal.env.type      = 'halfDisc';
stim.pedestal.env.circtaper = 0.2;       % boundary of disc
stim.pedestal.env.edgetaper = 0.0;       % edge

% Get the parameters for computing d-prime for the luminance disc
load(sprintf('../../ANALYSIS/RESULTS/lumDiscSharp_%s.mat',subj)); 
% Find the appropriate luminace level for this d-prime
[~,cue1ind] = min((threshstruct.DP - stim.dprime1).^2);
stim.pedestal.lumLev = threshstruct.dlStimLevelsPlot(cue1ind);
stim.lumLevels      = stim.pedestal.lumLev;                                         
                                         
clear threshstruct

stim.method         = 'staircase';       % This is irrelevant since there is only 1 level                                                                               
stim.stairNDown     = 2;        

% Details of the gaussBlob stimulus
stim.blob.vary      = 'pW';     % 'pW' or 'dens'
% stim.blob.pW        = [1];
stim.blob.dens      = [0.5];
stim.blob.maxlum    = 0.25;

% Get the parameters for computing d-prime for the luminance texture
load(sprintf('../../ANALYSIS/RESULTS/gaussBlobRandProp_%s.mat',subj)); 
% Find the appropriate pw for this d-prime
[~,cue2ind] = min((threshstruct.DP -stim.dprime2).^2); 
stim.blob.pW        = 0.5*(threshstruct.pwStimLevelsPlot(cue2ind)) + 0.5; 

clear threshstruct

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
 
stim.nOne           = 50; 
stim.nBoth          = 300;
stim.nConf          = 50; 

% Conditions 
% ----------
% 1 - cue 1 only
% 2 - cue 2 only
% 3 - cue 1 + 2  agreement: half in phase, half out of phase
% 4 - cue 1 + 2  conflict : half in phase, half out of phase
%
% We will run this in blocks. The first block will consist of
% equal numbers of single-cue + cue agreement conditions
% The second block will consist only of cue agreement and conflict

block1convec    = [1*ones(stim.nOne,1); 2*ones(stim.nOne,1); 3*ones(stim.nOne,1)];
block1phasevec  = [zeros(stim.nOne,1); zeros(stim.nOne,1); ...
                   zeros(stim.nOne/2,1); ones(stim.nOne/2,1)];
indblock1       = randperm(3*stim.nOne);
block1convec    = block1convec(indblock1);
block1phasevec  = block1phasevec(indblock1); 

nBothMore       = stim.nBoth - stim.nOne; 

block2convec    = [3*ones(nBothMore,1); 4*ones(stim.nConf,1)]; 
block2phasevec  = [zeros(nBothMore/2,1); ones(nBothMore/2,1); ...
                   zeros(stim.nConf/2,1);ones(stim.nConf/2,1) ];
indblock2       = randperm(nBothMore + stim.nConf);
block2convec    = block2convec(indblock2);
block2phasevec  = block2phasevec(indblock2);                

stim.conVec     = [block1convec; block2convec];
stim.phaseVec   = [block1phasevec; block2phasevec];

% Number of trials
stim.nTrials    = length(stim.conVec); 

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

