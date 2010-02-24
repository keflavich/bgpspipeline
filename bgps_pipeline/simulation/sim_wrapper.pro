function sim_wrapper,bgps,mapstr,nsources,mapcube=mapcube,niter=niter,noiselevel=noiselevel,blanksim=blanksim,_extra=_extra
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
