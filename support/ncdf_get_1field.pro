pro ncdf_get_1field, file, varname, z, name
;+
; Get a variable and its metadata from a NetCDF file
;
; Written 1 April 1993 by William Weibel, UCLA Atmospheric Sciences
;
; Source code control Id %W%	%G%
;
; USEAGE:    ncdf_get_1field, file, varname, z, name
;
; arguments
;	file		string containing the name of the NetCDF file
;	varname		name of the variable to read (string)
;	z		dependent field variable, any data type
;       name            ?
;
; bugs
;	only gets data, doesn't slice yet
;	assumes the field is rectilinear.
;	The way multiple coordinate arrays are allocated is not pretty
;	  passes only up to nine dimensions
;-

fid = ncdf_open(file)

; Find out how many dimensions are in the field, allocate an array
; and get the coordinates

var = ncdf_varinq( fid, varname )
IF (var.ndims gt 0) then BEGIN
  name = strarr(var.ndims)
  dimension = intarr(var.ndims)
  FOR ndim = 0,var.ndims-1 DO BEGIN
    ncdf_diminq, fid, var.dim(ndim), buffer, size
    name(ndim) = buffer
    dimension(ndim) = size
  ENDFOR
ENDIF
;
; get the field variable
;
ncdf_varget, fid, varname, z
;
ncdf_close,fid

return
end
