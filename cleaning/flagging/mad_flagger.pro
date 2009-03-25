; The Mad Flagger
; Flag based on the median average deviation within a spatial pixel
function mad_flagger,data,inds,flags,nsig=nsig,glitchloc=glitchloc

    t = systime(/sec)
    f0 = total(flags gt 0,/integer)

    if n_e(nsig) eq 0 then nsig = 3    
    
    newflags = flags*0
    undersampled = flags*0

    mx=max(inds)
    vec3=fltarr(mx+1)
    h=histogram(inds,reverse_indices=ri,OMIN=om)
    for j=0L,n_elements(h)-1 do begin
        if ri[j+1] gt ri[j] then begin
            v_inds = [ri[ri[j]:ri[j+1]-1]]
            if n_e(v_inds) gt 2 then begin
                vec = data[v_inds]
;                vecmad = mad(vec)  ; the MAD is WAY too small!  I ended up rejecting 8% of points!
                vecmad = stddev(vec)
                vecmed = median(vec,/even)
                madreject = where( (vec gt vecmed + nsig*vecmad) or (vec lt vecmed - nsig*vecmad) )
                if (n_e(madreject) gt 0 and total(madreject)) gt 0 then begin
                    reject_inds = v_inds[madreject]
                    newflags[reject_inds] = 1
                endif 
            endif else begin ; flag out any point where there were 0, 1, or 2 hits: they have too-high noise
                undersampled[v_inds] = 1
            endelse
        endif
    endfor

    glitchloc = (newflags gt 0)

    print,"MAD flagger took ",strc(systime(/sec)-t)," seconds and flagged ",$
        strc(total((newflags+undersampled) gt 0) - long(f0)),' points ',$
        strc(float((total((newflags+undersampled) gt 0) - long(f0)))/n_e(flags)),' fraction'

    return,newflags+undersampled+flags

end
