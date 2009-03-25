; mem_iter
; PURPOSE:
;    iterative cleaning of BGPS data entirely in memory (i.e. no NCDF file read/writes
;    after the initial setup)
; INPUTS:
;    filelist    - the name of a text file containing the list of ncdf files to read line-by-line
;                these files MUST be pre-processed, downsampled files
;    outmap      - a prefix to prepend to the output map file names and save file names
;    workingdir  - where the .sav and .fits files will be saved
;    niter       - a list of # of pca components to subtract at each iteration
;    minbaseline - the minimum baseline length to use when baseline subtracting
;    median_sky  - a flag to force median rather than baseline sky subtraction
;    deconvolve  - a flag to use maxent deconvolution instead of force-positive map2ts
;    noisecontrol- dead flag
;    fromsave    - a flag to use a previous saved iteration instead of reading the NCDF files from scratch
;    boloflat    - a flag to "flatfield" across bolometers (force them to some average value)
;
;    I've added a lot more input parameters since then and I think the code has become cluttered; I'll try to clean it out
;    but it may be difficult because part of what I did was add additional FITS output options at each stage of the processing

pro mem_iter_pc,filelist,outmap,workingdir=workingdir,niter=niter,$
        startiter=startiter,$           
        pointing_model=pointing_model,$
        minbaseline=minbaseline,$
        median_sky=median_sky, $
        deconvolve=deconvolve, $
        noisecontrol=noisecontrol,$
        fromsave=fromsave,$
        iter0savename=iter0savename,$
        boloflat=boloflat,$
        pixsize=pixsize,$
        mvperjy=mvperjy,$
        noflag=noflag,$
        dosave=dosave,$
        smoothmap=smoothmap,$
        fits_smooth=fits_smooth,$
        save_mapcube=save_mapcube,$
        flags=flags,ac_bolos=ac_bolos,raw=raw,        $
        ra_map=ra_map,dec_map=dec_map,mapstruct=mapstruct,ts_map=ts_map,      $
        corr_part=corr_part,uncorr_part=uncorr_part,fits_timestream=fits_timestream,$ 
        fits_nopca=fits_nopca,fits_psd=fits_psd,psd_flag=psd_flag,fits_model=fits_model,$
        bolo_params=bolo_params,psd_psd=psd_psd,scans_info=scans_info,_extra=_extra

    if n_e(deconvolve) eq 0 then deconvolve=1
    if n_e(fits_model) eq 0 then fits_model=1
    if n_e(fits_timestream) eq 0 then fits_timestream=1
    if n_e(fits_smooth) eq 0 then fits_smooth=1
    if n_e(pointing_model) eq 0 then pointing_model=1
    if keyword_set(workingdir) then cd,workingdir else begin
        spawn,'pwd',workingdir
        print,"WARNING: you have not specified a working directory.  Use .con to continue using the current directory",workingdir
        stop
    endelse
    time_s,"",time_whole
    time_s,"ALL PREPROC ... output is "+outmap+"  ",t1
    if ~keyword_set(pixsize) then pixsize=7.2 ;arcseconds
    openw,logfile,outmap+".log",/get_lun
    if keyword_set(fromsave) then restore,filelist else begin
        if strmid(filelist,strlen(filelist)-2,strlen(filelist)) eq 'nc' $
            or strmatch(filelist,'*.nc_preclean') then begin
                thefiles = [filelist] 
                singlefile = 1
        endif else begin
            readcol, filelist, thefiles, format='A80',comment="#",/silent  ; read in the raw filenames 
            singlefile = 0
        endelse
        time_s,"READING IN "+strc(n_e(thefiles))+ " FILES FROM "+filelist,t0
        print,""
        bolo_indices = indgen(144)                                 ; for flagging purposes, need to backtrack to find out
        readall_pc,thefiles,ac_bolos=ac_bolos,dc_bolos=dc_bolos,flags=flags,bolo_params=bolo_params, $
                raw=raw,sample_interval=sample_interval, scans_info=scans_info,noisefilt_weights=noisefilt_weights,  $
                ra_map=ra_map,dec_map=dec_map,wh_scan=wh_scan,bolo_indices=bolo_indices,lst=lst,fazo=fazo,fzao=fzao, $
                logfile=logfile,goodbolos=goodbolos,mvperjy=mvperjy,jd=jd,radec_offsets=radec_offsets,     $
                pointing_model=pointing_model,$
                _extra=_extra
        time_e,t0
        if n_e(raw) eq 0 or keyword_set(raw) then raw = ac_bolos   ; makes sure that the raw is extracted from the ncdf file

        ; FLAGGING and PSD CALCULATION
        ; all flagged points in the timestream are NANs after the wrapper
        ac_bolos = deline(ac_bolos,sample_interval,scans_info,/flat)   ;deline... does stuff, but not all stuff
        ac_bolos = exponent_sub(ac_bolos,scans_info=scans_info, flags=flags, bolo_params=bolo_params,sample_interval=sample_interval)
        flagging_wrapper,ac_bolos=ac_bolos,scans_info=scans_info,flags=flags,bolo_params=bolo_params,$
            sample_interval=sample_interval,psd_avescan=psd_avescan,psd_avebolo=psd_avebolo,         $
            bad_scans=bad_scans,bad_bolos=bad_bolos,raw=raw,dc_bolos=dc_bolos,ra_map=ra_map,         $
            dec_map=dec_map,psd_psd=psd_psd,bolo_indices=bolo_indices,logfile=logfile,_extra=_extra
        
        ; debug statement: what fraction of ac_bolos is NANed out?
        print,"AC_BOLOS has "+strc(total(finite(ac_bolos,/nan)))+" NAN points, which is "+strc(total(finite(ac_bolos,/nan))/n_e(ac_bolos))+" of total"
        printf,logfile,"AC_BOLOS has "+strc(total(finite(ac_bolos,/nan)))+" NAN points, which is "+strc(total(finite(ac_bolos,/nan))/n_e(ac_bolos))+" of total"

        ;  polynomial subtract and "flatten" the individual bolometer timestreams
        ;  bolo_flat corrects bolometers to match the median response of the bolometers
        if ~keyword_set(noflag) then begin
            ac_bolos = poly_sub_by_scans(ac_bolos,scans_info,flags=flags)
            ac_bolos = bolo_flat(ac_bolos)
        endif

        ; REFLAG?  RESKY? 
        ; reflag, at least, is necessary in order to remove more bad / unaccounted for bolometers
        ; however, since this process is ONLY used for flagging, we don't have to worry about the actual state of the data
        flagging_wrapper,ac_bolos=ac_bolos,scans_info=scans_info,flags=flags,bolo_params=bolo_params,$
            sample_interval=sample_interval,psd_avescan=psd_avescan,psd_avebolo=psd_avebolo,         $
            bad_scans=bad_scans,bad_bolos=bad_bolos,raw=raw,dc_bolos=dc_bolos,ra_map=ra_map,         $
            dec_map=dec_map,psd_psd=psd_psd,/reflag,bolo_indices=bolo_indices,logfile=logfile,       $
            _extra=_extra

        flag_fraction = total(finite(ac_bolos,/nan))/n_e(ac_bolos)
        print,"AC_BOLOS has "+strc(total(finite(ac_bolos,/nan)))+" NAN points, which is "+strc(flag_fraction)+" of total"
        printf,logfile,"AC_BOLOS has "+strc(total(finite(ac_bolos,/nan)))+" NAN points, which is "+strc(flag_fraction)+" of total"
        if flag_fraction gt .5 then return

        if ~keyword_set(noflag) then begin
            raw_delined = deline(raw,sample_interval,scans_info,/flat) ; powerline noise must be taken from AFTER the last flag
            raw_delined = exponent_sub(raw_delined,scans_info=scans_info, flags=flags, bolo_params=bolo_params,sample_interval=sample_interval)
        endif else raw_delined = raw
        
