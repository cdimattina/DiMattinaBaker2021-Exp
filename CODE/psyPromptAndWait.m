function flag = psyPromptAndWait(scr,key,flag)
%
% psyPromptAndWait - prompt observer that we are ready for a trial, and wait for button-press
%

fixLetters = {'A', 'B', 'C', 'D', 'E',...
                  'F', 'G', 'H', 'I', 'J',...
                  'K', 'L', 'M', 'N', 'O',...
                  'P', 'Q', 'R', 'S', 'T',...
                  'U', 'V', 'W', 'X', 'Y', 'Z'};

fpXpos = round(scr.stimRect(3)/2); % width
fpYpos = round(scr.stimRect(4)/2); % height

if IsLinux==0
        Screen('TextFont',scr.stimWinPtr, 'Helvetica');
        Screen('TextSize',scr.stimWinPtr, 14);
        Screen('TextStyle', scr.stimWinPtr, 1);
end;

%Screen('FillRect',scr.stimWinPtr,255,scr.fpRect);

% Modified by CD to show letters on PC. I think the MAC does color
% differenetly

Screen('DrawText', scr.stimWinPtr, fixLetters{round(rand(1)*25)+1}, fpXpos, fpYpos, [255, 255, 255]);
Screen('Flip', scr.stimWinPtr);
Screen('DrawText', scr.stimWinPtr, fixLetters{round(rand(1)*25)+1}, fpXpos, fpYpos, [255, 255, 255]);

%Screen('FillRect',scr.stimWinPtr,255,scr.fpRect);       

% wait for down-arrow key:      (see KbDemo.m in PTB)
while KbCheck; end  % wait until all keys are released
while 1
    [keyIsDown, seconds, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(key.down) || keyCode(key.five)
            break;
        elseif (keyCode(key.escape) || keyCode(key.home))
            flag.break = 1;
        end
        while KbCheck; end    % wait until key has been released
    end
end       
