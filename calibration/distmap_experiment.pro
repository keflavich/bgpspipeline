
; experiment.... try to figure out wtf's goin on
pro distmap_experiment,filename,outfile,doplot=doplot,doatv=doatv,fitmap=fitmap,allmap=allmap,$
    pixsize=pixsize,meas=meas,nominal=nominal,interactive=interactive,coordsys=coordsys,$
    projection=projection,distcor=distcor,_extra=_extra

    if ~keyword_set(doplot) then doplot=0
    if n_e(coordsys) eq 0 then coordsys='radec'
    if n_e(projection) eq 0 then projection='TAN'


    ; larger pixel size selected for mapping to reduce blank pixels
    ; should be 11 pixels because that's how much the array was moved
    if ~keyword_set(pixsize) then pixsize=11.0

    if size(filename,/type) eq 7 then thefiles = [filename] else thefiles=filename
    premap,thefiles,outfile,bgps=bgps,mapstr=mapstr,/noflat,pointing_model=0,distcor=distcor,$
        mvperjy=[1,0,0],fits_out=[5],projection=projection,coordsys=coordsys,pixsize=11,_extra=_extra
    ; removed nobeamloc 4/10/09 - necessary in order to co-add images
    ; also, should automatically account for rotation

    for i=0,2 do begin
        clean_iter_struct,bgps,mapstr,new_astro=new_astro,niter=intarr(10)+13,i=i,deconvolve=0,_extra=_extra
    endfor

    bolo_indices = bgps.bolo_indices
    nbolos = n_e(bolo_indices)

    angle = (-median([bgps.rotang]) + median([bgps.posang]) + median([bgps.arrang])) * !dtor
    dec_conversion =  cos(bgps.source_dec*!dtor)

    ncdf_varget_scale,thefiles[0],'bolo_params',bolo_params
    rtf = [[reform([bolo_params[2,bolo_indices]])],[reform(bolo_params[1,bolo_indices]*!dtor)]]
    xy_boloframe = [[rtf[*,0]*cos(rtf[*,1])],$
                    [rtf[*,0]*sin(rtf[*,1])]]
    rot_mat = [[cos(angle),-sin(angle)],$
               [sin(angle),cos(angle)]]
    xysky = (xy_boloframe # rot_mat) * ([1/dec_conversion,-1] ## (fltarr(nbolos)+1))
    nominal = { $
        radius : reform(bolo_params[2,*]) ,$
        theta :  reform(bolo_params[1,*])*!dtor ,$
        angle:angle,$
        dec_conversion:dec_conversion,$
        rth : rtf ,$
        xyrot : xy_boloframe # $
                 rot_mat, $
        xy : [[rtf[*,0]*cos(rtf[*,1]+angle)/dec_conversion],$
              [-1.0 * rtf[*,0]*sin(rtf[*,1]+angle)]],$
        xynom : xy_boloframe $
    } ; to match ra/dec, ra increases to left... signs all flipped (See apply_distortion_map_radec)

    meas = { $
        rth : fltarr(nbolos,2)    ,$
        xy  : fltarr(nbolos,2)    ,$
        xyoffs  : fltarr(nbolos,2),$
        xysize: fltarr(nbolos,2)  ,$
        chi2: fltarr(nbolos)      ,$
        err: fltarr(nbolos)       ,$
        angle: fltarr(nbolos)     ,$
        ampl: fltarr(nbolos)      ,$
        backgr: fltarr(nbolos)    ,$
        xcen: 0.0 ,$
        ycen: 0.0 ,$
        bolo_indices: bolo_indices $
    }

    ; some pca subtraction is necessary to clean up the image for fitting
;    pca_subtract,bgps.ac_bolos,21,uncorr_part=new_astro
;    if total(bgps.flags) gt 0 then new_astro[where(bgps.flags)] = 0

    ; makes a data cube with one map for each bolometer
    allmap = map_eachbolo(bgps.ra_map,bgps.dec_map,bgps.astrosignal+new_astro,bgps.scans_info,pixsize=pixsize,$
        blank_map=blank_map,hdr=hdr,coordsys=coordsys,projection=projection,$
        jd=bgps.jd,lst=bgps.lst,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)
    
    pipemap = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.astrosignal+new_astro,wtmap=1,weight=1)

    boremap = map_eachbolo(bgps.ra_bore ## (fltarr(nbolos)+1),bgps.dec_bore ## (fltarr(nbolos)+1),$
        bgps.astrosignal+new_astro,bgps.scans_info,pixsize=pixsize,$
        blank_map=blank_map,hdr=hdrbore,coordsys=coordsys,projection=projection,$
        jd=bgps.jd,lst=bgps.lst,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)

    bolospacing = pixsize/38.5  ; arcseconds per pixel / arcseconds per bolospacing
    extast,hdr[*,0,0],astr
    ra_cen = median(bgps.ra_bore)
    dec_cen = median(bgps.dec_bore)
    ad2xy,ra_cen,dec_cen,astr,xcen,ycen
    meas.xcen=xcen
    meas.ycen=ycen

    ; HACK
    if xcen gt n_e(allmap[*,0,0]) or ycen gt n_e(allmap[0,*,0]) then begin
        xcen = n_e(allmap[*,0,0])/2. ; assumes the center of the map is the pointing center.  This may be off by +/- .5 pixels
        ycen = n_e(allmap[0,*,0])/2. ; because of the frustrating error where not all bolometers have the same map size
                                ; 3/20/09 - I'm pretty sure there's no such error
    endif

    fitmapcube = allmap*0

    if doplot gt 1 then begin
        !p.multi=[0,3,3]
        set_plot,'ps'
        device,filename=outfile+"_boloplots.ps",/color,bits_per_pixel=16,xsize=16,ysize=16,/inches
        loadct,0
    endif

    refmap = total(allmap,3)
    fpref = centroid_map(convolve(refmap,refmap,/correl))
    xcen = fpref[4]
    ycen = fpref[5]

    xmin = 0                  ;floor(xcen-10)
    xmax = n_e(allmap[*,0,0])-1 ;ceil(xcen+10)
    ymin = 0                  ;floor(ycen-10)
    ymax = n_e(allmap[0,*,0])-1 ;ceil(ycen+10)

    xdiff = fltarr(nbolos)
    ydiff = fltarr(nbolos)
    for i=0,n_e(allmap[0,0,*])-1 do begin

        ; centroid: background, amplitude, xwidth, ywidth, xcenter, ycenter, angle
