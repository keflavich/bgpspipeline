; $Log: deline.pro,v $
; Revision 1.1  2007/08/15 18:14:06  jaguirre
; Added the delining algorithm in deline.pro and the calling module
; deline_module.
;
; $Id: deline.pro,v 1.1 2007/08/15 18:14:06 jaguirre Exp $

; A crude de-liner for the Bolocam 1 mm data

; The approach taken here is not to try to fit the lines, but just to
; notch them out and replace them with white noise at the same level
; as the surrounding PSD.

function deline, bolo_array, sample_interval, $
    lines=lines, flat=flat

    ; Define where the lines will be notched
    linefreqs = [10.05+findgen(10)*1.2,10.05-((findgen(5)+1))*1.2]
    ; Bandwidth which is corrupted (in Hz)
    df = 0.09
    ; Bandwidth over which to average
    df_avg = 0.5

    nbolos = n_e(bolo_array[*,0])
    delined_array = bolo_array

    ntod = n_e(bolo_array[0,*])

        freq = fft_f(1./sample_interval, ntod)

        posfreq = where(freq gt 0)
        f = freq[posfreq]

        ; Limit the linefreqs to be removed to just those that are less than
        ; the Nyquist frequency
        linefreqs = linefreqs[where(linefreqs lt max(f))]

        ; Fourier transform
        ftac = fft(bolo_array,dim=2,/double)
        ; Make a "PSD" ... note that the normalization is irrelevant here ...
        psd = abs(ftac[*,posfreq])

        for i=0L,n_e(linefreqs)-1 do begin

            ; Find the region to blank out
            whpos = where(freq ge linefreqs[i]-df and $
                          freq le linefreqs[i]+df, nrlz)
            if nrlz eq 0 then continue ; if the frequency is not in the data, don't try to get rid of it

            ; Deal with the Fucking Nyquist Problem (FNP)
            if (freq[max(whpos)] eq max(freq)) then $
              whpos = whpos[0:nrlz-2]
            ; Note that this logic ensures that every positive frequency is
            ; matched with its corresponding negative frequency, which saves a
            ; reverse statement below
            whneg = where_arr(freq,-freq[whpos])
            
            nrlz = n_e(whpos)

            ; Define a region around the line to average to produce the mean level.
            wh = where((f ge linefreqs[i]-df_avg and f le linefreqs[i]-df) or $
                       (f ge linefreqs[i]+df and f le linefreqs[i]+df_avg))

            if (n_e(whpos) ne n_e(whneg)) then $
              message,'Frequency finding didn''t work.'
            
            for n = 0,nbolos-1 do begin
                ; Generate a bunch of Gaussian random numbers with RMS given by the
                ; mean level.
                ;amp = randomn(seed,nrlz,/double) * $
                ;  sqrt(total(psd[n,wh]^2)/n_e(wh))/sqrt(2.)
                ; generate gaussian random numbers with mean equal to PSD mean
                ; and stddev equal to the PSD stddev
                amp = randomn(seed,nrlz,/double) * $
                    mad(psd[n,wh]) + sqrt(total(psd[n,wh]^2)/n_e(wh))*sqrt(2.)
                
                if keyword_set(flat) then amp = sqrt(total(psd[n,wh]^2)/n_e(wh))*sqrt(2.)
                phase = randomu(seed,nrlz,/double)*2.*!pi
                
                newdata = dcomplex(amp*cos(phase),amp*sin(phase))

                ftac[n,whpos] = newdata
                ftac[n,whneg] = conj(newdata)
                
            endfor

        endfor

        ftac = double(fft(ftac,dim=2,/double,/inverse))

        delined_array = ftac


    lines = bolo_array - delined_array

    return,delined_array

end



; Deglitch the data
;print,"STARTING SIGMADEGLITCH LOOP with nbolos ",nbolos
;if keyword_set(deglitch) then begin   ; Adam removed sigmadeglitching from code b/c it doesn't really belong here 8/12/08
;    for i=0,nbolos-1 do begin
;        acdeg[i,*] = sigmadeglitch(acdeg[i,*],/quiet)
;    endfor
;endif
;print,"FINISHED SIGMADEGLITCH LOOP"
;save,filename="aftersigmadeglitchloop.sav"


