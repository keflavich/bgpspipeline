pro ncdf_get_field, file, varname, z, name, c0, c1, c2, c3, c4, c5, c6, c7, c8
;+
;ROUTINE: NCDF_GET_FIELD
; 
;Get a variable and its metadata from a NetCDF file.
; 
;Calling Sequence
;        ncdf_get_field, File, Varname, Z, Name, C0, C1, C2, ...
; 
;Arguments
; 
;        File
; 
;                A string containing the name of an existing NetCDF file.
; 
;        Varname
;                A string containing the name of the variable you want to
;                read, or an integer corresponding to a NetCDF variable
;                identifier.  
; 
;        Z
;                An array output by ncdf_get_field containing the dependent
;                variable given in Varname.  The procedure will determine the
;                data type and dimensions of the array from the information
;                in the NetCDF file.
; 
;        Name
;                An array of strings containing names for the coordinate axes,
;                i.e. the names of the independent variables.
; 
;        C0, C1, C2, ...
;                Arrays output by ncdf_get_field containing the coordinates,
;                i.e. independent variables, of the field.
; 
;Example
; 
;        Suppose you have a file called stuff.cdf, and you know it contains
;        a four-dimensional scalar variable called 't'.  You would read the
;        data this way.
; 
;              IDL> ncdf_get_field, 'stuff.cdf', 't', t, titles, x, y, z, time
;        
;        If you examine your IDL memory contents, you find the following
; 
;              IDL>help,t
;                T               FLOAT     = Array(60, 60, 10, 3)
; 
;        The data could be sliced and displayed like so
; 
;              IDL>sst = t(*,*,0,2)
;              IDL>contour,sst,x,y,max_value=9000
; 
;Bugs
;        only gets entire field, doesn't slice yet
;        The way multiple coordinate arrays are allocated is not pretty
;          passes only up to nine dimensions
;        Has not been tested on irregular fields
; 
;Author
;        William Weibel, UCLA Atmospheric Sciences
; 
;Last Revision Date
; 
;        1 April 1993  
;-

fid = ncdf_open(file)

; Find out how many dimensions are in the field, allocate an array
; and get the coordinates

var = ncdf_varinq( fid, varname )
name = strarr(var.ndims)
dimension = intarr(var.ndims)
for ndim = 0,var.ndims-1 do begin
	ncdf_diminq, fid, var.dim(ndim), buffer, size
	name(ndim) = buffer
	dimension(ndim) = size
endfor
;
; Allocate arrays to hold the coordinates
;
if var.ndims ge 1 then ncdf_varget, fid, name(0), c0
if var.ndims ge 2 then ncdf_varget, fid, name(1), c1
if var.ndims ge 3 then ncdf_varget, fid, name(2), c2
if var.ndims ge 4 then ncdf_varget, fid, name(3), c3
if var.ndims ge 5 then ncdf_varget, fid, name(4), c4
if var.ndims ge 6 then ncdf_varget, fid, name(5), c5
if var.ndims ge 7 then ncdf_varget, fid, name(6), c6
if var.ndims ge 8 then ncdf_varget, fid, name(7), c7
if var.ndims ge 9 then ncdf_varget, fid, name(8), c8

;
; get a main title for the data (?)    MAYBE OBSOLETE
;

;
; get the field variable
;
ncdf_varget, fid, varname, z
;
ncdf_close,fid

return
end
