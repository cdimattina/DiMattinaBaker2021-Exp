function b = makeVBar(mpSize,barW,barL)

    b       = zeros(mpSize,mpSize);
    c       = mpSize/2;
    
    barW2   = floor(barW/2);
    barL2   = floor(barL/2); 
    
    cind    = (c - barW2 + 1):(c + barW2);
    rind    = (c - barL2 + 1):(c + barL2); 
    
    b(rind,cind)     = 1;
    
end