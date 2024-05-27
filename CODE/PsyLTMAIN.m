
%%
% THIS PROGRAM WILL BE INTEGRATED INTO PsyCPLAB (CD, 12-05-22)
%%

% PsyLTMAIN.m  
% 
% Adapted from PsyTexSegMAIN by Liz Zavitz & Curtis Baker
% and PsyTexRFMAINFGCU by Chris DiMattina
%
% This is a lightweight adaptation of these programs
%
% Like Liz's program, this relies on a config file for
% different paradigms. These files are saved in the
% ./CONFIG/ directory. The config files have the general form : 
% ltParams_<fName>.m, where fName specifies the base file 
% 
% In contrast to Liz's work, we make use of a staircase procedure to
% keep trials automatically focused near threshold. 
%
% -------------------------------------------------------------------------
% SUPPORTED STIMULUS PARADIGMS
% -------------------------------------------------------------------------
% 'lumDisc'             - plain luminance step edge
% 'gaussBlob'           - gaussian blob micropatterns of fixed amplitude whose
%                         proportions of white/black elements, blob density 
%                         or blob luminance is varied  
% 'gaussBlobDLFix'      - gaussian blob micropatterns where the luminance
%                         difference between sides is held same but the 
%                         number of luminance-cancelling background dots
%                         varies
% 'gaussBlobPedestal'   - paradigm where subject must determine orientation
%                         of luminance texture boundary with a super-imposed 
%                         luminance disc which the observer is instructed
%                         to ignore. 
% 'lumDiscPedestal'     - paradigm where subject must determine orientation
%                         of luminance disc with super-imposed luminace
%                         texture which the observer is instructed to
%                         ignore.
% 'twoLumCue'           - both cues together 
% 'lumDiscBlobs'        - luminance disc in the presence of blobs with
%                         non-informative luminance cue
% 'pwblobDiscSum'       - Summation paradigm (Kingdom et al., 2015)
%                         Both cues at specified levels (file + observer
%                         dependent). All trials congruent, w/feedback 
% 'pwtextTextMask'      - texture with super-imposed texture mask 
%
%
%

% Need to specify <stim.category> as one of these paradigms in the 
% configuration file
%

% FROM LIZ-----------------------------------------------------------------
% important data structures:
%   task - psychophysical task options, e.g. task.type, .feedback, .mirror
%   scr - screen information, e.g. scr.refreshHz
%   key - keycodes for recognized button-presses
%   stim - stimulus parameters etc, e.g. stim.durMsec, stim.lambda
%   win - window-mask type and parameters, e.g. win.type, win.size
%   results - table of how many left-judgements for each ori level-values
%   flag - binary variables for internal house-keeping, e.g. flag.break
%   paths - home, textures
%
% needs to run:
%   psyTexSegParamsSet.m - set run-time parameters
%       psyTexSegParamsAsk.m - prompt user for run-time parameters
%       getLevVals.m - calculate set of level values to be tested
%   psySetupScreen.m - initializes crt screen
%       csm_CRT_info.m - file containing gamma-correction, other info on the screen
%       gam_z_corr.m - apply gamma-correction to clut's
%   stimMakeWindowMask.m - create window-mask (e.g. cosine-tapered circle, gaussian)
%       mkCosTaper.m - make cosine-tapered circular window
%   stimMakeTexSeg.m - create stimulus for one trial
%       stimMakeEnvPattPsy.m - make envelope pattterns
%           bw2sigma.m - convert spatial bandwidth (octaves) to sigma value of gaussian envelope
%       stimMakeCarrPattPsy.m - make carrier patterns
%           imgZclip.m
%           stimMakeFractSclMatrix.m
%           stimMake2dFractNoise.m
%           phaseScramble.m
%       imgPrintStats.m
%   psyPromptAndWait.m - prompt observer that we are ready for a trial, and wait for button-press
%   psyPresentStimulus.m - show the stimulus to the observer
%   psyCollectResponse.m - wait for observer's response (left or right arrow keys)
% FROM LIZ----------------------------------------------------------------- 

% Clear workspace variables
clearvars;

% Add path with code for making Gabor Blob stimuli
if(IsWindows)
    addpath ..\makeGaborBlobLib
    addpath ..\makeTexMod
else
    addpath ../makeGaborBlobLib
    addpath ../makeTexMod
end

% Output program name
fprintf(1,'\nPsyLTMAIN\n\n');

disp('MONITOR CODES');
disp('''Dell27''');
disp('''Disp++''' );
disp('''VSQ71''')
disp('''EV17F2''');
disp('''McGill'''); 
fprintf(1,'\n');

monitorCode  = input('Enter monitor code:  ','s');
fName        = input('base file name:   ','s');     % e.g. cd_tst_01, cd_tst_02,...
subj         = input('observer initials:   ','s');  % e.g. cd, ss, jh,... 


fName_first  = [fName '_' monitorCode '_' subj '_01.mat'];  % create name for first data file in this series
fName_params = ['ltParams_' fName];                 % name of associated parameters

paths.home   = pwd;                                 % remember this as our home directory
computerInfo = Screen('computer');                  % (PsychToolbox)

computerInfo.machineName = computer;                % Get computer name (usually PCWIN)
task.computer = computerInfo.machineName;           % 
 
% Depending on which computer we are using (as indicated by monitorCode), 
% we will want to look for the pre-computed textures in different places
if(strcmp(monitorCode,'McGill'))
   atFGCU = 0; 
else
   atFGCU = 1;  
end

if(atFGCU)
    if(IsWindows)
        paths.records  = 'C:\PsyLT\DATA';
    else
        paths.records = '/home/cdimattina/Dropbox/CNPLab/TRANSFER';
    end
else
    paths.records  = '/Volumes/Macintosh HD/PsyLT/DATA';
end

fName_full_path = strcat(paths.records,'/',fName_first); 
 
if exist(fName_full_path,'file')
    fRun  = input('run number:   ', 's');
    fName_first  = [fName '_' monitorCode '_' subj '_0' fRun '.mat'];        % create name for data file
    fName_full_path = strcat(paths.records,'/',fName_first);
