;    """This is an implementation of the standard Hoegbom clean deconvolution 
;    algorithm, which operates on the assumption that the image is composed of
;    point sources.  This makes it a poor choice for images with distributed 
;    flux.  The algorithm works by iteratively constructing a model.  Each 
;    iteration, a point is added to this model at the location of the maximum 
;    residual, with a fraction (specified by 'gain') of the magnitude.  The 
;    convolution of that point is removed from the residual, and the process
;    repeats.  Termination happens after 'maxiter' iterations, or when the
;    clean loops starts increasing the magnitude of the residual.
;    im: The image to be deconvolved.
;    ker: The kernel to deconvolve by (must be same size as im).
;    mdl: An a priori model of what the deconvolved image should look like.
;    gain: The fraction of a residual used in each iteration.  If this is too
;        low, clean takes unnecessarily long.  If it is too high, clean does
;        a poor job of deconvolving.
;    maxiter: The maximum number of iterations performed before terminating.
;    chkiter: The number of iterations between when clean checks if the 
;        residual is increasing.
;    verbose: If true, prints some info on how things are progressing."""
;    dim = im.shape[1]
function hogbom_clean,im,ker,mdl=mdl,gain=gain,maxiter=maxiter,chkiter=chkiter,verbose=verbose,model=model
    if ~(keyword_set(gain)) then gain = .2
    if ~(keyword_set(maxiter)) then maxiter = 1000
    if ~(keyword_set(chkiter)) then chkiter = 100
    if ~(keyword_set(verbose)) then verbose = 0
    dim = size(im,/dim)
    ; NEED TO FIX KERNEL SIZE: small kernels are not acceptable
    new_ker = dblarr(dim)
    ker_dim = size(ker,/dim)
    shiftx = floor((dim[0]-ker_dim[0])/2.)
    shifty = floor((dim[1]-ker_dim[1])/2.)
    new_ker[shiftx:shiftx+ker_dim[0]-1,shifty:shifty+ker_dim[1]-1] = ker
    ker = new_ker

    dim = dim[0]
    ker_pwr = total(ker)
    m = max(ker,argm)
    kerx = argm / dim
    kery = argm mod dim
    G = ker_pwr / gain
    if ~keyword_set(mdl) then mdl = fltarr(size(im,/dim))
    dif = im - convolve(mdl,ker)
    score = mean(dif^2,/nan)
    prev_a = 0
    n_mdl = mdl
    n_dif = dif
    mode = 0
;   Begin the clean loop
    for i=0,maxiter do begin
    ; Rather than perform a convolution each loop, we'll just subtract
    ; from the residual a scaled kernel centered on the point just added,
    ; and to avoid recentering the kernel each time (because clean often
    ; chooses the same point over and over), we'll buffer the previous one.
            m = max(n_dif,a,/nan)
            if ~(a eq prev_a) then begin
                prev_a = a
                rec_ker = shift(ker,-(kery - (a mod dim)),-(kerx-a/dim))
            endif
            v = n_dif[a] / G
            n_mdl[a] = n_mdl[a] + v
            n_dif = n_dif - v * rec_ker
            if (i mod chkiter eq 0) then begin
    ;            # Check in on how clean is progressing.  Potenially terminate.
                n_score = mean(abs(n_dif)^2,/nan)
                print,"i: ",i,"   n_score:",n_score,"  score:",score
            endif
            if verbose then print,"v: ",v,"   n_dif[a]: ",n_dif[a],"  G: ",G," a: ",a," m: ",m,"  score: ",score,"  n_score:",n_score
            if verbose then print,i,n_score,score
            if (n_score gt score and i gt 0 and i mod chkiter eq 0) then begin
                n_mdl = mdl
                n_dif = dif
                print,"In last if, model max: ",max(n_mdl,/nan),"  n_dif max: ",max(n_dif,/nan)
                print,"Quitting with n_score = ",n_score," > score = ",score
                break
            endif
    ;    If we're still doing fine, buffer this solution as the new best.
            score = n_score
            mdl = n_mdl
            dif = n_dif
    endfor
    model = im - n_dif
    return,n_dif
end
