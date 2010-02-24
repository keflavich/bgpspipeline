FUNCTION min_curve_surf, z, x, y, REGULAR = regular, XGRID=xgrid, $
	XVALUES = xvalues, YGRID = ygrid, YVALUES = yvalues, $
	GS = gs, BOUNDS = bounds, NX = nx0, NY = ny0, XOUT=xout, $
	YOUT=yout, XPOUT=xpout, YPOUT=ypout
;
; Copyright (c) 1993, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;	MIN_CURVE_SURF
;
; PURPOSE:
;	Interpolate a regular or irregularly gridded set of points
;	with a minimum curvature spline surface.
; CATEGORY:
;	Interpolation, Surface Fitting
; CALLING SEQUENCE:
;	Result = min_curve_surf(z [, x, y])
; INPUTS:
;	X, Y, Z = arrays containing the x, y, and z locations of the
;		data points on the surface.  Need not necessarily be
;		regularly gridded.  For regularly gridded input data,
;		X and Y are not used, the grid spacing is specified
;		via the XGRID or XVALUES, and YGRID or YVALUES,
;		keywords, and Z must be a two dimensional array.
;		For irregular grids, all three parameters must be present
;		and have the same number of elements.
; KEYWORD PARAMETERS:
;  Input grid description:
;	REGULAR = if set, the Z parameter is a two dimensional array,
;		of dimensions (N,M), containing measurements over a
;		regular grid.  If any of XGRID, YGRID, XVALUES, YVALUES
;		are specified, REGULAR is implied.  REGULAR is also
;		implied if there is only one parameter, Z.  If REGULAR is
;		set, and no grid (_VALUE or _GRID) specifications are present,
;		the respective grid is set to (0, 1, 2, ...).
;	XGRID = contains a two element array, [xstart, xspacing],
;		defining the input grid in the X direction.  Do not specify
;		both XGRID and XVALUES.
;	XVALUES = if present, Xvalues(i) contains the X location
;		of Z(i,j).  Xvalues must be dimensioned with N elements.
;	YGRID, YVALUES = same meaning as XGRID, XVALUES except for the
;		Y locations of the input points.
;  Output grid description:
;
;	GS =  spacing of output grid.
;		If present, GS a two-element vector 
;	        [XS, YS], where XS is the horizontal spacing between 
;        	grid points and YS is the vertical spacing. The 
;        	default is based on the extents of X and Y. If the 
;        	grid starts at X value Xmin and ends at Xmax, then the 
;        	default horizontal spacing is  (Xmax - Xmin)/(NX-1).
;	        YS is computed in the same way. The default grid
;		size, if neither NX or NY are specified, is 26 by 26.
;	BOUNDS = a four element array containing the grid limits in X and
;		Y of the output grid:  [ Xmin, Ymin, Xmax, Ymax].
;		If not specified, the grid limits are set to the extend
;		of X and Y.
;	NX = Output grid size in the X direction.  Default = 26, need
;		not be specified if the size can be inferred by
;		GS and BOUNDS.
;	NY = Output grid size in the Y direction.  See NX.
;	XOUT = a vector containing the output grid X values.  If this
;		parameter is supplied, GS, BOUNDS, and NX are ignored
;		for the X output grid.  Use this parameter to specify
;		irregular spaced output grids.
;	YOUT = a vector containing the output grid in the Y direction.
;		If this	parameter is supplied, GS, BOUNDS, and NY are 
;		ignored	for the Y output grid.
;	XPOUT, YPOUT = arrays containing X and Y values for the output
;		points.  With these keywords, the output grid need not
;		be regular, and all other output grid parameters are
;		ignored.  XPOUT and YPOUT must have the same number of
;		points, which is also the number of points returned in
;		the result.
; OUTPUTS:
;	A two dimensional floating point array containing the interpolated
;	surface, sampled at the grid points.
; COMMON BLOCKS:
;	None.
; SIDE EFFECTS:
;	None.
; RESTRICTIONS:
;	Limited by the single precision floating point accuracy of the
;	machine.
;		SAMPLE EXECUTION TIMES  (measured on a Sun IPX)
;	# of input points	# of output points	Seconds
;	16			676			0.19
;	32			676			0.42
;	64			676			1.27
;	128			676			4.84
;	256			676			24.6
;	64			256			1.12
;	64			1024			1.50
;	64			4096			1.97
;	64			16384			3.32
;
; PROCEDURE:
;	A minimum curvature spline surface is fitted to the data points
;	described by X,Y, and Z.  The basis function:
;		C(x0,x1, y0,y1) = d^2 log(d),
;	where d is the distance between (x0,y0), (x1,y1), is used,
;	as described by Franke, R., Smooth interpolation of scattered
;	data by local thin plate splines: Computers Math With Applic.,
;	v.8, no. 4, p. 273-281, 1982.  For N data points, a system of N+3 
;	simultaneous equations are solved for the coefficients of the 
;	surface.  For any interpolation point, the interpolated value
;	is:
;	  F(x,y) = b(0) + b(1)*x + b(2)*y + Sum(a(i)*C(X(i),x,Y(i),y))
;
; EXAMPLE:  IRREGULARLY GRIDDED CASES
;	Make a random set of points that lie on a gaussian:
;	n = 15		;# random points
;	x = RANDOMU(seed, n)
;	y = RANDOMU(seed, n)
;	z = exp(-2 * ((x-.5)^2 + (y-.5)^2))  ;The gaussian
;
; get a 26 by 26 grid over the rectangle bounding x and y:
;	r = min_curve_surf(z, x, y)	;Get the surface.
; Or: get a surface over the unit square, with spacing of 0.05:
;	r = min_curve_surf(z, x, y, GS=[0.05, 0.05], BOUNDS=[0,0,1,1])
; Or: get a 10 by 10 surface over the rectangle bounding x and y:
;	r = min_curve_surf(z, x, y, NX=10, NY=10)
;
;		REGULARLY GRIDDED CASES
;	z = randomu(seed, 5, 6)		;Make some random data
;		interpolate to a 26 x 26 grid:
;	CONTOUR, min_curve_surf(z, /REGULAR)
;
; MODIFICATION HISTORY:
;	DMS, RSI, March, 1993.  Written.
;	DMS, RSI, July, 1993.   Added XOUT and YOUT.
;-


