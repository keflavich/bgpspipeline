pro centroid_plots,filename,date,nametype,interactive=interactive,nsig1=nsig1,nsig2=nsig2,polyorder=polyorder,compare_sigmas=compare_sigmas,$
    homedir=homedir,precess=precess,aberration=aberration,nutate=nutate,dosave=dosave
    readcol,filename,name,source_name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,objalt,objaz,altoff,azoff,$
        fzao,fazo,lst,jd,xerr,yerr,obsname,$
        Format="(A100,A20,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,D,F,F,A)",/silent,comment="#"

    set_plot,'ps'
    if ~keyword_set(homedir) then homedir='/usb/scratch1/'
    if strmid(homedir,strlen(homedir)-1,1) ne '/' then homedir = homedir + "/"
    badsourcelist = ['ngc6334i']
    badobslist = ['070629_ob1','070702_ob5','070702_ob6','070702_ob7','070702_ob8','070729_o49']

    mjd = jd-2400000-54000

    goodvals = where(xpix ne -1 and objalt gt 20 and altoff lt mean(altoff,/nan)+70 and altoff gt mean(altoff,/nan)-70)
    latitude=19.82611111D0 
;    my_eq2hor,objra,objdec,jd,objalt,objaz,lat=latitude,alt=4072,lon=-155.473366,refract=0,aberration=aberration,nutate=nutate,precess=precess,lst=lst
    ;getaltaz,objdec,latitude,lst-objra/15.,objalt,objaz
;    eq2hor,ra,dec,jd,alt,az,lat=latitude,alt=4072,lon=-155.473366,refract=0,aberration=0,nutate=0
    my_eq2hor,ra,dec,jd,alt,az,lat=latitude,alt=4072,lon=-155.473366,refract=0,aberration=aberration,nutate=nutate,precess=precess,lst=lst
