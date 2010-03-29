; pca_subtract
; returns two output variables : the n most correlated components and the n_bolo - n least...
; in timestream space....
; INPUTS:
;   timestream - input timestream (generally, raw - astro
;   n_comp     - number of pca components to remove
pro pca_subtract,timestream,n_comp,lower_n=lower_n,corr_part=corr_part,uncorr_part=uncorr_part
    if ~keyword_set(lower_n) then lower_n = 0
    time_s,"BEGINNING PCA SUBTRACTION OF COMPONENTS " + strc(lower_n) + " TO " + strc(n_comp) + " ... ",t0

;        if total(flags) gt 0 then source_sub[where(flags)] = 0
;        print,"Dimensions of source_sub array: " + strc(size(source_sub,/dim))
;        print,"Number of NANs: ",n_e(where(finite(source_sub,/nan)))

        nan_ind = where(finite(timestream,/nan))
        if n_e(nan_ind) gt 1 then timestream[nan_ind] = 0 $
            else if ~(nan_ind eq -1) then timestream[nan_ind] = 0 
        cov_mat = timestream # transpose(timestream)
        evals = eigenql(cov_mat,eigenvectors=evects)
        efuncs = timestream ## transpose(evects)
        atmos_efuncs = efuncs
        if lower_n ne 0 then atmos_efuncs[0:lower_n-1,*]=0
        atmos_efuncs[n_comp:*,*]=0
        efuncs[lower_n:n_comp-1,*] = 0
        uncorr_part = efuncs ## evects
        corr_part = atmos_efuncs ## evects
    if ~keyword_set(quiet) then time_e,t0
end

