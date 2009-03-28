; example:
; .r plot_dcfluxes   ; to compile quadratic
; plot_dcfluxes,'/usb/scratch1/planets/planet_dcfluxes.txt'
; plot_dcfluxes,'/usb/scratch1/planets/planet_dcfluxes.txt',plotfile='~/paper_figures/fluxcal.ps'
; plot_dcfluxes,'/usb/scratch1/planets/planet_dcfluxes.txt',/errbar,plotfile="~/paper_figures/fluxcal_errorbars.ps",charsize=1.5,charthick=2,xthick=2,ythick=2,linethick=3,symthick=3
pro plot_dcfluxes,infile,overplot=overplot,inter=inter,olde=olde,plotfile=plotfile,errbar=errbar,beamsize=beamsize,_extra=_extra

    readcol,infile,filename,planet,meandc,stddc,volts,ampl,err,voltsDflux,errDflux,amplDflux,flux,jd,xwidth,ywidth,$
        format="(A80,A20,F20,F20,F20,F20,F20,F20,F20,F20,F20,F20,F20,F20)",comment="#",/silent

    if keyword_set(plotfile) then begin
        set_plot,'ps'
        device,filename=plotfile,/color
    endif

    good = where(volts gt 1000); and voltsDflux gt 80)
    whmars = where((planet[good]) eq 'mars', complement=whnotmars)
    whuranus = where((planet[good]) eq 'uranus', complement=whnoturanus)
;    whneptune = where((planet[good]) eq 'neptune', complement=whnotneptune)
    meandcfit    = [meandc[good],0]
    amplDfluxfit = [amplDflux[good],0]
    invweight    = [err[good],.0001]
    whnotmars = [whnotmars,n_e(good)]
    stddcgood = [stddc[good],0]       ; / 10 ; errorbars are HUGE otherwise
    errDfluxgood = [errDflux[good],0] ; / 10 ; errorbars are HUGE otherwise     

    if keyword_set(overplot) then begin 
        oplot,meandcfit[whuranus],amplDfluxfit[whuranus],psym=1,_extra=_extra
;        plot,meandcfit[whnotmars],amplDfluxfit[whnotmars],psym=1,_extra=_extra 
        oplot,meandcfit[whmars],amplDfluxfit[whmars],psym=2,color=250,_extra=_extra 
;        oplot,meandcfit[whneptune],amplDfluxfit[whneptune],psym=7,color=100,_extra=_extra 
    endif else begin
        if keyword_set(errbar) then begin
            ploterror,[meandcfit[whuranus],0],[amplDfluxfit[whuranus],0],[stddcgood[whuranus],0],[errDfluxgood[whuranus],0],psym=3,xtitle="!6Mean DC voltage",ytitle="!6Volts/Jy",_extra=_extra
            oploterror,meandcfit[whmars],amplDfluxfit[whmars],stddcgood[whmars],errDfluxgood[whmars],psym=3,errcolor=250,_extra=_extra
        endif else begin
            plot,[meandcfit[whuranus],0],[amplDfluxfit[whuranus],0],psym=1,xtitle="!6Mean DC voltage",ytitle="!6Volts/Jy",_extra=_extra
    ;        plot,meandcfit[whnotmars],amplDfluxfit[whnotmars],psym=1,_extra=_extra 
            oplot,meandcfit[whmars],amplDfluxfit[whmars],psym=2,color=250,_extra=_extra 
    ;        oplot,meandcfit[whneptune],amplDfluxfit[whneptune],psym=7,color=100,_extra=_extra 
        endelse
    endelse

    guess = [0,1,1]
    p=mpfitfun('quadratic',meandcfit,amplDfluxfit,invweight,guess,yfit=yfit,/quiet)

    x= findgen(500)/499*max(meandc)

    print,p
    oplot,x,quadratic(x,p),_extra=_extra
    if keyword_set(olde) then oplot,x,quadratic(x,[-0.00333379,-2.92617,6.97269]),color=200
    if keyword_set(plotfile) then begin
        device,/close_file
        set_plot,'x'
    endif
    if keyword_set(beamsize) then begin
        print,"X (err),Y (err):",mean(xwidth[good])*7.2*2.35,stddev(xwidth[good])*7.2*2.35/sqrt(n_e(good)),mean(ywidth[good])*7.2*2.35,stddev(ywidth[good])*7.2*2.35/sqrt(n_e(good))
    endif
    if keyword_set(inter) then stop
end

function quadratic,x,a
    return,a[0]+a[1]*(x)+a[2]*(x)^2
end

