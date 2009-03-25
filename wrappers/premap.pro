; premap does a lot of things necessary to start the pipeline process....
; first off, it checks whether you're operting from a save file or from raw data
; it then does the initial processing, the most important of which is exponent subtraction
; which deals with the exponential increase of noise at the edge of scans
;
; INPUTS:
;   REQUIRED:
;   filelist - a list of filenames or a single .sav filename
;   outmap - the output prefix for the maps to be generated
;
;   OPTIONS (defaults):
;   pointing_model (true) - picks whether to use the pointing model.  
;   minbaseline - obsolete attempt to use a different sky estimation package
;   deconvolve (false) - use deconvolver?
;   fromsave (false) - is the input file a save file?
;   iter0savename (outmap+"_preiter.sav")
;   pixsize (7.2) - pixel size in arcseconds
;   mvperjy (specified in header) - calibration coefficients (e.g. [1,0,0])
pro premap,filelist,outmap,workingdir=workingdir,niter=niter,$
        pointing_model=pointing_model,$
        minbaseline=minbaseline,$
        deconvolve=deconvolve, $
        fromsave=fromsave,$
        iter0savename=iter0savename,$
        pixsize=pixsize,$
        mvperjy=mvperjy,$
        dosave=dosave,$
        smoothmap=smoothmap,$
        fits_smooth=fits_smooth,$
        mapstr=mapstr,$
        bgps=bgps,$
        noflat=noflat,$
        _extra=_extra
    
    ; set defaults
    if n_e(pointing_model) eq 0 then pointing_model=1
    if n_e(dosave) eq 0 then dosave = 0 
    if n_e(iter0savename) eq 0 then iter0savename=outmap+"_preiter.sav" 
    if ~keyword_set(pixsize) then pixsize=7.2 ;arcseconds


    if keyword_set(workingdir) then cd,workingdir else begin
        spawn,'pwd',workingdir
        print,"WARNING: you have not specified a working directory.  Using current directory "+workingdir+"by default."
;        print,"WARNING: you have not specified a working directory.  Use .con to continue using the current directory",workingdir
;        stop
    endelse
    time_s,"ALL PREPROC ... output is "+outmap+"  ",t1
    if keyword_set(fromsave) then begin
        restore,filelist
        mapstr.outmap = outmap
    endif else begin
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
        readall_pc,thefiles,bgps_struct=bgps,pointing_model=pointing_model,$
            bolo_indices=bolo_indices,_extra=_extra
        time_e,t0,prtmsg="Read files in "

        ; FLAGGING and PSD CALCULATION
        ; all flagged points in the timestream are NANs after the wrapper
        bgps.ac_bolos = deline(bgps.ac_bolos,bgps.sample_interval,scans_info=bgps.scans_info)   ;deline... does stuff, but not all stuff
        bgps.ac_bolos = exponent_sub(bgps.ac_bolos,scans_info=bgps.scans_info, flags=bgps.flags, bolo_params=bgps.bolo_params,sample_interval=bgps.sample_interval)
;        flagging_wrapper,ac_bolos=ac_bolos,scans_info=scans_info,flags=flags,bolo_params=bolo_params,$
;            sample_interval=sample_interval,psd_avescan=psd_avescan,psd_avebolo=psd_avebolo,         $
;            bad_scans=bad_scans,bad_bolos=bad_bolos,raw=raw,dc_bolos=dc_bolos,ra_map=ra_map,         $
;            dec_map=dec_map,psd_psd=psd_psd,bolo_indices=bolo_indices,logfile=logfile,_extra=_extra
        
        ; debug statement: what fraction of ac_bolos is NANed out?
        print,"bgps.ac_bolos has "+strc(total(finite(bgps.ac_bolos,/nan)))+" NAN points, which is "+strc(total(finite(bgps.ac_bolos,/nan))/n_e(bgps.ac_bolos))+" of total"

        ;  polynomial subtract and "flatten" the individual bolometer timestreams
        ;  bolo_flat corrects bolometers to match the median response of the bolometers
        if ~keyword_set(noflat) then begin
            time_s,"POLYSUB and BOLOFLAT ",t0
            bgps.ac_bolos = poly_sub_by_scans(bgps.ac_bolos,bgps.scans_info,flags=bgps.flags,_extra=_extra)
; removed 3/24/09            bgps.ac_bolos = bolo_flat(bgps.ac_bolos)
; removed 3/24/09 - this is done entirely in map_iter            bgps.scale_coeffs = relsens_cal(bgps.ac_bolos,bgps.ac_bolos)
            time_e,t0
        endif

        ; REFLAG?  RESKY? 
        ; reflag, at least, is necessary in order to remove more bad / unaccounted for bolometers
        ; however, since this process is ONLY used for flagging, we don't have to worry about the actual state of the data