;        if keyword_set(psd_flag) then psd_flag_and_clean,best_astro_model=0,raw_delined=raw_delined,atmos=0,niter=niter,flags=flags,$     
;                                      boloflat=boloflat,fits_timestream=fits_timestream,fits_nopca=fits_nopca,fits_psd=fits_psd,i=0,$               
;                                      minbaseline=minbaseline,median_sky=median_sky,bolo_params=bolo_params,psd_psd=psd_psd,$
;                                      sample_interval=sample_interval,scans_info=scans_info,unflagged=unflagged,weight=weight,wt_map=wt_map,$
;                                      ts=ts,hdr=hdr,blank_map_size=blank_map_size,outmap=outmap,logfile=logfile,_extra=_extra

;        unflagged = where(~flags)
        if keyword_set(boloflat) then raw_delined = bolo_flat(raw_delined,scale_ts=scale_ts) $
            else scale_ts =  replicate(1,n_e(raw_delined))

        ; MAPPING PREP
        weight = fltarr(n_e(raw_delined)) + 1. / scale_ts[*]
        if total(flags) gt 0 then begin
            weight[where(flags)] = 0
        endif
        phi = ra_map ;[unflagged] 
        theta = dec_map ;[unflagged]
        phi0   = 0; median(phi)
        theta0 = 0; median(theta)
        d = raw_delined ;[unflagged]