end

disp(fName_params);

% Evaluate the parameter file 
cd ('CONFIG')
eval(fName_params);
cd ..
 
disp('loaded config file');

% Set up screen. This applies Gamma correction to the monitor.
% This program will typically run at FGCU
if(atFGCU)
    scr = psySetupScreenFGCU(monitorCode,stim.size,scr); 
else
    scr = psySetupScreen(stim.size, scr);  
end

% If we are doing a stair-case, start at the top (easiest level)
stairLevel      = stim.nLevels; 
nCorrInRow      = 0; 

nTrialsLevel    = zeros(stim.nLevels,1);
nCorrLevel      = zeros(stim.nLevels,1); 

do2ifc          = 0; 

if(strcmp(task.type,'2afc'))
    messageStr = 'Press ''4'' if boundary is left-oblique, ''6'' if boundary is right-oblique. Press ''5'' to begin each trial!';
elseif(strcmp(task.type,'2ifc'))
    messageStr = 'Press ''1'' if the target occurs in the first interval, ''2'' if it occurs in the second interval. Press ''5'' to begin each trial!';
    do2ifc      = 1;
else
    Screen('CloseAll');  
    error('Task not recognized!'); 
end

DisplayExperimentMessage(scr.stimWinPtr,messageStr,15);
disp(sprintf('Number of trials = %d',stim.nTrials));

stim.nFrames    = ceil((stim.durMsec/1000)  * scr.refreshHz);     
iconFrames      = ceil((task.iconMsec/1000) * scr.refreshHz);

ClockRandSeed;
 
results.correct = zeros(stim.nLevels,1);    % how many judged correctly, for each level-value
results.nstimlv = zeros(stim.nLevels,1);    % how many presented at each level  
results.prcnt   = zeros(stim.nLevels,1);    % percent correct

nTrials         = stim.nTrials;             % total number of trials in this block
iTrial          = 0;
 
save psyTMP 'scr';   % create tmp-data file, and save screen info to it

doGauss         =      strcmp(stim.category,'gaussBlob')            || strcmp(stim.category,'gaussBlobMask') ...
                    || strcmp(stim.category,'gaussBlobDLFix')       || strcmp(stim.category,'gaussBlobPedestal') ...
                    || strcmp(stim.category,'lumDiscPedestal')      || strcmp(stim.category,'twoLumCue') ...
                    || strcmp(stim.category,'twoifcTargTexPedLum')  || strcmp(stim.category,'twoifcTargLumPedTex') ...
                    || strcmp(stim.category,'pwtextDiscMask')       || strcmp(stim.category,'lumdiscTexMask') || strcmp(stim.category,'pwtextDiscMaskDL')  ...
                    || strcmp(stim.category,'pwtextTextMask') ;

varynCL         = 0; 

% For gaussBlob stimuli without random locations
if(doGauss)
    % Load grid centers for stimulus 

    display('doGauss TRUE')
    
    % Create quadrants
    gaussInStruct.quadStruct = makeQuadrantMap(stim.size, stim.blob.mpSize); 
    
    % Determine what is being varied
    varypW      = strcmp(stim.blob.vary,'pW');      % proportion white
    varymaxlum  = strcmp(stim.blob.vary,'maxlum');  % blob luminance
    
    % This is for gaussBlobFixDL 
    % Here we vary number of luminance-cancelling b/w dots 
    % on each side while holding non-cancelling dots constant
    
    varynCL     = strcmp(stim.blob.vary,'nCL');  
                           
end

% we use MCS for this paradigm
if(varynCL)
   curLev_nCLL    = 1;
   numLev_nCLL    = length(stim.blob.nCL);
   curPerm_nCLL   = randperm(numLev_nCLL); 
end

fprintf(1,'\n\nstarting psychophysical trials !\n\n');

