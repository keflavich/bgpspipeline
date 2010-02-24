function inv_hex_gff, X, A
; PURPOSE:
;       from a real hexagonal grid, calculates r theta
; CALLING SEQUENCE:
;       result = hex_grid_fit_func, X, A
; INPUTS:
;       X = (x,y) ideal nondimensional positions of points,
;           n_points x 2 matrix 
;       A = parameters to use to convert X to physical positions:
;           A[0] = scale factor: physical units per unit increment in r
;           A[1] = center offset in x
;           A[2] = center offset in y
;           A[3] = rotation angle about the offset center, 
;                  CCW = positive, radians
; OUTPUTS: 
;      An matrix of size n_points x 2 containing the (r,theta) physical
;      positions of the points, theta in radians

ON_ERROR,2                      ;Return to caller if an error occurs

sz = size(X, /dim)
if (sz[1] ne 2) then begin
   message, 'X calling parameter must be a n_points x 2 matrix'
endif
n_points = sz[0]

result = dblarr(size(X, /dim))
xnew = dblarr(size(X, /dim))

; first apply offset
xnew[*,0] = x[*,0]/(A[0]*cos(A[5])+A[4]*sin(A[5])) - A[1]
xnew[*,1] = x[*,1]/(A[4]*cos(A[5])+A[0]*sin(A[5])) - A[2]
;result[*,0] = result[*,0] + A[1]
;result[*,1] = result[*,1] + A[2]

result[*,0] = sqrt(xnew[*,0]^2 + xnew[*,1]^2)
result[*,1] = atan(xnew[*,1],xnew[*,0])-A[3]

; then calculate the physical positions without the center offset
; result[*,0] = X[*,0] * A[0] * cos(X[*,1] + A[3])
; result[*,1] = X[*,0] * A[0] * sin(X[*,1] + A[3])


return, result

end
