; calculate_flags returns an array the same size as the input array (acb)
; and changes the badbolos input variable to a new badbolos array
; flagbadtime attempts to flag tims that have high std. devs: it's too aggressive on sources
; flags are nonzero where the data is bad
; bp[0,*] is ZERO where the bolometer is bad
; badbolos is the location of bad bolometers (should be location in a 144 element array)
;
; the "preflagged" keyword indicates that you are passing in both a "bp" (bolo_params) and
; a flag array.  Pre-flagged values will be ignored in the subsequent autoflagging calculations
; INPUTS: 
;   acb         - timestream array to flag
;   bp          - bolo_params
;   preflagged  - set this variable if bad bolometers in BOLO_PARAMS have already
;                 been flagged out, otherwise they will be flagged in this
;                 function
;   badbolos    - indices of bad bolometers to be ignored when calculating which
;                 bolos are bad
;   flagbadtime - a too-aggressive flagger that tries to deglitch but instead
;                 kills sources.  DON'T use it
;   do_deglitch - runs the deglitcher and flags out things that deglitcher said
;                 were glitches.  I don't think this should be used either; we 
;                 need to write our own deglitcher
;   reflag      - flag parameter that basically enables more-aggressive flagging
;                 based on 5-sigma (HARD-CODED!) rejection.  As of 6/25/08 I
;                 have disabled this function because I think it's too
;                 aggressive
; OUTPUTS:
;   flags   - have to pass in a flags array so that new flags are added to the
;             array instead of starting from scratch
;             
; NOTE / HACK / BADNESS: the flagging is very much unit-dependent.  I've
; hardcoded in that a variance > 1 is a problem... which is only true if the
; data is in volts.            
function calculate_flags,acb,bp=bp,flags=flags,badbolos=badbolos,preflagged=preflagged,$
        flagbadtime=flagbadtime,do_deglitch=do_deglitch,reflag=reflag
    if ~keyword_set(preflagged) then begin
        if ~keyword_set(bp) then message,"Error: if you haven't preflagged, you need to pass badbolo information"
        if ~keyword_set(flags) then message,"Error: if you haven't preflagged, you need to pass flag information"

        goodbolos = where(bp[0,*],complement=badbolos)
        acb[badbolos,*] = !values.f_nan ; ignore bolometers that are already known to be bad
    endif

    timesize = n_e(acb[0,*])
    n_bolos = n_e(acb[*,0])
    bolo_m = total(acb,2,/nan) / float(timesize)                                       ; bolo_m is the mean per bolometer
    bolo_v = total(( acb - rebin(bolo_m,size(acb,/dim)) )^2 / float(timesize),2,/nan)  ; bolo_v is the variance per bolometer
    bad_m = where(bolo_m lt -.999)  ; reject bolometers with means less than or equal to -1 (in general, these should already be badbolos)
    if keyword_set(reflag) then begin                                                  ; 'reflag' means apply a more aggresive flagger after sky subtraction 
        bad_v = where((bolo_v eq 0) or (bolo_v gt 5*stddev(bolo_v)+mean(bolo_v) ))     ; 5 sigma rejection on high-variance observations
        bad_m = where((bolo_m lt mean(bolo_m)-5*stddev(bolo_m)) or (bolo_m gt mean(bolo_m)+5*stddev(bolo_m)))
    endif else bad_v = where((bolo_v eq 0) or (bolo_v gt 1 ))                          ; simpler, less aggressive bad-point rejection

    ; set the flags / bad bolos --- THIS MEANS BAD BOLOMETERS ARE FLAGGED, NOT JUST IDENTIFIED IN BOLO_PARAMS
    if ~(bad_v[0] eq -1) then begin         ; only attempt to flag if n_bad > 0
        flags[bad_v,*] = 1
        bp[0,bad_v] = 0
    endif
    if ~(bad_m[0] eq -1) then begin         ; only attempt to flag if n_bad > 0
        flags[bad_m,*] = 1
        bp[0,bad_m] = 0
    endif

    ; it turned out that bad time flagging was way too aggressive on sources, so I made it optional
    ; I've added in something of an error checker that times shouldn't be flagged if they have high means...
    ; this means that sources are less likely to get flagged, but so are glitches
    ; there's no great automated way around this
    ; I recommend NOT using flagbadtime
    if keyword_set(flagbadtime) then begin
        time_m = total(acb,1,/nan) / float(timesize)
        time_v = total(( acb - rebin(bolo_m,size(acb,/dim)) )^2 / float(timesize),1,/nan)
        early_mean = mean(time_v[0:15])
        time_v[0:15] = !values.f_nan
        bad_time = where( (time_v gt (median(time_v) + 5 * stddev(time_v,/nan))) * (time_m lt ( mean(time_m) + stddev(time_m) ) ) )
        if early_mean gt (median(time_v) + 2 * stddev(time_v,/nan)) then bad_time = [indgen(15),bad_time]
        if ~(bad_time[0] eq -1) then begin         
            flags[*,bad_time] = 1
        endif
    endif
    
    ; the deglitcher is also optional because I've found that it causes problems - it puts NaNs in places where they are not recognized
    if keyword_set(do_deglitch) then begin
        deglitched = deglitch(acb,glitchflags,sigma=1000.,step=.12)
        whglitch = where(glitchflags eq 0)
        flags[whglitch] = 1
    endif

    ; flags are nonzero where the data is bad
    return,flags
end

