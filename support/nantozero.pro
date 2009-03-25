; convert all nans in an array to zero
function nantozero,data,n_nans=n_nans
    n_nans = total(finite(data,/nan))
    if n_nans gt 0 then begin
        data[where(finite(data,/nan))] = 0
    endif
    return,data
end
