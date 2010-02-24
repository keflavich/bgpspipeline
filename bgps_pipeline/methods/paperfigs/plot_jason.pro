pro plot_jason,bw=bw,color=color,bar=bar,label=label

;    loadct,3
;    modct,3,gamma=-.5
;    set_plot,'ps'
;    device,filename="mosaic.ps",/color,/inches,xsize=35,ysize=5,xoffset=.5,yoffset=.5,/encapsulated,bits=16
;
;    map = readfits('MOSAIC.fits',hdr)
;
;    crpix1 = sxpar(hdr,'CRPIX1')
;    crpix2 = sxpar(hdr,'CRPIX2')
;    crval1 = sxpar(hdr,'CRVAL1')
;    crval2 = sxpar(hdr,'CRVAL2')
;    cd1_1 = sxpar(hdr,'CD1_1')
;    cd2_2 = sxpar(hdr,'CD2_2')
;    
;    x = lindgen(n_e(map[*,0]))
;    y = lindgen(n_e(map[0,*]))
;    l = (x-crpix1)*cd1_1+crval1
;;    l[where(l gt 360)] -= 360
;    b = (y-crpix2)*cd2_2+crval2
;
;    imdisp,map,/axis,xrange=[max(l),min(l)],yrange=[min(b),max(b)],range=[-1,6],ticklen=.001,true=1,xtitle="Galactic Longitude",ytitle="Galactic Latitude"
;
;    device,/close_file
;
;    set_plot,'x'
;
;    imdisp,map,/axis,xrange=[max(l),min(l)],yrange=[min(b),max(b)],range=[-1,6],ticklen=.001,true=1,xtitle="Galactic Longitude",ytitle="Galactic Latitude"

    
    readcol,'landscapelist',filelist,format='A80',comment="#"
    if keyword_set(label) then begin
        readcol,'sourcelist',sourcename,sourceL,sourceB,format='(A17,F8,F8)',delimiter="|",comment="#"
        if total(sourceL gt 300) gt 0 then sourceL[where(sourceL gt 300)]-=360
    endif

    set_plot,'ps'
    if keyword_set(color) then begin
        loadct,3
        range=[-.25,1]
        f="_color"
        negative=0
        invertcolors=0
    endif else begin
        loadct,0
        range=[-.25,1]
        f="_bw_inv"
        negative=1
        invertcolors=1
    endelse
    if keyword_set(bar) then begin
        delta = .15*2
        offset = 0.03
        f = f+"_bar"
    endif else begin
        delta = .152*2
        offset = 0.03
    endelse
    if keyword_set(label) then f = f+"_label"
    print,f
;    modct,3,gamma=-.75
;    modct,1,lo=1,hi=0
;    loadct,0
;    modct,0,gamma=+.25
;    tvlct,r,g,b,/get
;    tvlct,reverse(r),reverse(g),reverse(b)
    pgnum = 1
    xoff = 0
    yoff = 0
    xsize=10.5
    ysize=6
    device,filename="landscape1"+f+".ps",/inches,xsize=xsize,ysize=ysize,xoffset=xoff,yoffset=yoff,/encapsulated,bits=16,color=color
    if keyword_set(bar) then colorbar,/top,position=[.075,.96,.975,.98],range=range,format='(F0.2)',invertcolors=invertcolors;ticknames=['-0.25','0.0','0.25','0.5','0.75','1.0']

    nfigs = 3
    !P.MULTI = [0,1,nfigs]
;    !p.region = [0,0,1,1]
    !p.region=0
    !p.position=0
;    !p.multi=0

    for i=0,n_e(filelist)-1 do begin

        filename = filelist[i]
        ;filename_root = strmid(filename,0,strlen(filename)-5)

        if i mod nfigs eq 0 and i lt n_e(filelist) and i ne 0 then begin
            device,/close_file
            if pgnum lt 5 then pgnum = (i) / nfigs + 1
            device,filename="landscape"+strc(pgnum)+f+".ps",/inches,xsize=xsize,ysize=ysize,xoffset=xoff,yoffset=yoff,/encapsulated,bits=16,color=color
            if keyword_set(bar) then colorbar,/top,position=[.075,.96,.975,.98],range=range,format='(F0.2)',invertcolors=invertcolors;ticknames=['-0.25','0.0','0.25','0.5','0.75','1.0']
        end

        position = [.05,(nfigs-(i mod nfigs)-1)*delta+offset,1,(nfigs-(i mod nfigs))*delta+offset]
        print,filename,position,"   i: ",i,i mod nfigs,delta,pgnum," negative: ",negative

        display_with_wcs,filename,position=position,range=range,negative=negative,sourcename=sourcename,sourceL=sourceL,sourceB=sourceB

    endfor
    device,/close_file
    set_plot,'x'

end

