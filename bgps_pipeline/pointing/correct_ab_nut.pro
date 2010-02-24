; correct_ab_nut
; INPUT:
;    JD, RA, DEC should all be the same length
;    all three have usual meanings
;    units are in DEGREES (RA is not in hours)
; OUTPUT:
;    RA and DEC are also output variables: they will be modified in
;   this procedure
; co_aberration and co_nutate state that the corrections must be ADDED
; to the ra/dec in order to get the correct RA/Dec.  They return corrections
; in arcseconds
pro correct_ab_nut,jd,ra,dec,abnutsign=abnutsign,dontabnut=dontabnut,$
    d_ra_ab=d_ra_ab,d_dec_ab=d_dec_ab,d_ra_nu=d_ra_nu,d_dec_nu=d_dec_nu,_extra=_extra
    
    co_aberration, jd, ra, dec, d_ra_ab, d_dec_ab
    co_nutate, jd, ra, dec, d_ra_nu, d_dec_nu
;debug    print,median(d_ra_ab),median(d_dec_ab)
;debug    print,median(d_ra_nu),median(d_dec_nu)
    if ~keyword_set(abnutsign) then abnutsign = 'p'
    if ~keyword_set(dontabnut) then begin
        if abnutsign eq 'p' then begin
            ra += (d_ra_ab + d_ra_nu)/3600.D ;* 24.d/360.
            dec += (d_dec_ab + d_dec_nu)/3600.D
        endif else if abnutsign eq 'm' then begin
            ra  -= (d_ra_ab + d_ra_nu)/3600.D ;* 24.d/360.
            dec -= (d_dec_ab + d_dec_nu)/3600.D
        endif
    endif
end

