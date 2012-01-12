; pointing model uses the alt/az (really just alt) of the telescope
; to compute a correction to the instrument specific pointing model
; that was applied during the observations.  The nomenclature I'm using isn't
; very good - fazo/fzao change meanings during the course of this code.
; As inputs, they are the offsets applied at the telescope
; as outputs, they are corrections to the alt/az
; JD, ALT, AZ are Julian mjd, alt and az of telescope (approximate)
pro pointing_model,jd,alt,az,fzao=fzao,fazo=fazo,altoff_model=altoff_model,azoff_model=azoff_model
;    pointingdir = stregex(!PATH,'/[/A-Za-z_]*pointing/',/extract)   ; THIS IS A HACK
    pointingdir = strmid(which('pointing_model'),0,strlen(which('pointing_model'))-18)
    readcol,pointingdir+'pointing_model_coeffs.txt',smjd,emjd,aa0,aa1,aa2,aa3,aa4,ab0,ab1,ab2,ab3,ab4,/silent,format='(D,D,D,D,D,D,D,D,D,D,D,D)',comment="#"
    mjd = median(jd)-2400000. ; pick middle MJD

    found_model = 0
    for i=0,n_e(smjd)-1 do begin
        if mjd gt smjd[i] and mjd lt emjd[i] then begin
            a0 = aa0[i] & a1 = aa1[i] & a2 = aa2[i] & a3 = aa3[i] & a4 = aa4[i]
            b0 = ab0[i] & b1 = ab1[i] & b2 = ab2[i] & b3 = ab3[i] & b4 = ab4[i]
            found_model = 1
        endif
    endfor
    if found_model eq 0 then begin
        message,"Did not find a pointing model for MJD = "+strc(mjd),/info
        altoff_model = 0
        azoff_model = 0
        return
    endif

    ;za = 90.-alt
    ;azoff_model = (a0 + a3*za + a4*za^2)/3600.
    ;altoff_model = -(b0 + b3*za + b4*za^2)/3600.  ; DEGREES - DISTANCE!
    ;; note that altoff_model is negative because the coefficients represent ZA offset
    ;; and the model is calculated with elevation, not ZA....
    ;; of course, this is an endless source of confusion

    ; as far as I can tell, I'm computing an alt, not a za, model
    ; and there should be no need for a sign flip
    azoff_model = (a0 + a1*az + a2*az^2 + a3*alt + a4*alt^2)/3600.
    altoff_model = (b0 + b1*az + b2*az^2 + b3*alt + b4*alt^2)/3600.  ; DEGREES - DISTANCE!

    ; this code is obsolete - it was the way fazo/fzao were treated in the OP
    if keyword_set(fazo) and keyword_set(fzao) then begin
        azo_model = (a0 + a3*(90.-alt) + a4*(90-alt)^2)/3600.
        zao_model = (b0 + b3*(90.-alt) + b4*(90-alt)^2)/3600.  ; DEGREES
        fazo = fazo/3600. - azo_model ; based off of pcal5, the model should be SUBTRACTED from the original offset
        fzao = fzao/3600. - zao_model
    endif
end

;;;; OLD CODE (removed 8/22/08):
;    if mjd ge 54101.5 and mjd le 54252.5 then begin  ; Jan 1 2007 is 54101
;;james        a0 = -93.474457 &  a3 = -0.022848629  & a4 = -0.0050140761
;;james        b0 = 88.255875  &  b3 = 0.44414777    & b4 = -0.011090795
;        a0=-99.078392    & a1=0.0 & a2=0.0  & a3=0.10527000     & a4=-0.0059434911 ;meredith        
;        b0=86.896333     & b1=0.0 & b2=0.0  & b3=0.54257415     & b4=-0.011919129 ;meredith        
;    endif else if mjd ge 53522.5 and mjd le 53582.5 then begin ; June 1 2005 - July 31 2005
;        a0 = -9.2413685  & a3 = -0.0066354359 & a4 =  -0.0015110883
;        b0 =  7.0392221  & b3 =  -0.053635657 & b4 = -0.00047042481
;    endif else if mjd ge 53614.5 and mjd le 53643.5 then begin ; September 1 2005 - September 30 2005
;        a0 = 84.969583   & a3 = -2.4339154 & a4 = 0.016300937
;        b0 = 126.00164   & b3 = -2.4424431 & b4 = 0.015455417
;    endif else if mjd ge 53887.5 and mjd le 53947.5 then begin ; June 1 2006 - July 31 2006
;        a0 = 9.5305281   & a3 = -0.053191181 & a4 = -0.0029300592
;        b0 = 0.13425019  & b3 =  0.48160040  & b4 = -0.0092814256
;    endif else if mjd ge 53979.5 and mjd le 54008.5 then begin ; September 1 2006 - September 30 2006
;        a0 =  -98.980381 & a3 = 0.65354164 & a4 =  -0.012414466
;        b0 =   52.841380 & b3 =  1.6705743 & b4 =  -0.020893018
;    endif else if mjd ge 54252.5 and mjd le 54288 then begin ; June 1 2007 - NOON July 6 2007
;        a0 = -103.03831  & a3 =   0.20972540 & a4 = -0.0060336987
;        b0 =  100.74491  & b3 = 0.0099012827 & b4 = -0.0033331895
;    endif else if mjd ge 54288 and mjd le 54313 then begin ; NOON July 6 2007 - NOON Aug 1 2007
;        a0 =  -99.078392 & a3 =  0.10527000 & a4 = -0.0059434911
;        b0 =   86.896333 & b3 =  0.54257415 & b4 =  -0.011919129
;    endif else begin
;        print,"NO POINTING MODEL AVAILABLE FOR JD ",mjd
;        a0 = 0 & a3 = 0 & a4 = 0
;        b0 = 0 & b3 = 0 & b4 = 0
;    endelse

