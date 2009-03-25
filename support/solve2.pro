 pro solve2,fu,fv,u,v,x,y,xrange,yrange,tol=tol,view=view
;+
; routine    solve2
; purpose    solve two simultaneous non-linear equations for variables
;            x and y.  In The non-linear equations are formally
;            expressed as,
;                           fu(x,y) = u
;                           fv(x,y) = v
; input:
;   fu       name of first non-linear function (string)
;   fv       name of second non-linear function (string)
;   u        rhs value of first non-linear function (scalor)
;   v        rhs value of second non-linear function (scalor)
;   x        first guess value for variable x (scalor)
;   y        first guess value for variable y (scalor)
;   xrange   reasonable range of x (i.e.,  [xmin, xmax] )
;   yrange   reasonable range of y (i.e.,  [ymin, ymax] )
;
; keyword input
;   view     plot convergence trace and print diagnostics
;   tol      convergence criterium (see below).
;   maxit    maximum number of iterations
;
;            Iteration terminates when one of the following 
;            conditions is true:
;
;            1. number of iterations exceeds MAXIT
;
;            2. x or y is pegged at their extreme values, 
;               given by XRANGE or YRANGE.
;
;            3. abs{fu(x,y)-u} lt TOL * u  and 
;               abs{fv(x,y)-v} lt TOL * v
; 
; output:
;   x        converged value of x
;   y        converged value of y
;
; 
; PROCEDURE:  the functions fu and fv should return both the values
;             of the non-linear function and their derivatives with respect
;             to x and y.  SOLVE2 assumes that these quantities are actually
;             implemented as procedures, so that all three values can be
;             obtained simply.  The argument list of the fu or fv procedures
;             should be set up as follows,
;
;             pro fu,x,y,uu,dudx,dudy
;               and
;             pro fv,x,y,vv,dvdx,dvdy
;
;             where uu    function value of fu at x,y
;                   dudx  partial derivative of fu with respect to x
;                   dudy  partial derivative of fu with respect to y
;                   vv    function value of fv at x,y
;                   dvdx  partial derivative of fv with respect to x
;                   dvdy  partial derivative of fv with respect to y
;
;             the equations are solved by newton-raphson iteration
;             
;
;  author:  Paul Ricchiazzi                            22mar93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
if keyword_set(tol) eq 0 then tol=.0001
;
niter=0
mxdx=.1*(xrange(1)-xrange(0))
mxdy=.1*(yrange(1)-yrange(0))
if keyword_set(view) then begin
  plot,xrange,yrange,/nodata
  plots,x,y,psym=-2
  print,form='(27x,a24,2e12.4)','(u,v)= ',u,v
  print,form='(6a12)','x','y','dx','dy','uu','vv'
endif
nomore=0
repeat begin
  niter=niter+1
  call_procedure,fu,x,y,uu,dudx,dudy
  call_procedure,fv,x,y,vv,dvdx,dvdy
  denom=dudx*dvdy-dvdx*dudy
  du=u-uu
  dv=v-vv
  dx=(du*dvdy-dv*dudy)/denom
  dy=(dudx*dv-dvdx*du)/denom
  if abs(dx) gt mxdx then dx=dx*mxdx/abs(dx)
  if abs(dy) gt mxdy then dy=dy*mxdy/abs(dy)
  if x ge xrange(1) and dx gt 0 then nomore=1
  if x le xrange(0) and dx lt 0 then nomore=1
  if y ge yrange(1) and dy gt 0 then nomore=1
  if y le yrange(0) and dy lt 0 then nomore=1
  if niter ge 20 then                nomore=1
  if abs(uu-u) lt tol*abs(u) and abs(vv-v) lt tol*abs(v) then nomore=1
  x=x+dx
  y=y+dy
  x=x > xrange(0) < xrange(1)
  y=y > yrange(0) < yrange(1)
  if keyword_set(view) then begin
    print,form='(i3,6e12.4)',niter,x,y,dx,dy,uu,vv
    if nomore then plots,x,y,/continue,psym=-5 else $
                   plots,x,y,/continue,psym=-4 
    xyouts,x,y,string(niter)
  endif
endrep until nomore
return
end