;removed 10/29/08        weight = psd_weight(raw_delined,scans_info,flags=flags,bolo_params=bolo_params,sample_interval=sample_interval,psd_psd=psd_psd)
        ts_full = prepare_map(phi,theta,pixsize=pixsize,blank_map=blank_map,phi0=phi0,theta0=theta0,hdr=hdr,smoothmap=smoothmap,_extra=_extra)
        ts = ts_full ; [unflagged]
        add_to_header,hdr,lst,fazo,fzao,jd,mvperjy,thefiles[0],pixsize,radec_offsets,pointing_model=pointing_model,singlefile=singlefile
        blank_map_size = size(blank_map,/dim)
        wt_map   = blank_map
        wt_map[min(ts):max(ts)] = wt_map[min(ts):max(ts)] + histogram(ts)  ; this is a clever trick that adds 
                                                ; the histogram of the timestream to the weight map: this means that
                                                ; each pixel in the weight map is equal to the number of pixels that
                                                ; will be mapped to that pixel from the data
;removed 10/29/08        wt_map = ts_to_map(blank_map_size,ts,weight)
        rawmap = ts_to_map(blank_map_size,ts,d*weight) / wt_map
        writefits,outmap+"_rawmap.fits",rawmap,hdr
        writefits,outmap+"_nhitsmap.fits",wt_map,hdr