;    getaltaz,dec,latitude,lst-ra/15.,alt,az
    azoff_dist = azoff*cos(!dtor*alt)
    altpfzao = alt + fzao/3600.
    azmfazo  = az  - fazo/3600.
    nofzao_altoff = (altpfzao - objalt)*3600
    nofazo_azoff  = (azmfazo  - objaz)*3600
    allalt = findgen(1000)*90./1000.
    pointing_model,jd,alt,az,altoff_model=altoff_model,azoff_model=azoff_model
    pointing_model,jd,allalt,az,altoff_model=allaltoff_model,azoff_model=allazoff_model
    my_altoff_model = poly_fit(alt[goodvals],altoff[goodvals],2)
    my_azoff_model = poly_fit(alt[goodvals],azoff[goodvals],2)
    gv_std_altoff = stddev(altoff[goodvals])
    gv_mean_altoff = mean(altoff[goodvals])
    gv_std_azoff = stddev(azoff[goodvals])
    gv_mean_azoff = mean(azoff[goodvals])
    if ~keyword_set(nsig1) then nsig1 = 3
    if ~keyword_set(nsig2) then nsig2 = 3
    good_alts = sigmareject(altoff,[nsig1,nsig2],goodvals=goodvals,/domedian,flagarr=flagarr_alt)
    good_azs  = sigmareject(azoff_dist,[nsig1,nsig2],goodvals=goodvals,/domedian,flagarr=flagarr_az)
    good_both = where(flagarr_alt and flagarr_az)
    my_altoff_model1 = poly_fit(alt[good_alts],altoff[good_alts],2)
    my_azoff_model1 = poly_fit(alt[good_azs],azoff[good_azs],2)
    my_altoff_model2 = poly_fit(alt[good_both],altoff[good_both],2)
    my_azoff_model2 = poly_fit(alt[good_both],azoff_dist[good_both],2)

    ;; RA/DEC ptg mdl
    raoff_dist = raoff / cos(!dtor*dec)
    prd = fit_ptgmdl(ra[goodvals],dec[goodvals],raoff_dist[goodvals],decoff[goodvals])
    f = ptgmdl([ra,dec],prd,xoff=ra_mdl,yoff=dec_mdl)

    ;; ALT/AZ ptg mdl
    paa = fit_ptgmdl(alt[goodvals],az[goodvals],altoff[goodvals],azoff_dist[goodvals])
    f = ptgmdl([alt,az],paa,xoff=alt_mdl,yoff=az_mdl)

    ;; FAZO_NEW/FZAO_NEW MODEL CALCULATIONS (PARALLEL TO MEREDITH'S)
    altoffmfzao = altoff-fzao
    azoffpfazo = azoff_dist+fazo
    good_alts2 = sigmareject(altoffmfzao,[nsig1,nsig2],goodvals=goodvals,/domedian,flagarr=flagarr_alt2)
    good_azs2  = sigmareject(azoffpfazo,[nsig1,nsig2],goodvals=goodvals,/domedian,flagarr=flagarr_az2)
    good_both_f = where(flagarr_alt2 and flagarr_az2)
    fzao_new_model = poly_fit(alt[good_both_f],altoffmfzao[good_both_f],2)
    fazo_new_model = poly_fit(alt[good_both_f],azoffpfazo[good_both_f],2)
    fpmsub_altoff = altoffmfzao - poly(alt,fzao_new_model)
    fpmsub_azoff  = azoffpfazo - poly(alt,fazo_new_model)
    fcorrected_alt = alt - fzao/3600. - poly(alt,fzao_new_model)/3600. 
    fcorrected_az = az - (poly(alt,fazo_new_model)-fazo)/3600./cos(!dtor*alt)
    getradec,fcorrected_alt,fcorrected_az,latitude,fcorrected_ha,fcorrected_dec
    fcorrected_ra = (lst-fcorrected_ha) * 15
    postcorr_good_alts = sigmareject(fpmsub_altoff,[nsig1,nsig2],goodvals=goodvals,badvals=bad_fzao_points,/domedian,flagarr=flagarr_pc_alt)
    postcorr_good_azs = sigmareject(fpmsub_azoff,[nsig1,nsig2],goodvals=goodvals,badvals=bad_fazo_points,/domedian,flagarr=flagarr_pc_az)
    postcorr_good_both = where(flagarr_pc_alt and flagarr_pc_az,complement=postcorr_bad_either)

    corrected_alt = alt - poly(alt,my_altoff_model2)/3600. 
    corrected_az = az - poly(alt,my_azoff_model2)/3600./cos(!dtor*alt)
    my_hor2eq,corrected_alt,corrected_az,jd,corrected_ra,corrected_dec,lat=latitude,alt=4072,lon=-155.473366,refract=0,aberration=0,nutate=0,lst=lst
    corrected_raoff = (corrected_ra - objra)*3600.
    corrected_raoff_dist = (corrected_ra - objra)*3600.*cos(!dtor*dec)
    corrected_decoff = (corrected_dec - objdec)*3600.

    loadct,39

    if keyword_set(compare_sigmas) then begin
        dist_azoff = azoff * cos(!dtor*alt)
        good_alts12 = sigmareject(altoff,[1,2],goodvals=goodvals,/domedian)
        good_azs12 = sigmareject(dist_azoff,[1,2],goodvals=goodvals,/domedian)
        good_alts23 = sigmareject(altoff,[2,3],goodvals=goodvals,/domedian)
        good_azs23 = sigmareject(dist_azoff,[2,3],goodvals=goodvals,/domedian)
        good_alts122 = sigmareject(altoff,[1,2,2],goodvals=goodvals,/domedian)
        good_azs122 = sigmareject(dist_azoff,[1,2,2],goodvals=goodvals,/domedian)

        altoffmdl    = poly_fit(alt[goodvals]    ,altoff[goodvals]    ,polyorder)
        azoffmdl     = poly_fit(alt[goodvals]    ,azoff[goodvals]     ,polyorder)
        altoffmdl12  = poly_fit(alt[good_alts12] ,altoff[good_alts12] ,polyorder)
        azoffmdl12   = poly_fit(alt[good_azs12]  ,azoff[good_azs12]   ,polyorder)
        altoffmdl23  = poly_fit(alt[good_alts23] ,altoff[good_alts23] ,polyorder)
        azoffmdl23   = poly_fit(alt[good_azs23]  ,azoff[good_azs23]   ,polyorder)
        altoffmdl122 = poly_fit(alt[good_alts122],altoff[good_alts122],polyorder)
        azoffmdl122  = poly_fit(alt[good_azs122] ,azoff[good_azs122]  ,polyorder)

        set_plot,'ps'
        device,filename=homedir+'plots/sigmarejectcompare_alt_'+nametype+"_polyorder"+strc(polyorder)+"_"+date+'.ps',/color
        !P.MULTI=[0,2,2,0,1]
        plot,alt[goodvals],altoff[goodvals],psym=1,xtitle="Alt",ytitle="Altoff",title='RMS: '+string(stddev(altoff[goodvals]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,altoffmdl),color=225
        plot,alt[good_alts12],altoff[good_alts12],psym=1,xtitle="Alt",ytitle="Altoff",title='1,2 RMS: '+string(stddev(altoff[good_alts12]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,altoffmdl12),color=225
        plot,alt[good_alts23],altoff[good_alts23],psym=1,xtitle="Alt",ytitle="Altoff",title='2,3 RMS: '+string(stddev(altoff[good_alts23]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,altoffmdl23),color=225
        plot,alt[good_alts122],altoff[good_alts122],psym=1,xtitle="Alt",ytitle="Altoff",title='1,2,2 RMS: '+string(stddev(altoff[good_alts122]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,altoffmdl122),color=225
        device,/close_file

        device,filename=homedir+'plots/sigmarejectcompare_az_'+nametype+"_polyorder"+strc(polyorder)+"_"+date+'.ps',/color
        !P.MULTI=[0,2,2,0,1]
        plot,alt[goodvals],dist_azoff[goodvals],psym=1,xtitle="Alt",ytitle="dist_azoff",title='RMS: '+string(stddev(dist_azoff[goodvals]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,azoffmdl)*cos(allalt*!dtor),color=225
        plot,alt[good_azs12],dist_azoff[good_azs12],psym=1,xtitle="Alt",ytitle="dist_azoff",title='1,2 RMS: '+string(stddev(dist_azoff[good_azs12]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,azoffmdl12)*cos(allalt*!dtor),color=225
        plot,alt[good_azs23],dist_azoff[good_azs23],psym=1,xtitle="Alt",ytitle="dist_azoff",title='2,3 RMS: '+string(stddev(dist_azoff[good_azs23]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,azoffmdl23)*cos(allalt*!dtor),color=225
        plot,alt[good_azs122],dist_azoff[good_azs122],psym=1,xtitle="Alt",ytitle="dist_azoff",title='1,2,2 RMS: '+string(stddev(dist_azoff[good_azs122]),format='(F5.2)'),/ys
        oplot,allalt,poly(allalt,azoffmdl122)*cos(allalt*!dtor),color=225
        device,/close_file
;        set_plot,'x'
        set_plot,'ps'
        device,filename=homedir+'plots/sigmarejectcompare_ptg_alt_'+nametype+"_polyorder"+strc(polyorder)+"_"+date+'.ps',/color
        !P.MULTI=[0,2,2,0,1]
        altoff_ptg   = altoff[goodvals]-poly(alt[goodvals],altoffmdl)
        altoff_ptg12 = altoff[good_alts12]-poly(alt[good_alts12],altoffmdl12)
        altoff_ptg23 = altoff[good_alts23]-poly(alt[good_alts23],altoffmdl23)
        altoff_ptg122 = altoff[good_alts122]-poly(alt[good_alts122],altoffmdl122)
        plot,alt[goodvals],altoff_ptg,psym=1,xtitle="Alt",ytitle="Altoff",title='RMS: '+string(stddev(altoff_ptg),format='(F5.2)')
        plot,alt[good_alts12],altoff_ptg12,psym=1,xtitle="Alt",ytitle="Altoff",title='1,2 RMS: '+string(stddev(altoff_ptg12),format='(F5.2)')
        plot,alt[good_alts23],altoff_ptg23,psym=1,xtitle="Alt",ytitle="Altoff",title='2,3 RMS: '+string(stddev(altoff_ptg23),format='(F5.2)')
        plot,alt[good_alts122],altoff_ptg122,psym=1,xtitle="Alt",ytitle="Altoff",title='1,2,2 RMS: '+string(stddev(altoff_ptg122),format='(F5.2)')
        device,/close_file

        device,filename=homedir+'plots/sigmarejectcompare_ptg_az_'+nametype+"_polyorder"+strc(polyorder)+"_"+date+'.ps',/color
        !P.MULTI=[0,2,2,0,1]
        azoff_ptg   = dist_azoff[goodvals]-poly(alt[goodvals],azoffmdl)*cos(alt[goodvals]*!dtor)
        azoff_ptg12 = dist_azoff[good_azs12]-poly(alt[good_azs12],azoffmdl12)*cos(alt[good_azs12]*!dtor)
        azoff_ptg23 = dist_azoff[good_azs23]-poly(alt[good_azs23],azoffmdl23)*cos(alt[good_azs23]*!dtor)
        azoff_ptg122 = dist_azoff[good_azs122]-poly(alt[good_azs122],azoffmdl122)*cos(alt[good_azs122]*!dtor)
        plot,alt[goodvals],azoff_ptg,psym=1,xtitle="Alt",ytitle="Azoff",title='RMS: '+string(stddev(azoff_ptg),format='(F5.2)')
        plot,alt[good_azs12],azoff_ptg12,psym=1,xtitle="Alt",ytitle="Azoff",title='1,2 RMS: '+string(stddev(azoff_ptg12),format='(F5.2)')
        plot,alt[good_azs23],azoff_ptg23,psym=1,xtitle="Alt",ytitle="Azoff",title='2,3 RMS: '+string(stddev(azoff_ptg23),format='(F5.2)')
        plot,alt[good_azs122],azoff_ptg122,psym=1,xtitle="Alt",ytitle="Azoff",title='1,2,2 RMS: '+string(stddev(azoff_ptg122),format='(F5.2)')
        device,/close_file
;        set_plot,'x'
    endif


    
    if keyword_set(interactive) then stop else begin


        set_plot,'ps'
        device,filename=homedir+'plots/paper_models_'+nametype+"_"+date+'.ps',/color
        !P.MULTI=[0, 2, 2, 0, 1]
        altoff_min=min(altoff[goodvals]) & azoff_min=min(azoff_dist[goodvals])
        altoff_max=max(altoff[goodvals]) & azoff_max=max(azoff_dist[goodvals])
        plot,alt[goodvals],altoff[goodvals],psym=1,xtitle="Alt",ytitle="Altoff",$
            title='RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[altoff_min,altoff_max]
        oplot,allalt,allaltoff_model*3600.,color=254   
        plot,alt[goodvals],azoff_dist[goodvals],psym=1 ,xtitle="Alt",ytitle="Azoff (distance)"  ,$
            title='RMS: '+string(stddev(azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[azoff_min,azoff_max]
        oplot,allalt,allazoff_model*3600.,color=254   
        pmsub_altoff = altoff - poly(alt,my_altoff_model2)
        pmsub_azoff  = azoff_dist  - poly(alt,my_azoff_model2)
        mpmsub_altoff = altoff - altoff_model*3600
        mpmsub_azoff  = azoff_dist  - azoff_model*3600
        plot,alt[good_both],mpmsub_altoff[good_both],psym=1,xtitle="Alt",ytitle="Altoff",$
            title="RMS: "+string(stddev(mpmsub_altoff[good_both]),format='(F5.2)')
        plot,alt[good_both],mpmsub_azoff[good_both],psym=1,xtitle="Alt",ytitle="Azoff (distance)",$
            title="RMS: "+string(stddev(mpmsub_azoff[good_both]),format='(F5.2)') 

        faltoff_min=min(altoffmfzao[goodvals]) & fazoff_min=min(azoffpfazo[goodvals])
        faltoff_max=max(altoffmfzao[goodvals]) & fazoff_max=max(azoffpfazo[goodvals])

        plot,az[goodvals],altoff[goodvals],psym=1,xtitle="Az",ytitle="Altoff",title='RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[altoff_min,altoff_max]
        oplot,az[good_both],altoff[good_both],psym=1
        plot,az[goodvals],azoff_dist[goodvals],psym=1 ,xtitle="Az",ytitle="Azoff (distance)"  ,title='RMS: '+string(stddev(azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys ,yrange=[azoff_min,azoff_max]
        oplot,az[good_both],azoff_dist[good_both],psym=1
        pmsub_altoff = altoff - poly(alt,my_altoff_model2)
        pmsub_azoff  = azoff_dist  - poly(alt,my_azoff_model2)
        plot,az[good_both],pmsub_altoff[good_both],psym=1,xtitle="Az",ytitle="Altoff",title="RMS: "+string(stddev(pmsub_altoff[good_both]),format='(F5.2)')+" mean: "+string(mean(pmsub_altoff[good_both]),format='(F5.2)'),/ys
        plot,az[good_both],pmsub_azoff[good_both],psym=1,xtitle="Az",ytitle="Azoff (distance)",title="RMS: "+string(stddev(pmsub_azoff[good_both]),format='(F5.2)')+" mean: "+string(mean(pmsub_azoff[good_both]),format='(F5.2)'),/ys

        ;;HISTOGRAMS
        h_alt = hist_wrapper(pmsub_altoff,1.,-20,20,/gauss_fit,/noverbose)
        h_az = hist_wrapper(pmsub_azoff,1.,-20,20,/gauss_fit,/noverbose)
        h_ra = hist_wrapper(corrected_raoff_dist,1.,-20,20,/gauss_fit,/noverbose)
        h_dec = hist_wrapper(corrected_decoff,1.,-20,20,/gauss_fit,/noverbose)
        x_g = findgen(1000)/25.-20.
        g_alt = h_alt.fit_ampl*exp(-(x_g - h_alt.fit_mean)^2/h_alt.fit_rms^2)
        g_az = h_az.fit_ampl*exp(-(x_g - h_az.fit_mean)^2/h_az.fit_rms^2)
        g_ra = h_ra.fit_ampl*exp(-(x_g - h_ra.fit_mean)^2/h_ra.fit_rms^2)
        g_dec = h_dec.fit_ampl*exp(-(x_g - h_dec.fit_mean)^2/h_dec.fit_rms^2)

        ; PAGE 16
        !P.MULTI=[0, 2, 1, 0, 1]
        plot,h_alt.hb,h_alt.hc,psym=10,/xs,xtitle="Residual altoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_alt,color=250
        plot,h_az.hb,h_az.hc,psym=10,/xs,xtitle="Residual azoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_az,color=250

        device,/close_file

        if keyword_set(dosave) then save,filename=homedir+'plots/'+nametype+"_"+date+".sav"

        ;;; PAGE 1
        set_plot,'ps'
        device,filename=homedir+'plots/models_'+nametype+"_"+date+'.ps',/color
        !P.MULTI=[0, 2, 2, 0, 1]
        altoff_min=min(altoff[goodvals]) & azoff_min=min(azoff_dist[goodvals])
        altoff_max=max(altoff[goodvals]) & azoff_max=max(azoff_dist[goodvals])
        plot,alt[goodvals],altoff[goodvals],psym=1,xtitle="Alt",ytitle="Altoff",$
            title='RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[altoff_min,altoff_max]
        oplot,allalt,allaltoff_model*3600.,color=254   
;        oplot,allalt,poly(allalt,my_altoff_model2),color=225,psym=3
;        oplot,alt[good_both],altoff[good_both],psym=1;,color=250 ;,$
;            title="Outlier rejection"+string(byte(13))+'RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),xtitle="Alt",ytitle="Altoff",/ys   
        plot,alt[goodvals],azoff_dist[goodvals],psym=1 ,xtitle="Alt",ytitle="Azoff (distance)"  ,$
            title='RMS: '+string(stddev(azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[azoff_min,azoff_max]
        oplot,allalt,allazoff_model*3600.,color=254   
;        oplot,allalt,poly(allalt,my_azoff_model2),color=226,psym=3
;        plot,alt[good_alts],altoff[good_alts],psym=1 ,$
;            title="Outlier rejection"+string(byte(13))+'RMS: '+string(stddev(altoff[good_alts]),format='(F5.2)'),xtitle="Alt",ytitle="Altoff",/ys   
;        oplot,allalt,-allaltoff_model*3600.,color=100   
;        oplot,allalt,poly(allalt,my_altoff_model2),color=225,psym=3
;        oplot,alt[good_both],azoff_dist[good_both],psym=1;,color=250   ;,xtitle="Alt",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_both]*cos(!dtor*alt[good_both])),format='(F5.2)'),/ys
;        plot,alt[good_azs],azoff[good_azs]*cos(!dtor*alt[good_azs]),psym=1   ,xtitle="Alt",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_azs]*cos(!dtor*alt[good_azs])),format='(F5.2)'),/ys
;        oplot,allalt,-allazoff_model*3600.,color=100   
 ;       oplot,allalt,poly(allalt,my_azoff_model2)*cos(!dtor*allalt),color=225,psym=3
        pmsub_altoff = altoff - poly(alt,my_altoff_model2)
        pmsub_azoff  = azoff_dist  - poly(alt,my_azoff_model2)
        mpmsub_altoff = altoff - altoff_model*3600
        mpmsub_azoff  = azoff_dist  - azoff_model*3600
        plot,alt[good_both],mpmsub_altoff[good_both],psym=1,xtitle="Alt",ytitle="Altoff",$
            title="RMS: "+string(stddev(mpmsub_altoff[good_both]),format='(F5.2)')
;            " mRMS: "+string(stddev(mpmsub_altoff[good_both]),format='(F5.2)') 
            ;+" mean: "+string(mean(pmsub_altoff[good_both]),format='(F5.2)'),/ys
;        oplot,alt[good_both],mpmsub_altoff[good_both],psym=1,color=250
        plot,alt[good_both],mpmsub_azoff[good_both],psym=1,xtitle="Alt",ytitle="Azoff (distance)",$
            title="RMS: "+string(stddev(mpmsub_azoff[good_both]),format='(F5.2)') 
;            " mRMS: "+string(stddev(mpmsub_azoff[good_both]),format='(F5.2)')
;        oplot,alt[good_both],mpmsub_azoff[good_both],psym=1,color=250
            ; +" mean: "+string(mean(pmsub_azoff[good_both]),format='(F5.2)'),/ys
;        device,/close_file
;        set_plot,'x'

        ;;; PAGE 2
        faltoff_min=min(altoffmfzao[goodvals]) & fazoff_min=min(azoffpfazo[goodvals])
        faltoff_max=max(altoffmfzao[goodvals]) & fazoff_max=max(azoffpfazo[goodvals])
        plot,alt[goodvals],altoffmfzao[goodvals],psym=1,xtitle="Alt",ytitle="Altoff (no offset subtract)",title='RMS: '+string(stddev(altoffmfzao[good_both_f]),format='(F5.2)')+" n: "+strc(n_e(good_both_f)),/ys,yrange=[faltoff_min,faltoff_max]
        oplot,allalt,allaltoff_model*3600.,color=100   
        oplot,allalt,poly(allalt,fzao_new_model),color=225,psym=3
        oplot,alt[good_both_f],altoffmfzao[good_both_f],psym=1,color=200 ;,$
;            title="Outlier rejection"+string(byte(13))+'RMS: '+string(stddev(altoff[good_both_f]),format='(F5.2)')+" n: "+strc(n_e(good_both_f)),xtitle="Alt",ytitle="Altoff",/ys   
        plot,alt[goodvals],azoffpfazo[goodvals],psym=1 ,xtitle="Alt",ytitle="Azoff (distance)"  ,title='RMS: '+string(stddev(azoffpfazo[good_both_f]),format='(F5.2)')+" n: "+strc(n_e(good_both_f)),/ys,yrange=[fazoff_min,fazoff_max]
        oplot,allalt,allazoff_model*3600.,color=100   
        oplot,allalt,poly(allalt,fazo_new_model),color=226,psym=3
        oplot,alt[good_both_f],azoffpfazo[good_both_f],psym=1,color=200   ;,xtitle="Alt",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_both_f]*cos(!dtor*alt[good_both_f])),format='(F5.2)'),/ys
        plot,alt[good_both_f],fpmsub_altoff[good_both_f],psym=1,xtitle="Alt",ytitle="Altoff",title="RMS: "+string(stddev(fpmsub_altoff[good_both_f]),format='(F5.2)')+" mean: "+string(mean(fpmsub_altoff[good_both_f]),format='(F5.2)'),/ys
        plot,alt[good_both_f],fpmsub_azoff[good_both_f],psym=1,xtitle="Alt",ytitle="Azoff (distance)",title="RMS: "+string(stddev(fpmsub_azoff[good_both_f]),format='(F5.2)')+" mean: "+string(mean(fpmsub_azoff[good_both_f]),format='(F5.2)'),/ys
;        device,/close_file
;        set_plot,'x'

        ;;; PAGE 3
        plot,alt,fzao,psym=1,xtitle="alt",ytitle="fzao"        
        plot,alt,fazo,psym=1,xtitle="alt",ytitle="fazo"        
        plot,az,fzao,psym=1,xtitle="az",ytitle="fzao"        
        plot,az,fazo,psym=1,xtitle="az",ytitle="fazo"        

;;;;;; AZIMUTH PLOTTING
        ;;; PAGE 4
        plot,az[goodvals],altoff[goodvals],psym=1,xtitle="Az",ytitle="Altoff",title='RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[altoff_min,altoff_max]
        oplot,az[good_both],altoff[good_both],psym=1,color=200 ;,$
;            title="Outlier rejection"+string(byte(13))+'RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),xtitle="Az",ytitle="Altoff",/ys   
        plot,az[goodvals],azoff_dist[goodvals],psym=1 ,xtitle="Az",ytitle="Azoff (distance)"  ,title='RMS: '+string(stddev(azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys ,yrange=[azoff_min,azoff_max]
;        plot,az[good_alts],altoff[good_alts],psym=1 ,$
;            title="Outlier rejection"+string(byte(13))+'RMS: '+string(stddev(altoff[good_alts]),format='(F5.2)'),xtitle="Az",ytitle="Altoff",/ys   
        oplot,az[good_both],azoff_dist[good_both],psym=1,color=200   ;,xtitle="Az",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_both]*cos(!dtor*alt[good_both])),format='(F5.2)'),/ys
;        plot,az[good_azs],azoff[good_azs]*cos(!dtor*alt[good_azs]),psym=1   ,xtitle="Az",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_azs]*cos(!dtor*alt[good_azs])),format='(F5.2)'),/ys
        pmsub_altoff = altoff - poly(alt,my_altoff_model2)
        pmsub_azoff  = azoff_dist  - poly(alt,my_azoff_model2)
        plot,az[good_both],pmsub_altoff[good_both],psym=1,xtitle="Az",ytitle="Altoff",title="RMS: "+string(stddev(pmsub_altoff[good_both]),format='(F5.2)')+" mean: "+string(mean(pmsub_altoff[good_both]),format='(F5.2)'),/ys
        plot,az[good_both],pmsub_azoff[good_both],psym=1,xtitle="Az",ytitle="Azoff (distance)",title="RMS: "+string(stddev(pmsub_azoff[good_both]),format='(F5.2)')+" mean: "+string(mean(pmsub_azoff[good_both]),format='(F5.2)'),/ys
;        device,/close_file
;        set_plot,'x'

        ;;; PAGE 5
        plot,az[goodvals],altoffmfzao[goodvals],psym=1,xtitle="Az",ytitle="Altoff (no offset subtract)",title='RMS: '+string(stddev(altoffmfzao[good_both_f]),format='(F5.2)')+" n: "+strc(n_e(good_both_f)),/ys,yrange=[faltoff_min,faltoff_max]
        oplot,az[good_both_f],altoffmfzao[good_both_f],psym=1,color=200 ;,$
;            title="Outlier rejection"+string(byte(13))+'RMS: '+string(stddev(altoff[good_both_f]),format='(F5.2)')+" n: "+strc(n_e(good_both_f)),xtitle="Az",ytitle="Altoff",/ys   
        plot,az[goodvals],azoffpfazo[goodvals],psym=1 ,xtitle="Az",ytitle="Azoff (distance)"  ,title='RMS: '+string(stddev(azoffpfazo[good_both_f]),format='(F5.2)')+" n: "+strc(n_e(good_both_f)),/ys ,yrange=[fazoff_min,fazoff_max]
        oplot,az[good_both_f],azoffpfazo[good_both_f],psym=1,color=200   ;,xtitle="Az",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_both_f]*cos(!dtor*alt[good_both_f])),format='(F5.2)'),/ys
