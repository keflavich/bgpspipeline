; centroiding portion of distmap
pro distmap_centroids,filename,outfile,doplot=doplot,doatv=doatv,fitmap=fitmap,allmap=allmap,$
    pixsize=pixsize,meas=meas,nominal=nominal,interactive=interactive,coordsys=coordsys,$
    projection=projection,_extra=_extra

    if ~keyword_set(doplot) then doplot=0
    if n_e(coordsys) eq 0 then coordsys='radec'
    if n_e(projection) eq 0 then projection='TAN'


    ; larger pixel size selected for mapping to reduce blank pixels
    ; should be 11 pixels because that's how much the array was moved
    if ~keyword_set(pixsize) then pixsize=11.0

    if size(filename,/type) eq 7 then thefiles = [filename] else thefiles=filename
    premap,thefiles,outfile,bgps=bgps,mapstr=mapstr,/noflat,pointing_model=0,$
        mvperjy=[1,0,0],fits_out=[5],projection=projection,coordsys=coordsys,_extra=_extra
    ; removed nobeamloc 4/10/09 - necessary in order to co-add images
    ; also, should automatically account for rotation

    for i=0,5 do begin
        clean_iter_struct,bgps,mapstr,niter=intarr(10)+13,i=i,deconvolve=0,_extra=_extra
    endfor

    bolo_indices = bgps.bolo_indices
    nbolos = n_e(bolo_indices)

    angle = (-median(bgps.rotang) + median(bgps.posang) + median(bgps.arrang)) * !dtor
    dec_conversion = cos(bgps.source_dec*!dtor)

    ncdf_varget_scale,thefiles[0],'bolo_params',bolo_params
    rtf = [[reform([bolo_params[2,bolo_indices]])],[reform(bolo_params[1,bolo_indices]*!dtor)]]
    xy_boloframe = [[rtf[*,0]*cos(rtf[*,1])],$
                    [rtf[*,0]*sin(rtf[*,1])]]
    rot_mat = [[cos(angle),sin(angle)],$
               [-sin(angle),cos(angle)]]
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
        xy2: xy_boloframe # $
                 rot_mat * $
                 [1/dec_conversion,1] ## (fltarr(nbolos)+1), $
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
    allmap = map_eachbolo(bgps.ra_map,bgps.dec_map,bgps.astrosignal,bgps.scans_info,pixsize=pixsize,$
        blank_map=blank_map,hdr=hdr,coordsys=coordsys,projection=projection,$
        jd=bgps.jd,lst=bgps.lst,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)

    bolospacing = pixsize/38.5  ; arcseconds per pixel / arcseconds per bolospacing
    extast,hdr[*,0,0],astr
    ad2xy,bgps.source_ra*15,bgps.source_dec,astr,xcen,ycen
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

    openw,fitparfile,outfile+"_bolofits.txt",/get_lun
    printf,fitparfile,"Bolometer number","background","amplitude","sigma_x","sigma_y","xcen","ycen","angle",format='(8A20)'

    xmin = 0                  ;floor(xcen-10)
    xmax = n_e(allmap[*,0,0])-1 ;ceil(xcen+10)
    ymin = 0                  ;floor(ycen-10)
    ymax = n_e(allmap[0,*,0])-1 ;ceil(ycen+10)

    for i=0,n_e(allmap[0,0,*])-1 do begin

        ; centroid: background, amplitude, xwidth, ywidth, xcenter, ycenter, angle
        fitpars = centroid_map(allmap[xmin:xmax,ymin:ymax,i],perror=perror,fitmap=fitmap,pixsize=pixsize)
        fitmapcube[xmin:xmax,ymin:ymax,i] = fitmap

        meas.chi2[i] = total((allmap[*,*,i]-fitmap)^2)/n_e(fitmap)
        meas.err[i] = sqrt(perror[4]^2+perror[5]^2)*bolospacing
        meas.xyoffs[i,0] = (fitpars[4]-(xcen-xmin))*bolospacing  ; XYOFFS ARE IN ROTATED PLANE
        meas.xyoffs[i,1] = (fitpars[5]-(ycen-ymin))*bolospacing 
        meas.xy[i,0] = nominal.xy[i,0] - meas.xyoffs[i,0]  ; something is twisted
        meas.xy[i,1] = nominal.xy[i,1] - meas.xyoffs[i,1]  
        meas.angle[i] = fitpars[6]
        meas.xysize[i,*] = fitpars[2:3]*bolospacing
        meas.ampl[i] = fitpars[1]
        meas.backgr[i] = fitpars[0]

        printf,fitparfile,bolo_indices[i],fitpars[0:1],meas.xysize[i,*],meas.xy[i,*],fitpars[6],format='(8F20)'

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
    if doplot gt 1 then begin
        plot,meas.xyoffs[*,0],meas.xyoffs[*,1],psym=1
        plot,meas.xyoffs[*,0]/bolospacing,meas.xyoffs[*,1]/bolospacing,psym=1
        plot,meas.xy[*,0],meas.xy[*,1],psym=1
        oplot,nominal.xy[*,0],nominal.xy[*,1],psym=7,color=250
        device,/close_file
        set_plot,'x'
    endif
    !p.multi=0

    close,fitparfile
    free_lun,fitparfile 

    fitmap=fitmapcube


    ; convert back to the format used in the beam locations files (assumes no
    ; projection and no rotation)
    meas.rth[*,0] = sqrt((meas.xy[*,0]*dec_conversion)^2+meas.xy[*,1]^2)
    meas.rth[*,1] = atan(-meas.xy[*,1],meas.xy[*,0]*dec_conversion)-angle

    save,filename=outfile+".sav"

    if keyword_set(interactive) then stop

end
