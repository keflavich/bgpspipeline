function fft_mkfreq, dt, npts
;+
; NAME:
;    fft_mkfreq
;
; PURPOSE:
;    Calculates the frequency array appropriate to a given fft.
;
; CALLING SEQUENCE:
;    f = fft_mkfreq(dt, npts)
;    
; INPUTS:
;    dt = time interval between consecutive points of timestream
;    npts = total number of points in timestream
;
; OUTPUTS:
;    frequency array aligned with output of fft function.
;    Note that this will be wrapped in the standard fashion: it will start 
;    with the DC component, hit the first positive frequency at 1/(npts * dt),
;    run up through the positive frequencies to the maximum positive
;    frequency, then start with the most negative frequency and run up 
;    through the negative frequencies to -1/(npts * dt)
;
;    When there are an even number of points, the most positive frequency is
;    the Nyquist frequency 1/(2 dt) and the most negative frequency is
;    - (npts/2 - 1)/ (npts * dt).  When there are an odd number of points, 
;    the most positive frequency is (npts-1)/(2 * npts * dt) and the most 
;    negative frequency is the negative of this.
;
; REVISION HISTORY:
;    2001/02/26 SG
;-

if (n_params() lt 2) then begin
   message, 'Not enough arguments'
   return, -1
endif

; frequency bin size
df = 1./(npts * dt)

; most negative bin
if (npts mod 2) eq 0 then begin
   ; even number of points
   nmin = -(long(npts/2) - 1)
endif else begin
   nmin = -long((npts-1)/2)
endelse

f = (findgen(npts) + nmin) * df

; then wrap it like a standard fft
f = shift(f, nmin)

return, f

end
