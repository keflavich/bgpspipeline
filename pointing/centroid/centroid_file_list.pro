; centroid_file_list takes a list of files and prints out
; the centroid coordinates in x,y,ra,dec,alt,az and 
; ra,dec,alt,az offsets if you input the ra/dec with it
; The output is in a fixed-format ASCII file specified with
; the parameter 'outfile'
;
; if you specify a 'savfile' then IDL will save variables to that
; file
;
; mpfit2dpeak is used for the 2d gaussian fitting with 7
; free parameters.  The errors are saved in the variables
; xerr/yerr and output to the centroid file
;
; I apologize that this code is ugly.  I wrote it with the intent
; of being straight to .txt and then realized that idl sav variables
; and structs are actually more sensible.  But that makes the code
; downright hideous, imo.  Indexing variables is no fun.
pro centroid_file_list,filelist,outfile,objra=objra,objdec=objdec,source_name=source_name,dontconv=dontconv,$
    fitpars=fitpars,zfit=zfit,fiterr=perror,precess=precess,aberration=aberration,nutate=nutate,savfile=savfile,$
    ncfile=ncfile
    readcol, filelist, thefiles, format='A80',/silent  ; read in the raw filenames 
    openw,outf,outfile,/get_lun
    if keyword_set(source_name) then findsource = 0 else findsource = 1
    printf,outf,"filename","source_name","x_pix","y_pix","ra(deg)","dec(deg)","ra_off(as)","dec_off(as)","obj_ra","obj_dec",$
        "alt","az","alt_off(as)","az_off(as)","FZAO","FAZO",$
        "lst","jd",'xerr','yerr','obsname',format='("#",A99,A20,18A18,A15)'

    fwhm = 31.2/7. & hwhm = fwhm / 2.
    psf = psf_gaussian(npix=19,ndim=2,fwhm=hwhm,/norm)

    nfiles=n_e(thefiles)
    blank = dblarr(nfiles)
    blankbyt = bytarr(nfiles)
    blankstr = strarr(nfiles)
    ss = create_struct($
        ['filename','obsname','source_name','ncfile','xpix','ypix', $
        'ra','dec','objra','objdec','alt','az','altoff','azoff','azoff_dist',$
        'objalt','objaz','fazo','fzao','lst','jd','xerr','yerr',$
        'ncra','ncdec','ncepoch','raoff','decoff','raoff_dist','good'],blankstr,blankstr,blankstr,blankstr,blank,$
        blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,$
        blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blankbyt)
    ss.good[*] = 1

    if ~keyword_set(ncfile) then ncfile=''

    for i=0,n_e(thefiles)-1 do begin
        ss.filename[i]  = thefiles[i]
        if strmid(ss.filename[i],0,1) eq "#" and strlen(ss.filename[i]) gt 1 then begin
            printf,outf,ss.filename[i],format='("#",A99)'
            ss.good[i] = 0
            continue
        endif else if strmid(ss.filename[i],0,1) eq "#" then begin
            ss.good[i] = 0
            continue
        endif
        map = readfits(ss.filename[i],header,/silent)
        ss.obsname[i] = stregex(ss.filename[i],'[0-9]{6}_o[b0-9][0-9]',/extract)
        if strlen(ss.obsname[i]) eq 0 then obsname = 'null'

        if findsource then find_object_radec,ss.filename[i],ora,odec,source_name=source_name $
            else begin
                ora = objra
                odec = objdec
            endelse
        ss.objra[i]=ora
        ss.objdec[i]=odec
        ss.source_name[i]=source_name

        ; centroiding is not easy because of source finding.  More robust source finding may be useful
        x = floor(n_e(map[*,0])/2.)
        y = floor(n_e(map[0,*])/2.)
        xl = x - 20 ; x/2.  ; 20 pixels at 7"/pix is 140 arcseconds, which is huge but hopefully small enough to cut out anomolous high points
        xh = x + 20 ; x/2.
        yl = y - 20 ; y/2.
        yh = y + 20 ; y/2.
        submap = map[xl:xh,yl:yh]
