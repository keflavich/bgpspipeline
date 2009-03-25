function compare_me_meredith,meredith_in,me_in,gv=gv
    restore,meredith_in
    az_meredith = az
    restore,me_in
    n_meredith = n_e(date_obs_list)
    n_me = n_e(name)

    if n_e(obsname) eq 0 then begin
        obsname = strarr(n_me)
        for i=0,n_me-1 do  obsname[i] = stregex(name[i],'[0-9]{6}_o[b0-9][0-9]',/extract)   
    endif

    blank = dblarr(n_meredith)

    whbad = where_arr(date_obs_list,badobs)
    indarr = intarr(n_meredith)+1
    if size(whbad,/dim) gt 0 then indarr[whbad] = 0
    whgood = where(indarr)

    compare = create_struct($
        ['obsname','fazo_new','fzao_new','fazo_set','fzao_set', $
        'fazo','fzao','altoff','azoff_dist','azoff','raoff','raoff_dist','decoff',$
        'jd','alt','az','el','za','az_meredith','dx','dy','ra','dec','myra','mydec',$
        'objra','objdec','lst'],strarr(n_meredith),blank,blank,blank,$
        blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,$
        blank,blank,blank,blank,blank,blank,blank,blank,blank,blank,blank)
            
    for i=0,n_meredith-1 do begin

        if indarr[i] then begin
            match = 0
            for j=0,n_me-1 do begin

                if date_obs_list[i] eq obsname[j] then begin
                    match = 1
                    if (xpix[j] ne -1) then myfit_good = 1D else myfit_good = !values.f_nan
                    compare.obsname[i]       = obsname[j]
                    compare.fazo_new[i]      = fazo_new[i]
                    compare.fzao_new[i]      = fzao_new[i]
                    compare.fazo_set[i]      = fazo_set[i]
                    compare.fzao_set[i]      = fzao_set[i]
                    compare.fazo[i]          = fazo[j]*myfit_good
                    compare.fzao[i]          = fzao[j]*myfit_good
                    compare.altoff[i]        = altoff[j]*myfit_good
                    compare.azoff[i]         = azoff[j]*myfit_good
                    compare.azoff_dist[i]    = azoff_dist[j]*myfit_good
                    compare.raoff[i]         = raoff[j]*myfit_good
                    compare.raoff_dist[i]    = raoff[j] * cos(!dtor*dec[j])*myfit_good
                    compare.decoff[i]        = decoff[j]*myfit_good
                    compare.jd[i]            = jd[j]*myfit_good
                    compare.lst[i]           = lst[j]*myfit_good
                    compare.alt[i]           = alt[j]*myfit_good
                    compare.az[i]            = az[j]*myfit_good
                    compare.myra[i]          = ra[j]*myfit_good
                    compare.mydec[i]         = dec[j]*myfit_good
                    compare.objra[i]         = objra[j]*myfit_good
                    compare.objdec[i]        = objdec[j]*myfit_good
                    compare.el[i]            = el[i]
                    compare.za[i]            = za[i]
                    compare.az_meredith[i]   = az_meredith[i]
                    compare.dx[i]            = dx[i]
                    compare.dy[i]            = dy[i]
                    compare.ra[i]            = ra[j]*myfit_good
                    compare.dec[i]           = dec[j]*myfit_good
                endif 
            endfor
            if match eq 0 then compare.obsname[i] = 'null'
        endif else compare.obsname[i] = 'null'
    endfor
    
    gv = where(compare.obsname ne 'null' and indarr)

    return,compare
end
