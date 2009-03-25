
pro plot_ts,filename,bolonum,doraw=doraw,iter0=iter0,domap=domap

    loadct,39
    f=ncdf_open(filename)
    check_skymod = ncdf_varid(f,'map_model')
    ncdf_close,f
    ncdf_varget_scale, filename, 'ac_bolos', acb
    ncdf_varget_scale, filename, 'bolo_params',bp
    ncdf_varget_scale, filename, 'dc_bolos',dc
    ncdf_varget_scale, filename, 'scans_info',scans
    ncdf_varget_scale, filename, 'flags',flags
    nscans = n_e(scans[0,*])
    gb = where(bp[0,*],ngb)
    if check_skymod eq -1 then  map = dblarr(size(acb,/dim)) else ncdf_varget_scale, filename, 'map_model',map 
    if check_skymod eq -1 then atm = dblarr(size(acb,/dim)) else ncdf_varget_scale, filename, 'atmos_model', atm
    if check_skymod eq -1 then raw = dblarr(size(acb,/dim)) else ncdf_varget_scale, filename, 'raw', raw

;    acb *= (1-flags)
;    atm *= (1-flags)
;    raw *= (1-flags)
;    map *= (1-flags)
    acb[where(flags)] = !values.f_nan
    atm[where(flags)] = !values.f_nan
    raw[where(flags)] = !values.f_nan
    map[where(flags)] = !values.f_nan

    print,"Raw is red, sky is cyan, astrophysical is white (if iter0, green is intermediate astro signal)"

    wset,0
    for s = 0,nscans-1 do begin
        lb = scans[0,s]
        ub = scans[1,s]
        
        if keyword_set(doraw) then begin
            plot,raw[bolonum,lb:ub],col=240 ;,/xst ;,yrange=[-.5,.5]
            oplot,acb[bolonum,lb:ub]
            oplot,raw[bolonum,lb:ub]-acb[bolonum,lb:ub],col=100
            if keyword_set(iter0) then oplot,atm[bolonum,lb:ub],col=200
            if keyword_set(domap) then oplot,map[bolonum,lb:ub],col=150
        endif else begin
            plot,acb[bolonum,lb:ub],yrange=[-.1,.1]
            oplot,raw[bolonum,lb:ub],col=240 ;,/xst ;,yrange=[-.5,.5]
            oplot,raw[bolonum,lb:ub]-acb[bolonum,lb:ub],col=100
            if keyword_set(iter0) then oplot,atm[bolonum,lb:ub],col=200
            if keyword_set(domap) then oplot,map[bolonum,lb:ub],col=150
        endelse
;        oplot,map[gb[bolonum],lb:ub],col=240
;        oplot,atm[gb[bolonum],lb:ub],col=20
;        oplot,ts_map[gb[bolonum],*,s],col=4
        
        blah = ''
        read,blah,prompt="scan "+strc(s)
        if blah eq 'q' then break
        
    endfor

end

pro plot_scan,filename,scannum,doraw=doraw,iter0=iter0,domap=domap

    loadct,39
    f=ncdf_open(filename)
    check_skymod = ncdf_varid(f,'map_model')
    ncdf_close,f
    ncdf_varget_scale, filename, 'ac_bolos', acb
    ncdf_varget_scale, filename, 'bolo_params',bp
    ncdf_varget_scale, filename, 'dc_bolos',dc
    ncdf_varget_scale, filename, 'scans_info',scans
    ncdf_varget_scale, filename, 'flags',flags
    nscans = n_e(scans[0,*])
    gb = where(bp[0,*],ngb)
    print,"Check_skymod = ",check_skymod
    if check_skymod eq -1 then  map = dblarr(size(acb,/dim)) else ncdf_varget_scale, filename, 'map_model',map 
    if check_skymod eq -1 then atm = dblarr(size(acb,/dim)) else ncdf_varget_scale, filename, 'atmos_model', atm
    if check_skymod eq -1 then raw = dblarr(size(acb,/dim)) else ncdf_varget_scale, filename, 'raw', raw
    read_ncdf_vars,filename,ac_bolos=acb,bolo_params=bp,raw=raw,scans_info=scans,flags=flags,map_model=map,atmos_model=atm
    nscans = n_e(scans[0,*])
    gb = where(bp[0,*],ngb)
    acb[where(flags)] = !values.f_nan
    if n_e(atm) gt 0 then atm[where(flags)] = !values.f_nan
    if n_e(raw) gt 0 then raw[where(flags)] = !values.f_nan
    if n_e(map) gt 0 then map[where(flags)] = !values.f_nan