;        fpmsub_altoff = altoff - fzao - poly(alt,fzao_new_model)
;        fpmsub_azoff  = azoff_dist + fazo - poly(alt,fazo_new_model)
        plot,az[good_both_f],fpmsub_altoff[good_both_f],psym=1,xtitle="Az",ytitle="Altoff",title="RMS: "+string(stddev(fpmsub_altoff[good_both_f]),format='(F5.2)')+" mean: "+string(mean(fpmsub_altoff[good_both_f]),format='(F5.2)'),/ys
        plot,az[good_both_f],fpmsub_azoff[good_both_f],psym=1,xtitle="Az",ytitle="Azoff (distance)",title="RMS: "+string(stddev(fpmsub_azoff[good_both_f]),format='(F5.2)')+" mean: "+string(mean(fpmsub_azoff[good_both_f]),format='(F5.2)'),/ys
;        device,/close_file
;        set_plot,'x'

;        plot,az[goodvals],+fzao[goodvals]+altoff[goodvals],psym=1,xtitle="Az",ytitle="Altoff (no offset subtract)",title='RMS: '+string(stddev(fzao[good_both]+altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys
;        oplot,az[good_both],+fzao[good_both]+altoff[good_both],psym=1,color=200 ;,$
;;            title="Outlier rejection"+string(byte(13))+'RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),xtitle="Az",ytitle="Altoff",/ys   
;        plot,az[goodvals],+fazo[goodvals]+azoff_dist[goodvals],psym=1 ,xtitle="Az",ytitle="Azoff (distance)"  ,title='RMS: '+string(stddev(+fazo[good_both]+azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys
;        oplot,az[good_both],-fazo[good_both]+azoff_dist[good_both],psym=1,color=200   ;,xtitle="Az",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_both]*cos(!dtor*alt[good_both])),format='(F5.2)'),/ys
;        fpmsub_altoff2 = altoff + fzao - poly(alt,fzao_new_model)
;        fpmsub_azoff2  = azoff_dist - fazo - poly(alt,fazo_new_model)
;        plot,az[good_both],fpmsub_altoff2[good_both],psym=1,xtitle="Az",ytitle="Altoff",title="RMS: "+string(stddev(fpmsub_altoff2[good_both]),format='(F5.2)')+" mean: "+string(mean(fpmsub_altoff[good_both]),format='(F5.2)'),/ys
;        plot,az[good_both],fpmsub_azoff2[good_both],psym=1,xtitle="Az",ytitle="Azoff (distance)",title="RMS: "+string(stddev(fpmsub_azoff2[good_both]),format='(F5.2)')+" mean: "+string(mean(fpmsub_azoff[good_both]),format='(F5.2)'),/ys
;;        device,/close_file
;;        set_plot,'x'

        ;;;;CURIOSITIES
        ; PAGE 6
        totaloff_altaz = sqrt(altoff^2+azoff_dist^2)
        raoff_dist = (raoff*cos(!dtor*dec))
        totaloff_radec = sqrt(raoff_dist^2+decoff^2)
        plot,totaloff_radec[goodvals],totaloff_altaz[goodvals],psym=1,title="Total offsets in RA/Dec vs Alt/Az (goodvals)",xtitle="RADEC tot",ytitle="AltAz tot",/ys,/xs
        plot,totaloff_radec[good_both],totaloff_altaz[good_both],psym=1,title="Total offsets in RA/Dec vs Alt/Az (goodboth)",xtitle="RADEC tot",ytitle="AltAz tot",/ys,/xs
        plot,alt[good_both],(totaloff_radec-totaloff_altaz)[good_both],psym=1,xtitle="alt",ytitle="radec/altaz difference",/ys,/xs
        plot,az[good_both],(totaloff_radec-totaloff_altaz)[good_both],psym=1,xtitle="az",ytitle="radec/altaz difference",/ys,/xs

        ; PAGE 7
        plot,ra[good_both],altoff[good_both],xtitle="RA",ytitle="altoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(altoff[good_both]),format="(F5.2)")
        plot,ra[good_both],azoff_dist[good_both],xtitle="RA",ytitle="azoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(azoff_dist[good_both]),format="(F5.2)")
        plot,dec[good_both],altoff[good_both],xtitle="Dec",ytitle="altoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(altoff[good_both]),format="(F5.2)")
        plot,dec[good_both],azoff_dist[good_both],xtitle="Dec",ytitle="azoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(azoff_dist[good_both]),format="(F5.2)")

        ; PAGE 8
        plot,ra[good_both],raoff_dist[good_both],xtitle="RA",ytitle="raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        plot,ra[good_both],decoff[good_both],xtitle="RA",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")
        plot,dec[good_both],raoff_dist[good_both],xtitle="Dec",ytitle="raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        plot,dec[good_both],decoff[good_both],xtitle="Dec",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")

        ;PAGE 9
        plot,ra[good_both],corrected_raoff_dist[good_both],xtitle="RA",ytitle="corrected_raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_raoff_dist[good_both]),format="(F5.2)")
        plot,ra[good_both],corrected_decoff[good_both],xtitle="RA",ytitle="corrected_decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_decoff[good_both]),format="(F5.2)")
        plot,dec[good_both],corrected_raoff_dist[good_both],xtitle="Dec",ytitle="corrected_raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_raoff_dist[good_both]),format="(F5.2)")
        plot,dec[good_both],corrected_decoff[good_both],xtitle="Dec",ytitle="corrected_decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_decoff[good_both]),format="(F5.2)")

        ;PAGE 10
        plot,mjd[good_both],altoff[good_both],xtitle="MJD-54000",ytitle="altoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(altoff[good_both]),format="(F5.2)")
        plot,mjd[good_both],azoff_dist[good_both],xtitle="MJD-54000",ytitle="azoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(azoff_dist[good_both]),format="(F5.2)")
        plot,mjd[good_both],raoff_dist[good_both],xtitle="MJD-54000",ytitle="raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        plot,mjd[good_both],decoff[good_both],xtitle="MJD-54000",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")

        ;PAGE 11
        plot,lst[good_both],altoff[good_both],xtitle="lst",ytitle="altoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(altoff[good_both]),format="(F5.2)")
        plot,lst[good_both],azoff_dist[good_both],xtitle="lst",ytitle="azoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(azoff_dist[good_both]),format="(F5.2)")
        plot,lst[good_both],raoff_dist[good_both],xtitle="lst",ytitle="raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        plot,lst[good_both],decoff[good_both],xtitle="lst",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")

        ;PAGE 12
        plot,lst[good_both],pmsub_altoff[good_both],xtitle="lst",ytitle="altoff corrected",/xs,/ys,psym=1,title="RMS: "+string(stddev(pmsub_altoff[good_both]),format="(F5.2)")
        plot,lst[good_both],pmsub_azoff[good_both],xtitle="lst",ytitle="azoff corrected",/xs,/ys,psym=1,title="RMS: "+string(stddev(pmsub_azoff[good_both]),format="(F5.2)")
        plot,lst[good_both],corrected_raoff_dist[good_both],xtitle="lst",ytitle="raoff corrected",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_raoff_dist[good_both]),format="(F5.2)")
        plot,lst[good_both],corrected_decoff[good_both],xtitle="lst",ytitle="decoff corrected",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_decoff[good_both]),format="(F5.2)")

        ; what happens if we fit a model to ra/dec vs. az?
        allaz = findgen(1000)*360./1000.
        ra_model = poly_fit(az[good_both],raoff_dist[good_both],5)
        dec_model = poly_fit(az[good_both],decoff[good_both],5)
        corrected_raoff_2 = raoff_dist[good_both] - poly(az[good_both],ra_model)
        corrected_decoff_2 = decoff[good_both] - poly(az[good_both],dec_model)

        ;PAGE 13
        plot,alt[good_both],raoff_dist[good_both],xtitle="Alt",ytitle="raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        plot,alt[good_both],decoff[good_both],xtitle="Alt",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")
        plot,az[good_both],raoff_dist[good_both],xtitle="Az",ytitle="raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        oplot,allaz,poly(allaz,ra_model),color=225
        plot,az[good_both],decoff[good_both],xtitle="Az",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")
        oplot,allaz,poly(allaz,dec_model),color=225

        ; PAGE 14
        plot,alt[good_both],corrected_raoff_dist[good_both],xtitle="Alt",ytitle="corrected raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_raoff_dist[good_both]),format="(F5.2)")
        plot,alt[good_both],corrected_decoff[good_both],xtitle="Alt",ytitle="corrected decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_decoff[good_both]),format="(F5.2)")
        plot,az[good_both],corrected_raoff_dist[good_both],xtitle="Az",ytitle="corrected raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_raoff_dist[good_both]),format="(F5.2)")
        plot,az[good_both],corrected_decoff[good_both],xtitle="Az",ytitle="corrected decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_decoff[good_both]),format="(F5.2)")

        ; PAGE 15
        plot,alt[good_both],corrected_raoff_2[good_both],xtitle="Alt",ytitle="corrected raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_raoff_2[good_both]),format="(F5.2)")
        plot,alt[good_both],corrected_decoff_2[good_both],xtitle="Alt",ytitle="corrected decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_decoff_2[good_both]),format="(F5.2)")
        plot,az[good_both],corrected_raoff_2[good_both],xtitle="Az",ytitle="corrected raoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_raoff_2[good_both]),format="(F5.2)")
        plot,az[good_both],corrected_decoff_2[good_both],xtitle="Az",ytitle="corrected decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(corrected_decoff_2[good_both]),format="(F5.2)")

        ;;HISTOGRAMS
        h_alt = hist_wrapper(pmsub_altoff,1.,-20,20,/gauss_fit,/noverbose)
        h_az = hist_wrapper(pmsub_azoff,1.,-20,20,/gauss_fit,/noverbose)
        h_ra = hist_wrapper(corrected_raoff_dist,1.,-20,20,/gauss_fit,/noverbose)
        h_dec = hist_wrapper(corrected_decoff,1.,-20,20,/gauss_fit,/noverbose)
        x_g = findgen(1000)/25.-20.
        g_alt = h_alt.fit_ampl*exp(-(x_g - h_alt.fit_mean)^2/h_alt.fit_rms^2)
        g_az = h_az.fit_ampl*exp(-(x_g - h_az.fit_mean)^2/h_az.fit_rms^2)
        g_ra = h_ra.fit_ampl*exp(-(x_g - h_ra.fit_mean)^2/h_ra.fit_rms^2)
        g_dec = h_dec.fit_ampl*exp(-(x_g - h_dec.fit_mean)^2/h_dec.fit_rms^2)

        ; PAGE 16
        plot,h_alt.hb,h_alt.hc,psym=10,/xs,xtitle="Residual altoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_alt,color=250
        plot,h_az.hb,h_az.hc,psym=10,/xs,xtitle="Residual azoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_az,color=250
        plot,h_ra.hb,h_ra.hc,psym=10,/xs,xtitle="Residual raoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_ra,color=250
        plot,h_dec.hb,h_dec.hc,psym=10,/xs,xtitle="Residual decoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_dec,color=250

        h_falt = hist_wrapper(fpmsub_altoff,1.,-20,20,/gauss_fit,/noverbose)
        h_faz = hist_wrapper(fpmsub_azoff,1.,-20,20,/gauss_fit,/noverbose)
        g_falt = h_falt.fit_ampl*exp(-(x_g - h_falt.fit_mean)^2/h_falt.fit_rms^2)
        g_faz = h_faz.fit_ampl*exp(-(x_g - h_faz.fit_mean)^2/h_faz.fit_rms^2)

        ; PAGE 17
        plot,h_falt.hb,h_falt.hc,psym=10,/xs,xtitle="Residual altoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_alt,color=250
        plot,h_faz.hb,h_faz.hc,psym=10,/xs,xtitle="Residual azoff",thick=2,ytitle="Number of observations"
        oplot,x_g,g_az,color=250
        plot,[1,1]
        plot,[1,1]

        ; PAGE 18
        plot,alt[goodvals],altoff[goodvals],psym=1,xtitle="Alt",ytitle="Altoff",title='RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[altoff_min,altoff_max]
        oplot,alt,alt_mdl,color=225,psym=7
        oplot,alt[good_both],altoff[good_both],psym=1,color=200 ;,$
        plot,alt[goodvals],azoff_dist[goodvals],psym=1 ,xtitle="Alt",ytitle="Azoff (distance)"  ,title='RMS: '+string(stddev(azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[azoff_min,azoff_max]
        oplot,alt,az_mdl,color=226,psym=7
        oplot,alt[good_both],azoff_dist[good_both],psym=1,color=200   ;,xtitle="Alt",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_both]*cos(!dtor*alt[good_both])),format='(F5.2)'),/ys
        psub_altoff = altoff     - alt_mdl
        psub_azoff  = azoff_dist - az_mdl
        plot,alt[good_both],psub_altoff[good_both],psym=1,xtitle="Alt",ytitle="Altoff",title="RMS: "+string(stddev(psub_altoff[good_both]),format='(F5.2)')+" mean: "+string(mean(psub_altoff[good_both]),format='(F5.2)'),/ys
        plot,alt[good_both],psub_azoff[good_both],psym=1,xtitle="Alt",ytitle="Azoff (distance)",title="RMS: "+string(stddev(psub_azoff[good_both]),format='(F5.2)')+" mean: "+string(mean(psub_azoff[good_both]),format='(F5.2)'),/ys

        ; PAGE 19
        plot,az[goodvals],altoff[goodvals],psym=1,xtitle="Az",ytitle="Altoff",title='RMS: '+string(stddev(altoff[good_both]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys,yrange=[altoff_min,altoff_max]
        oplot,az[good_both],altoff[good_both],psym=1,color=200 ;,$
        plot,az[goodvals],azoff_dist[goodvals],psym=1 ,xtitle="Az",ytitle="Azoff (distance)"  ,title='RMS: '+string(stddev(azoff_dist[goodvals]),format='(F5.2)')+" n: "+strc(n_e(good_both)),/ys ,yrange=[azoff_min,azoff_max]
        oplot,az[good_both],azoff_dist[good_both],psym=1,color=200   ;,xtitle="Az",ytitle="Azoff (distance)",title='RMS: '+string(stddev(azoff[good_both]*cos(!dtor*alt[good_both])),format='(F5.2)'),/ys
        plot,az[good_both],psub_altoff[good_both],psym=1,xtitle="Az",ytitle="Altoff",title="RMS: "+string(stddev(psub_altoff[good_both]),format='(F5.2)')+" mean: "+string(mean(psub_altoff[good_both]),format='(F5.2)'),/ys
        plot,az[good_both],psub_azoff[good_both],psym=1,xtitle="Az",ytitle="Azoff (distance)",title="RMS: "+string(stddev(psub_azoff[good_both]),format='(F5.2)')+" mean: "+string(mean(psub_azoff[good_both]),format='(F5.2)'),/ys

        ; PAGE 20
        psub_raoff = raoff_dist - ra_mdl
        psub_decoff = decoff    - dec_mdl
        plot,ra[good_both],raoff_dist[good_both],xtitle="RA",ytitle="raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        plot,ra[good_both],decoff[good_both],xtitle="RA",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")
        plot,ra[good_both],psub_raoff[good_both],xtitle="RA",ytitle="raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(psub_raoff[good_both]),format="(F5.2)")
        plot,ra[good_both],psub_decoff[good_both],xtitle="RA",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(psub_decoff[good_both]),format="(F5.2)")

        ; PAGE 21
        plot,dec[good_both],raoff_dist[good_both],xtitle="Dec",ytitle="raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(raoff_dist[good_both]),format="(F5.2)")
        plot,dec[good_both],decoff[good_both],xtitle="Dec",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(decoff[good_both]),format="(F5.2)")
        plot,dec[good_both],psub_raoff[good_both],xtitle="Dec",ytitle="raoff distance",/xs,/ys,psym=1,title="RMS: "+string(stddev(psub_raoff[good_both]),format="(F5.2)")
        plot,dec[good_both],psub_decoff[good_both],xtitle="Dec",ytitle="decoff",/xs,/ys,psym=1,title="RMS: "+string(stddev(psub_decoff[good_both]),format="(F5.2)")


