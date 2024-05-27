

JNDmin      = 0.5;
JNDmax      = 1.5; 
nLevels     = 11; 
rayAngleVec = [0, 15, 30, 45, 60, 75, 90];

figure(1); 

for i=1:length(rayAngleVec)
    [ levelMat ] = makeRayLevels(JNDmin,JNDmax,rayAngleVec(i),nLevels);
    plot(levelMat(1,:),levelMat(2,:),'b.'); hold on; axis square; grid on;  
end