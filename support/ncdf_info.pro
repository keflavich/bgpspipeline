pro ncdf_info,file,ofile
;+
;
;ROUTINE: NCDF_INFO
; 
;PURPOSE: Summarize the information from a NetCDF file
; 
;USEAGE:  NCDF_INFO, File,ofile
; 
;INPUT:
; 
; file    A string containing the name of an existing NetCDF file.
;
; ofile   name of output file, output goes to screen if ofile not set
; 
;Example
; 
;        If you have a file called "stuff.cdf", you can find out what variables
;        are inside it by entering:
; 
;             IDL> ncdf_info,'stuff.cdf'
; 
;        IDL will print the following:
; 
;                Contents of stuff.cdf
; 
;                Variables
; 
;                  Name: t,  data type: FLOAT
;                  long_name = Temperature
;                  units = celsius
;                  Dimensions:
;                    longitude[60], latitude[60], depth[10], time[3]
; 
; 
;Bugs:
; 
;    Although this algorithm follows NetCDF conventions, it is inappropriate
;    for irregularly gridded data.
; 
; 
;Author:
; 
;        William Weibel, Department of Atmospheric Sciences, UCLA
; 
;Last Revision:
; 
;        April, 1993;
; Summarize the information from a NetCDF file
;
;
; Bugs:
;
;    Although this algorithm follows NetCDF conventions, it is inappropriate
;    for irregularly gridded data.
;-
if keyword_set(ofile) then begin
  openw,lun,/get_lun,ofile
  printf,lun
  printf,lun,"Contents of ",file
  printf,lun
endif else begin
  print
  print,"Contents of ",file
  print
endelse
fid = ncdf_open(file)
q = ncdf_inquire(fid)
;
; list the global attributes of the file
;

for attnum = 0, q.ngatts-1 do begin
  att_descrip = ncdf_attname( fid, attnum, /GLOBAL )
  ncdf_attget, fid, att_descrip, value, /GLOBAL
  if keyword_set(ofile) then printf,lun, att_descrip, " = ", string(value) $
                        else print, att_descrip, " = ", string(value)
endfor
;
;
; list dependent variables, their dimensions, and their attributes.
;    Variables which are synonymous with "dimensions" in the NetCDF are considered
;    independent
;
if keyword_set(ofile) then begin
  printf,lun,"Variables"
  printf,lun
endif else begin
  print,"Variables"
  print
endelse
for i = 1, q.nvars-1 do begin
  var = ncdf_varinq( fid, i )
  ncdf_control, fid, /NOVERBOSE
  if ncdf_dimid( fid, var.name ) eq -1 then begin
    if keyword_set(ofile) $
       then printf,lun, "  Name: ", var.name, ",  data type: ", var.datatype $
       else print, "  Name: ", var.name, ",  data type: ", var.datatype
    for attnum = 0, var.natts-1 do begin
        att_descrip = ncdf_attname( fid, i, attnum )
        ncdf_attget, fid, i, att_descrip, value
        if keyword_set(ofile) $
           then printf,lun, "  ", att_descrip, " = ", string(value) $
           else print, "  ", att_descrip, " = ", string(value)
    endfor
    if keyword_set(ofile) then printf,lun, "  Dimensions:" $
                          else print, "  Dimensions:"
    outstring = "    "
    for j = 0,var.ndims-1 do begin
        ncdf_diminq, fid, var.dim(j), name, size
        outstring = outstring + strcompress(string(name, "[", size, "]"), /REMOVE_ALL)
        if ( j lt var.ndims-1 ) then outstring = outstring + ", "
    endfor
    if keyword_set(ofile) then printf,lun, outstring else print, outstring
    if keyword_set(ofile) then printf,lun else print
  endif
  ncdf_control, fid, /VERBOSE
endfor
;
ncdf_close,fid
if keyword_set(ofile) then free_lun,lun

return
end
