%%
% THIS PROGRAM WILL BE INTEGRATED INTO PsyCPLAB (CD, 12-05-22)
%%

function [thisImage] = stimMakeTexQuilt(stim)

% This is the highly simplified and gutted version of stimMakeTexSeg.m
% by Liz Zavitz (Arsenault)


imgSize           = stim.size;
envPatt           = stimMakeEnvPattPsy(stim.env,imgSize); % range -1 to +1

% note that within the disk, (envPattA.^2 + envPattB.^2) always sums to 1.0, seamlessly across the contour
envPattA          = sqrt((1 + (stim.modDepth/100)*envPatt)/2.0).*stim.winMask;  % range -1 to +1
envPattB          = sqrt((1 - (stim.modDepth/100)*envPatt)/2.0).*stim.winMask;      
   
halfPattA         = stim.carrPattA.*envPattA;    % re-envelope, now with zero-mean -> range -.5 to +.5
halfPattB         = stim.carrPattB.*envPattB;    % re-envelope, now with zero-mean -> range -.5 to +.5
thisImage         = halfPattA + halfPattB;  % quilt, range -1 to +1


% 
% %%%%%%% Added by CD: 3/4/2019 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Zero-mean stimulus image
% thisStimImageZM = scr.inc*stim.carrMCon*thisStimImage;
% 
% if(stim.fixRMSCon)
%     c = (stim.RMSConVal/RMScontrast2(thisStimImageZM));
%     thisStimImageZM = c*thisStimImageZM;   
% end
% 
% thisStimImage = scr.gray + thisStimImageZM;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Clip values < min 
% thisStimImage(find(thisStimImage < scr.black)) = scr.black; 
% % Clip values > max
% thisStimImage(find(thisStimImage > scr.white)) = scr.white;
 
end