;        m = max(submap,whmax)             ; old code used moment-based centroids
;        xm = whmax mod n_e(submap[*,0])   ; and used the x/y max as a 'guess'
;        ym = whmax / n_e(submap[*,0])  
        whneg = where(submap lt 0)
        if size(whneg,/dim) ne 0 then submap[whneg] = 0  ; force positive
        if keyword_set(dontconv) then csm = submap else csm = convolve(submap,psf)
        m = max(total(csm,2),xm)
        m = max(total(csm,1),ym)
;        cntrd,submap,xm,ym,xcen,ycen,3.        ; relic of old code
;        gcntrd,submap,xm,ym,xcen,ycen,fwhm     ; one step up...
        zfit = mpfit2dpeak(csm,fitpars,/tilt,/gaussian,perror=perror,estimate=[median(csm),max(csm),hwhm,hwhm,xm,ym,0])
        if fitpars[4] gt 0 and fitpars[5] gt 0 then begin
            ss.xpix[i] = xl + fitpars[4]
            ss.ypix[i] = yl + fitpars[5]
        endif else begin
            ss.xpix[i] = -1
            ss.ypix[i] = -1
        endelse
        ss.xerr[i] = perror[4]
        ss.yerr[i] = perror[5]

        extast,header,astr
        coordsys = fxpar(header,'CTYPE1')
        if coordsys eq 'GLON-CAR' then begin ; check coordinate system...
            xy2ad,ss.xpix[i],ss.ypix[i],astr,l,b
            euler,l,b,a,d,2
        endif else if coordsys eq 'RA---TAN' or coordsys eq 'RA---SFL' then begin
            xy2ad,ss.xpix[i],ss.ypix[i],astr,a,d
        endif
        ss.ra[i] = a
        ss.dec[i] = d
        ss.lst[i] = fxpar(header,'lst')
        ss.jd[i] = fxpar(header,'jd')
        tempstr = stregex(ss.filename[i],'[a-z0-9\._-]*/[a-z_]*[0-9]{6}_o[b0-9][0-9]',/extract)
        if file_test(ncfile) ne 1 then ncfile = '/scratch/sliced_polychrome/' + stregex(tempstr,'[a-z0-9\._-]*/',/extract) + stregex(tempstr,'[0-9]{6}_o[b0-9][0-9]',/extract) + '_raw_nods.nc'
        if file_test(ncfile) ne 1 then ncfile = strmid(ncfile,0,strlen(ncfile)-7) + "ds1.nc"
        if file_test(ncfile) ne 1 then begin   ; that is really an error, but what if?  Usually this happens if a file has been moved to bad/
            printf,outf,"#"+ss.filename[i]+"  no raw file for jd/lst"
            print,ss.filename[i]+"  no raw file for jd/lst"
            ss.good[i] = 0
            continue
        endif
        ss.ncfile[i] = ncfile ; who knows, maybe this will be useful....
        ncdf_varget_scale,ncfile,'source_ra',source_ra
        ncdf_varget_scale,ncfile,'source_dec',source_dec
        ncdf_varget_scale,ncfile,'source_epoch',source_epoch
        source_ra *= 15.
        ss.ncra[i] = source_ra[0]
        ss.ncdec[i] = source_dec[0]
        ss.ncepoch[i] = source_epoch[0]
        if ss.ncepoch[i] ne 2000.0 then begin
            jprecess,ss.ncra[i],ss.ncdec[i],ncra,ncdec
            ss.ncra[i] = ncra
            ss.ncdec[i] = ncdec
        endif

        ; simple error-checking between my source position (from SIMBAD) and the source position in the header
        ; if they ever differ by more than 2", the source is probably not pointlike and therefore not good for
        ; pointing
        if sqrt(((ss.objra[i]-ss.ncra[i])/cos(!dtor*ss.objdec[i]))^2+(ss.objdec[i]-ss.ncdec[i])^2)*3600. gt 2. then $
            print,ss.filename[i],"  ",ss.source_name[i],"  JP: Delta-ra: "+strc(3600.*(ss.objra[i]-ss.ncra[i]))+$
            " Delta-dec: "+strc(3600.*(ss.objdec[i]-ss.ncdec[i]))+" ra: "+strc(ss.objra[i])+" dec: "+strc(ss.objdec[i])
        if ss.jd[i] eq 0 then begin            ; if the JD wasn't written to the header, the LST probably wasn't either
            ncdf_varget_scale,ncfile,'jd',jd
            ncdf_varget_scale,ncfile,'ut',ut
            ncdf_varget_scale,ncfile,'lst',lst
            ss.jd[i] = median(jd) + 2400000.5d + median(ut)/24.
            ss.lst[i] = median(lst)   ; careful here!  Is the median LST the right choice?
        endif
        ncfile = ''
        latitude=19.82611111D
        ; the next series of comments are debug tests, comparing eq2hor/getaltaz and my new code.
        ;getaltaz,ss.objdec[i],latitude,lst-ss.objra[i]/15.,objalt,objaz
        ;eq2hor,ss.objra[i],ss.objdec[i],jd,objalt,objaz,lat=latitude,alt=4072,lon=-155.473366,refract=0,precess=precess,aberration=0,nutate=0
        my_eq2hor,ss.objra[i],ss.objdec[i],ss.jd[i],objalt,objaz,lat=latitude,alt=4072,lon=-155.473366,refract=0,precess=0,aberration=aberration,nutate=nutate,lst=ss.lst[i]
        ss.objalt[i] = objalt
        ss.objaz[i] = objaz
        ;getaltaz,d,latitude,lst-a/15.,alt_fit,az_fit
        ;eq2hor,a,d,jd,alt_fit,az_fit,lat=19.82611111,alt=4072,lon=-155.473366,refract=0,precess=precess,aberration=aberration,nutate=nutate
        my_eq2hor,ss.ra[i],ss.dec[i],ss.jd[i],alt,az,lat=latitude,alt=4072,lon=-155.473366,refract=0,precess=0,aberration=aberration,nutate=nutate,lst=ss.lst[i]
        ss.alt[i] = alt
        ss.az[i] = az

        ss.fzao[i] = fxpar(header,'FZAO')
        ss.fazo[i] = fxpar(header,'FAZO')
        if ss.fzao[i] eq 0 then begin    ; if FAZO/FZAO aren't in the header, get them
            get_fixed_offsets_file,ss.filename[i],fazo,fzao
            ss.fzao[i] = fzao
            ss.fazo[i] = fazo
        endif

        ss.altoff[i] = (ss.alt[i]-ss.objalt[i])*3600.D
        ss.azoff[i]  = (ss.az[i]-ss.objaz[i])*3600.D
        ss.azoff_dist[i]  = (ss.az[i]-ss.objaz[i])*3600.D / cos(!dtor*ss.alt[i])

        ss.raoff[i]  = (ss.ra[i]-ss.objra[i])*3600.D
        ss.decoff[i] = (ss.dec[i]-ss.objdec[i])*3600.D
        ss.raoff_dist[i]  = (ss.ra[i]-ss.objra[i])*3600.D / cos(!dtor*ss.dec[i])

        printf,outf,ss.filename[i],ss.source_name[i],ss.xpix[i],ss.ypix[i],$
            ss.ra[i],ss.dec[i],ss.raoff[i],ss.decoff[i],$
            ss.objra[i],ss.objdec[i],ss.objalt[i],ss.objaz[i],ss.altoff[i],ss.azoff[i],$
            ss.fzao[i],ss.fazo[i],ss.lst[i],ss.jd[i],ss.xerr[i],ss.yerr[i],ss.obsname[i],$
            format='(A100,A20,18F18.6,A15)'

    endfor
    close,outf
    free_lun,outf
    if keyword_set(savfile) then begin
        if savfile eq 1 then savfile = strmid(outfile,0,strlen(outfile)-3)+"sav"
        save,ss,filename=savfile
    endif
end

