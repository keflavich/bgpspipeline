function hex_grid_fit_func, X, A
;
; $Id: hex_grid_fit_func.pro,v 1.1 2003/10/13 17:58:31 observer Exp $
; $Log: hex_grid_fit_func.pro,v $
; Revision 1.1  2003/10/13 17:58:31  observer
; Implenting SG's email suggestions for archive reorg.
;
;
;+
; NAME:
;       hex_grid_fit_func
;
; PURPOSE:
;       Calculates a real, physical hexagonal grid from an ideal, 
;       nondimensional hexagonal grid.  That is, given a set of
;       (r, theta) points, where r is in units of grid-point spacing,
;       calculate the physical position of these points given
;       the parameters A.  
;      
;
; CALLING SEQUENCE:
;       result = hex_grid_fit_func, X, A
;
; INPUTS:
;       X = (r,theta) ideal nondimensional positions of points,
;           n_points x 2 matrix, theta in radians
;       A = parameters to use to convert X to physical positions:
;           A[0] = scale factor: physical units per unit increment in r
;           A[1] = center offset in x
;           A[2] = center offset in y
;           A[3] = rotation angle about the offset center, 
;                  CCW = positive, radians
;
; OUTPUTS: 
;      An matrix of size n_points x 2 containing the (x,y) physical
;      positions of the points.
;
; MODIFICATION HISTORY:
;      2003/01/26 SG
;-

ON_ERROR,2                      ;Return to caller if an error occurs

sz = size(X, /dim)
if (sz[1] ne 2) then begin
   message, 'X calling parameter must be a n_points x 2 matrix'
endif
n_points = sz[0]

result = dblarr(size(X, /dim))

; first calculate the physical positions without the center offset
result[*,0] = X[*,0] * A[0] * cos(X[*,1] + A[3])
result[*,1] = X[*,0] * A[0] * sin(X[*,1] + A[3])

; then apply offset
result[*,0] = result[*,0] + A[1]
result[*,1] = result[*,1] + A[2]

return, result

end
