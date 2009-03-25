; neat plotting program
; takes the output of centroid_file_list and uses
; atv to display the image with the centroid overplotted
; as a plus and the true position overplotted as an x
; Optionally, you can pass a .sav file instead
pro image_with_centroid,centfile,goodbad=goodbad
    if ~keyword_set(goodbad) then goodbad='bad'
    if strmid(centfile,strlen(centfile)-3,3) eq 'sav' then begin 
        restore,centfile 
        if goodbad eq 'good' then wh = postcorr_good_both else wh = postcorr_bad_either
        name = name[wh]
        objra = objra[wh]
        objdec = objdec[wh]
        source_name = source_name[wh]
        xpix = xpix[wh]
        ypix = ypix[wh]
        alt = alt[wh]
        az = az[wh]
        altoff = altoff[wh]
        azoff = azoff[wh]
        fcorrected_ra = fcorrected_ra[wh]
        fcorrected_dec = fcorrected_dec[wh]
    endif else $
    readcol,centfile,name,source_name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,alt,az,altoff,azoff,$
        fzao,fazo,lst,jd,xerr,yerr,obsname,$
        format='(A100,A20,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,F18,A15)',$
        /silent,comment="#"
    loadct,13

    for i=0,n_e(name)-1 do begin
        map = readfits(name[i],header,/silent)
        atv,map,header=header
        atvplot,xpix[i],ypix[i],psym=1   ;,color=250
        extast,header,astr
        if fxpar(header,'CTYPE1') eq 'GLON-CAR' then begin
            euler,objra[i],objdec[i],l,b,1
            ad2xy,l,b,astr,objx,objy
        endif else ad2xy,objra[i],objdec[i],astr,objx,objy
        if n_e(fcorrected_ra) gt 0 then begin
            ad2xy,fcorrected_ra[i],fcorrected_dec[i],astr,corrx,corry
            atvplot,corrx,corry,psym=1,color='green'
        endif
        atvplot,objx,objy,psym=7   ;,color=150
        print,name[i],source_name[i],xpix[i],ypix[i],alt[i],az[i],altoff[i],azoff[i],format="(A100,A15,6F18.4)"
        atv_activate
    endfor

end
