
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
;
;    dosave now has two options: 
;    dosave = 1 - save preiter
;    dosave = 2 - save preiter and postiter

pro mem_iter,filelist,outmap,workingdir=workingdir,niter=niter,$
        pointing_model=pointing_model,$
        fromsave=fromsave,$
        iter0savename=iter0savename,$
        pixsize=pixsize,$
        dosave=dosave,$
        mapstr=mapstr,$
        bgps=bgps,$
        simulate_only=simulate_only,$
        _extra=_extra

    if n_e(niter) eq 0 then begin
        print,"WARNING: No NITER entered, setting default to [13,13] (two iterations, 13 components)"
        niter=[13,13]
    endif

    time_s,"",time_whole
    premap,filelist,outmap,workingdir=workingdir,niter=niter,$
        pointing_model=pointing_model,$
        fromsave=fromsave,$
        iter0savename=iter0savename,$
        pixsize=pixsize,$
        mvperjy=mvperjy,$
        dosave=dosave,$
        mapstr=mapstr,$
        bgps=bgps,$
        _extra=_extra

    if ~(keyword_set(startiter)) then startiter = 0
    if n_e(niter) gt 1 then num_iter = n_e(niter) else num_iter = 1

    if keyword_set(simulate_only) then bgps.ac_bolos[*]=sim_wrapper(bgps,mapstr,simulate_only,mapcube=mapcube,niter=niter,_extra=_extra)

    for i=startiter,num_iter-1 do begin    ; BEGIN ITERATING
        time_s,"ITERATION NUMBER "+strc(i)+" ...",t0

        ; passed off each iteration to a cleaning procedure because it was getting filled with 
        ; ugly if statements
        clean_iter_struct,bgps,mapstr,niter=niter,i=i,deconvolve=deconvolve,_extra=_extra

        if keyword_set(simulate_only) then mapcube[*,*,i+1] = mapstr.astromap

        time_e,t0,prtmsg="FINISHED ITERATION "+strc(i)+"   "
    endfor
    if keyword_set(dosave) then begin
        iter0savename=outmap+"_postiter.sav" 
        if dosave eq 2 then save,bgps,mapstr,i,filename=iter0savename
    endif
    if keyword_set(simulate_only) then save,mapcube,filename=outmap+"_sim_mapcube.sav"
    time_e,time_whole,prtmsg=outmap+" took "
    print,"" ;helps space out observations when run in queue mode
end
