% DisplayExperimentMessage.m
% by
% Christopher DiMattina, PhD
% Florida Gulf Coast University
%
% Description: This program displays a message in to the specified
%              Psychtoolbox window and waits for a keypress
%              
% Copyright (C) 2015- Christopher DiMattina
%           
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% Version: 1.0 Beta
%       
% Changes: 1-22-2015: Created by CD 
%
% Usage:   DisplayExperimentMessage( window, messageStr, fontSize)
%  
%% Inputs 
% 
% window     - Handle to Psychtoolbox window
% messageStr - Message to display
% fontSize   - Text font size


function DisplayExperimentMessage( window, messageStr, fontSize )
    
    WaitSecs(0.5);
    Screen('TextSize', window, fontSize);
    DrawFormattedText(window, messageStr, 'center', 'center', [1 1 1]);
    Screen('Flip',window,0,0);
    KbStrokeWait;
    Screen('Flip',window,0,0);
    FlushEvents;
    WaitSecs(0.5);
    
end