;    acb *= (1-flags)
;    atm *= (1-flags)
;    raw *= (1-flags)
;    map *= (1-flags)
    acb[where(flags)] = !values.f_nan
    atm[where(flags)] = !values.f_nan
    raw[where(flags)] = !values.f_nan
    map[where(flags)] = !values.f_nan

    print,"Raw is red, sky is cyan, astrophysical is white, green is map2ts, yellow is atmos_model"

    lb = scans[0,scannum]
    ub = scans[1,scannum]

    wset,0
    for i = 0,n_e(gb)-1 do begin
        bolonum = gb[i]
        
        if keyword_set(doraw) then begin
            plot,raw[bolonum,lb:ub],col=240 ;,/xst ;,yrange=[-.5,.5]
            oplot,acb[bolonum,lb:ub]
            if keyword_set(iter0) then oplot,atm[bolonum,lb:ub],col=200
            if keyword_set(domap) then oplot,map[bolonum,lb:ub],col=150
            oplot,raw[bolonum,lb:ub]-acb[bolonum,lb:ub],col=100
        endif else begin
            plot,acb[bolonum,lb:ub],yrange=[-.1,.1]
            oplot,raw[bolonum,lb:ub],col=240 ;,/xst ;,yrange=[-.5,.5]
            if keyword_set(domap) then oplot,map[bolonum,lb:ub],col=150
            if keyword_set(iter0) then oplot,atm[bolonum,lb:ub],col=200
            oplot,raw[bolonum,lb:ub]-acb[bolonum,lb:ub],col=100
        endelse
;        oplot,map[gb[bolonum],lb:ub],col=240
;        oplot,atm[gb[bolonum],lb:ub],col=20
;        oplot,ts_map[gb[bolonum],*,s],col=4
        
        scan_stddev = stddev(acb[bolonum,lb:ub])

        blah = ''
        read,blah,prompt="scan stddev: " + strc(scan_stddev) + " bolo "+strc(bolonum)
        if blah eq 'q' then break
        
    endfor

end



