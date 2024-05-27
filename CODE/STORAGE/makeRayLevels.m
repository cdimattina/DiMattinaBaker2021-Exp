function  [ levelMat ] = makeRayLevels(minJND,maxJND,rayAngle,nLevels)
    
    % Make column vector
    xVec        = linspace(minJND,maxJND,nLevels);
    yVec        = zeros(1,nLevels);
    V           = [xVec; yVec];
    thetaRad    = (pi/180)*rayAngle;
    rotMat      = [cos(thetaRad) , -sin(thetaRad) ; sin(thetaRad), cos(thetaRad)];
   
    levelMat    = rotMat*V; 
    
end