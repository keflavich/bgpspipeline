; view each efunc...
function single_pca_comp,timestream,n_comp
        nan_ind = where(finite(timestream,/nan))
        if n_e(nan_ind) gt 1 then timestream[nan_ind] = 0 $
            else if ~(nan_ind eq -1) then timestream[nan_ind] = 0 
        cov_mat = timestream # transpose(timestream)
        evals = eigenql(cov_mat,eigenvectors=evects)
        efuncs = timestream ## transpose(evects)
        if n_comp ne 0 then efuncs[0:n_comp-1,*] = 0
        if n_comp ne n_e(efuncs[0,*]) then efuncs[n_comp+1:*,*] = 0
        new_source = efuncs ## evects
        return,new_source
end

