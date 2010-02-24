; set the parameters, including filename, of a _ds5.nc 
; file that has already been preprocessed
; this process operates at a VERY low level and will crash
; without giving nice error messages
pro set_params,ncfile,beam_locations,bolo_params,array_params

    readcol,beam_locations,c1,c2,c3,c4,/silent
    beamloc = transpose([[c2],[c3],[c4]])
    ncid = ncdf_open(ncfile,/write)
    beamlocid = ncdf_varid(ncid,'beam_locations')
    ncdf_varput,ncid,beamlocid,beamloc
    ncdf_control,ncid,/redef
    ncdf_attput,ncid,beamlocid,'file',beam_locations
    ncdf_control,ncid,/endef

    readcol,array_params,c1,c2,format="(A,F)",/silent
    arrayparsid = ncdf_varid(ncid,'array_params')
    ncdf_varget,ncid,arrayparsid,arraypars
    arraypars[0:2]=c2[0:2]
    ncdf_varput,ncid,arrayparsid,arraypars
    ncdf_control,ncid,/redef
    ncdf_attput,ncid,arrayparsid,'file',array_params
    ncdf_control,ncid,/endef

    readcol,bolo_params,c1,c2,c3,c4,format='(AFFF)',/silent
    boloparsid = ncdf_varid(ncid,'bolo_params')
    bolopars =  transpose([[c2],[c3],[c4]])
    ncdf_varput,ncid,boloparsid,bolopars
    ncdf_control,ncid,/redef
    ncdf_attput,ncid,boloparsid,'file',bolo_params
    ncdf_control,ncid,/endef

    ncdf_close,ncid
end