;;;        if nametype eq 'rawcsoptg' or nametype eq 'rawcsoptg_radec' then begin
;;;;            ra_uncorr  = ra - ra_nut/3600. - ra_ab/3600. - ra_prec/3600. 
;;;;            dec_uncorr = dec - dec_nut/3600. - dec_ab/3600. - ra_prec/3600.
;;;            eq2hor,ra_uncorr,dec_uncorr,jd,alt_uncorr,az_uncorr,lat=latitude,alt=4072,lon=-155.473366,refract=0
;;;;            alt_raw = alt_uncorr - fzao / 3600.
;;;;            az_raw  = az_uncorr  + fazo / cos(!dtor*alt) / 3600.
;;;            alt_withF = alt - fzao / 3600.
;;;            az_withF  = az  + fazo / cos(!dtor*alt) / 3600.
;;;;            altoff_raw      = (alt_raw - objalt)*3600.
;;;;            azoff_raw       = (az_raw - objaz)*3600.
;;;;            altoff_uncorr   = (alt_uncorr - objalt)*3600.
;;;;            azoff_uncorr    = (az_uncorr - objaz)*3600.
;;;;            altoff_withF    = (alt_withF - objalt)*3600.
;;;;            azoff_withF     = (az_withF - objaz)*3600.
;;;;            altoff_ptgmdl   = (altoff + altoff_model*3600.)
;;;;            azoff_ptgmdl    = (azoff  + azoff_model*3600./cos(!dtor*alt))
;;;;            altoff_myptgmdl = (altoff - poly(alt,my_altoff_model2))
;;;;            azoff_myptgmdl  = (azoff  - poly(alt,my_azoff_model2))
;;;;
;;;            if keyword_set(interactive) then begin set_plot,'x' & stop & endif
;;;            
;;;;            set_plot,'ps'
;;;;            device,filename=homedir+'plots/altprogression_'+date+'.ps',/color
;;;            !P.MULTI=[0, 2, 1, 0, 1]
;;;    ;        plot,alt[good_alts],altoff_raw[good_alts],psym=1,title="raw ncdf alt offset",xtitle="alt",ytitle="altoff (as)"
;;;    ;        plot,alt[good_alts],altoff_withF[good_alts],psym=1,title="raw ncdf alt offset ab/nut/prec corrected",xtitle="alt",ytitle="altoff (as)"
;;;            plot,alt[good_alts],altoff[good_alts],psym=1,title="ab/nut/prec corrected CSO ptg mdl",xtitle="alt",ytitle="altoff (as)"
;;;            oplot,allalt,-allaltoff_model*3600.,color=100   
;;;            oplot,allalt,poly(allalt,my_altoff_model),color=225,psym=3
;;;            plot,alt[good_alts],altoff_ptgmdl[good_alts],psym=1,title="ptg mdl correction applied",xtitle="alt",ytitle="altoff (as)"
;;;            oplot,alt[good_alts],altoff_ptgmdl[good_alts],psym=1,color=100
;;;            oplot,alt[good_azs],altoff_myptgmdl[good_alts],psym=1,color=225
;;;            x = (!X.Window[1] - !X.Window[0]) / 2. + !X.Window[0] 
;;;            XYOuts, x, .91, "blue rms:"+string(stddev(altoff_ptgmdl[good_alts]),format='(F10.5)'),/Normal, Alignment=0.5, Charsize=.6
;;;            XYOuts, x, .89, "red rms:"+string(stddev(altoff_myptgmdl[good_alts]),format='(F10.5)'),/Normal, Alignment=0.5, Charsize=.6
;;;;            device,/close_file
;;;;            device,filename=homedir+'plots/azprogression_'+date+'.ps',/color
;;;            !P.MULTI=[0, 2, 1, 0, 1]
;;;    ;        plot,alt[good_azs],azoff_raw[good_azs],psym=1,title="raw ncdf az offset",xtitle="alt",ytitle="azoff (as - coordinate)"
;;;    ;        plot,alt[good_azs],azoff_withF[good_azs],psym=1,title="raw ncdf az offset ab/nut/prec corrected",xtitle="alt",ytitle="azoff (as - coordinate)"
;;;            plot,alt[good_azs],azoff[good_azs],psym=1,title="ab/nut/prec corrected CSO ptg mdl",xtitle="alt",ytitle="azoff (as - coordinate)"
;;;            oplot,allalt,-allazoff_model*3600./cos(!dtor*allalt),color=100   
;;;            oplot,allalt,poly(allalt,my_azoff_model2),color=225,psym=3
;;;            plot,alt[good_azs],azoff_ptgmdl[good_azs],psym=1,title="ptg mdl correction applied",xtitle="alt",ytitle="azoff (as - coordinate)"
;;;            oplot,alt[good_azs],azoff_ptgmdl[good_azs],psym=1,color=100
;;;            oplot,alt[good_azs],azoff_myptgmdl[good_azs],psym=1,color=225
;;;;            device,/close_file
;;;;            device,filename=homedir+'plots/azprogression_divcosalt_'+date+'.ps',/color
;;;            !P.MULTI=[0, 2, 1, 0, 1]
;;;    ;        plot,alt[good_azs],azoff_raw[good_azs]*cos(!dtor*alt[good_azs]),psym=1,title="raw ncdf az offset",xtitle="alt",ytitle="azoff (as - distance)"
;;;    ;        plot,alt[good_azs],azoff_withF[good_azs]*cos(!dtor*alt[good_azs]),psym=1,title="raw ncdf az offset ab/nut/prec corrected",xtitle="alt",ytitle="azoff (as - distance)"
;;;            plot,alt[good_azs],azoff[good_azs]*cos(!dtor*alt[good_azs]),psym=1,title="ab/nut/prec corrected CSO ptg mdl",xtitle="alt",ytitle="azoff (as - distance)"
;;;            oplot,allalt,-allazoff_model*3600.,color=100   
;;;            oplot,allalt,poly(allalt,my_azoff_model2)*cos(!dtor*allalt),color=225,psym=3
;;;            plot,alt[good_azs],azoff_ptgmdl[good_azs]*cos(!dtor*alt[good_azs]),psym=1,title="ptg mdl correction applied",xtitle="alt",ytitle="azoff (as - distance)"
;;;            oplot,alt[good_azs],azoff_ptgmdl[good_azs]*cos(!dtor*alt[good_azs]),psym=1,color=100
;;;            oplot,alt[good_azs],azoff_myptgmdl[good_azs]*cos(!dtor*alt[good_azs]),psym=1,color=225
;;;            x = (!X.Window[1] - !X.Window[0]) / 2. + !X.Window[0] 
;;;            XYOuts, x, .91, "blue rms:"+string(stddev(azoff_ptgmdl[good_azs]*cos(!dtor*alt[good_azs])),format='(F10.5)'),/Normal, Alignment=0.5, Charsize=.6
;;;            XYOuts, x, .89, "red rms:"+string(stddev(azoff_myptgmdl[good_azs]*cos(!dtor*alt[good_azs])),format='(F10.5)'),/Normal, Alignment=0.5, Charsize=.6
;;;        endif
        device,/close_file