for i=1:nTrials

    thisStim = stim;            % (make a copy, which can now be modified for this trial)

    % Randomize envelope phase and orientation
    if(rand < 0.5)
       thisStim.env.phase = 0; 
    else
       thisStim.env.phase = 180; 
    end

    if(rand < 0.5)
       thisStim.env.ori   = +45; 
    else
       thisStim.env.ori   = -45; 
    end

    thisOri = thisStim.env.ori;
    thisPhase = thisStim.env.phase;    
    
    if(strcmp(stim.category,'gaussBlob'))   % Gaussian blob grid stimulus

        if(varypW)
            thispWLevel         = stim.blob.pW(stairLevel);
            thismaxlumLevel     = stim.blob.maxlum;
        elseif(varymaxlum)
            thispWLevel         = stim.blob.pW; 
            thismaxlumLevel     = stim.blob.maxlum(stairLevel);
        end

        gaussInStruct.imSize        = stim.size;
        gaussInStruct.mpSize        = stim.blob.mpSize;      
        gaussInStruct.nPattSide     = stim.blob.nPattSide;
        
        gaussInStruct.pWL           = thispWLevel; 
        gaussInStruct.ori           = thisOri;
        gaussInStruct.phase         = thisStim.env.phase;
        gaussInStruct.sigma         = stim.blob.sigma;
        gaussInStruct.dodots        = stim.blob.dodots;
        
        [lumTex,nWL,nBL]  = makeRandThrowGaussStim(gaussInStruct);

        thisStim.nWL  = nWL; 
        thisStim.nBL  = nBL; 
        
        thisStimImage = scr.gray + thismaxlumLevel*lumTex; 
    
    elseif(strcmp(stim.category,'gaussBlobPedestal'))   % Gaussian blob grid stimulus with luminance 
        
        if(varypW)
            thispWLevel         = stim.blob.pW(stairLevel);
            thismaxlumLevel     = stim.blob.maxlum;
        elseif(varymaxlum)
            thispWLevel         = stim.blob.pW; 
            thismaxlumLevel     = stim.blob.maxlum(stairLevel);
        end

        gaussInStruct.imSize        = stim.size;
        gaussInStruct.mpSize        = stim.blob.mpSize;      
        gaussInStruct.nPattSide     = stim.blob.nPattSide;
        
        gaussInStruct.pWL           = thispWLevel; 
        gaussInStruct.ori           = thisOri;
        gaussInStruct.phase         = thisStim.env.phase;
        gaussInStruct.sigma         = stim.blob.sigma;
        gaussInStruct.dodots        = stim.blob.dodots;
        
        [lumTex,nWL,nBL]  = makeRandThrowGaussStim(gaussInStruct);

        thisStim.nWL  = nWL; 
        thisStim.nBL  = nBL; 
         
        thisStim.congruent = stim.conVec(i); 
        thisStim.flipphase = stim.phaseVec(i); 
        
        if(stim.conVec(i)==1)       % 1 = neutral trial
            
            thisStimImage   = scr.gray + thismaxlumLevel*lumTex; 
            
        else
            if(stim.conVec(i)==2)   % 2 = congruent trial
                lumDiscOri = thisOri;
            else                    % 3 = incongruent trial 
                lumDiscOri = -1*thisOri; 
            end
            
            if(stim.phaseVec(i)==0) % same phase as stimulus
                lumDiscPhase = thisStim.env.phase;
            else                    % flip phase
                lumDiscPhase = 180 - thisStim.env.phase;
            end
            
            thisLumLevel    = stim.pedestal.lumLev(stairLevel);
            lumDisc         = makeLumDisc(stim.size, lumDiscPhase, lumDiscOri, stim.pedestal.env.edgetaper, stim.pedestal.env.circtaper);
        
            thisStimImage   = scr.gray + scr.inc*thisLumLevel*lumDisc + thismaxlumLevel*lumTex;
                
        end
                                                  
    elseif(strcmp(stim.category,'lumDiscPedestal'))
        
        thisLumLevel    = stim.pedestal.lumLev(stairLevel);
        lumDisc         = makeLumDisc(stim.size, thisPhase, thisOri, ...
                                        stim.pedestal.env.edgetaper, stim.pedestal.env.circtaper);
                                            
        thisStim.congruent = stim.conVec(i); 
        thisStim.flipphase = stim.phaseVec(i); 
        
        if(stim.conVec(i)==1)
            thisStimImage   = scr.gray + scr.inc*thisLumLevel*lumDisc;
            
            thisStim.nWL  = 0; 
            thisStim.nBL  = 0; 
            
        else
            
            % Make luminance texture
            if(varypW)
                thispWLevel         = stim.blob.pW(stairLevel);
                thismaxlumLevel     = stim.blob.maxlum;
            elseif(varymaxlum)
                thispWLevel         = stim.blob.pW; 
                thismaxlumLevel     = stim.blob.maxlum(stairLevel);
            end

            gaussInStruct.imSize        = stim.size;
            gaussInStruct.mpSize        = stim.blob.mpSize;      
            gaussInStruct.nPattSide     = stim.blob.nPattSide;

            gaussInStruct.pWL           = thispWLevel; 
            gaussInStruct.sigma         = stim.blob.sigma;
            gaussInStruct.dodots        = stim.blob.dodots;
            
            if(stim.conVec(i)==2)   % 2 = congruent trial
                gaussInStruct.ori = thisOri;
            else                    % 3 = incongruent trial 
                gaussInStruct.ori = -1*thisOri; 
            end
            
            if(stim.phaseVec(i)==0) % same phase as stimulus
                gaussInStruct.phase = thisPhase;
            else                    % flip phase
                gaussInStruct.phase = 180 - thisPhase;
            end
 
            [lumTex,nWL,nBL]  = makeRandThrowGaussStim(gaussInStruct);

            thisStim.nWL  = nWL; 
            thisStim.nBL  = nBL; 
            
            thisStimImage   = scr.gray + scr.inc*thisLumLevel*lumDisc + thismaxlumLevel*lumTex;
               
        end
       
    elseif(strcmp(stim.category,'pwtextDiscMask'))
        
        % we set the phase and orientation for each stimulus based on the 
        % conditions matrix stim.conMat
        
        % stim.conMat(:,1) - target orientation
        % stim.conMat(:,2) - mask orientation
        % stim.conMat(:,3) - phase relationship
        
        % Make luminance texture
        if(varypW)
            thispWLevel         = stim.blob.pW(stairLevel);
            thismaxlumLevel     = stim.blob.maxlum;
        elseif(varymaxlum)
            thispWLevel         = stim.blob.pW;
            thismaxlumLevel     = stim.blob.maxlum(stairLevel);
        end
        
        thisTexPhase = thisPhase;
        
        if(stim.conMat(i,1)==1)
           thisTexOri =  +45;
        else
           thisTexOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisTexOri;
        
        if(stim.conMat(i,2)==1)
            thisDiscOri = thisTexOri;
        else
            thisDiscOri = -thisTexOri;
        end
        
        if(stim.conMat(i,3)==1)
            thisDiscPhase = thisPhase;
        else
            thisDiscPhase = 180 - thisPhase;
        end
        
        
        % Detect a texture boundary with a masking luminance disc
