
; a vectorized version of stddev
; if you have an n-dimensional array, returns the standard deviation
; along the specified dimension
; will ignore nan values if passses the nan keyword
function stddevaxis,x,dimension=dimension,nan=nan,mad=mad,_extra=extra 

    dimsize = size(x,/dim)

    if keyword_set(dimension) then begin
        if keyword_set(mad) then begin
            dimmedian = median(x,dim=dimension)
            absdev = abs(x-dimmedian#replicate(1,dimsize[dimension-1]))
            mad = median(absdev,dim=dimension)/.6745
            return,mad
        endif else begin
            dimmean = total(x,dimension,nan=nan) / float(dimsize[dimension-1])
            dimvar = total( (x - dimmean#replicate(1,dimsize[dimension-1]))^2 ,dimension,nan=nan ) / float(dimsize[dimension-1])
            dimstd = sqrt(dimvar)
            return,dimstd
        endelse
    endif else return,stddev(x,nan=nan,_extra=extra)
end


