; z = p[0] + p[1] * (x-p[2]) + p[3] * (y-p[4])
; offset, xscale, xoff, yscale, yoff
; need to redo with error consideration included
function fit_plane2d,z,p,err,x,y,znew=znew,dompfit=dompfit

  if n_elements(x) eq 0 then x = indgen(n_e(z[*,0]))
  if n_elements(y) eq 0 then y = indgen(n_e(z[0,*]))

  ;; Make 2D arrays of X and Y values -- if the user hasn't done it
  if n_elements(x) NE n_elements(z) then   xx = x[*] # (y[*]*0 + 1)   else xx = x
  if n_elements(y) NE n_elements(z) then   yy = (x[*]*0 + 1) # y[*]   else yy = y

  if n_e(err) ne n_e(z) then err = (z*0)+1.0
  ; two-d linear least squares (analytic) solution
  x0  = double(min(x)); double(mean(x)) ; x0/y0 are unecessary b/c included in b
  y0  = double(min(y)); double(mean(y)) ; x0/y0 are unecessary b/c included in b
  sx  = double(total((x-x0)/err^2))
  sy  = double(total((y-y0)/err^2))
  sxy = double(total((x-x0)*(y-y0)/err^2))
  sx2 = double(total((x-x0)^2/err^2))
  sy2 = double(total((y-y0)^2/err^2))
  sb  = double(total(err^2))
  szx = double(total(z*(x-x0)/err^2))
  szy = double(total(z*(y-y0)/err^2))
  sz  = double(total(z/err^2))
  a1 = sz/sx  
  a2 = (sy*((-sb*sxy + sx*sy)*(sx2*sz - sx*szx) - (sx^2 -            $
     sb*sx2)*(sxy*sz - sx*szy)))/(                                   $
     sx*(-sb*sx*sxy^2 + 2*sx^2*sxy*sy - sx*sx2*sy^2 - sx^3*sy2 +     $ 
     sb*sx*sx2*sy2)) 
  a3 = (sb*((sxy*sz - sx*szy)/(-sb*sxy +                              $ 
     sx*sy) - ((-sxy*sy +                                           $ 
     sx*sy2)*((-sb*sxy + sx*sy)*(sx2*sz - sx*szx) - (sx^2 -          $ 
       sb*sx2)*(sxy*sz - sx*szy)))/((-sb*sxy + sx*sy)*(-sb*sx*sxy^2 +  $  
     2*sx^2*sxy*sy - sx*sx2*sy^2 - sx^3*sy2 + sb*sx*sx2*sy2))))/sx    
  ; error check because it is possible to have sx = 0 which leads to sbAsbs.
  ; While this IS possible, it shouldn't be.
  a = 0
  if finite(a1) then a+=a1
  if finite(a2) then a+=a2
  if finite(a3) then a+=a3
  b1 = -((sxy*sz - sx*szy)/(-sb*sxy + sx*sy)) 
  b2 = ((-sxy*sy +                                                  $ 
      sx*sy2)*((-sb*sxy + sx*sy)*(sx2*sz - sx*szx) - (sx^2 -         $ 
      sb*sx2)*(sxy*sz - sx*szy)))/((-sb*sxy + sx*sy)*(-sb*sx*sxy^2 +   $ 
      2*sx^2*sxy*sy - sx*sx2*sy^2 - sx^3*sy2 +                      $ 
      sb*sx*sx2*sy2))                                                 
  b = 0
  if finite(b1) then b+=b1
  if finite(b2) then b+=b2
  c1 = -(((-sb*sxy + sx*sy)*(sx2*sz -                                $ 
      sx*szx) - (sx^2 - sb*sx2)*(sxy*sz - sx*szy))/(-sb*sx*sxy^2 +    $ 
      2*sx^2*sxy*sy - sx*sx2*sy^2 - sx^3*sy2 + sb*sx*sx2*sy2))        
  if finite(c1) then c=c1 else c=0
  p = [b,a,x0,c,y0]
  znew = plane2d(xx,yy,p)
  if keyword_set(dompfit) then begin 
      if n_e(p) ne 3 then p = [0.0,1.0,0.0,1.0,0.0]
      p = mpfit2dfun('plane2d',xx,yy,z,1,p,/quiet,yfit=yfit)
      znew = yfit
  endif 

  return,p
end
