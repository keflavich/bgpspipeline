pro ncdf_varget_scale,fileid_in,field,value, $
                      offset=offset,$
                      count=count,$
                      noresample=noresample,$
                      noscale=noscale,$
                      noclose=noclose,$
                      fileid=fileid,$
                      close=close,$
                      trck_tel=trck_tel,$
                      trck_das=trck_das,$
                      goodbolos=goodbolos,$
                      median=median,$
                      sigmacut=sigmacut

;$Id: ncdf_varget_scale.pro,v 1.12 2007/06/11 17:27:46 golwala Exp $
;$Log: ncdf_varget_scale.pro,v $
;Revision 1.12  2007/06/11 17:27:46  golwala
;2007/06/11 SG Fixed to work with 1Hz variables that have an extra dimension.
;
;Revision 1.11  2005/12/13 04:25:01  jaguirre
;Fixed a bug in getting onehertz variables with an offset.  The program
;was correctly computing the variable onehertzoff, but the call to
;ncdf_varget was with offset=onehertzoffset.  So the offset was never applied.
;

;This procedure is a quick way to access netcdf variables

;VARIABLES
;FILEID_IN	Filename or id number of ncdf file
;FIELD		String of ncdf variable name
;VALUE		Value of variable (returned by procedure)
;OFFSET		ncdf_varget offset parameter (at 50 Hz)
;COUNT		ncdf_varget count parameter (at 50 Hz)
;NORESAMPLE	Set in order to not upsample to 50Hz
;NOSCALE	Set to not scale data by scale and offset
;NOCLOSE	Set to not close netcdf file (if FILEID_IN = a filename)
;FILEID		Set to a variable name to output id number (if FILEID_IN = a filename)
;CLOSE		Set to close netcdf file
;TRCK_TEL	Set to return only were trck_tel is low
;TRCK_DAS	Set to return only were trck_das is low
;GOODBOLOS	Set to return only where bolo_params(0,*) = 1
;MEDIAN		Set to return only the median value
;SIGMACUT	Set to do a 3-sigma cut on the data

;revisions
;20030620 GL major revision to completely replace readncdf_dec01.pro (no offset or count needed)
;20030829 GL added noclose,id keywords
;20030908 GL allowed possibility of reading a string variable
;20030914 GL corrected bug in onehertz counts
;20031016 GL added /goodbolos, /trck_tel and /trck_das keywords
;20031017 GL added /median keyword
;20031107 GL added /sigmacut keyword
;20031211 GL added count,offset to gettracking.pro
;20040810 JS added new sample_interval variable
;20040811 JS changed how add_offset and scale_factor are applied so that
;            not every variable is scaled to a double
;20070406 SG Fixed to work for 1Hz data that has a second dimension
;           (was needed for MKID run)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;figure out whether we are feeding a id number or a filename
type=size(fileid_in,/type)
if type eq 7 then fileid=ncdf_open(fileid_in,/nowrite) else fileid=fileid_in

;determine dimensions of variable
varinq_struct=ncdf_varinq(fileid,field)
vardims=varinq_struct.dim
vardimid=vardims(n_elements(vardims)-1L) 
ncdf_diminq,fileid,vardimid,vardimname,dimsize

time_dimid = ncdf_dimid(fileid, 'time')
ncdf_diminq, fileid, time_dimid, dummy, time_dim