%         thispWLevel         = stim.blob.pW(stairLevel);
%         thismaxlumLevel     = stim.blob.maxlum;
        
        gaussInStruct.imSize        = stim.size;
        gaussInStruct.mpSize        = stim.blob.mpSize;      
        gaussInStruct.nPattSide     = stim.blob.nPattSide;
        
        gaussInStruct.pWL           = thispWLevel; 
        gaussInStruct.ori           = thisTexOri;
        gaussInStruct.phase         = thisTexPhase;
        gaussInStruct.sigma         = stim.blob.sigma;
        gaussInStruct.dodots        = stim.blob.dodots;
        
        [lumTex,nWL,nBL]    = makeRandThrowGaussStim(gaussInStruct);

        thisStim.nWL        = nWL; 
        thisStim.nBL        = nBL; 
        
        thisLumLevel        = stim.pedestal.lumLev;  
        
        lumDisc             = makeLumDisc(stim.size, thisDiscPhase, thisDiscOri, ...
                                        stim.pedestal.env.edgetaper, stim.pedestal.env.circtaper);
        
        thisStimImage       = scr.gray + scr.inc*thisLumLevel*lumDisc + thismaxlumLevel*lumTex;
     
    elseif(strcmp(stim.category,'pwtextDiscMaskDL'))    
         % we set the phase and orientation for each stimulus based on the 
        % conditions matrix stim.conMat
        
        % stim.conMat(:,1) - target orientation
        % stim.conMat(:,2) - mask orientation
        % stim.conMat(:,3) - phase relationship
        
        % Make luminance texture
        if(varypW)
            thispWLevel         = stim.blob.pW(stairLevel);
            thismaxlumLevel     = stim.blob.maxlum;
        elseif(varymaxlum)
            thispWLevel         = stim.blob.pW;
            thismaxlumLevel     = stim.blob.maxlum(stairLevel);
        end
        
        thisTexPhase = thisPhase;
        
        if(stim.conMat(i,1)==1)
           thisTexOri =  +45;
        else
           thisTexOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisTexOri;
        
        if(stim.conMat(i,2)==1)
            thisDiscOri = thisTexOri;
        else
            thisDiscOri = -thisTexOri;
        end
        
        if(stim.conMat(i,3)==1)
            thisDiscPhase = thisPhase;
        else
            thisDiscPhase = 180 - thisPhase;
        end
        
        
        % Detect a texture boundary with a masking luminance disc
