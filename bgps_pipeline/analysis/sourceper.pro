pro sourceper,bgps,cutoff=cutoff,binsize=binsize,outfile=outfile,_extra=_extra

    if n_e(cutoff) eq 0 then cutoff=.3
    if n_e(binsize) eq 0 then binsize=1

    blower = -.5
    bupper = 0.5
    fluxok = bgps.flux_40 gt cutoff
    latok = bgps.glat gt blower and bgps.glat lt bupper
    ok = where(fluxok and latok)
    lvals = (bgps.glon)[ok]
    bvals = (bgps.glon)[ok]
    lvals[where(lvals gt 300)] -= 360
    
    h=histogram(lvals,location=l,min=-11,max=85)
    l+=.5
    plot,l,h


    if keyword_set(outfile) then begin
        
        openw,outf,outfile,/get_lun
        printf,outf,"longitude","number_over_cutoff",format="(A20,A20)"

        for i=0,n_e(l)-1 do begin
            printf,outf,l[i],h[i],format="(F20.2,F20.2)"
        endfor
        
        close,outf
        free_lun,outf

    endif


;    nbins = 100/binsize
;    l_plot = fltarr(nbins)
;    n_plot = fltarr(nbins)
;
;    start=-10
;    for i=0,nbins-1 do begin
;        llower = i*binsize+start
;        lupper = (i+1)*binsize+start
;        l_plot[i] = (lupper+llower)/2.
;        if llower lt 0 then begin
;            llower+=360
;            lupper+=360
;        endif
;
;        lok = where(lvals lt lupper and lvals gt llower)
;
;        n_plot[i] = n_e(lok)
;    endfor
;
;    plot,l_plot,n_plot,_extra=_extra
    stop

end
