; centroiding portion of distmap
pro distmap_centroids,filename,outfile,doplot=doplot,doatv=doatv,xy=xy,fitmap=fitmap,allmap=allmap,pixsize=pixsize,rtf=rtf,_extra=_extra

    if ~keyword_set(doplot) then doplot=0

    ncdf_varget_scale,filename,'bolo_params',bolo_params
    radius = reform(bolo_params[2,*])
    theta =  reform(bolo_params[1,*])
    rtheta = [[radius],[theta*!dtor]] ;fltarr(total_bolos,2)

    ; larger pixel size selected for mapping to reduce blank pixels
    if ~keyword_set(pixsize) then pixsize=10.0

    thefiles = [filename]
    readall_pc,thefiles,bgps_struct=bgps,bolo_indices=bolo_indices,bolo_params=bolo_params,$
        pointing_model=0,/nobeamloc,_extra=_extra

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

    nbolos = n_e(bolo_indices)
    xy = fltarr(nbolos,2) ; will store measured x,y positions 
    invweight = fltarr(nbolos,2) + 1
    chi2arr = fltarr(n_e(bolo_indices))

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
        chi2arr[i] = total((allmap[*,*,i]-fitmap)^2)/n_e(fitmap)

        xdist = (fitpars[4]-xcen)*bolospacing
        ydist = (fitpars[5]-ycen)*bolospacing
        err = sqrt(perror[4]^2+perror[5]^2)*bolospacing
        distance = sqrt(xdist^2+ydist^2)
        angle = atan(ydist,xdist)

        xy[i,0] = xdist
        xy[i,1] = ydist

        printf,fitparfile,bolo_indices[i],fitpars,format='(8F20)'
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

    rtf = rtheta[bolo_indices,*]

    fitmap=fitmapcube

    close,fitparfile
    free_lun,fitparfile 

    save,filename=outfile+".sav"

end
