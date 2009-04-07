; the fits headers need to have at least the following parameters in them for pointing
; and other purposes
; FYI, this will definitely crash if you don't pass all the necessary parameters
pro add_to_header,hdr,lst,fazo,fzao,jd,$
    mvperjy,filename,pixsize,radec_offsets,$
    pointing_model=pointing_model,singlefile=singlefile,$
    meandc=meandc,stddc=stddc,deconv_fwhm=deconv_fwhm,$
    filenames=filenames

    if singlefile then begin
        if keyword_set(filename) then begin
            find_object_radec,filename,objra,objdec,source_name=source_name
            if finite(objra,/nan) gt 0 then begin
                ncdf_varget_scale,filename,'source_ra',source_ra
                ncdf_varget_scale,filename,'source_dec',source_dec
                ncdf_varget_scale,filename,'source_epoch',source_epoch
                objra = median(source_ra)
                objdec = median(source_dec)
                if source_epoch[0] ne 2000 then precess,objra,objdec,median(source_epoch),2000
            endif
            fxaddpar,hdr,"tgt_ra",objra,"right ascension of target object"
            fxaddpar,hdr,"tgt_dec",objdec,"declination of target object"
            fxaddpar,hdr,"tgt_name",source_name,"name of target object"
        endif
        if keyword_set(pointing_model) then fxaddpar,hdr,"ptgmdl",1,"was the pointing model applied?" $
            else fxaddpar,hdr,'ptgmdl',0,"was the pointing model applied?"
        if n_e(pointing_model) eq 2 then begin
            fxaddpar,hdr,'ptmdlra',pointing_model[0]
            fxaddpar,hdr,'ptmdldec',pointing_model[1]
        endif
        fxaddpar,hdr,"lst",median([lst]),"median lst"
        midjd = string(median([jd]),format='(F20.10)')
        fxaddpar,hdr,"jd",midjd,"median jd"
        fxaddpar,hdr,"ut",median([jd]) mod 1,"median UT"
        fxaddpar,hdr,"fzao",median([fzao]),"median fixed (manual) zenith angle offset"
        fxaddpar,hdr,"fazo",median([fazo]),"median fixed (manual) azimuth offset"
        if n_e(radec_offsets) ne 2 then radec_offsets = [0,0]
        fxaddpar,hdr,"raoff",radec_offsets[0],"applied RA offset added to input (degrees)"
        fxaddpar,hdr,"decoff",radec_offsets[1],"applied Dec offset added to input (degrees)"
;        fxaddpar,hdr,"dra___ab",median_corrections[0],"median aberration correction to RA (has been added to RA)"
;        fxaddpar,hdr,"ddec__ab",median_corrections[1],"median aberration correction to dec (has been added to dec)"
;        fxaddpar,hdr,"dra__nut",median_corrections[2],"median nutation correction to RA (has been added to RA)"
;        fxaddpar,hdr,"ddec_nut",median_corrections[3],"median nutation correction to dec (has been added to dec)"
;        fxaddpar,hdr,"prec__ra",median_corrections[4],"median precession correction to RA (has been added to RA)"
;        fxaddpar,hdr,"prec_dec",median_corrections[5],"median precession correction to dec (has been added to dec)"
;        fxaddpar,hdr,"dra__ptg",median_corrections[6],"median pointing model correction to ra (has been added to ra)"
;        fxaddpar,hdr,"ddec_ptg",median_corrections[7],"median pointing model correction to dec (has been added to dec)"
;        fxaddpar,hdr,"dra__ptg",median_corrections[0],"median ptgmdl corr to ra (has been added to ra)"
;        fxaddpar,hdr,"ddec_ptg",median_corrections[1],"median ptgmdl corr to dec (has been added to dec)"
    endif

    if keyword_set(deconv_fwhm) then fxaddpar,hdr,"decfwhm",deconv_fwhm,"Deconvolution Kernel FWHM" $
        else fxaddpar,hdr,"decfwhm",14.4,"Deconvolution Kernel FWHM" 

    if keyword_set(meandc) then fxaddpar,hdr,"meandc",meandc,"Mean DC level"
    if keyword_set(stddc) then fxaddpar,hdr,"stddc",stddc,"Std. dev. DC level"
    fxaddpar,hdr,"UNITS","Jy/Beam"
    beamsize = 35.6  ; was 31.2
    fxaddpar,hdr,"ppbeam" ,2*!dpi*(beamsize/2.35482)^2/pixsize^2,"pixels per beam" 
    fxaddpar,hdr,"calib_0",mvperjy[0]," 0th coefficient for flux cal"
    fxaddpar,hdr,"calib_1",mvperjy[1]," 1st coefficient for flux cal"
    fxaddpar,hdr,"calib_2",mvperjy[2]," 2nd coefficient for flux cal"
    fxaddpar,hdr,"iternum",0,"Iteration number"
    fxaddpar,hdr,"n_pca"  ,0,"number of PCA components subtracted"
    fxaddpar,hdr,"WL",1.12,"mm (avoids CO 2-1)"
    fxaddpar,hdr,"COMMENT","Made by the Bolocam Galactic Plane Survey (BGPS) pipeline"
    fxaddpar,hdr,"COMMENT","described in Aguirre et al 2009 (not yet published)"
    fxaddpar,hdr,"COMMENT","BGPS data was taken at the Caltech Submillimeter Observatory"
    for i=0,n_e(filenames)-1 do begin
        fxaddpar,hdr,"HISTORY",strmid(filenames[i],stregex(filenames[i],'[0-9]{6}_o[b0-9][0-9]',10))
    end
end 
