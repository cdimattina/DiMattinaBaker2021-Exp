function [thisResp,flag] = psyCollectResponse(key,flag,task)
%
% psyCollectResponse - wait for observer's response (left or right arrow keys)


% Notes:
%   for Kensington keypad, pagedown does not work 

% Edited by CD 11-16-2016

% Commented out by CD
while KbCheck; end  % wait until all keys are released

while 1
    [keyIsDown, seconds, keyCode] = KbCheck;
    if keyIsDown  
        if (keyCode(key.left) || keyCode(key.end) || keyCode(key.four))
            thisResp = -1;
            break;
        elseif (keyCode(key.right) || keyCode(key.pagedown) || keyCode(key.six))  
            thisResp = +1;
            break;
        elseif (keyCode(key.escape) || keyCode(key.home))
            flag.break = 1;
            fprintf(1,'\naborting this run\n\n');
            % break; % Added by CD
        end
        % Commented out by CD
        while KbCheck; end      % wait until key has been released
    end
end    

if task.mirror == 1
    thisResp = -1*thisResp;
end

%fprintf(1,'thisResp = %d\n',thisResp);       




