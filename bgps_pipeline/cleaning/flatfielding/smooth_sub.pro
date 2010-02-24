
function smooth_sub,ts,sample_interval
    scanspeed = 120.                ; scan rate 120"/sec
    maxscale = 7.5 * 60.0           ; focal plane ~7.5'
    tvary = maxscale/scanspeed * 40.    
    svary = long(tvary/sample_interval)
    sgfilt = savgol(svary,svary,0,4)

    for i=0,n_e(ts[*,0])-1 do begin
        smoothed = convol(reform(ts[i,*]),sgfilt,/edge_trunc)
        ts[i,*] -= smoothed
    endfor
    
    return,ts
end
