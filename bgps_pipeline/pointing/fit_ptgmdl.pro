function fit_ptgmdl,myx,myy,dx,dy,p0=p0

    guess_xx = reform(poly_fit(myx,dx,3))
    guess_xy = reform(poly_fit(myx,dy,3))
    guess_yx = reform(poly_fit(myy,dx,3))
    guess_yy = reform(poly_fit(myy,dy,3))
    ;x = transpose([[myx],[myy]])
    x = [myx,myy]
    ;y = transpose([[realx],[realy]])
    ;y = [realx,realy]
    ;d = transpose([[dx],[dy]])
    d = [dx,dy]
    e = dblarr(size(d,/dim)) + 1.
    if n_e(p0) ne 16 then p0 = [guess_xx,guess_yx,guess_xy,guess_yy]
    p = mpfitfun('ptgmdl',x,d,e,p0,/quiet)
    return,p
end