;        if keyword_set(fits_timestream) then writefits,outmap+"_flags.fits",reshape_timestream(flags,scans_info),hdr

        if ~keyword_set(iter0savename) then iter0savename="save_setup.sav"
        mapcube = blank_map
        ; I think writing to disk was taking up a LOT of processing time.  It was definitely taking up a lot
        ; of HD space (~50GB in a day, no problem... ugh)
        if keyword_set(dosave) then $
        save,mapcube,sample_interval,bolo_params,ac_bolos,scans_info,flags,raw_delined,raw,phi,theta,$
            ra_map,dec_map,weight,d,ts,hdr,blank_map,wt_map,wh_scan,bolo_indices,dc_bolos,goodbolos,blank_map_size,$
            filename=iter0savename
        if n_e(ac_bolos) ne n_e(ts_full) then stop ; DEBUG 10/30/08
        if keyword_set(ts_map) or n_e(ts_map) eq 0 then write_ts,ts_full,hdr,outmap,scans_info,nbolos=n_e(ac_bolos[*,0]),ntime=n_e(ac_bolos[0,*])
    endelse

    if ~(keyword_set(startiter)) then startiter = 0
    if n_e(niter) gt 1 then num_iter = n_e(niter) else num_iter = 1

    dc_bolos = 0         ;CLEANUP MEMORY
    ac_bolos = 0         ;CLEANUP MEMORY
    raw = 0              ;CLEANUP MEMORY
    noise_ts         = 0 ;fltarr(size(ac_bolos,/dim))
    best_astro_model = 0 ; Should be starting basically from scratch with the iterator
    ;    wt_map0 = wt_map

    time_e,t1,prtmsg="Done preproc ... "

    for i=startiter,num_iter-1 do begin    ; BEGIN ITERATING
        time_s,"ITERATION NUMBER "+strc(i)+" ...",t0

        ; passed off each iteration to a cleaning procedure because it was getting filled with 
        ; ugly if statements
        clean_iter,best_astro_model=best_astro_model,raw_delined=raw_delined,atmos=atmos,niter=niter,flags=flags,$     
        boloflat=boloflat,fits_timestream=fits_timestream,fits_nopca=fits_nopca,fits_psd=fits_psd,i=i,$               
        minbaseline=minbaseline,median_sky=median_sky,bolo_params=bolo_params,psd_psd=psd_psd,noise_ts=noise_ts,$
        sample_interval=sample_interval,scans_info=scans_info,unflagged=unflagged,weight=weight,wt_map=wt_map,$
        ts=ts,hdr=hdr,blank_map_size=blank_map_size,outmap=outmap,_extra=_extra

        ; MAPPING
        if keyword_set(smoothmap) then astromap = map_timestream(best_astro_model*weight,blank_map_size,ts,pixsize,smoothmap,weight_map=wt_map) $
        else astromap = ts_to_map(blank_map_size,ts,best_astro_model*weight) / wt_map
        writefits,outmap+'_map'+string(i,format='(I2.2)')+'.fits',astromap,hdr
        if keyword_set(fits_smooth) then begin
            convolved_map = conv_fft(astromap,psf_gaussian(npix=19,ndim=2,fwhm=31.2/pixsize,/norm))
            writefits,outmap+'_smoothmap'+string(i,format='(I2.2)')+'.fits',convolved_map,hdr
        endif
        if keyword_set(deconvolve) then begin
            model = deconv_map(astromap)
            model *=  total( (model-mean(model,/nan)) * (astromap-mean(astromap,/nan)) ,/nan) / total( (model-mean(model,/nan))^2 ,/nan)
            if keyword_set(fits_model) then writefits,outmap+'_model'+string(i,format='(I2.2)')+'.fits',model,hdr
        endif else model = astromap ;*(astromap gt stddev(astromap,/nan))

        ; chi2 calculations - to show convergence (these may be incorrect as of 8/25/08)
        chi2 = total(((best_astro_model-model[ts])*weight)^2,/nan)
        print,"Chi2 for iteration "+strc(i)+" is "+strc(chi2)+" with "+strc(float(n_e(bolo_indices)-(niter[i]+1))*n_e(flags[0,*]))+" degrees of freedom"
        printf,logfile,"Chi2 for iteration "+strc(i)+" is "+strc(chi2)+" with "+strc(float(n_e(bolo_indices)-(niter[i]+1))*n_e(flags[0,*]))+" degrees of freedom"

        ; noisemap = raw - atmosphere - astrophysical
        if keyword_set(smoothmap) then noisemap = map_timestream(noise_ts[ts]*weight,blank_map_size,ts,pixsize,smoothmap,weight_map=wt_map) $
        else noisemap = ts_to_map(blank_map_size,ts,noise_ts[ts]*weight) / wt_map
; model residual        if keyword_set(smoothmap) then noisemap = map_timestream((best_astro_model[unflagged]-model[ts])*weight,blank_map_size,ts,pixsize,smoothmap,weight_map=wt_map) $
;        else noisemap = ts_to_map(blank_map_size,ts,(best_astro_model[unflagged]-model[ts])*weight) / wt_map
        printf,logfile,"Mean noise: ",total(noisemap,/nan)/float(total(finite(noisemap)))," RMS noise: ",stddev(noisemap,/nan)," sum of noisemap^2: ",total(noisemap^2,/nan)
        writefits,outmap+'_noisemap'+string(i,format='(I2.2)')+'.fits',noisemap,hdr

        best_astro_model = model[ts]
        if keyword_set(save_mapcube) then mapcube = [[[mapcube]],[[astromap]]]
        time_e,t0,prtmsg="FINISHED ITERATION "+strc(i)+"   "
    endfor
    if keyword_set(save_mapcube) then save,mapcube,filename=outmap+'_mapcube.sav'
    time_e,time_whole,prtmsg=outmap+" took "
    printf,logfile,"Whole observation took "+strc(time_whole)+" seconds to reduce"
    close,logfile
    free_lun,logfile
    print,"" ;helps space out observations when run in queue mode
end
