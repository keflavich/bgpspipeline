pro plot_dcfluxes,infile,overplot=overplot,inter=inter,_extra=_extra

    readcol,infile,filename,planet,meandc,stddc,volts,ampl,err,voltsDflux,errDflux,amplDflux,flux,jd,$
        format="(A80,A20,F20,F20,F20,F20,F20,F20,F20,F20,F20,F20)",comment="#",/silent

    good = where(volts gt 1000); and voltsDflux gt 80)
    whmars = where((planet[good]) eq 'mars', complement=whnotmars)
    meandcfit    = [meandc[good],0]
    amplDfluxfit = [amplDflux[good],0]
    invweight    = [err[good],.0001]
    whnotmars = [whnotmars,n_e(good)]

    if keyword_set(overplot) then begin 
        oplot,meandcfit[whnotmars],amplDfluxfit[whnotmars],psym=3,_extra=_extra 
        oplot,meandcfit[whmars],amplDfluxfit[whmars],psym=3,color=200,_extra=_extra 
    endif else begin
        plot,meandcfit[whnotmars],amplDfluxfit[whnotmars],psym=1,_extra=_extra 
        oplot,meandcfit[whmars],amplDfluxfit[whmars],psym=1,color=200,_extra=_extra 
    endelse

    guess = [0,1,1]
    p=mpfitfun('quadratic',meandcfit,amplDfluxfit,invweight,guess,yfit=yfit,/quiet)

    x= findgen(500)/499*max(meandc)

    print,p
    oplot,x,quadratic(x,p),_extra=_extra
    oplot,x,quadratic(x,[-0.00333379,-2.92617,6.97269]),color=200
    if keyword_set(inter) then stop
end

function quadratic,x,a
    return,a[0]+a[1]*(x)+a[2]*(x)^2
end