%         thispWLevel         = stim.blob.pW(stairLevel);
%         thismaxlumLevel     = stim.blob.maxlum;
        
        gaussInStruct.imSize        = stim.size;
        gaussInStruct.mpSize        = stim.blob.mpSize;      
        gaussInStruct.nPattSide     = stim.blob.nPattSide;
        
        gaussInStruct.pWL           = thispWLevel; 
        gaussInStruct.ori           = thisTexOri;
        gaussInStruct.phase         = thisTexPhase;
        gaussInStruct.sigma         = stim.blob.sigma;
        gaussInStruct.dodots        = stim.blob.dodots;
        
        [lumTex,nWL,nBL]    = makeRandThrowGaussStim(gaussInStruct);

        thisStim.nWL        = nWL; 
        thisStim.nBL        = nBL; 
        
        % Parameters of the masking disc
        stepParams           = stim.stepParams;
        stepParams.ori       = thisDiscOri; 
        stepParams.phase     = thisDiscPhase; 
        stepParams.dLset     = stim.pedestal.lumLev;    
        
        [discOut,dL_diag_disc,dL_anti_disc]   = makeStepLSBStim(stepParams);
        
         thisStimImage       = scr.gray + scr.inc*discOut + thismaxlumLevel*lumTex;
        
    elseif(strcmp(stim.category,'natTextDiscMask'))   
        thisTexPhase = thisPhase;
        
        if(stim.conMat(i,1)==1)
           thisTexOri =  +45;
        else
           thisTexOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisTexOri;
        
        if(stim.conMat(i,2)==1)
            thisDiscOri = thisTexOri;
        else
            thisDiscOri = -thisTexOri;
        end
        
        if(stim.conMat(i,3)==1)
            thisDiscPhase = thisPhase;
        else
            thisDiscPhase = 180 - thisPhase;
        end
       
        % Parameters of the masking disc
        stepParams           = stim.stepParams;
        stepParams.ori       = thisDiscOri; 
        stepParams.phase     = thisDiscPhase; 
        stepParams.dLset     = stim.pedestal.lumLev;    
        
        [discOut,dL_diag_disc,dL_anti_disc]   = makeStepLSBStim(stepParams);
                
        thisStim.dL_diag_disc     = dL_diag_disc;
        thisStim.dL_anti_disc     = dL_anti_disc; 
        
        % Parameters of the target texture
        texParams           = stim.texParams; 
        texParams.ori       = thisOri;
        texParams.phase     = thisPhase;
        
        thisLumLevel        = stim.lumLevels(stairLevel);
        texParams.dLset     = thisLumLevel;
        
        texIn               = subsample_texture(texParams.texIn,texParams.subsz,stim.size);
        [texOut,IR,IL,dL_diag_text,dL_anti_text]   = makeTextureLTBStim(texParams,texIn);
                
        thisStim.dL_diag_text    = dL_diag_text;
        thisStim.dL_anti_text    = dL_anti_text; 
        
        % Final stimulus image
        thisStimImage       = scr.gray + scr.inc*discOut + scr.inc*texOut;
      
    elseif(strcmp(stim.category,'natDiscTextMask'))    
        
        thisDiscPhase = thisPhase;
        
        if(stim.conMat(i,1)==1)
           thisDiscOri =  +45;
        else
           thisDiscOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisDiscOri;
        
        if(stim.conMat(i,2)==1)
            thisTextOri = thisDiscOri;
        else
            thisTextOri = -thisDiscOri;
        end
        
        if(stim.conMat(i,3)==1)
            thisTextPhase = thisPhase;
        else
            thisTextPhase = 180 - thisPhase;
        end
        
        % Parameters of the target disc
        stepParams           = stim.stepParams;
        stepParams.ori       = thisOri; 
        stepParams.phase     = thisPhase; 
        stepParams.dLset     = stim.lumLevels(stairLevel);   
        
        [discOut,dL_diag_disc,dL_anti_disc]   = makeStepLSBStim(stepParams);
                
        thisStim.dL_diag_disc     = dL_diag_disc;
        thisStim.dL_anti_disc     = dL_anti_disc;        
        
        % Parameters of the masking texture
        texParams           = stim.texParams; 
        texParams.ori       = thisTextOri;
        texParams.phase     = thisTextPhase;
        
        thisLumLevel        = stim.pedestal.lumLev;
        texParams.dLset     = thisLumLevel;
        
        texIn               = subsample_texture(texParams.texIn,texParams.subsz,stim.size);
        [texOut,IR,IL,dL_diag_text,dL_anti_text]   = makeTextureLTBStim(texParams,texIn);
                
        thisStim.dL_diag_text    = dL_diag_text;
        thisStim.dL_anti_text    = dL_anti_text; 
        
        % Final stimulus image
        thisStimImage       = scr.gray + scr.inc*discOut + scr.inc*texOut;
        
    elseif(strcmp(stim.category,'pwtextTextMask'))
        
        % we set the phase and orientation for each stimulus based on the 
        % conditions matrix stim.conMat
        
        % stim.conMat(:,1) - target orientation
        % stim.conMat(:,2) - mask orientation
        % stim.conMat(:,3) - phase relationship
        
        % Make luminance texture
        if(varypW)
            thispWLevel         = stim.blob.pW(stairLevel);
            thismaxlumLevel     = stim.blob.maxlum;
        elseif(varymaxlum)
            thispWLevel         = stim.blob.pW;
            thismaxlumLevel     = stim.blob.maxlum(stairLevel);
        end
        
        thisTexPhase = thisPhase;
        
        if(stim.conMat(i,1)==1)
           thisTexOri =  +45;
        else
           thisTexOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisTexOri;
        
        if(stim.conMat(i,2)==1)
            thisMaskOri = thisTexOri;
        else
            thisMaskOri = -thisTexOri;
        end
        
        disp(thisTexOri)
        
        disp(thisMaskOri)
        
        if(stim.conMat(i,3)==1)
            thisMaskPhase = thisPhase;
        else
            thisMaskPhase = 180 - thisPhase;
        end
        
        % Target texture
        gaussInStruct.imSize        = stim.size;
        gaussInStruct.mpSize        = stim.blob.mpSize;      
        gaussInStruct.nPattSide     = stim.blob.nPattSide;
        
        gaussInStruct.pWL           = thispWLevel; 
        gaussInStruct.ori           = thisTexOri;
        gaussInStruct.phase         = thisTexPhase;
        gaussInStruct.sigma         = stim.blob.sigma;
        gaussInStruct.dodots        = stim.blob.dodots;
        
        [lumTex,nWL,nBL]    = makeRandThrowGaussStim(gaussInStruct);

        thisStim.nWL        = nWL; 
        thisStim.nBL        = nBL; 
        

        gaussInStructMask = gaussInStruct;

        gaussInStructMask.pWL       = stim.pedestal.blob.pW;
        gaussInStructMask.ori       = thisMaskOri;
        gaussInStructMask.phase     = thisMaskPhase;
        
        
        maskMaxLumLevel        = stim.pedestal.blob.maxlum;  
         
        [lumTexMask,~,~]    = makeRandThrowGaussStim(gaussInStructMask);
        
        thisStimImage       = scr.gray + maskMaxLumLevel*lumTexMask + thismaxlumLevel*lumTex;     
      
      % thisStimImage       = scr.gray +  maskMaxLumLevel*lumTexMask;
        
        disp(stairLevel)
        
    elseif(strcmp(stim.category,'discTargDiscMask'))
        % Luminance disc target with disc masker
                % we set the phase and orientation for each stimulus based on the 
        % conditions matrix stim.conMat
        
        % stim.conMat(:,1) - target orientation
        % stim.conMat(:,2) - mask orientation
        % stim.conMat(:,3) - phase relationship
        
       
        thisTargDiscPhase   = thisPhase;
                
        if(stim.conMat(i,1)==1)
           thisTargDiscOri =  +45;
        else
           thisTargDiscOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisTargDiscOri;
        
        if(stim.conMat(i,2)==1)
            thisMaskDiscOri = thisTargDiscOri;
        else
            thisMaskDiscOri = -thisTargDiscOri;
        end
        
        if(stim.conMat(i,3)==1)
            thisMaskDiscPhase = thisTargDiscPhase;
        else
            thisMaskDiscPhase = 180 - thisTargDiscPhase;
        end
        
        thisLumLevel    = stim.lumLevels(stairLevel);
        lumDiscTarg         = makeLumDisc(stim.size, thisTargDiscPhase, thisTargDiscOri, ...
                                      stim.env.edgetaper, stim.env.circtaper);
                                  
        thisMaskLumLevel    = stim.pedestal.lumLev;
        lumDiscMask         = makeLumDisc(stim.size, thisMaskDiscPhase, thisMaskDiscOri, ...
                                      stim.env.edgetaper, stim.env.circtaper);
                                  
        thisStimImage       = scr.gray + scr.inc*thisLumLevel*lumDiscTarg + thisMaskLumLevel*lumDiscMask;
        
    elseif(strcmp(stim.category,'lumdiscTexMask'))
        
        % we set the phase and orientation for each stimulus based on the 
        % conditions matrix stim.conMat
        
        % stim.conMat(:,1) - target orientation
        % stim.conMat(:,2) - mask orientation
        % stim.conMat(:,3) - phase relationship
        
       
        thisDiscPhase   = thisPhase;
                
        if(stim.conMat(i,1)==1)
           thisDiscOri =  +45;
        else
           thisDiscOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisDiscOri;
        
        if(stim.conMat(i,2)==1)
            thisTexOri = thisDiscOri;
        else
            thisTexOri = -thisDiscOri;
        end
        
        if(stim.conMat(i,3)==1)
            thisTexPhase = thisDiscPhase;
        else
            thisTexPhase = 180 - thisDiscPhase;
        end
        
        thisLumLevel    = stim.lumLevels(stairLevel);

        lumDisc         = makeLumDisc(stim.size, thisDiscPhase, thisDiscOri, ...
                                      stim.env.edgetaper, stim.env.circtaper);
                                  
        thismaxlumLevel     = stim.blob.maxlum;         
        
        gaussInStruct.imSize        = stim.size;
        gaussInStruct.mpSize        = stim.blob.mpSize;      
        gaussInStruct.nPattSide     = stim.blob.nPattSide;

        gaussInStruct.pWL           = stim.blob.pW; 
        gaussInStruct.sigma         = stim.blob.sigma;
        gaussInStruct.dodots        = stim.blob.dodots;
        gaussInStruct.ori           = thisTexOri;
        gaussInStruct.phase         = thisTexPhase; 
            
        [lumTex,nWL,nBL]    = makeRandThrowGaussStim(gaussInStruct);

        thisStim.nWL        = nWL; 
        thisStim.nBL        = nBL;                           
        
        thisStimImage       = scr.gray + scr.inc*thisLumLevel*lumDisc + thismaxlumLevel*lumTex;
        
        
    elseif(strcmp(stim.category,'twoLumCue'))

        % This was modified on 12/14/2020 so that the Disc cue is no longer
        % presented in isolation, but rather in the presence of an
        % uninformative texture boundary (pW = 0.5). We assume that one is
        % presenting the luminance disc at a threshold determined for this
        % uninformative masker
        
        % In this paradigm, what we do depends on the condition
        % 1: disc only
        % 2: texture only
        % 3: disc + texture (aligned) 
        % 4: disc + texture (conflict)

        % Make luminance texture
        if(varypW)
            thispWLevel         = stim.blob.pW(stairLevel);
            thismaxlumLevel     = stim.blob.maxlum;
        elseif(varymaxlum)
            thispWLevel         = stim.blob.pW; 
            thismaxlumLevel     = stim.blob.maxlum(stairLevel);
        end
        
        lumDisc = zeros(stim.size,stim.size);
