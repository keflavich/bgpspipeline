function make_atmosphere, timestream, bolo_params, amplitude=amplitude, $
  samplerate=samplerate, relative_scale_rms=relative_scale_rms,$
  individual_bolonoise_rms=individual_bolonoise_rms,dofilter=dofilter,$
  relative_scales=relative_scales,offset_plane=offset_plane,fix_bolo_0=fix_bolo_0,seed=seed

    ; distribution: y = 10.0^6*x^(-1.78)
    ; N(x) = { 10.0^6*x^(-1.78)   | x < 0.4 Hz
    ;        { 10.0^4*x^(-0.57)   | x > 0.4 Hz

    if n_elements(seed) eq 0 then seed=systime(/sec)

    ds1rate = 0.02
    if n_elements(samplerate) eq 0 then samplerate = 0.1 ; bolocam defaults
    dsfactor = samplerate/ds1rate
    if dsfactor ne round(dsfactor) then message,"Error: samplerate is not an integer multiple of ds1rate"
    if n_elements(relative_scale_rms) eq 0 then relative_scale_rms = 0.1
    if n_elements(individual_bolonoise_rms) eq 0 then individual_bolonoise_rms = 0.1
    if n_elements(dofilter) eq 0 then dofilter=1
    if n_elements(fix_bolo_0) eq 0 then fix_bolo_0 = 1

    sz = size(timestream,/dim)
    ds1sz = [sz[0],sz[1]*dsfactor]
    insize = ds1sz[1]
    outsize = long(ds1sz[1]) / long(dsfactor)
    ; rescale the noise - should have a mean of 1, not 0, and std determine in pyflagger (see below, 12/13/11)
    gnoise = randomn(seed+0,insize,/normal)*1.20 + 1.0 
    gnoise1 = randomn(seed+1,insize,/normal)*1.20 + 1.0
    randsign1 = sign(randomn(seed+2,insize,/normal))
    randsign2 = sign(randomn(seed+3,insize,/normal))
    ;xarr = (findgen(insize/2)) / (insize) / ds1rate / 2.0
    freq = fft_mkfreq(ds1rate, insize)
    ;pspec = 1e4*xarr^(-1.78) * (xarr lt 0.4) + 3e4*xarr^(-0.57) * (xarr ge 0.4)
    ;pspecold = 1e4*abs(xarr)^(-1.78) * (abs(xarr) lt 2) + 4.3e3*abs(xarr)^(-0.57) * (abs(xarr) ge 2)
    ;pspecold[0] = pspecold[1]
    ;pspec = 1e4*abs(freq)^(-1.78) * (abs(freq) lt 2) + 4.3e3*abs(freq)^(-0.57) * (abs(freq) ge 2)
    ; use a very simple alpha=2 + flat power spectrum
    ; the above are fits to various spectra (that I probably can't reproduce) but are consistent
    ; with the following.  The AMPLITUDE is only consistent with small-scale maps; the amplitude of
    ; everything in the power spectrum goes up for larger scans.  Does this make sense? it implies that
    ; there is a very high delta function in the timestream?.... hmmmm
    ; either way, the point is that the amplitude should be reset, not used as-is
    ; you can reproduct this using pyflagger with f.broken_powerfit(defaultplot=True)
    ;pspec = 1e4*abs(freq^(-2.0)) * (abs(freq) lt 2) + 2.5e3*(abs(freq) ge 2)
    ; 12/13/2011  pyflagger 050706_o53_raw_ds2.nc_indiv13pca_postiter.sav --compute_powerfit
    pspec1 = 10^12.21*abs(freq)^1.04 * (abs(freq) lt 0.02)
    pspec2 = 10^5.70*abs(freq)^(-2.52) * (abs(freq) lt 2) * (abs(freq) gt 0.02)
    pspec3 = 10^5.34*abs(freq)^(-1.30)*(abs(freq) ge 2)
    pspec = pspec1+pspec2+pspec3
    ; the UNDO below only applies to astrosignal, NOT ac_bolos
    ; UNDO! On 12/13/2011, modified to be log-linear (i.e. an exponential) since there was apparently too much high-frequency noise
    ; UNDO! it's not clear that this will fix that issue, though...
    ; UNDO! I now use this pyflagger command in l=30:
    ; UNDO! pyflagger 050706_o53_raw_ds2.nc_indiv13pca_postiter.sav --compute_expfit
    ; UNDO! to compute the best fit...
    ; UNDO! THERE IS STILL A DISCREPANCY AT LOW FREQUENCIES!  ac_bolos is high-pass filtered!
    ; UNDO! pspec = 1e5*10^(-0.5*abs(freq))*(abs(freq) lt 2.5) + 5623.4*(abs(freq) ge 2)
    pspec[0] = pspec[1] ; DC component is non-zero, but also not infinite

    ;realvals = fltarr(insize)
    ;realvals[0:insize/2-1] = pspec
    ;realvals[insize/2:insize-1] = reverse(pspec) 
    ;complexvals_old = complex(sqrt(realvals)*gnoise1,gnoise*sqrt(realvals))
    ;atmold = fft(complexvals_old,-1)

    ; the abs() means that the noise no longer follows a normal distribution perfectly
    ; HOWEVER, I empirically showed that it matches the data reasonably
    complexvals = complex(sqrt(pspec*abs(gnoise1))*randsign1,sqrt(abs(gnoise)*pspec)*randsign2)

    ; filter noise in the same way that the data is filtered
    if dsfactor gt 1 and dofilter then begin
      fnyq = 1./(2. * ds1rate)
      fnyq_out = fnyq / dsfactor
      filt_ac = replicate(1.0,insize)/(1. + 10.^(abs(freq/(fnyq_out))^3.))*2.0
      freq_out = fft_mkfreq(samplerate,outsize)
      filt_ds_deconv = (1. + 10.^(abs(freq_out/(fnyq_out))^3.)) / 2.0
      data = fft(complexvals*filt_ac,-1)
      ; have to split the data to resample (downsample) it
      data_out_r = congrid(real_part(data),outsize,interp=0)
      data_out_i = congrid(imaginary(data),outsize,interp=0)
      data_out = complex(data_out_r,data_out_i)
      data_out_ft = fft(data_out,-1)
      data_out_ft = data_out_ft * filt_ds_deconv
      one_atmosphere = real_part(float(fft(data_out_ft, 1)))
    endif else one_atmosphere = real_part(fft(complexvals,-1))

    relative_scales = 1.0 + randomn(seed+2,sz[0],/normal) * relative_scale_rms
    whlt0 = where(relative_scales lt 0,nlt0)
    if nlt0 gt 0 then relative_scales[whlt0] = 0

    if fix_bolo_0 then relative_scales[0] = 1.0
    
    atmosphere = relative_scales # one_atmosphere 
    if n_elements(amplitude) eq 1 then atmosphere = atmosphere / (max(atmosphere) - min(atmosphere)) * amplitude

    IF keyword_set(offset_plane) THEN BEGIN
      nbolos = sz[0]
      offset = fltarr(sz)
      xbolos = bolo_params[2,*] * cos( (bolo_params[1,*] / 360.) * 2*!PI ) ; define the x loc for each bolo
      ybolos = bolo_params[2,*] * sin( (bolo_params[1,*] / 360.) * 2*!PI ) ; define the x loc for each bolo
            
      ; generate the fit parameters for each step in the timestream
      xco = amplitude*randomn(seed+4, sz[1]) ; set the x-slopes
      yco = amplitude*randomn(seed+5, sz[1]) ; set the y-slopes
      
      FOR i=0, sz[1]-1 DO BEGIN
        
        ; for each step in the timestream, calculate the offset for each bolometer
        z = plane2d(xbolos, ybolos, [0,xco[i], 0, yco[i], 0])
        offset[*,i] = z

      ENDFOR

      atmosphere += offset

    ENDIF ; offset_plane

    if individual_bolonoise_rms gt 0 then begin
      bnoise = randomn(seed+3,sz,/normal)*individual_bolonoise_rms 
      atmosphere += bnoise
    endif

    return,atmosphere
end
