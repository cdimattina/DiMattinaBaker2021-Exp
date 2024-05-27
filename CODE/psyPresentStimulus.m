% PsyPresentStimulus.m Draws the current stimulus image on the screen
% draws the texture and refreshes it for nFrames
% used in psyTexSegMain.m
% 
% Recent Changes
% 1 Nov AY:
% modified screen to use drawtexture instead of put image
function presTime = psyPresentStimulus(thisStimImage,nFrames,scr)
%
%

ifi                  = Screen('GetFlipInterval', scr.stimWinPtr);

priorityLevel = MaxPriority(scr.stimWinPtr);
Priority(priorityLevel);                   % beginning of real-time priority
Screen('FillRect', scr.stimWinPtr, scr.gray);   % gray out the screen
texPtr = Screen('MakeTexture',scr.stimWinPtr,thisStimImage);

% for iFrame=1:nFrames
%     Screen('DrawTexture', scr.stimWinPtr, texPtr); % write image to stimulus window
%     Screen('Flip', scr.stimWinPtr, vbl + (waitframes - 0.5) * ifi);   % update the screen to reflect changes
% end
% 
% Screen('FillRect', scr.stimWinPtr, scr.gray);   % gray out the screen
% Screen('Flip', scr.stimWinPtr); 


Screen('DrawTexture', scr.stimWinPtr, texPtr); % write image to stimulus window

vbl1 = Screen('Flip', scr.stimWinPtr);
vbl2 = Screen('Flip', scr.stimWinPtr, vbl1 + ifi*(nFrames-0.5));

presTime = vbl2-vbl1; 
disp(vbl2-vbl1);

% Added by CD - closes texture so memory does not get clogged
Screen('Close', texPtr);
% Screen('FillRect', scr.stimWinPtr, scr.gray);   % gray out the screen

Priority(0);        % relax now, finished all the real-time-critical stuff



