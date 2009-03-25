; bolopairs returns a 2 x n list of pairs of bolometers with baselines
; in the range (minlen,maxlen) that are NOT FLAGGED OUT in the bolopars array
; INPUTS:
;       minlen,maxlen - input variables for bolopairs specifying the minimum/maximum baseline length to use
;       bolo_params   - necessary list of bolometers; should come from NCDF bolo_params variable
function bolopairs,minlen=minlen,maxlen=maxlen,bolo_params=bolo_params

    ; how many good bolos are there?  Assumes good bolos have index 0 equal to 1
    n = uint(total(bolo_params[0,*]))

    ; convert angles into cartesian coordinates
    bolo_angle = bolo_params[1,where(bolo_params[0,*])]
    bolo_cendist = bolo_params[2,where(bolo_params[0,*])]
    one_vec = (1.+fltarr(n)) ; used instead of 'rebin' below
    bolo_x = (cos(bolo_angle*!dtor) * bolo_cendist)
    bolo_y = (sin(bolo_angle*!dtor) * bolo_cendist)
    ; n x n arrays of delta-x, delta-y
    dx = one_vec#bolo_x - transpose(bolo_x##one_vec)
    dy = one_vec#bolo_y - transpose(bolo_y##one_vec)
    d = sqrt(dx^2+dy^2) ; distance array (two-D)

    ; find where distance is within specified range
    if keyword_set(minlen) then gtmin = d gt minlen $
        else gtmin = (1+bytarr(size(d,/dim)))
    if keyword_set(maxlen) then ltmax = d lt maxlen $
        else ltmax = (1+bytarr(size(d,/dim)))
    
    ; we're only concerned with half of the above matrix
    ; this looks really complicated: trust that it gives a matrix with ones on and above the diagonal,
    ; or test it yourself... simple enough to specify n
    upper_tri_mask = rebin(transpose(indgen(n)),n,n,/sample) le rebin(indgen(n),n,n,/sample)
    inrange = ltmax * gtmin * upper_tri_mask

    ; use the x-y coordinates of the inrange matrix to determine which pairs are needed
    bolopairs = transpose( [ [where(inrange) mod n] , [where(inrange) / n] ] )

    return,bolopairs
end