;        set_plot,'x'

        source_name_good = source_name[goodvals]
        uniq_srcs = uniq(source_name_good)
        n_uniq_srcs = n_e(uniq_srcs)
        alt_min = min(altoff[good_alts])-5 & alt_max = max(altoff[good_alts])+5
        az_min = min(azoff_dist[good_azs])-5 & az_max = max(azoff_dist[good_azs])+5
        if az_max gt 200 then az_max=200.
        tot_min = sqrt(alt_min^2+az_min^2) & tot_max = sqrt(alt_max^2+az_max^2)
        altoff_good = altoff[goodvals]
        azoff_dist_good = azoff_dist[goodvals]
        alt_good = alt[goodvals]
        az_good = az[goodvals]
        rms_altoff = fltarr(n_uniq_srcs)
        rms_azoff = fltarr(n_uniq_srcs)
        rms_totoff = fltarr(n_uniq_srcs)
        ctable = [0,40,60,150,255]
        set_plot,'ps'
        device,filename=homedir+'plots/sourcecompare_'+nametype+"_"+date+'.ps',/color
        !P.MULTI   = [0, 2, 5, 0, 1]
        !X.OMARGIN = [0,20]
        for j=0,n_uniq_srcs / 5 do begin
            plot,[20],[0],xrange=[25,75],yrange=[alt_min,alt_max],xtitle="Alt",ytitle="Altoff (arseconds)",/xs
            if 5*(j+1) ge n_uniq_srcs then max_i = n_uniq_srcs-1 else max_i = 5*(j+1)-1