%        lumTex  = zeros(stim.size,stim.size); 
        thisLumLevel = 0; 
        
        % make a luminance disc if necessary
        if(stim.conVec(i)==1 || stim.conVec(i)==3 || stim.conVec(i)==4 )
            
            thisLumLevel    = stim.pedestal.lumLev(stairLevel);
            lumDisc         = makeLumDisc(stim.size, thisPhase, thisOri, ...
                                            stim.pedestal.env.edgetaper, stim.pedestal.env.circtaper);         
        
%             thisStim.nWL  = 0; 
%             thisStim.nBL  = 0; 
        
        end
        
        % always make a luminance texture
%        if(stim.conVec(i)==2 || stim.conVec(i)==3 || stim.conVec(i)==4 )
            
            if(stim.conVec(i)==1 || stim.conVec(i)==2 || stim.conVec(i)==3)
               texOri = thisOri; 
            elseif(stim.conVec(i) == 4)
               texOri = -thisOri;   % cue conflict
            end
            
            if(stim.conVec(i)==3 || stim.conVec(i)==4)   
                if(stim.phaseVec(i)==1)
                    texPhase = 180-thisPhase; 
                else
                    texPhase = thisPhase;
                end
            else
                texPhase = thisPhase;
            end
            
            gaussInStruct.imSize        = stim.size;
            gaussInStruct.mpSize        = stim.blob.mpSize;      
            gaussInStruct.nPattSide     = stim.blob.nPattSide;

            if(stim.conVec(i)==1)
                gaussInStruct.pWL       = 0.5;
            else
                gaussInStruct.pWL       = thispWLevel; 
            end
            
            gaussInStruct.sigma         = stim.blob.sigma;
            gaussInStruct.dodots        = stim.blob.dodots;
            gaussInStruct.ori           = texOri;
            gaussInStruct.phase         = texPhase; 
            
            [lumTex,nWL,nBL]  = makeRandThrowGaussStim(gaussInStruct);

            thisStim.nWL  = nWL; 
            thisStim.nBL  = nBL; 
     
