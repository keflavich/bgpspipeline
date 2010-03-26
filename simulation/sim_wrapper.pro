function sim_wrapper,bgps,mapstr,nsources,mapcube=mapcube,niter=niter,noiselevel=noiselevel,$
    jitter=jitter,blanksim=blanksim,_extra=_extra

    time_s,"",simtime
    mapstr.outmap += "_sim"
    simmap = make_sim(mapstr.blank_map,mapstr.outmap,nsources,pixsize=mapstr.pixsize,_extra=_extra)
    writefits,mapstr.outmap+"_initial.fits",simmap,mapstr.hdr

    if keyword_set(blanksim) then simts = bgps.ac_bolos*0 $
        else simts=bgps.ac_bolos-bgps.astrosignal
        ; if I just use the atmosphere, the resulting noise level is way too low
        ;pca_subtract,bgps.ac_bolos-bgps.astrosignal,niter,corr_part=simts
        ;else if total(bgps.atmosphere,/nan) ne 0 then simts=bgps.atmosphere $
    simts += simmap[mapstr.ts]

    if n_e(noiselevel) eq 0 and keyword_set(blanksim) then noiselevel=.05 else noiselevel=0
    if noiselevel ne 0 then begin
        print,"Beginning noise generation for ",n_e(simts)," points"
        print,""
        noise = randomn(h,n_e(simts),/normal)*noiselevel
        simts += noise
    endif

    if keyword_set(jitter) then begin
        print,"Adding jitter to the timestream"
        nbolos = n_e(bgps.bolo_indices)
        ntime = n_e(bgps.lst)

        if jitter eq 1 then begin
            ; the spread are determined empirically from the Mars 050911_o22-3
            randx = randomn(systime(/sec),nbolos)  *mapstr.pixsize/3600.*0.5
            randy = randomn(systime(/sec)+1,nbolos)*mapstr.pixsize/3600.*0.8
        endif else if jitter eq 2 then begin
            readcol,getenv('PIPELINE_ROOT')+'/bgps_params/beam_locations_jun05.txt',bl_num,bl_dist,bl_ang,bl_rms,/silent
            bolo_params = bgps.bolo_params
            bolo_params[2,*] = bl_dist[bgps.bolo_indices]*5*7.7/3600.
            bolo_params[1,*] = bl_ang[bgps.bolo_indices]
            ; subtract the distortion-correction locations from the "nominal" locations
            ; in order to do the opposite of a distortion correction
            randx = bgps.bolo_params[2,*] * cos(bgps.bolo_params[1,*]*!dtor) - bolo_params[2,*] * cos(bolo_params[1,*]*!dtor)
            randy = bgps.bolo_params[2,*] * sin(bgps.bolo_params[1,*]*!dtor) - bolo_params[2,*] * sin(bolo_params[1,*]*!dtor)
        endif else begin
            randx = randomn(systime(/sec),nbolos)  *mapstr.pixsize/3600.*2.0
            randy = randomn(systime(/sec)+1,nbolos)*mapstr.pixsize/3600.*2.0
        endelse
        print,"Spread of randx,randy:",stddev(randx),stddev(randy)

        print,"Max RA/DEC: ",max(bgps.ra_map),max(bgps.dec_map)
        print,"Min RA/DEC: ",min(bgps.ra_map),min(bgps.dec_map)
        bgps.ra_map  = bgps.ra_map  + (randx # replicate(1.0,ntime))
        bgps.dec_map = bgps.dec_map + (randy # replicate(1.0,ntime))
        print,"Max RA/DEC: ",max(bgps.ra_map),max(bgps.dec_map)
        print,"Min RA/DEC: ",min(bgps.ra_map),min(bgps.dec_map)

        pixsize = mapstr.pixsize
        old_ts = mapstr.ts
        ts = prepare_map(bgps.ra_map,bgps.dec_map,pixsize=pixsize,blank_map=blank_map,phi0=0,theta0=0,hdr=hdr,$
            smoothmap=smoothmap,lst=bgps.lst,jd=bgps.jd,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)
        blank_map_size = size(blank_map,/dim)
        wt_map   = blank_map
        wt_map[min(ts):max(ts)] = wt_map[min(ts):max(ts)] + histogram(ts)
        bgps.weight[*] = 1
        rawmap = ts_to_map(blank_map_size,ts,bgps.ac_bolos,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=wt_map,_extra=_extra)
        outmap = mapstr.outmap

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

        jittermap = ts_to_map(blank_map_size,ts,simmap[old_ts],weight=bgps.weight,scans_info=bgps.scans_info,wtmap=wt_map,_extra=_extra)
        writefits,mapstr.outmap+"_jitter.fits",jittermap,mapstr.hdr
        simmap = jittermap

    endif

    bgps.ac_bolos[*] = simts
    bgps.astrosignal[*] = 0

    fits_timestream=0
    mapcube=fltarr([size(simmap,/dim),n_e(niter)+1])
    mapcube[*,*,0] = simmap
    atmomap = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.atmosphere,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra)
    writefits,mapstr.outmap+"_atmosphere.fits",atmomap,mapstr.hdr
    time_e,simtime,prtmsg="Simulation preparation took "
    return,simts
end
