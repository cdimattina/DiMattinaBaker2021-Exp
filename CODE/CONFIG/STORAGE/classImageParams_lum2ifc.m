% Parameters for classificiation image experiment
%
% 

addpath ..

disp('Setting stimulus parameters for classification image experiment...'); 

% Two different paradigms are supported
% depending on the value of task.type
%
% Detection ('det')  : One interval  , one stimulus  1/2 = present/absent
% 2IFC      ('2ifc') : Two intervals , two stimuli   1/2 = first/second

task.type           = '2ifc'; 
task.vary           = 'lum';
task.restPeriod     = 100;

stim.juxtaposed     = 1;            % Stimulus will always be juxtaposed

stim.showRefBar     = 1; 
stim.giveFeedback   = 1; 
     
stim.viewDist       = 520;          % viewing distance in mm
stim.shiftDVA       = 2;            % Degrees of visual angle to move stimulus 
                                    % above and below fixation spot
stim.doTaper        = 1;                                    
                                    
shiftDVArad         = stim.shiftDVA*(pi/180);
mmSize              = tan(shiftDVArad/2)*(2*stim.viewDist);
stim.shiftPix       = round(mmSize*scr.pmmConv);
                                   
stim.vDVA           = 1;            % DVA of stimulus in vertical dimension (this is multiplied by 2)
stim.hDVA           = 8;            % DVA of stimulus in horizontal dimension (this is multiplied by 2)

vDVArad             = stim.vDVA*(pi/180);
hDVArad             = stim.hDVA*(pi/180); 

mmSizev             = tan(vDVArad/2)*(2*stim.viewDist);
mmSizeh             = tan(hDVArad/2)*(2*stim.viewDist);

stim.vPixSize       = round(mmSizev*scr.pmmConv);
stim.hPixSize       = round(mmSizeh*scr.pmmConv);

stim.method         = 'staircase';                                                                               
stim.stairNDown     = 2;            

stim.lum            = 0.5;
stim.sigma          = 0.1; 
stim.lumLevels      = stim.sigma*(0:0.125:1.5);     

stim.nLevels        = length(stim.lumLevels); 
stim.squareSize     = 24;

% Requested number of trials. May be changed below to a slightly larger
% number to allow for perfect balancing of conditions (must be multiple of
% number of levels AND 4)
stim.nTrials        = 500; 

% Create basic block structure for generating a completely balanced set
% where every level is presented the same number of times 
% in the top/bottom positions
stim.trial.XmatTop      = zeros(stim.nTrials,2*stim.squareSize); 
stim.trial.XmatBottom   = zeros(stim.nTrials,2*stim.squareSize);

% Compute number of pixels per strip
    
stripPix      = floor(stim.hPixSize/stim.squareSize);
stim.stripPix = stripPix; 
stim.hPixSize = stim.squareSize*stripPix;

stim.trial.XmatTopFull      = zeros(stim.nTrials,2*stim.hPixSize);
stim.trial.XmatBottomFull   = zeros(stim.nTrials,2*stim.hPixSize);

% Randomly select which trials the target will appear on the top
% Make sure number of trials is even
stim.trial.targetTop        = zeros(stim.nTrials,1);  
% Randomly select which trials we will flip the stimulus polarity
stim.trial.targetFlipPhase  = zeros(stim.nTrials,1);

stim.trial.timeInt1         = zeros(stim.nTrials,1);
stim.trial.timeInt2         = zeros(stim.nTrials,1); 

if(rem(stim.nTrials,2))
    error('Number of trials must be even!');
else
    v = randperm(stim.nTrials);
    stim.trial.targetTop(v(1:(stim.nTrials/2))) = 1;  
    
    v = randperm(stim.nTrials);
    stim.trial.targetFlipPhase(v(1:(stim.nTrials/2))) = 1; 
end



stim.trial.thisVal      = zeros(stim.nTrials,1);
stim.trial.resp         = zeros(stim.nTrials,1);