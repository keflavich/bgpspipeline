; ncdf_new_variable: adds a new variable to the ncdf file (or overwrites an old one)
; ncdf_file is a FILE NAME
; newvarname is a VARIABLE NAME
; newvar is an array or other form of data
; attribute is an attribute you can define in the header

pro ncdf_new_variable, ncdf_file, newvarname, newvar, dims_like, attribute=attribute,verbose=verbose

    ; Open the file for writing
    ncid = ncdf_open(ncdf_file,/write)
    ncdf_control,ncid,/redef
    varsize = size(newvar,/dim)

    ; make an array of dimension ids
    dimid = ncdf_dimid(ncid,dims_like[0])
    if dimid eq -1 then message,"Must specify dimensions already specified in the file to use this task"
    ncdf_diminq,ncid,dimid[0],tvarname,d0
    if ~(d0 eq varsize[0]) then message,"Variable size doesn't match "+strc(tvarname)+" size of "+strc(d0)

    ndims = size(dims_like,/dim)
    for i=1,ndims[0]-1 do begin
        dimid = [dimid,ncdf_dimid(ncid, dims_like[i])]
        ncdf_diminq,ncid,dimid[i],tvarname,di
        if ~(di eq varsize[i]) then message,"Variable size doesn't match "+strc(tvarname)+" size of "+strc(di)
    endfor

    ; check if variable is defined
    varid = ncdf_varid(ncid,newvarname)
    isnew = 0 ; only affects output statement at the end
    if varid eq -1 then begin
        varid = ncdf_vardef(ncid,newvarname,dimid,/float)
        if keyword_set(verbose) then print,"'Variable not found' is a good thing: it means you're adding a new one. Variable ID: ",varid
        isnew = 1
    endif

    if keyword_set(attribute) then ncdf_attput,ncid,varid,newvarname,attribute
    ncdf_attput,ncid,varid,'scale_factor',1.
    ncdf_attput,ncid,varid,'add_offset',0.
    ncdf_attput,ncid,varid,'units',"volts"

    tempid = ncdf_varid(ncid,newvarname)

    if keyword_set(verbose) then print,"Dimid: ",dimid,"varid: ",varid,"    tempid (should be same as varid): ",tempid
    ncdf_control,ncid,/endef
    ncdf_varput,ncid,varid,newvar

    ncdf_close, ncid

    if isnew then begin
        print,'Added ',newvarname,' to ',string(ncdf_file)
    endif else begin
        print,'Updated ',newvarname,' in ',string(ncdf_file)
    endelse

end
