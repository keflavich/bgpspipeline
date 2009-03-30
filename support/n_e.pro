;$Id: n_e.pro,v 1.1 2003/11/17 18:53:38 jaguirre Exp $
;$Log: n_e.pro,v $
;Revision 1.1  2003/11/17 18:53:38  jaguirre
;Labor saving device.
;
;
;--------------------------------------------
;
; NAME:
;	N_E
;
; PURPOSE:
;	Avoid typing "lements"
;
; CALLING SEQUENCE:
;	RESULT = N_E(array)
;
; INPUTS:
;	array - an array
;
; OUTPUTS:
;	result - number of elements in array
;
; PROCEDURES USED:
;	n_elements
;
; MODIFICATION HISTORY:
;	Created, sometime long ago - CI
;       Used by TopHatters - JA
;-------------------------------------------------

function n_e, x

n_e = n_elements(x)

return, n_e

end
