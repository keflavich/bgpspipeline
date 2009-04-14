; streamlined version of centroid_plots
; i.e. it only plots the stuff we actually want in the paper

pro pointing_plots,filename,date
    readcol,filename,name,source_name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,objalt,objaz,altoff,azoff,$
        fzao,fazo,lst,jd,xerr,yerr,obsname,$
        Format="(A100,A20,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,D,F,F,A)",/silent,comment="#"

    mjd = jd-2400000-54000

    goodvals = where(xpix ne -1 and objalt gt 20 and altoff lt mean(altoff,/nan)+70 and altoff gt mean(altoff,/nan)-70)
    latitude=19.82611111D0 
    my_eq2hor,ra,dec,jd,alt,az,lat=latitude,alt=4072,lon=-155.473366,refract=0,aberration=aberration,nutate=nutate,precess=precess,lst=lst

    azoff_dist = azoff*cos(!dtor*alt)

    allalt = findgen(1000)*90./1000.
    pointing_model,jd,alt,az,altoff_model=altoff_model,azoff_model=azoff_model
    pointing_model,jd,allalt,az,altoff_model=allaltoff_model,azoff_model=allazoff_model ; for plotting

    if ~keyword_set(nsig1) then nsig1 = 3
    if ~keyword_set(nsig2) then nsig2 = 3
    good_alts = sigmareject(altoff,[nsig1,nsig2],goodvals=goodvals,/domedian,flagarr=flagarr_alt)
    good_azs  = sigmareject(azoff_dist,[nsig1,nsig2],goodvals=goodvals,/domedian,flagarr=flagarr_az)
    good_both = where(flagarr_alt and flagarr_az)

    my_altoff_model2 = poly_fit(alt[good_both],altoff[good_both],2)
    my_azoff_model2 = poly_fit(alt[good_both],azoff_dist[good_both],2)

    set_plot,'ps'
    loadct,39
    device,filename=getenv('HOME')+'/paper_figures/paper_models_'+date+'.ps',/color,/encapsulated
    !P.MULTI=[0, 2, 2, 0, 1]
    !p.thick = 2
    !p.charthick = 2
    !p.charsize = 1.5
    altoff_min=min(altoff[goodvals]) & azoff_min=min(azoff_dist[goodvals])
    altoff_max=max(altoff[goodvals]) & azoff_max=max(azoff_dist[goodvals])
    plot,alt[goodvals],altoff[goodvals],psym=1,xtitle="!6Alt",ytitle="!6Altoff",$
        title='!6RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[altoff_min,altoff_max]
    oplot,allalt,allaltoff_model*3600.,color=254   
    plot,alt[goodvals],azoff_dist[goodvals],psym=1 ,xtitle="!6Alt",ytitle="!6Azoff (distance)"  ,$
        title='!6RMS: '+string(stddev(azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[azoff_min,azoff_max]
    oplot,allalt,allazoff_model*3600.,color=254   
    pmsub_altoff = altoff - poly(alt,my_altoff_model2)
    pmsub_azoff  = azoff_dist  - poly(alt,my_azoff_model2)
    mpmsub_altoff = altoff - altoff_model*3600
    mpmsub_azoff  = azoff_dist  - azoff_model*3600
    plot,alt[good_both],mpmsub_altoff[good_both],psym=1,xtitle="!6Alt",ytitle="!6Altoff",$
        title="RMS: "+string(stddev(mpmsub_altoff[good_both]),format='(F5.2)')
    plot,alt[good_both],mpmsub_azoff[good_both],psym=1,xtitle="!6Alt",ytitle="!6Azoff (distance)",$
        title="RMS: "+string(stddev(mpmsub_azoff[good_both]),format='(F5.2)') 

    device,/close_file

    device,filename=getenv('HOME')+'/paper_figures/paper_gaussian_'+date+'.ps',/color,/encapsulated

    !p.multi=[0,2,1]
    ;;HISTOGRAMS
    h_alt = hist_wrapper(pmsub_altoff,1.,-20,20,/gauss_fit,/noverbose)
    h_az = hist_wrapper(pmsub_azoff,1.,-20,20,/gauss_fit,/noverbose)
    x_g = findgen(1000)/25.-20.
    g_alt = h_alt.fit_ampl*exp(-(x_g - h_alt.fit_mean)^2/h_alt.fit_rms^2)
    g_az = h_az.fit_ampl*exp(-(x_g - h_az.fit_mean)^2/h_az.fit_rms^2)

        plot,h_alt.hb,h_alt.hc,psym=10,/xs,xtitle="!6Residual altoff",thick=2,ytitle="!6Number of observations"
        oplot,x_g,g_alt,color=250
        plot,h_az.hb,h_az.hc,psym=10,/xs,xtitle="!6Residual azoff",thick=2,ytitle="!6Number of observations"
        oplot,x_g,g_az,color=250

    device,/close_file
    set_plot,'x'


end