;        flagging_wrapper,ac_bolos=ac_bolos,scans_info=scans_info,flags=flags,bolo_params=bolo_params,$
;            sample_interval=sample_interval,psd_avescan=psd_avescan,psd_avebolo=psd_avebolo,         $
;            bad_scans=bad_scans,bad_bolos=bad_bolos,raw=raw,dc_bolos=dc_bolos,ra_map=ra_map,         $
;            dec_map=dec_map,psd_psd=psd_psd,/reflag,bolo_indices=bolo_indices,logfile=logfile,       $
;            _extra=_extra

        flag_fraction = total(finite(bgps.ac_bolos,/nan))/n_e(bgps.ac_bolos)
        print,"AC_BOLOS has "+strc(total(finite(bgps.ac_bolos,/nan)))+" NAN points, which is "+strc(flag_fraction)+" of total"
        if flag_fraction gt .5 then return

; removed 3/24/09        if ~keyword_set(noflag) then begin
; removed 3/24/09            time_s,"DELINE and EXPONENT_SUB ",t0
; removed 3/24/09            bgps.ac_bolos = deline(bgps.raw,bgps.sample_interval,scans_info=bgps.scans_info)
; removed 3/24/09            bgps.ac_bolos = exponent_sub(bgps.ac_bolos,scans_info=bgps.scans_info, flags=bgps.flags, bolo_params=bgps.bolo_params,sample_interval=bgps.sample_interval)
; removed 3/24/09            time_e,t0
; removed 3/24/09        endif 

        time_s,"CHECK SCANS: ",t0 ; checking to make sure scans are not just single points that weren't flagged out
        bgps.flags=check_scans(bgps.flags,scans_info=bgps.scans_info,bolo_params=bgps.bolo_params,nbadscan=nbadscan)
        time_e,t0,prtmsg=strc(nbadscan)+" BAD SCANS in  "
        
;        commented out because scaling shouldn't be set this way and I don't want to 'flat' the raw timestreams
;        if keyword_set(boloflat) then bgps.ac_bolos = bolo_flat(bgps.ac_bolos,scale_ts=scale_ts) $
        scale_ts =  replicate(1,n_e(bgps.ac_bolos))

        ; MAPPING PREP
        time_s,"MAPPING PREPARATION: ",t0
        bgps.weight = fltarr(n_e(bgps.ac_bolos)) + 1. / scale_ts[*]
        if total(bgps.flags) gt 0 then begin
            bgps.weight[where(bgps.flags)] = 0
        endif

        ;dsts = prepare_map(bgps.ra_map,bgps.dec_map,pixsize=pixsize*4,blank_map=blank_map,phi0=0,theta0=0,hdr=hdr,smoothmap=smoothmap,_extra=_extra)
        ts = prepare_map(bgps.ra_map,bgps.dec_map,pixsize=pixsize,blank_map=blank_map,phi0=0,theta0=0,hdr=hdr,$
            smoothmap=smoothmap,lst=bgps.lst,jd=bgps.jd,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)
        add_to_header,hdr,bgps.lst,bgps.fazo,bgps.fzao,bgps.jd,bgps.mvperjy,thefiles[0],pixsize,bgps.radec_offsets,$
            pointing_model=pointing_model,singlefile=singlefile,meandc=mean(bgps.dc_bolos),stddc=stddev(bgps.dc_bolos)
        blank_map_size = size(blank_map,/dim)
        wt_map   = blank_map
        wt_map[min(ts):max(ts)] = wt_map[min(ts):max(ts)] + histogram(ts)  ; this is a clever trick that adds 
                                                ; the histogram of the timestream to the weight map: this means that
                                                ; each pixel in the weight map is equal to the number of pixels that
                                                ; will be mapped to that pixel from the data

        rawmap = ts_to_map(blank_map_size,ts,bgps.ac_bolos,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=wt_map,_extra=_extra)
        writefits,outmap+"_rawmap.fits",rawmap,hdr
        writefits,outmap+"_nhitsmap.fits",wt_map,hdr
;        if keyword_set(fits_timestream) then writefits,outmap+"_flags.fits",reshape_timestream(flags,scans_info),hdr

        if n_e(bgps.ac_bolos) ne n_e(ts) then stop ; DEBUG 10/30/08
        if keyword_set(ts_map) or (n_e(ts_map) eq 0 and bgps.n_obs eq 1) then $
            write_ts,ts,hdr,outmap,bgps.scans_info,nbolos=n_e(bgps.ac_bolos[*,0]),ntime=n_e(bgps.ac_bolos[0,*])

        mapstr = {$
            outmap: outmap,$
            astromap: blank_map,$
            noisemap: blank_map,$
            wt_map: wt_map,$
            blank_map: blank_map,$
            blank_map_size: blank_map_size,$
            ts: ts,$
            hdr: hdr,$
            model: blank_map,$
            rawmap: rawmap, $
            pixsize: pixsize $
            }
        time_e,t0,prtmsg="MAP PREP COMPLETED IN "

        if keyword_set(dosave) then save,bgps,mapstr,filename=iter0savename
    endelse

    time_e,t1,prtmsg="Done preproc ... "
    return
end
