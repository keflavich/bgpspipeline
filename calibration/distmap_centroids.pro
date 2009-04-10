; centroiding portion of distmap
pro distmap_centroids,filename,outfile,doplot=doplot,doatv=doatv,fitmap=fitmap,allmap=allmap,$
    pixsize=pixsize,meas=meas,nominal=nominal,_extra=_extra

    if ~keyword_set(doplot) then doplot=0


    ; larger pixel size selected for mapping to reduce blank pixels
    ; should be 11 pixels because that's how much the bolometers were moved
    if ~keyword_set(pixsize) then pixsize=11.0

    if size(filename,/type) eq 7 then thefiles = [filename]
    readall_pc,thefiles,bgps_struct=bgps,bolo_indices=bolo_indices,bolo_params=bolo_params,$
        pointing_model=0,/nobeamloc,_extra=_extra

    nbolos = n_e(bolo_indices)

    ncdf_varget_scale,filename,'bolo_params',bolo_params
    rtf = [[reform([bolo_params[2,bolo_indices]])],[reform(bolo_params[1,bolo_indices]*!dtor)]]
    nominal = { $
        radius : reform(bolo_params[2,*]) ,$
        theta :  reform(bolo_params[1,*])*!dtor ,$
        rth : rtf ,$
        xy : [[rtf[*,0]*cos(rtf[*,1])],[rtf[*,0]*sin(rtf[*,1])]] $
    }

    meas = { $
        rth : fltarr(nbolos,2)    ,$
        xy  : fltarr(nbolos,2)    ,$
        xysize: fltarr(nbolos,2)  ,$
        chi2: fltarr(nbolos)      ,$
        err: fltarr(nbolos)       ,$
        angle: fltarr(nbolos)     ,$
        ampl: fltarr(nbolos)      ,$
        backgr: fltarr(nbolos)    ,$
        bolo_indices: bolo_indices $
    }

    ; some pca subtraction is necessary to clean up the image for fitting
    pca_subtract,bgps.ac_bolos,13,uncorr_part=new_astro
    if total(bgps.flags) gt 0 then new_astro[where(bgps.flags)] = 0

    ; makes a data cube with one map for each bolometer
    allmap = map_eachbolo(bgps.ra_map,bgps.dec_map,new_astro,bgps.scans_info,pixsize=pixsize,$
        blank_map=blank_map,hdr=hdr,$
        jd=bgps.jd,lst=bgps.lst,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)

    bolospacing = pixsize/38.5  ; arcseconds per pixel / arcseconds per bolospacing
    xcen = n_e(allmap[*,0,0])/2. ; assumes the center of the map is the pointing center.  This may be off by +/- .5 pixels
    ycen = n_e(allmap[0,*,0])/2. ; because of the frustrating error where not all bolometers have the same map size
                                ; 3/20/09 - I'm pretty sure there's no such error

    fitmapcube = allmap*0

    if doplot gt 1 then begin
        !p.multi=[0,5,5]
        set_plot,'ps'
        device,filename=outfile+"_boloplots.ps",/color,bits_per_pixel=16
        loadct,0
    endif

    openw,fitparfile,outfile+"_bolofits.txt",/get_lun
    printf,fitparfile,"Bolometer number","background","amplitude","sigma_x","sigma_y","xcen","ycen","angle",format='(8A20)'

    for i=0,n_e(allmap[0,0,*])-1 do begin

        ; centroid: background, amplitude, xwidth, ywidth, xcenter, ycenter, angle
        fitpars = centroid_map(allmap[*,*,i],perror=perror,fitmap=fitmap,pixsize=pixsize)
        fitmapcube[*,*,i] = fitmap

        meas.chi2[i] = total((allmap[*,*,i]-fitmap)^2)/n_e(fitmap)
        meas.err[i] = sqrt(perror[4]^2+perror[5]^2)*bolospacing
        meas.xy[i,0] = (fitpars[4]-xcen)*bolospacing
        meas.xy[i,1] = (fitpars[5]-ycen)*bolospacing
        meas.angle[i] = fitpars[6]
        meas.xysize[i,*] = fitpars[2:3]*bolospacing
        meas.ampl[i] = fitpars[1]
        meas.backgr[i] = fitpars[0]

        printf,fitparfile,bolo_indices[i],fitpars[0:1],fitpars[2:5]*bolospacing,fitpars[6],format='(8F20)'

        if keyword_set(doatv) then begin ; plotting
            atv,allmap[*,*,i]
            atvxyouts,[fitpars[4]],[fitpars[5]],strc(bolo_indices[i]),charsize=4,color='red'
            atv_plot1ellipse,fitpars[2],fitpars[3],fitpars[4],fitpars[5],fitpars[6],color=250
        endif

        if doplot gt 1 then begin
            loadct,0,/silent
            imdisp,asinh(reform(allmap[*,*,i])),erase=0,/axis
            loadct,39,/silent
            tvellipse,fitpars[2],fitpars[3],fitpars[4],fitpars[5],fitpars[6],color=250,/data,thick=.5
            tvellipse,fitpars[2]*2.35,fitpars[3]*2.35,fitpars[4],fitpars[5],fitpars[6],color=250,/data,thick=.5
        endif

    endfor
    device,/close_file
    set_plot,'x'
    !p.multi=0

    close,fitparfile
    free_lun,fitparfile 

    fitmap=fitmapcube

    meas.rth[*,0] = sqrt(meas.xy[*,0]^2+meas.xy[*,1]^2)
    meas.rth[*,1] = atan(meas.xy[*,1],meas.xy[*,0])

    save,filename=outfile+".sav"

end