pro compare_iters,filename,iters,bolonum,scannum,doraw=doraw,iter0=iter0,domap=domap,overplot=overplot

    fn = filename
    print,"Raw is red, sky is cyan, astrophysical is white (if iter0, green is intermediate astro signal)"
    loadct,12
    num_index = strlen(filename)-4
    for i = 0,n_e(iters)-1 do begin
        filename = strmid(filename,0,num_index) + strc(iters[i]) + ".nc"
        read_ncdf_vars,filename,ac_bolos=acb,bolo_params=bp,raw=raw,scans_info=scans,flags=flags,map_model=map,atmos_model=atm
        nscans = n_e(scans[0,*])
        gb = where(bp[0,*],ngb)
        acb[where(flags)] = !values.f_nan
        if n_e(atm) gt 0 then atm[where(flags)] = !values.f_nan
        if n_e(raw) gt 0 then raw[where(flags)] = !values.f_nan
        if n_e(map) gt 0 then map[where(flags)] = !values.f_nan
        if i eq 0 then begin
            acbarr = acb
            if ~keyword_set(overplot) then begin
                atmarr = atm
                rawarr = raw
                maparr = map
            endif
        endif else begin
            acbarr = [[acbarr],[acb]]
            if ~keyword_set(overplot) then begin
                atmarr = [[atmarr],[atm]]
                rawarr = [[rawarr],[raw]]
                maparr = [[maparr],[map]]
            endif
        endelse           

        lb = scans[0,scannum]
        ub = scans[1,scannum]
        if keyword_set(overplot) then begin
            if i eq 0 then plot,acb[bolonum,lb:ub] $
                else oplot,acb[bolonum,lb:ub],color=i*256/n_e(iters)
            if keyword_set(polyfit) then begin
                x = findgen(n_e(acb[bolonum,lb:ub]))
                a = poly_fit(x,acb[bolonum,lb:ub],polyfit)
                oplot,poly(x,a),color=200
            endif
        endif else begin
            if keyword_set(doraw) then begin
                plot,raw[bolonum,lb:ub],col=240 ;,/xst ;,yrange=[-.5,.5]
                oplot,acb[bolonum,lb:ub]
                ;oplot,raw[bolonum,lb:ub]-acb[bolonum,lb:ub],col=100
                if keyword_set(iter0) and n_e(atm) gt 0 then oplot,atm[bolonum,lb:ub],col=200
                if keyword_set(domap) and n_e(map) gt 0 then oplot,map[bolonum,lb:ub],col=150
            endif else begin
                plot,acb[bolonum,lb:ub],yrange=[-.1,.1]
                oplot,raw[bolonum,lb:ub],col=240 ;,/xst ;,yrange=[-.5,.5]
                ;oplot,raw[bolonum,lb:ub]-acb[bolonum,lb:ub],col=100
                if keyword_set(iter0) and n_e(atm) gt 0 then oplot,atm[bolonum,lb:ub],col=200
                if keyword_set(domap) and n_e(map) gt 0 then oplot,map[bolonum,lb:ub],col=150
           endelse
       endelse
        
        blah = ''
        read,blah,prompt="iter "+strc(iters[i])
        if blah eq 'q' then break
        
    endfor
    filename=fn
end

function logscale,data
    logdata = alog(data)
    logdata[where(~finite(logdata))] = 0
    return,logdata
end

pro waterfall,filename,psd=psd
    if keyword_set(psd) then begin
        ncdf_varget_scale,filename,'psd_freq',psd_freq
        ncdf_varget_scale,filename,'psd_psd',psd_psd
        ncdf_varget_scale,filename,'psd_avebolo',psd_avebolo
        ncdf_varget_scale,filename,'psd_avescan',psd_avescan
        ncdf_varget_scale,filename,'psd_freq_avescan',psd_freq_avescan
        ncdf_varget_scale,filename,'psd_aveobs',psd_aveobs
        ncdf_varget_scale,filename,'psd_avescan',psd_avescan
    endif
    atv,psd_avescan
end

pro compare_mean_psds,filename
    read_ncdf_vars,filename,ac_bolos=ac_bolos,raw=raw,flags=flags,scans_info=scans_info,bolo_params=bolo_params,atmos_model=atmos_model,map_model=map_model
    acb_psd = all_psds(ac_bolos,scans_info,flags=flags,bolo_params=bolo_params)
    if n_e(raw) gt 0 then raw_psd = all_psds(raw,scans_info,flags=flags,bolo_params=bolo_params)
    if n_e(atmos_model) gt 0 then atmos_psd = all_psds(transpose(atmos_model),scans_info,bolo_params=[1])
    if n_e(map_model) gt 0 then map_psd = all_psds(map_model,scans_info,flags=flags,bolo_params=bolo_params)

    print,n_e(raw),n_e(ac_bolos),n_e(atmos_model),n_e(map_model)

    loadct,13
    plot,median(median(acb_psd,dim=2),dim=1),/ylog,color=255
    if n_e(raw) gt 0 then oplot,median(median(raw_psd,dim=2),dim=1),color=70
    if n_e(atmos_model) gt 0 then oplot,median(median(atmos_psd,dim=2),dim=1),color=140
    if n_e(map_model) gt 0 then oplot,median(median(map_psd,dim=2),dim=1),color=210
end



