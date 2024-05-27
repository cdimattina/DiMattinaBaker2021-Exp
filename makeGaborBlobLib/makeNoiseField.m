% makeNoiseField.m
% 
% Description:  This program makes a zero-mean noise field 
% 

function noiseMask = makeNoiseField( sz, mu, RMSCont, circleMask)
    
    % calculate sigma from mean luminance level and RMS      
    sigma       = RMSCont*mu;
    noiseMask   = sigma*randn(sz,sz); % zero-mean noise field;
    noiseMask   = circleMask.*noiseMask;
    
end