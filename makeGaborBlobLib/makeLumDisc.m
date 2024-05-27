
function lumDisc = makeLumDisc(imSize, phase, ori, taperEdge,taperMask)

    env.type  = 'halfDisc';
    env.taper = taperEdge; 
    env.phase = phase;
    env.shift = 0;
    env.ori   = ori;     
    lumDisc   = stimMakeEnvPattPsy(env,imSize).*stimMakeCosTaper2(imSize,taperMask);
  
end