%        end
        
        thisStimImage   = scr.gray + scr.inc*thisLumLevel*lumDisc + thismaxlumLevel*lumTex;
        
    elseif(strcmp(stim.category,'gaussBlobDLFix'))
    
        % for this paradigm we use MCS
        % placeholders
        thispWLevel     = -1;
        thisdensLevel   = -1;

        stairLevel      = curPerm_nCLL(curLev_nCLL); 
        thisnCLLevel    = stim.blob.nCL(stairLevel);
        thisnWLLevel    = stim.blob.nWL;
        thismaxlumLevel = stim.blob.maxlum; 
        
        gaussInStruct.imSize        = stim.size; 
        gaussInStruct.mpSize        = stim.blob.mpSize;      
     
        gaussInStruct.nWL           = thisnWLLevel; 
        gaussInStruct.nCL           = thisnCLLevel;    
        gaussInStruct.ori           = thisOri;
        gaussInStruct.phase         = thisStim.env.phase;
        gaussInStruct.sigma         = stim.blob.sigma;
        gaussInStruct.dodots        = stim.blob.dodots;
    
        [lumTex,nWL,nBL]    = makeRandThrowGaussStimFix(gaussInStruct);
        
        thisStimImage       = scr.gray + thismaxlumLevel*lumTex;
        
        thisStim.nCLevel    = thisnCLLevel;
        thisStim.nWL        = nWL;
        thisStim.nBL        = nBL;
       
        % increment curLev
        curLev_nCLL = curLev_nCLL + 1; 
        if(curLev_nCLL >numLev_nCLL)
            curLev_nCLL     = 1; 
            curPerm_nCLL    = randperm(numLev_nCLL); 
        end
        
    elseif(strcmp(stim.category,'lumDisc')) % Plain luminance disc
 
        % Make plain luminance disc
        thisLumLevel    = stim.lumLevels(stairLevel);
        lumDisc         = makeLumDisc(stim.size, thisStim.env.phase, thisStim.env.ori, stim.env.edgetaper, stim.env.circtaper);
        thisStimImage   = scr.gray + scr.inc*thisLumLevel*lumDisc;

    elseif(strcmp(stim.category,'lumDiscMask')) % Luminance disc with noise mask
        
        thisLumLevel    = stim.lumLevels(stairLevel); 
        
        if(strcmp(stim.mask.category,'white'))
            thisStimImage   = makeLumDiscWhiteMask(thisStim,thisLumLevel,thisStim.mask.RMScont,thisStim.mask.normRMS);
        else
           error('masking category not recognized!') 
        end
           
        % clipping - should not be needed                               
        thisStimImage(find(thisStimImage > 1)) = 1; 
        thisStimImage(find(thisStimImage < 0)) = 0; 
     
    elseif(strcmp(stim.category,'natTexLTB'))
        % This creates a luminance texture boundary using a natural
        % texture
        
        texParams           = stim.texParams; 
        texParams.ori       = thisStim.env.ori; 
        texParams.phase     = thisStim.env.phase; 
        
        thisLumLevel        = stim.lumLevels(stairLevel);
        texParams.dLset     = thisLumLevel;
        
        texIn               = subsample_texture(texParams.texIn,texParams.subsz,stim.size);
        [texOut,IR,IL,dL_diag,dL_anti]   = makeTextureLTBStim(texParams,texIn);
                
        thisStimImage       = scr.gray + scr.inc*texOut;
        
        thisStim.dL_diag    = dL_diag;
        thisStim.dL_anti    = dL_anti; 
        
    elseif(strcmp(stim.category,'natTexLSB'))
        % This creates a luminance texture boundary by superimposing
        % a luminance step over the 
        
        texParams           = stim.texParams; 
        texParams.ori       = thisStim.env.ori; 
        texParams.phase     = thisStim.env.phase; 
        
        thisLumLevel        = stim.lumLevels(stairLevel);
        texParams.dLset     = thisLumLevel;
        
        texIn               = subsample_texture(texParams.texIn,texParams.subsz,stim.size);
        [texOut,dL_diag,dL_anti]   = makeTextureLSBStim(texParams,texIn);
                
        thisStimImage       = scr.gray + scr.inc*texOut;
        
        thisStim.dL_diag    = dL_diag;
        thisStim.dL_anti    = dL_anti; 
      
    elseif(strcmp(stim.category,'lumDiscDL'))
        
        stepParams           = stim.stepParams;
        stepParams.ori       = thisStim.env.ori; 
        stepParams.phase     = thisStim.env.phase; 
        
        thisLumLevel         = stim.lumLevels(stairLevel);
        stepParams.dLset     = thisLumLevel;
        
        [texOut,dL_diag,dL_anti]   = makeStepLSBStim(stepParams);
                
        thisStimImage        = scr.gray + scr.inc*texOut;
        
        thisStim.dL_diag     = dL_diag;
        thisStim.dL_anti     = dL_anti; 
        
    elseif(strcmp(stim.category,'lumDisclumMaskDL'))
        
        thisTargDiscPhase    = thisPhase; 
        
        stepParams           = stim.stepParams;
        maskParams           = stim.stepParams;
        
        
        if(stim.conMat(i,1)==1)
           thisTargDiscOri =  +45;
        else
           thisTargDiscOri =  -45; 
        end
        
        % re-assign thisOri
        thisOri = thisTargDiscOri;
        
        if(stim.conMat(i,2)==1)
            thisMaskDiscOri = thisTargDiscOri;
        else
            thisMaskDiscOri = -thisTargDiscOri;
        end
        
        if(stim.conMat(i,3)==1)
            thisMaskDiscPhase = thisTargDiscPhase;
        else
            thisMaskDiscPhase = 180 - thisTargDiscPhase;
        end 
        
        thisLumLevel          = stim.lumLevels(stairLevel);
        stepParams.dLset      = thisLumLevel;
        stepParams.ori        = thisTargDiscOri;
        stepParams.phase      = thisTargDiscPhase;
        
        maskParams.dLset      = stim.pedestal.lumLev;
        maskParams.ori        = thisMaskDiscOri;
        maskParams.phase      = thisMaskDiscPhase;
        
        [stepOut,dL_diag,dL_anti]   = makeStepLSBStim(stepParams);
        [maskOut, ~, ~]       = makeStepLSBStim(maskParams);        
        
        thisStimImage         = scr.gray + scr.inc*stepOut + scr.inc*maskOut;
        
        thisStim.dL_diag      = dL_diag;
        thisStim.dL_anti      = dL_anti; 
        
