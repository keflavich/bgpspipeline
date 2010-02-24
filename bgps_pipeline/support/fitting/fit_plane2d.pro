
function fit_plane2d,z,p,err,x,y,znew=znew

  if n_elements(x) eq 0 then x = indgen(n_e(z[*,0]))
  if n_elements(y) eq 0 then y = indgen(n_e(z[0,*]))

  ;; Make 2D arrays of X and Y values -- if the user hasn't done it
  if n_elements(x) NE n_elements(z) then   xx = x[*] # (y[*]*0 + 1)   else xx = x
  if n_elements(y) NE n_elements(z) then   yy = (x[*]*0 + 1) # y[*]   else yy = y

  if n_e(p) ne 3 then p = [0.0,1.0,0.0,1.0,0.0]
;  if n_e(err) ne n_e(z) then err = (z*0)+1.0

  p = mpfit2dfun('plane2d',xx,yy,z,1,p,/quiet,yfit=yfit)

  znew = yfit

  return,p
end