;upsample to 50Hz if we have a variable sampled at 1Hz
; 2007/04/06 SG fix so works for 1 Hz data that has another dimension
if (vardimname eq 'onehertz' and not keyword_set(noresample)) then begin
	;get number of frames per second
 	check = ncdf_attinq(fileid, 'sample_interval', 'scale_factor')
  	if(check.datatype eq 'UNKNOWN' or check.length ne 1) then begin
    	  rate = 50.
  	endif else begin
          sampleid = ncdf_varid(fileid, 'sample_interval')
          ncdf_varget, fileid, sampleid, sample_interval
	  rate=long(1.0/sample_interval)
  	endelse

        ; get full dimensions of variable
        vardimids = varinq_struct.dim
        ndim = n_elements(vardimids)

	;get offsets
	if keyword_set(offset) then begin
		onehertzoff=offset(0)/rate
		offset_mod=offset(0) mod rate
	endif else begin
            offset = lonarr(ndim)
            offset_mod = 0L
            onehertzoff = 0L
        endelse

 	if keyword_set(count) then begin
		count_new=count
		onehertzcount=(count(0)+offset_mod-1L)/rate+1L 
	endif else begin
           ; no count provided, need to figure it out from the data file
           dims = [time_dim]
            if (ndim gt 1) then begin
               for k = ndim-2, 0, -1 do begin
                  ncdf_diminq,fileid,vardimids[k],vardimname,dimsize
                  dims = [dimsize, dims]
              endfor
           endif
           count = dims
           count_new = count
           onehertzcount = time_dim/rate 
        endelse
                                  
	;read data
        if (ndim eq 1) then begin
     	   ncdf_varget,fileid,field,onehertztemp,$
              count=onehertzcount,offset=onehertzoff
        endif else begin
   	   ncdf_varget,fileid,field,onehertztemp,$
              count=[count[0:ndim-2],onehertzcount], $
              offset=[offset[0:ndim-2], onehertzoff]
        endelse

	;upsample to 50Hz
        dim = size(onehertztemp, /dim)
        dim[ndim-1] = onehertzcount*rate
  	value=rebin(onehertztemp,dim,/sample)
	count_new[ndim-1]=min([count_new[ndim-1],n_elements(onehertztemp)*rate-offset_mod])
        if (ndim eq 1) then value=value[offset_mod:offset_mod+count_new-1L] $
           else value=value[*,offset_mod:offset_mod+count_new[ndim-1]-1L]
endif else ncdf_varget,fileid,field,value,count=count,offset=offset


;figure out if value is a byte, string or float
type_value=size(value,/type)

;if value is not a byte or a string
if type_value ne 1 and type_value ne 7 then begin

	;scale data
	if not keyword_set(noscale)  then begin
		ncdf_attget,fileid,field,'add_offset',b
		ncdf_attget,fileid,field,'scale_factor',a  
		if b ne 0 or a ne 1 then begin
    		  ;scale variable to double precision for scaling
		  value=double(value)
		  value=a*value+b
		endif
	endif
endif

;trck_tel and trck_das keywords
if keyword_set(trck_tel) or keyword_set(trck_das) then begin
	;get tracking info
	trck=gettracking(fileid,count=n_e(value),offset=offset)
	valid_trck=where(trck eq 0)

	;now we must figure out which dimension is the same size as the trck variable
	sz=size(value,/dim)	
	ndim=n_elements(sz)

	;make sure that a dimension actually has the same number of elements as trck
	dim_index=where(sz eq n_elements(trck),ndim_index)
	if ndim_index ne 1 then message,'ERROR: dimensions of variable do not match those of tracking ttl'

	;now pick out elements where we are tracking
	if ndim eq 1 then value=value(valid_trck) else value=value(*,valid_trck)
endif

;goodbolos keyword
if keyword_set(goodbolos) then begin
	;get bolometer parameters
	ncdf_varget_scale,fileid,'bolo_params',bolo_params
	valid_bolos=where(bolo_params(0,*) eq 1)

	;now we must figure out which dimension is the same size as the trck variable
	sz=size(value,/dim)	
	ndim=n_elements(sz)

	;make sure that a dimension actually has the same number of elements as trck
	dim_index=where(sz eq n_elements(bolo_params(0,*)),ndim_index)
	if ndim_index ne 1 then message,'ERROR: dimensions of variable do not match those of number of bolometers'

	;now pick out elements where we are tracking
	if ndim eq 1 then value=value(valid_bolos) else value=value(valid_bolos,*)
endif

if keyword_set(sigmacut) then value=datadiscard(value)
if keyword_set(median) and (n_elements(value) gt 1) then value=median(value)



if (type eq 7 and not keyword_set(noclose)) or keyword_set(close) then ncdf_close,fileid

return
end