;            print,"Number ",j,source_name_good[uniq_srcs[indgen(5)+5*j]]," and min,max_i are ",5*j,max_i
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                oplot,alt_good[where_src],altoff_good[where_src],color=ctable[(i-5*j)],psym=1
;                oplot,alt_good[where_src],fpmsub_altoff_good[where_src],color=ctable[(i-5*j)],psym=7
                if n_e(where_src) gt 1 then rms_altoff[i] = stddev(altoff_good[where_src]) else rms_altoff[i] = 999
            endfor
            oplot,allalt,-allaltoff_model*3600.,color=100   
            oplot,allalt,poly(allalt,fzao_new_model),color=225,psym=3

            plot,[20],[0],xrange=[25,75],yrange=[az_min,az_max],xtitle="Alt",ytitle="Azoff (arcseconds distance)",/xs
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                oplot,alt_good[where_src],azoff_dist_good[where_src],color=ctable[(i-5*j)],psym=1
;                oplot,alt_good[where_src],fpmsub_azoff_good[where_src],color=ctable[(i-5*j)],psym=7
                if n_e(where_src) gt 1 then rms_azoff[i] = stddev(azoff_dist_good[where_src]) else rms_azoff[i] = 999
            endfor
            oplot,allalt,allazoff_model*3600.,color=100   
            oplot,allalt,poly(allalt,fazo_new_model)*cos(!dtor*allalt),color=225,psym=3

            plot,[20],[0],xrange=[25,75],yrange=[tot_min,tot_max],xtitle="Alt",ytitle="Total offset",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff = sqrt(azoff_dist_good[where_src]^2 + altoff_good[where_src]^2)
                colornum = ctable[(i-5*j)]
                oplot,alt_good[where_src],totaloff,color=colornum,psym=1
