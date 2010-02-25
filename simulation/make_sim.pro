function make_sim,blank_map,outmap,nsources,meanamp=meanamp,spreadamp=spreadamp,$
    pixsize=pixsize,widthspread=widthspread,simmap=simmap,$
    randomsim=randomsim,uniformsim=uniformsim,maxamp=maxamp,minamp=minamp,$
    linearsim=linearsim,fluxrange=fluxrange,uniformrandom=uniformrandom,$
    minsrc=minsrc,maxsrc=maxsrc,separator=separator,srcsize=srcsize,$
    logspacing=logspacing,edgebuffer=edgebuffer

    if n_e(meanamp) eq 0 then meanamp=1
    if n_e(spreadamp) eq 0 then spreadamp=1
    if n_e(pixsize) eq 0 then pixsize=7.2
    if n_e(edgebuffer) eq 0 then edgebuffer = 30
    xsize = n_e(blank_map[*,0]) - 2*edgebuffer
    ysize = n_e(blank_map[0,*]) - 2*edgebuffer

    if keyword_set(uniformsim) then begin
        if ~keyword_set(srcsize) then srcsize = 33.0/pixsize/sqrt(8*alog(2))
        if ~keyword_set(separator) then separator=10.0
        nx = floor(xsize / (srcsize * separator ))
        ny = floor(ysize / (srcsize * separator ))
        nsources = nx * ny
        xcen = edgebuffer + findgen(nx) # (fltarr(ny)+1) * (srcsize*separator) + findgen(nx)*srcsize # replicate(1.0,ny)
        ycen = edgebuffer + (fltarr(nx)+1) # findgen(ny) * (srcsize*separator)
        xwidth = fltarr(nsources)+srcsize
        ywidth = fltarr(nsources)+srcsize
        if keyword_set(fluxrange) then begin
            amplitudes=((fltarr(nx)+1)) # ((findgen(ny)+1)*(fluxrange[1]-fluxrange[0])/nx) 
        endif else if keyword_set(minamp) and keyword_set(maxamp) then begin
            if keyword_set(logspacing) then begin
                logmax = alog10(maxamp)
                logmin = alog10(minamp)
                amplitudes = 10^(findgen(nsources)*(logmax-logmin)/float(nsources)+logmin)
            endif else begin
                amplitudes = findgen(nsources)*(maxamp-minamp)/float(nsources)+minamp
            endelse
        endif else begin
            amplitudes = fltarr(nsources)+meanamp / !dpi
        endelse
;            amplitudes=((findgen(nx)+1)*(fluxrange[1]-fluxrange[0])/nx) # (fltarr(ny)+1) $
        angles = fltarr(nsources)

        if keyword_set(uniformrandom) then begin
            if n_e(maxamp) eq 0 then maxamp=20
            amplitudes = [reform(amplitudes,n_e(amplitudes)),((meanamp*randomu(a,nsources,/uniform))^(-1.0/1.2)*spreadamp-meanamp) / !dpi]
            if total(amplitudes lt 0) gt 0 then amplitudes[where(amplitudes lt 0)] = 0
            if total(amplitudes gt maxamp) gt 0 then amplitudes[where(amplitudes gt maxamp)] = 0

            xcen = [reform(xcen,n_e(xcen)),randomu(b,nsources,/uniform) * xsize]
            ycen = [reform(ycen,n_e(ycen)),randomu(c,nsources,/uniform) * ysize]

            if n_e(widthspread) eq 0 then widthspread=2.5
            xwidth = [reform(xwidth,n_e(xwidth)),randomn(d,nsources,/uniform)*widthspread + 31.2/pixsize/2.0]
            ywidth = [reform(ywidth,n_e(ywidth)),randomn(e,nsources,/uniform)*widthspread + 31.2/pixsize/2.0]