;        fitpars = centroid_map(allmap[xmin:xmax,ymin:ymax,i],perror=perror,fitmap=fitmap,pixsize=pixsize)
;        fitmapcube[xmin:xmax,ymin:ymax,i] = fitmap
        corr = convolve(allmap[*,*,i],refmap,/correl) 
        fitpars = centroid_map(corr,perror=perror,fitmap=fitmap,pixsize=pixsize)

        meas.chi2[i] = total((allmap[*,*,i]-fitmap)^2)/n_e(fitmap)
        meas.err[i] = sqrt(perror[4]^2+perror[5]^2)*bolospacing
        xdiff[i] = fitpars[4]-(xcen-xmin)
        ydiff[i] = fitpars[5]-(ycen-ymin)
        meas.xyoffs[i,0] =  xdiff*bolospacing  ; XYOFFS ARE IN ROTATED PLANE
        meas.xyoffs[i,1] =  ydiff*bolospacing 
        meas.xy[i,0] = nominal.xy[i,0] - meas.xyoffs[i,0]  ; something is twisted
        meas.xy[i,1] = nominal.xy[i,1] - meas.xyoffs[i,1]  
;        meas.xyoffs[*,0] -= (meas.xyoffs[0,0]) ; assume bolometer 0 is correct - it is our reference
;        meas.xyoffs[*,1] -= (meas.xyoffs[0,1])
        meas.angle[i] = fitpars[6]
        meas.xysize[i,*] = fitpars[2:3]*bolospacing
        meas.ampl[i] = fitpars[1]
        meas.backgr[i] = fitpars[0]


        if keyword_set(doatv) and doplot lt 2 then begin ; plotting
            atv,allmap[*,*,i]
            atvxyouts,[fitpars[4]],[fitpars[5]],strc(bolo_indices[i]),charsize=4,color='red'
            atv_plot1ellipse,fitpars[2],fitpars[3],fitpars[4],fitpars[5],fitpars[6],color=250
        endif

        if doplot gt 1 then begin
            loadct,0,/silent
            imdisp,asinh(reform(allmap[*,*,i])),erase=0,title=strc(bolo_indices[i]),/axis
            loadct,39,/silent
            tvellipse,fitpars[2],fitpars[3],fitpars[4]+xmin,fitpars[5]+ymin,fitpars[6],color=250,/data,thick=1
            tvellipse,fitpars[2]*2.35,fitpars[3]*2.35,fitpars[4]+xmin,fitpars[5]+ymin,fitpars[6],color=250,/data,thick=1
            oplot,[xcen],[ycen],psym=7,color=225,symsize=1
;            oplot,[nominal.xy[i,0]/bolospacing+xcen],[nominal.xy[i,1]/bolospacing+ycen],psym=1,symsize=1,color=60
;            oplot,[meas.xy[i,0]/bolospacing+xcen],[meas.xy[i,1]/bolospacing+ycen],psym=1,symsize=1,color=240
;            arrow,[nominal.xy[i,0]/bolospacing+xcen],[nominal.xy[i,1]/bolospacing+ycen],[meas.xy[i,0]/bolospacing+xcen],[meas.xy[i,1]/bolospacing+ycen],/data,color=80,hsize=1
            oplot,[nominal.xy[i,0]/bolospacing+xcen,meas.xy[i,0]/bolospacing+xcen],[nominal.xy[i,1]/bolospacing+ycen,meas.xy[i,1]/bolospacing+ycen],color=150
            oplot,[fitpars[4]+xmin,xcen],[fitpars[5]+ymin,ycen],color=150

            ad2xy,median(bgps.ra_map[i,*]),median(bgps.dec_map[i,*]),astr,pointx,pointy
            oplot,[pointx],[pointy],psym=1,color=60,symsize=1,thick=.5

