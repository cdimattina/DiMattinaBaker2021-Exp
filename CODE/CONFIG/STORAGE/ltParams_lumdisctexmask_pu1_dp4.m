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
stim.env.circtaper  = 0.2;
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

stim.category       = 'lumdiscTexMask';  
stim.method         = 'staircase';                                                                               
stim.stairNDown     = 2;        

stim.lumLevels      = logspace(-2.7,-1.7,21);             % for 'plainStep'
stim.nLevels        = length(stim.lumLevels); 

% Properties of masking blob stimulus



% Get the JND for luminance disc and PW for luminance texture
load(sprintf('../../ANALYSIS/RESULTS/gaussBlobRandPropMaxLum_%s.mat',subj)); 

gMC = threshstruct.g;
pMC = threshstruct.p;

% JNDmaxlum = threshstruct.JND75; 
% JNDunits  = 0;

clear threshstruct

% Details of the gaussBlob stimulus
stim.blob.vary      = 'pW';
stim.blob.pW        = [1];
stim.blob.dens      = [0.5];

stim.blob.maxlumDP  = 4; 
stim.blob.maxlum    = exp(log(stim.blob.maxlumDP)/pMC - log(gMC));

disp(stim.blob.maxlum)

stim.blob.nPattSide = 32; 
stim.blob.mpSize    = 8;
stim.blob.jitter    = 4; 
stim.blob.sigma     = 2; 
stim.blob.gridspace = 20; 
stim.blob.dodots    = 0;    % 0 - gaussians, 1 - polka-dots

% Requested number of trials
stim.nTrials        = 240;

if(~(rem(stim.nTrials,8)==0))
    error('number of trials must be a multiple of 8');
end

trialsOverTwo         = stim.nTrials/2;
trialsOverFour        = stim.nTrials/4;
trialsOverEight       = stim.nTrials/8;

% Conditions Matrix 
% -----------------
% stim.conMat(:,1) : target orientation     
% stim.conMat(:,2) : mask orientation
% stim.conMat(:,3) : mask/target phase relations (in-phase)
%

targetOrVec = [ zeros(trialsOverTwo,1) ; ones(trialsOverTwo,1)]; % 0 - left, 1 - right
maskOrVec   = [ zeros(trialsOverFour,1); ones(trialsOverFour,1); zeros(trialsOverFour,1); ones(trialsOverFour,1)];                                                              
phaseRelate = [ zeros(trialsOverEight,1); ones(trialsOverEight,1); ...
                zeros(trialsOverEight,1); ones(trialsOverEight,1);  ...
                zeros(trialsOverEight,1); ones(trialsOverEight,1);  ...
                zeros(trialsOverEight,1); ones(trialsOverEight,1) ];

stim.conMat(:,1) = targetOrVec;
stim.conMat(:,2) = maskOrVec;
stim.conMat(:,3) = phaseRelate;

% scramble the conditions matrix
scind       = randperm(stim.nTrials);
stim.conMat = stim.conMat(scind,:);


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

