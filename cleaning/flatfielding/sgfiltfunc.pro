; sgfiltfunc
; A wrapper for savgol designed for use with bolocam
; INPUTS:
;   scanspeed       - scanning rate in arcseconds/second?
;   beam            - beamsize in arcseconds?   
;   tvary_factor    - multiplicative factor: larger means smoother over long timescales
;   sample_interval - sample interval recovered from the NCDF file, defaults to downsampled rate
;                     of .1s = 100ms
function sgfiltfunc,scanspeed=scanspeed,beam=beam,tvary_factor=tvary_factor,sample_interval=sample_interval
    if ~keyword_set(scanspeed) then scanspeed = 120.
    if ~keyword_set(beam) then beam = 30.
    if ~keyword_set(tvary_factor) then tvary_factor = 10.
    if ~keyword_set(sample_interval) then sample_interval = 0.1
    tvary = float(beam) / float(scanspeed) * tvary_factor
    svary = long(tvary/sample_interval)
    thefilter = savgol(svary,svary,0,4)
    return,thefilter
end