; pretty sure this is wrong            oplot,[-nominal.xy[i,0]/bolospacing+xcen],[-nominal.xy[i,1]/bolospacing+ycen],psym=7,color=225,symsize=.25
        endif

    endfor
    
    ; convert back to the format used in the beam locations files (assumes no
    ; projection and no rotation)
    meas.rth[*,0] = sqrt((meas.xy[*,0]*dec_conversion)^2+meas.xy[*,1]^2)
    meas.rth[*,1] = atan(-meas.xy[*,1],meas.xy[*,0]*dec_conversion)-angle

    if doplot gt 1 then begin
        plot,meas.xyoffs[*,0],meas.xyoffs[*,1],psym=3,title='offsets - bolodist'
        xyouts,meas.xyoffs[*,0],meas.xyoffs[*,1],strc(bolo_indices)
        plot,meas.xyoffs[*,0]/bolospacing,meas.xyoffs[*,1]/bolospacing,psym=1,title='offsets - pixels'
        plot,meas.xyoffs[*,0]/bolospacing*pixsize,meas.xyoffs[*,1]/bolospacing*pixsize,psym=1,title='offsets - arcseconds'
        plot,meas.xy[*,0],meas.xy[*,1],psym=1,title='beam locations'
        oplot,nominal.xy[*,0],nominal.xy[*,1],psym=7,color=250
        if keyword_set(distcor) then begin
            readcol,distcor,corr_bolonum,corr_dist,corr_angle,corr_rms,/silent
            plot,meas.rth[*,0]*cos(meas.rth[*,1])-(corr_dist*cos(corr_angle*!dtor))[bolo_indices],$
                 meas.rth[*,0]*sin(meas.rth[*,1])-(corr_dist*sin(corr_angle*!dtor))[bolo_indices],psym=1,title='offset from corrected'
        endif
        device,/close_file
        set_plot,'x'
    endif
    !p.multi=0

    shiftmap = allmap
    for i=0,nbolos-1 do begin
        shiftmap[*,*,i] = fshift(allmap[*,*,i],-xdiff[i],-ydiff[i])
    endfor


;    atv,allmap[*,*,0]-shift(boremap,[nominal.xy[0,1],nominal.xy[1,1]])
    array_params = [7.7,31.2,bgps.arrang[0]]
    bolo_params2 = bolo_params
    bolo_params2[1,bolo_indices] = meas.rth[*,1]/!dtor
    bolo_params2[2,bolo_indices] = meas.rth[*,0]
    
    xy2 = nominal.xy 
    xy2[*,0] += (meas.xyoffs[*,0])
    xy2[*,1] -= (meas.xyoffs[*,1])
    bolo_params2[2,bolo_indices] = sqrt((xy2[*,0]*nominal.dec_conversion)^2+xy2[*,1]^2)
    bolo_params2[1,bolo_indices] = (atan(-xy2[*,1],xy2[*,0]*nominal.dec_conversion)-nominal.angle)/!dtor
    ra_new = bgps.ra_bore
    dec_new = bgps.dec_bore
    apply_distortion_map_radec,ra_new,dec_new,bgps.rotang,array_params,bgps.posang,bolo_params=bolo_params2[*,bolo_indices]
    newmap = map_eachbolo(ra_new,dec_new,bgps.astrosignal+new_astro,bgps.scans_info,pixsize=pixsize,$
        blank_map=blank_map,hdr=hdr,coordsys=coordsys,projection=projection,$
        jd=bgps.jd,lst=bgps.lst,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)
    atv,total(newmap,3)



    if keyword_set(interactive) then stop
    stop
    plot,bolo_params[2,*]*cos(bolo_params[1,*]*!dtor),bolo_params[2,*]*sin(bolo_params[1,*]*!dtor),psym=1
    oplot,bolo_params2[2,*]*cos(bolo_params2[1,*]*!dtor),bolo_params2[2,*]*sin(bolo_params2[1,*]*!dtor),psym=1,color=250
        plot,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
        plot,meas.rth[*,0]*cos(meas.rth[*,1]),meas.rth[*,0]*sin(meas.rth[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
        xyouts,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),strc(meas.bolo_indices)
        xyouts,nominal.xy[*,0],nominal.xy[*,1],strc(meas.bolo_indices)
; ...        xyouts,-3600/38.5*(bgps.ra_map[*,0]-median(bgps.ra_map[*,0])),(bgps.dec_map[*,0]-median(bgps.dec_map[*,0]))*3600/38.5,strc(meas.bolo_indices)
        xyouts,meas.rth[*,0]*cos(meas.rth[*,1]),meas.rth[*,0]*sin(meas.rth[*,1]),strc(meas.bolo_indices),color=250
        oplot,[0,nominal.rth[0,0]*cos(nominal.rth[0,1])],[0,nominal.rth[0,0]*sin(nominal.rth[0,1])]
        oplot,[0,meas.rth[0,0]*cos(meas.rth[0,1])],[0,meas.rth[0,0]*sin(meas.rth[0,1])],color=250

end