;                oplot,alt_good[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=7
                if n_e(where_src) gt 1 then rms_totoff[i] = stddev(totaloff) else rms_totoff[i] = 999
                xyouts,.87,(i-5*j)/float(5)+.14,source_name_good[uniq_srcs[i]],/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.11,strc(rms_altoff[i]),/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.08,strc(rms_azoff[i]),/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.05,strc(rms_totoff[i]),/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.02,strc(n_e(where_src)),/normal,color=colornum
            endfor

            plot,[20],[0],xrange=[25,75],yrange=[0,50],xtitle="Alt",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
                oplot,alt_good[where_src],totaloff_resid,color=colornum,psym=1
;                oplot,alt_good[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=7
            endfor

            plot,[20],[0],xrange=[min(mjd),max(mjd)],yrange=[0,50],xtitle="MJD-54000",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
                oplot,mjd[where_src],totaloff_resid,color=colornum,psym=1
;                oplot,mjd[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=7
            endfor

            
            ; X AXIS AZIMUTH
            plot,[20],[0],xrange=[0,360],yrange=[alt_min,alt_max],xtitle="Az",ytitle="Altoff (arseconds)",/xs
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                oplot,az_good[where_src],altoff_good[where_src],color=ctable[(i-5*j)],psym=1
;                oplot,az_good[where_src],fpmsub_altoff_good[where_src],color=ctable[(i-5*j)],psym=7
            endfor
            plot,[20],[0],xrange=[0,360],yrange=[az_min,az_max],xtitle="Ax",ytitle="Azoff (arcseconds distance)",/xs
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                oplot,az_good[where_src],azoff_dist_good[where_src],color=ctable[(i-5*j)],psym=1
;                oplot,az_good[where_src],fpmsub_azoff_good[where_src],color=ctable[(i-5*j)],psym=7
            endfor
            plot,[20],[0],xrange=[0,360],yrange=[tot_min,tot_max],xtitle="Az",ytitle="Total offset",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff = sqrt(azoff_dist_good[where_src]^2 + altoff_good[where_src]^2)
                colornum = ctable[(i-5*j)]
                oplot,az_good[where_src],totaloff,color=colornum,psym=1
            endfor
            plot,[20],[0],xrange=[0,360],yrange=[0,50],xtitle="Az",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
                oplot,az_good[where_src],totaloff_resid,color=colornum,psym=1
;                oplot,az_good[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=7
            endfor
            plot,[20],[0],xrange=[min(lst),max(lst)],yrange=[0,50],xtitle="LST",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
                oplot,lst[where_src],totaloff_resid,color=colornum,psym=1
;                oplot,lst[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=7
            endfor
        endfor


        ; POINTING MODEL RESIDUALS (in principle)
        fpmsub_altoff_good = fpmsub_altoff[goodvals]
        fpmsub_azoff_good = fpmsub_azoff[goodvals]
        fpmsub_totoff_good = (sqrt(fpmsub_altoff^2+fpmsub_azoff^2))[goodvals]
        falt_min = min(fpmsub_altoff[good_alts])-5 & falt_max = max(fpmsub_altoff[good_alts])+5
        faz_min = min(fpmsub_azoff[good_azs])-5 & faz_max = max(fpmsub_azoff[good_azs])+5
        ftot_min = sqrt(falt_min^2+faz_min^2) & ftot_max = sqrt(falt_max^2+faz_max^2)
        ; X AXIS ALTITUDE
        !P.MULTI   = [0, 2, 4, 0, 1]
        !Y.OMARGIN = [0,2]
        for j=0,n_uniq_srcs / 5 do begin
            plot,[20],[0],xrange=[25,75],yrange=[falt_min,falt_max],xtitle="Alt",ytitle="Altoff (arseconds)",/xs
            xyouts,.3,.97,"FZAO/FAZO NEW MODEL RESIDUALS",/normal
            if 5*(j+1) ge n_uniq_srcs then max_i = n_uniq_srcs-1 else max_i = 5*(j+1)-1
;            print,"Number ",j,source_name_good[uniq_srcs[indgen(5)+5*j]]," and min,max_i are ",5*j,max_i
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
;                oplot,alt_good[where_src],altoff_good[where_src],color=ctable[(i-5*j)],psym=1
                oplot,alt_good[where_src],fpmsub_altoff_good[where_src],color=ctable[(i-5*j)],psym=1
                if n_e(where_src) gt 1 then rms_altoff[i] = stddev(altoff_good[where_src]) else rms_altoff[i] = 999
            endfor
            oplot,allalt,-allaltoff_model*3600.,color=100   
            oplot,allalt,poly(allalt,fzao_new_model),color=225,psym=3

            plot,[20],[0],xrange=[25,75],yrange=[faz_min,faz_max],xtitle="Alt",ytitle="Azoff (arcseconds distance)",/xs
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
;                oplot,alt_good[where_src],azoff_dist_good[where_src],color=ctable[(i-5*j)],psym=1
                oplot,alt_good[where_src],fpmsub_azoff_good[where_src],color=ctable[(i-5*j)],psym=1
                if n_e(where_src) gt 1 then rms_azoff[i] = stddev(azoff_dist_good[where_src]) else rms_azoff[i] = 999
            endfor
            oplot,allalt,allazoff_model*3600.,color=100   
            oplot,allalt,poly(allalt,fazo_new_model)*cos(!dtor*allalt),color=225,psym=3

;            plot,[20],[0],xrange=[25,75],yrange=[ftot_min,ftot_max],xtitle="Alt",ytitle="Total offset",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff = sqrt(azoff_dist_good[where_src]^2 + altoff_good[where_src]^2)
                colornum = ctable[(i-5*j)]
;                oplot,alt_good[where_src],totaloff,color=colornum,psym=1
;                oplot,alt_good[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=1
                if n_e(where_src) gt 1 then rms_totoff[i] = stddev(totaloff) else rms_totoff[i] = 999
                xyouts,.87,(i-5*j)/float(5)+.14,source_name_good[uniq_srcs[i]],/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.11,strc(rms_altoff[i]),/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.08,strc(rms_azoff[i]),/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.05,strc(rms_totoff[i]),/normal,color=colornum
                xyouts,.87,(i-5*j)/float(5)+.02,strc(n_e(where_src)),/normal,color=colornum
            endfor

            plot,[20],[0],xrange=[25,75],yrange=[0,50],xtitle="Alt",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
;                oplot,alt_good[where_src],totaloff_resid,color=colornum,psym=1
                oplot,alt_good[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=1
            endfor

            plot,[20],[0],xrange=[min(mjd),max(mjd)],yrange=[0,50],xtitle="MJD-54000",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
;                oplot,mjd[where_src],totaloff_resid,color=colornum,psym=1
                oplot,mjd[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=1
            endfor

            
            ; X AXIS AZIMUTH
            plot,[20],[0],xrange=[0,360],yrange=[falt_min,falt_max],xtitle="Az",ytitle="Altoff (arseconds)",/xs
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
;                oplot,az_good[where_src],altoff_good[where_src],color=ctable[(i-5*j)],psym=1
                oplot,az_good[where_src],fpmsub_altoff_good[where_src],color=ctable[(i-5*j)],psym=1
            endfor
            plot,[20],[0],xrange=[0,360],yrange=[faz_min,faz_max],xtitle="Ax",ytitle="Azoff (arcseconds distance)",/xs
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
;                oplot,az_good[where_src],azoff_dist_good[where_src],color=ctable[(i-5*j)],psym=1
                oplot,az_good[where_src],fpmsub_azoff_good[where_src],color=ctable[(i-5*j)],psym=1
            endfor
;            plot,[20],[0],xrange=[0,360],yrange=[ftot_min,ftot_max],xtitle="Az",ytitle="Total offset",/xs,/ys
;            for i=5*j,max_i do begin
;                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
;                totaloff = sqrt(azoff_dist_good[where_src]^2 + altoff_good[where_src]^2)
;                colornum = ctable[(i-5*j)]
;                oplot,az_good[where_src],totaloff,color=colornum,psym=1
;            endfor
            plot,[20],[0],xrange=[0,360],yrange=[0,50],xtitle="Az",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
;                oplot,az_good[where_src],totaloff_resid,color=colornum,psym=1
                oplot,az_good[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=1
            endfor
            plot,[20],[0],xrange=[min(lst),max(lst)],yrange=[0,50],xtitle="LST",ytitle="Total offset residual",/xs,/ys
            for i=5*j,max_i do begin
                where_src = where(source_name_good eq source_name_good[uniq_srcs[i]])
                totaloff_resid = sqrt(pmsub_azoff[where_src]^2 + pmsub_altoff[where_src]^2)
                colornum = ctable[(i-5*j)]
;                oplot,lst[where_src],totaloff_resid,color=colornum,psym=1
                oplot,lst[where_src],fpmsub_totoff_good[where_src],color=colornum,psym=1
            endfor
        endfor



        device,/close_file
;        set_plot,'x'
        !X.OMARGIN=[0,0]
        !Y.OMARGIN=[0,0]


    endelse
    
    !P.MULTI=0
     
    if stregex(homedir,'scratch') eq 1 then $
        save,filename=homedir+'pointing/'+date+"_"+nametype+".sav" $
        else save,filename=homedir+date+"_"+nametype+".sav" 

end
