; Compute the frequencies corresponding to a finite Fourier transform
; of a given sampling frequency 'sfreq' (in inverse sample length) and
; number of samples 'n'.  sfreq and n may be passed as either integers
; or floats.  The result returned is a floating point array.  The
; result is returned in the standard order [0,Ny,-Ny,0]

function fft_f, sfreq, n

if (n_params() ne 2) then begin
    print, 'fft_f(sfreq, n)'
    return, -1
endif

sfreq = float(sfreq)
nc = float(long(n))

; Compute the position of the Nyquist frequency
ny = floor(nc/2.) + 1.

f = findgen(nc)
f[ny:nc-1] = -reverse(f[1:nc-ny]) 
f = f*sfreq/nc

return, f

end
