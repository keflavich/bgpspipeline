
; psd flagging based on how close the PSD of each bolometer is to
; the median PSD for the whole observation
pro psd_flag_projection,psd_avescan=psd_avescan,bad_bolos=bad_bolos
    
    median_psd  = median(psd_avescan,dim=1)
    dot_product = total(psd_avescan*(median_psd # replicate(1,n_e(psd_avescan[*,0]))),2)/total(median_psd*median_psd)
    where_high  = where(dot_product) gt 1.5
    where_low   = where(dot_product) lt 0.5

    if keyword_set(bad_bolos) then bad_bolos = [badbolos,where_high,where_low] $
        else bad_bolos = [where_high,where_low]

end

