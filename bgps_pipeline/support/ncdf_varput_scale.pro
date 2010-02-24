pro ncdf_varput_scale,fileid_in,field,value,offset=offset,count=count,noresample=noresample,noscale=noscale,noclose=noclose,fileid=fileid,close=close

;This procedure is a quick way to access netcdf variables

;VARIABLES
;FILEID_IN      Filename or id number of ncdf file
;FIELD          String of ncdf variable name
;VALUE          Value of variable (returned by procedure)
;OFFSET         ncdf_varget offset parameter (at 50 Hz)
;COUNT          ncdf_varget count parameter (at 50 Hz)
;NORESAMPLE     Set in order to not upsample to 50Hz  
;NOSCALE        Set to not scale data by scale and offset
;NOCLOSE        Set to not close netcdf file (if FILEID_IN = a filename)
;FILEID         Set to a variable name to output id number (if FILEID_IN = a filename)
;CLOSE          Set to close netcdf file 

;revisions
;20030620 GL major revision to completely replace readncdf_dec01.pro (no offset or count needed)
;20030829 GL added noclose,id keywords
;20030908 GL allowed possibility of reading a string variable
;20030910 GL - Major edit to replace writencdf_dec01
;20040811 JS added new sample_interval variable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;figure out whether we are feeding a id number or a filename
type=size(fileid_in,/type)
if type eq 7 then fileid=ncdf_open(fileid_in,/write) else fileid=fileid_in

;determine dimensions of variable
varinq_struct=ncdf_varinq(fileid,field)
vardims=varinq_struct.dim
vardimid=vardims(n_elements(vardims)-1L)
ncdf_diminq,fileid,vardimid,vardimname,dimsize

;we don't want to edit parameters below, so rename
value_out=value
if keyword_set(offset) then offset_out=offset
if keyword_set(count) then count_out=count

;downsample to 50Hz if we have a variable sampled at 1Hz
if (vardimname eq 'onehertz' and not keyword_set(noresample)) then begin
 	check = ncdf_attinq(fileid, 'sample_interval', 'scale_factor')
  	if(check.datatype eq 'UNKNOWN' or check.length ne 1) then begin
    	  rate = 50.
  	endif else begin
          sampleid = ncdf_varid(fileid, 'sample_interval')
          ncdf_varget, fileid, sampleid, sample_interval
	  rate=long(1.0/sample_interval)
  	endelse

	;count parameter
	if keyword_set(count) then begin
		nframes=min([count,n_elements(value_out)])
		value_out=value_out(0L:nframes-1L)
	endif

        ;get offsets at 1Hz
        if keyword_set(offset) then begin
                offset_out=offset(0)/rate
                offset_mod=offset(0) mod rate 
		;if an offset is set, then we must make sure to phase up the data to 1Hz
		;i.e. if offset is not a multiple of 50, we must padd the edges of the data in order to resample 
		if offset_mod ne 0 then value_out=[replicate(value_out(0),offset_mod),value_out]
        endif

	;check to see if n_elements is a multiple of 50 -- if not, make it so
	nvalue=n_elements(value_out)
	value_mod=nvalue mod rate
	if value_mod ne 0 then value_out=[value_out,replicate(value_out(nvalue-1L),rate-value_mod)]

	;get the number of 1Hz frames to output
	count_out=min([dimsize,n_elements(value_out)/rate])

        ;downsample to 50Hz
        value_out=rebin(value_out,n_elements(value_out)/rate,/sample)
endif

;figure out if value is a byte, string or float
type_value=size(value_out,/type)

;if value is not a byte or a string, scale data
if type_value ne 1 and type_value ne 7 and not keyword_set(noscale) then begin
    	ncdf_attget,fileid,field,'add_offset',b
       	ncdf_attget,fileid,field,'scale_factor',a
     	value_out=(value_out-b)/a
endif

ncdf_varput,fileid,field,value_out,offset=offset_out,count=count_out

if (type eq 7 and not keyword_set(noclose)) or keyword_set(close) then ncdf_close,fileid

return
end