%     elseif(strcmp(stim.category,'twoifcTargTexPedLum')) 
%         % Detect a luminance texture on a luminance disc pedestal    
%         % This uses a two-interval set-up. The appropriate keys are '1'
%         % and '2' in order to indicate the interval.
%         
%         % level for target
%         thispWLevel         = stim.blob.pW; 
%         thismaxlumLevel     = stim.blob.maxlum(stairLevel);
%         
%         % level for pedestal
%         thisLumLevel        = stim.lumLevels; 
%         
%         % which interval contains target
%         whichInterval       = stim.trial.target(i);
%         
%         gaussInStruct.imSize        = stim.size;
%         gaussInStruct.mpSize        = stim.blob.mpSize;      
%         gaussInStruct.nPattSide     = stim.blob.nPattSide;
% 
%         gaussInStruct.pWL           = thispWLevel; 
%         gaussInStruct.sigma         = stim.blob.sigma;
%         gaussInStruct.dodots        = stim.blob.dodots;
%         gaussInStruct.ori           = 0;
%         gaussInStruct.phase         = thisPhase; 
%         
%         if(stim.pedestal.env.inphase)
%             maskPhase = thisPhase;
%         else
%             maskPhase = 180 - thisPhase; 
%         end
%         
%         [lumTex,nWL,nBL]            = makeRandThrowGaussStimFix(gaussInStruct);
%         lumDisc                     = makeLumDisc(stim.size, maskPhase, 0, 0, 0.2);
          
    else
        error('Stimulus type not supported!');
    end

    % Prompt to begin trial
    flag             = psyPromptAndWait(scr,key,flag);                
    if flag.break  
        break; 
    end  

    if(strcmp(task.type,'2afc'))
    
        % Present stimulus
        thisStim.presTime = psyPresentStimulus(thisStimImage,stim.nFrames,scr);

        % Wait for response
        [thisResp,flag] = psyCollectResponse(key,flag,task);  
        if flag.break 
            break;  
        end  

        if(thisResp == sign(thisOri))
            isCorrect = 1;  
        else
            isCorrect = 0; 
        end

    elseif(strcmp(task.type,'2ifc'))
        
      % NOT SUPPORTED! 
        
        
    end
    
    % Give feedback (optionally):
    if task.feedback
        if (~isCorrect)
            fprintf(1,'incorrect !\n');
            % visual feedback, that response was incorrect
            Screen('FillRect',scr.stimWinPtr,255,scr.errRect);	% show error icon
            Screen('Flip', scr.stimWinPtr);
            Screen('FillRect',scr.stimWinPtr,255,scr.errRect);                
            WaitSecs(task.iconMsec/1000);
            Screen('FillRect',scr.stimWinPtr, scr.gray);        % gray out the whole screen
            Screen('Flip', scr.stimWinPtr);
            Screen('FillRect',scr.stimWinPtr, scr.gray);        % and the background buffer  
        else  % feedback that response was correct (including ambiguous case of vertical)
            fprintf(1,'correct\n');
            Screen('FillRect',scr.stimWinPtr,255,scr.fpRect);   % show fp icon, as "correct"
            Screen('Flip', scr.stimWinPtr);
            Screen('FillRect',scr.stimWinPtr,255,scr.fpRect);                
            WaitSecs(task.iconMsec/1000);
            Screen('FillRect',scr.stimWinPtr, scr.gray);        % gray out the whole screen
            Screen('Flip', scr.stimWinPtr);
            Screen('FillRect',scr.stimWinPtr, scr.gray);        % and the background buffer      
        end
    else
       WaitSecs(task.iconMsec/1000); 
    end
     
    % Update number correct + number trials at the current staircase level
    results.nstimlv(stairLevel) = results.nstimlv(stairLevel) + 1;   
    if(isCorrect)
        results.correct(stairLevel) = results.correct(stairLevel) + 1;
    end
    
    thisStim.thisOri    = thisOri;
    thisStim.thisResp   = thisResp;  
    thisStim.stairLevel = stairLevel;
    
    if(doGauss && ~strcmp(stim.category,'lumDiscPedestal') && ~strcmp(stim.category,'lumdiscTexMask'))
        thisStim.pWLevel     = thispWLevel;  
        thisStim.maxlumLevel = thismaxlumLevel;
    elseif(strcmp(stim.category,'ormod'))
        thisStim.thisOrModLev = thisOrModLevel; 
    elseif(strcmp(stim.category,'cm'))
        thisStim.thisCMLevel  = thisCMLevel; 
    else
        thisStim.thisLumLev = thisLumLevel;  
    end
    
    
    if(stim.saveImages)
        thisStim.thisStimImage = thisStimImage;
    end
         
    trialRecord(i) = thisStim; 
    
    % Do staircase level adjustment 
    if(isCorrect)
        nCorrLevel(stairLevel) = nCorrLevel(stairLevel) + 1; 
        nCorrInRow = nCorrInRow + 1; 
        if(nCorrInRow == stim.stairNDown)
            stairLevel = max(1,stairLevel-1); % go down one level 
            nCorrInRow = 0; 
        end
    else
        stairLevel = min(stim.nLevels,stairLevel + 1);
    end 
   
    % Break if flag.break
    if flag.break        
        break;  
    end
    
end

% Return monitor to default state
isDPP       = strcmp(monitorCode,'Disp++');
isBitsSharp = strcmp(monitorCode,'EV17F2');
isCRS       = isDPP | isBitsSharp;

if(isDPP)
    COMPort     = 'COM4';
else
    COMPort     = 'COM7';
end

if(isCRS)
    % Set back to Bits++ mode + close serial port  
    fopen(scr.s1); 
    fprintf(scr.s1, ['#BitsPlusPlus' 13]);
    fclose(scr.s1);
else
   % Remove hardware Gamma correction 
   gammaTable = (1/255)*[(0:255)',(0:255)',(0:255)'];
   Screen('LoadNormalizedGammaTable',scr.stimWinPtr,gammaTable);
   Screen('ColorRange',scr.stimWinPtr,1.0,1); 
end

% Close screen
Screen('Close',    scr.stimWinPtr);     % deallocate off-screen memory
Screen('CloseAll');                     % close all windows

% Print results
results.prcnt = 100*results.correct./results.nstimlv;

% Clear command window
% clc;
fprintf(1,'\n\n\n');

if(doGauss && ~strcmp(stim.category,'lumDiscPedestal') && ~strcmp(stim.category,'lumdiscTexMask'))
    if(varypW)
        displayLevels = stim.blob.pW;
    elseif(varymaxlum)
        displayLevels = stim.blob.maxlum; 
    elseif(varynCL)
        displayLevels = stim.blob.nCL; 
    end
    stimVary = stim.blob.vary;
elseif(strcmp(stim.category,'ormod'))    
    displayLevels = stim.orModLevels;
    stimVary = '';
elseif(strcmp(stim.category,'cm'))
    displayLevels = stim.cmStimParams.cmLevels;
    stimVary = '';
else
    displayLevels = stim.lumLevels;
    stimVary = '';
end

displayResults(results.prcnt,results.nstimlv,displayLevels,stim.category,stimVary);


% save results to psyTMP
save psyTMP 'trialRecord' 'results' -append;  
 
% This code, as originally written by Liz, assumes that the data will 
% be saved (at least temporarily) in the same directory as the 
% program (CODE). I would prefer that all data files are saved on the 
% LOCAL machine so as to avoid taking up space on the CNPLab Dropbox
%
% Towards this end, I am replacing fName_first with the full path
% including the directory
%
% 
% create new variable which includes the data directory
% fName_full_path = strcat(paths.records,'/',fName_first); 
%  
% if exist(fName_full_path,'file')
%     fRun  = input('run number:   ', 's');
%     fName_first  = [fName '_' monitorCode '_' subj '_0' fRun '.mat'];        % create name for data file
%     fName_full_path = strcat(paths.records,'/',fName_first);
% end

% % CD : 05-24-2016
% % if strcmp(task.computer,'Faith')       % (something about Tiger ?)
% %    fName_new = [fName_new '.mat'];
% % end
 
[success,mssg,mssgid] = copyfile('psyTMP.mat',fName_full_path); % $ or movefile
if success
    fprintf(1,'\npsyTMP.mat successfully renamed to:  %s\n',fName_full_path);
else
    disp(mssg);
    error('error in copying file !  -> manually rename psyTMP.mat to desired file name !')
end    

% Added a clear command to clean out the workspace
clear all;