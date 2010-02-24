;
;
pro plane_sky,ac_bolos,ra,dec
    
    dra  = (ra  - median(ra))*cos(!dtor*dec)
    ddec = (dec - median(dec))
    
    dx = dra/(max(dra)-min(dra)) * 20.
    dy = ddec/(max(ddec)-min(ddec)) * 20.

    minimap = fltarr(n_e(ac_bolos[0,*]),10,10)
    for i=0,n_e(ac_bolos[*,0])-1 do begin
        minimap[*,dx[i],dy[i]] = ac_bolos[i,*]
    endfor

    model = quad_skysub_mp(findgen(10),findgen(10),params)

end