;            if total(xwidth lt 3) gt 0 then xwidth[where(xwidth lt 3)] = 3
;            if total(ywidth lt 3) gt 0 then ywidth[where(ywidth lt 3)] = 3
            ; sets a maximum aspect ratio of 5
            if total(xwidth/ywidth gt 5) gt 0 then xwidth[where(xwidth gt 5*ywidth)] = 5*ywidth[where(xwidth gt 5*ywidth)] 
            if total(ywidth/xwidth gt 5) gt 0 then ywidth[where(ywidth gt 5*xwidth)] = 5*xwidth[where(ywidth gt 5*xwidth)]

            angles = [reform(angles,n_e(angles)), randomu(f,nsources,/uniform)*2*!pi]
            nsources = n_e(xcen)
        endif

        print,"Filling map with a uniform set of ",nsources," sources"
    endif else if keyword_set(linearsim) then begin
        if ~keyword_set(maxsrc) then maxsrc = 150/pixsize
        if ~keyword_set(minsrc) then minsrc = 31.2/pixsize/2.35 
        if ~keyword_set(separator) then separator = 5
        nx = floor(xsize / ((maxsrc+minsrc)/2 * separator ))
        xsrcsize = (findgen(nx))/nx*maxsrc+minsrc
        maxsrc = max(xsrcsize)
        ny = floor(ysize / ((maxsrc) * separator ))
        nsources = nx * ny
        xcen = edgebuffer + (total(xsrcsize*separator,/cumulative)+minsrc) # (fltarr(ny)+1)  + (fltarr(nx)+1) # (findgen(ny)*maxsrc/3)
        ycen = edgebuffer + (fltarr(nx)+1) # (findgen(ny)+1) * maxsrc*separator  
        xwidth = xsrcsize # (fltarr(ny)+1)
        ywidth = xsrcsize # (fltarr(ny)+1)
        amplitudes = (fltarr(nx)+1) # (1+findgen(ny)) * .2   ; 200 millijansky steps
        if keyword_set(maxamp) and keyword_set(minamp) then amplitudes = (replicate(1.0,nx)) # (findgen(ny)/(ny-1)*(maxamp-minamp)+minamp)
        angles = fltarr(nsources)
        if (max(xcen) ge xsize) or (max(ycen) ge ysize) then begin
            print,"Some sources were unacceptable."
            good = where((xcen lt xsize) and (ycen lt ysize) and (xwidth ge 1) and (ywidth ge 1))
            ngood = n_e(good)
            xcen = xcen[good]
            ycen = ycen[good]
            xwidth = xwidth[good]
            ywidth = ywidth[good]
            amplitudes = amplitudes[good]
            angles = angles[good]
        endif else ngood = nsources
        print,"Filling map with a linear set of ",nsources," sources (",ngood," were kept)"
        nsources = ngood
    endif else if keyword_set(randomsim) then begin

        if n_e(maxamp) eq 0 then maxamp=50
;        amplitudes = (meanamp*2*randomu(a,nsources,/uniform))^(-1.2)*spreadamp
        amplitudes = ((meanamp*randomu(a,nsources,/uniform))^(-1.0/1.2)*spreadamp-meanamp) / !dpi
        if total(amplitudes lt 0) gt 0 then amplitudes[where(amplitudes lt 0)] = 0
        if total(amplitudes gt maxamp) gt 0 then amplitudes[where(amplitudes gt maxamp)] = 0

        xcen = randomu(b,nsources,/uniform) * xsize
        ycen = randomu(c,nsources,/uniform) * ysize

        if n_e(widthspread) eq 0 then widthspread=2.5
        xwidth = randomn(d,nsources,/normal)*widthspread + 31.2/pixsize/2.0
        ywidth = randomn(e,nsources,/normal)*widthspread + 31.2/pixsize/2.0
        if total(xwidth lt 3) gt 0 then xwidth[where(xwidth lt 3)] = 3
        if total(ywidth lt 3) gt 0 then ywidth[where(ywidth lt 3)] = 3
        if total(xwidth/ywidth gt 5) gt 0 then xwidth[where(xwidth gt 5*ywidth)] = 5*ywidth[where(xwidth gt 5*ywidth)] 
        if total(ywidth/xwidth gt 5) gt 0 then ywidth[where(ywidth gt 5*xwidth)] = 5*xwidth[where(ywidth gt 5*xwidth)]

        angles = randomu(f,nsources,/uniform)*2*!pi
        print,"Filling map with a random set of ",nsources," sources"
    endif

    simmap = blank_map
    for i=0,nsources-1 do begin
        if i mod 100 eq 0 then print,"Adding source ",strc(i)," with ",xcen[i],ycen[i],xwidth[i],ywidth[i],amplitudes[i],angles[i]
        simmap+=add_source(blank_map,xcen[i],ycen[i],xwidth[i],ywidth[i],amplitudes[i],angles[i])
    endfor

    save,xcen,ycen,xwidth,ywidth,amplitudes,angles,file=outmap+"_sim_sources.sav"

    return,simmap

end

    
; mem_iter,'/scratch/adam_work/l065/l065.sav','/scratch/adam_work/l065/v0.7_l065_13pca',workingdir='/scratch/adam_work',deconvolve=0,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,noiselevel=0
; mem_iter,'/scratch/adam_work/l024/l024.sav','/scratch/adam_work/l024/v0.7_l024_13pca',workingdir='/scratch/adam_work',deconvolve=0,/pointing_model,/fromsave,smoothmap=0,fits_timestream=0,ts_map=0,niter=intarr(31)+13,simulate_only=1000,/randomsim





