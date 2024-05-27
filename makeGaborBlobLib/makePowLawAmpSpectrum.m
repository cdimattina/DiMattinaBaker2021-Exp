function Ipk = makePowLawAmpSpectrum(I,alpha)
    
     % Get image dimensions - should be square.  
    [m,n] = size(I); 
    if(m~=n) 
        error('Input must be square!'); 
    end
    
    % Take FFT of image and extract phase spectrum
    FFTI            = fft2(I);
    IPhSp           = angle(FFTI);

    %---------- THIS SNIPPET TAKEN FROM generatepinknoise.m
    % calculate 1/f amplitude matrix (for the DC component, manually set it to 0)
    [xx,yy] = calccpfov(m);
    cpfov   = ifftshift(sqrt(xx.^2 + yy.^2));
    NAmSp   = zerodiv(1,cpfov.^alpha);  % not fftshifted
    %---------- END SNIPPET

    FFTIpk          = (NAmSp.*exp(1i*IPhSp)); 
    Ipk             = real(ifft2(FFTIpk));
         
    % flip image
   % Ipk = flipud(fliplr(Ipk));
    
end