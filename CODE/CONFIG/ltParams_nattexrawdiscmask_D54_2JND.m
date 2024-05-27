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

% % Envelope properties
% stim.env.type       = 'halfDisc';
% stim.env.taper      = 0.0;
% stim.env.edgetaper  = 0.0;         % This allows the edge to have different tapering than boundary


stim.stepParams.size     = 256;

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
load(sprintf('../../ANALYSIS3/RESULTS/lumDiscStep_%s.mat',subj)); 
% Find the appropriate luminace level for this d-prime
stim.pedestal.lumLev = median(threshstruct.bootJND75DLVec); 
% clear threshstruct

disp(sprintf('JND = %.3f',stim.pedestal.lumLev));


stim.category                = 'natTextDiscMask'; 


% Pedestal is a luminance disc
stim.pedestal.category       = 'lumDisc';
stim.pedestal.env.type       = 'halfDisc';
stim.pedestal.env.circtaper  = 0.2;       % boundary of disc
stim.pedestal.env.edgetaper  = 0.2;       % edge
stim.pedestal.lumLevJNDunits = 2; 
stim.pedestal.lumLev         = stim.pedestal.lumLev*stim.pedestal.lumLevJNDunits;        
                                          % luminance level of disc. Will be set 
                                          % at various multiples of JND                                        

stim.lumLevels      = [0:100:2600];                           % In units of dimensionless luminance across diagonal
stim.nLevels        = length(stim.lumLevels); 

stim.method         = 'staircase';                                                                               
stim.stairNDown     = 2;        

% Get the full texture
thisTexture = sprintf('../../makeTexMod/128x128/D%d.tif',54);
I           = imread(thisTexture,'tif');
I           = double(I);
texIn       = I - mean2(I); % center at zero

stim.texParams.texIn = texIn;
stim.texParams.amp   = 0.2;
stim.texParams.clip  = 0.8;
stim.texParams.size  = 256;
stim.texParams.taper = 0.2; 
stim.texParams.phase = 180;
stim.texParams.ori   = 0; 

stim.texParams.balance_anti   = 0;


% for each individual example, take a 96x96 subsample, which is then
% resized back up to 128x128, effectively smoothing high spatial
% frequencies 
stim.texParams.texsz = 128;
stim.texParams.subsz = 96; 

% For future masking/sub-threshold summation studies 
stim.doMask         = 0;
stim.mask.cateogry  = '';

% Requested number of trials
stim.nTrials        = 600;

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

stim.conMat(:,1)    = targetOrVec;
stim.conMat(:,2)    = maskOrVec;
stim.conMat(:,3)    = phaseRelate;

% scramble the conditions matrix
scind               = randperm(stim.nTrials);
stim.conMat         = stim.conMat(scind,:);

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

