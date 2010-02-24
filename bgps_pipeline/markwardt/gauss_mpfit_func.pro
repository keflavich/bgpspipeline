function gauss_mpfit_func, X, A
;+
; NAME:
;       gauss_mpfit_func
;
; PURPOSE:
;       Routine to return a  gaussian of the form
;
;       z = A[3] + A[2] * exp( - (x - A[0])^2/ (2 * A[1]^2) )
;

; CALLING SEQUENCE:
;       result = gauss_mpfit_func(X, A)
;
; INPUTS:
;       X = array consisting of the x coordinates
;       A = parameters of fit as given above
;
; OUTPUTS: 
;      The function values in an array of length n_elements(X)
;
; MODIFICATION HISTORY:
;      2003/02/10 SG
;      2003/05/13 SG Rename to gauss_mpfit_func because of conflict with
;                    lmfit version.
;      2003/09/27 SG Modify so that A[3] is optional
;-

   ON_ERROR,2                      ;Return to caller if an error occurs

   xtrans = X - A[0]
   f = A[2] * exp( - 0.5 * (xtrans/A[1])^2 )

   if (n_elements(A) gt 3) then f = f + A[3]

   return, f

end




