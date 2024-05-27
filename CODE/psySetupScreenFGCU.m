function scr = psySetupScreenFGCU(monitorCode,stimSize,scr)
%
% psySetupScreen - set up crt screen for psychophysics
%
%  usage:  scr = psySetupScreen(stimSize,scr)


% recent changes:
% ??, AY:  bitsplusplus
% 23 Apr 08, CB:  flag.bitsplusplus -> scr.bitsplusplus


% needs to run:
%   csm_CRT_info.m - loads z-calib parameters for CRT
%   gam_z_corr.m - create linearized clut

% We do not use Bits++ at FGCU
% 
%

% if (~scr.bitsplusplus)
% %     [scr,z] = csm_crt_info;     % scr.xxx info about CRT, e.g. gamma-correction info (z)
%     csm_crt_info;     % scr.xxx info about CRT, e.g. gamma-correction info (z)
% 
%     scr.grayClut = gam_z_corr(scr.gammaOption,z,scr.rgRatio);	% calc linearized clut
%     clear z;	% -> rename to scr.z (also in CSM2)   
%     % suppress detailed screen-checking
%     scr.oldVisualDebugLevel   = Screen('Preference', 'VisualDebugLevel', 3);
%     scr.oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);	
%     scr.whichScreen = max(Screen('Screens')); % use largest screen number
% 
%     [scr.stimWinPtr,scr.stimRect] = Screen('OpenWindow', scr.whichScreen);
%     Screen('LoadNormalizedGammaTable',scr.stimWinPtr,scr.grayClut/256);    
% 
% elseif (scr.bitsplusplus)           % if there is a bits++ connected
%     scr.oldVisualDebugLevel   = Screen('Preference', 'VisualDebugLevel', 3);
%     scr.oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);	
%     scr.whichScreen = max(Screen('Screens')); % use largest screen number
%     [scr.stimWinPtr,scr.stimRect] = Screen('OpenWindow', scr.whichScreen);
% 
%     
%     Screen('LoadNormalizedGammaTable',scr.stimWinPtr,linspace(0,1,256)'*ones(1,3));     % Load a linearized ramp to graphic card's CLUT
%     
%     LoadIdentityClut(scr.stimWinPtr);
%     
%     csm_crt_info;
%     Clutentries = gam_z_corr(scr.gammaOption,z,scr.rgRatio);	% calc linearized lut, from z-calib in csm_config.m    
%     Clut=Clutentries*256;           % Scale the inverse gamma to be between 0 and 65535
%     BitsPlusSetClut(scr.stimWinPtr,Clut);           % write the inverse gamma to bits++ CLUT
%     clear z;
% end

% Suppress detailed screen-checking
scr.oldVisualDebugLevel     = Screen('Preference', 'VisualDebugLevel', 3);
scr.oldSupressAllWarnings   = Screen('Preference', 'SuppressAllWarnings', 1);	
scr.whichScreen             = max(Screen('Screens')); % use largest screen number

%%%%% NEW CODE: CHRIS DIMATTINA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scr.bitsplusplus = 0;       % We have a Bits# at FGCU, not a Bits++

    isDPP       = strcmp(monitorCode,'Disp++');
    isBitsSharp = strcmp(monitorCode,'VM404') | strcmp(monitorCode,'VSQ71') | strcmp(monitorCode,'EV17F2'); 
    isCRS       = isDPP | isBitsSharp;

    
    
    % With firmware update, for BitsSharp is COM7
   % Default COM port for Disp++
    if(IsWindows)
        COMPort = 'COM4';
        if(isBitsSharp)
            COMPort = 'COM7';
        end
    else
        % COMPort on the Disp++
        COMPort = '/dev/ttyACM0';    
    end
    
     if(isCRS)
        % Statements to allow use of full 14 bit range
        %
      
        % If using Display++/Bits#, open communication port and establish
        % communication with device.
        s1 = serial(COMPort);
        fopen(s1);
        % Set to Mono++ mode
        fprintf(s1, ['$monoPlusPlus' 13]);
       
        % For Bits# system, load appropriate Gamma correction file depending
        % on which CRT monitor is being used
        if(isBitsSharp)
            if(strcmp(monitorCode,'VM404'))
                gammafName = 'VM404APR19'; 
            elseif(strcmp(monitorCode,'VSQ71')) 
                gammafName = 'VSQ71JUN19';
            elseif(strcmp(monitorCode,'EV17F2'))
                gammafName = 'EV17F2JUN19';
            else
               error('Monitor not calibrated recently!');
            end
            
            fprintf(s1,[sprintf('$enableGammaCorrection=[%s.txt]',gammafName) 13]);
            pause(3); 
            
        end
        
        if(isDPP)
             fprintf(s1, ['$TemporalDithering=[ON]' 13]);
        end
        
        scr.s1 = s1; 
        fclose(s1); 
        
        
        % Code to permit use of 14 bit range 
        PsychImaging('PrepareConfiguration');
        PsychImaging('AddTask','General','FloatPoint32Bit');
        PsychImaging('AddTask','General','EnableBits++Mono++OutputWithOverlay'); 
        
        
    else
        % Otherwise, we are using one of the two desktop systems for
        % testing/debugging purposes    
        
        % There is no need to set the monitor mode
    end
    
    % Open psychtoolbox window and get information about the monitor
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    % Get the number of screens attached to the device + use the highest
    % numbered screen in case of multiple monitors
    screens         = Screen('Screens');
    screenNumber    = max(screens);
    
    if(screenNumber > 0)
        Screen('Preference', 'SkipSyncTests',1);
    end
    
    % Define black and white (white will be 1 and black 0). This is because
    % luminace values are genrally defined between 0 and 1.
    white           = WhiteIndex(screenNumber);
    black           = BlackIndex(screenNumber);
    grey            = white / 2;
    
    [scr.stimWinPtr, scr.stimRect] = PsychImaging('OpenWindow', screenNumber,grey,[],32,2);
    Screen('BlendFunction', scr.stimWinPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    if(isCRS)      
        % Nullify graphics card gamma table
        linearLUT = repmat((linspace(0,255/256,256))', 1, 3);
        Screen('LoadNormalizedGammaTable',scr.stimWinPtr,linearLUT);
        Screen('ColorRange',scr.stimWinPtr,1.0,1);
    else
        % Use hardware gamma correction (Gamma = 2.2) 
        gammaTable = (1/255)*[(0:255)',(0:255)',(0:255)'];
        gammaTable = gammaTable.^(1/2.2);  % Apply gamma correction for Gamma = 2.2
        Screen('LoadNormalizedGammaTable',scr.stimWinPtr,gammaTable);
        Screen('ColorRange',scr.stimWinPtr,1.0,1);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (scr.stimRect(4) < stimSize)
    Screen('Close', scr.stimWinPtr);    % deallocate off-screen memory
    Screen('Closeall');
    error('stim.size is too large for this screen height !');
end

scr.refreshHz=Screen('NominalFrameRate',scr.stimWinPtr);

if (scr.refreshHz==0)  % (if MacOSX does not know the frame rate) 
    scr.refreshHz=75;
    fprintf(1,'cannot measure frame rate, using %f Hz\n',scr.refreshHz);
end

scr.black = BlackIndex(scr.stimWinPtr);  % Retrieves the CLUT color code for black.
scr.white = WhiteIndex(scr.stimWinPtr);  % Retrieves the CLUT color code for white.
scr.gray = (scr.black + scr.white) / 2;  % Computes the CLUT color code for gray.
scr.inc = abs(scr.white - scr.gray);

scr.fpRect  = CenterRect(SetRect(0,0,6,6),  scr.stimRect);		% create fixation point
scr.errRect = CenterRect(SetRect(0,0,20,10),scr.stimRect);		% create error icon

Screen('FillRect',scr.stimWinPtr, scr.gray);     % gray out the whole screen
Screen('Flip', scr.stimWinPtr);
Screen('FillRect',scr.stimWinPtr, scr.gray);	 % and the background buffer