ON_ERROR, 2
s = size(z)		;Assume 2D
nx = s(1)
ny = s(2)

reg = keyword_set(regular) or (n_params() eq 1)

if n_elements(xgrid) eq 2 then begin
	x = findgen(nx) * xgrid(1) + xgrid(0)
	reg = 1
endif else if n_elements(xvalues) gt 0 then begin
	if n_elements(xvalues) ne nx then $
		message,'Xvalues must have '+string(nx)+' elements.'
	x = xvalues
	reg = 1
endif

if n_elements(ygrid) eq 2 then begin
	y = findgen(ny) * ygrid(1) + ygrid(0)
	reg = 1
endif else if n_elements(yvalues) gt 0 then begin
	if n_elements(yvalues) ne ny then $
		message,'Yvalues must have '+string(ny)+' elements.'
	y = yvalues
	reg = 1
endif

if reg then begin
	if s(0) ne 2 then message,'Z array must be 2D for regular grids'
	if n_elements(x) ne nx then x = findgen(nx)
	if n_elements(y) ne ny then y = findgen(ny)
	x = x # replicate(1., ny)	;Expand to full arrays.
	y = replicate(1.,nx) # y
	endif

n = n_elements(x)
if n ne n_elements(y) or n ne n_elements(z) then $
	message,'x, y, and z must have same number of elements.'

m = n + 3			;# of eqns to solve
a = fltarr(m, m)		;LHS

for i=0, n-2 do for j=i+1,n-1 do begin
	d = (x(i)-x(j))^2 + (y(i)-y(j))^2 > 1.0e-8  ;Distance squared...
	d = d * alog(d)/2.0	;d^2 * alog(d)
	a(i+3,j) = d
	a(j+3,i) = d
	endfor

a(0,0:n-1) = 1		; fill rest of array
a(1,0:n-1) = reform(x,1,n)
a(2,0:n-1) = reform(y,1,n)

a(3:m-1,n) = 1.
a(3,n+1) = reform(x, n, 1)
a(3,n+2) = reform(y, n, 1)

b = fltarr(m)		;Right hand side
b(0) = reform(z,n,1)

c = b # invert(a)	;Solution using inverse
;  c = svd_solve(transpose(a),b)	;solution using svd


if n_elements(XPOUT) gt 0 then begin	;Explicit output locations?
  if n_elements(YPOUT) ne n_elements(XPOUT) then $
	message, 'XPOUT and YPOUT must have same number of points'
endif else begin			;Regular grid
  if n_elements(bounds) lt 4 then begin	;Bounds specified?
	xmin = min(x, max = xmax)
	ymin = min(y, max = ymax)
	bounds = [xmin, ymin, xmax, ymax]
	endif

  if n_elements(gs) lt 2 then begin	;GS specified?  No.
    if n_elements(nx0) le 0 then nx = 26 else nx = nx0 ;Defaults for nx and ny
    if n_elements(ny0) le 0 then ny = 26 else ny = ny0
    gs = [(bounds(2)-bounds(0))/(nx-1.), $
	   (bounds(3)-bounds(1))/(ny-1.)]
  endif else begin			;GS is specified?
    if n_elements(nx0) le 0 then $
	nx = ceil((bounds(2)-bounds(0))/gs(0)) + 1 $
    else nx = nx0
    if n_elements(ny0) le 0 then $
	ny = ceil((bounds(3)-bounds(1))/gs(1)) + 1 $
    else ny = ny0
  endelse


  if n_elements(xout) gt 0 then begin		;Output grid specified?
	nx = n_elements(xout)
	xpout = xout
  endif else xpout = gs(0) * findgen(nx) + bounds(0)

  if n_elements(yout) gt 0 then begin
	ny = n_elements(yout)
	ypout = yout
  endif else ypout = gs(1) * findgen(ny) + bounds(1)
  xpout = xpout # replicate(1.,ny)
  ypout = replicate(1., nx) # ypout
endelse					;Regular grid

s = c(0) + c(1) * xpout + c(2) * ypout		;First terms
for i=0, n-1 do begin
	d = (xpout-x(i))^2 + (ypout-y(i))^2 > 1.0e-8  ;Distance
	s = s + d * alog(d)* (c(i+3)/2.0)
	endfor
return, s
end

