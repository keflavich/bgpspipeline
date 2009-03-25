pro $
   process_ncdf, $
      input_file, output_file, $
      downsample_factor = downsample_factor, $
      deconv_elec_flag = deconv_elec_flag, $
      deconv_bolo_tau = deconv_bolo_tau, $
      despike_flag = despike_flag, $
      keep_all_frames = keep_all_frames, $
      precise_scans_offset_file = precise_scans_offset_file, $
      beam_locations_file = beam_locations_file, $
      bolo_params_file = bolo_params_file, $
      array_params_file = array_params_file, $
      das_start = das_start, $
      das_end = das_end, $
      scans_offset = scans_offset, $
      nframesperscan = nframesperscan, $
      turnaround = turnaround, $
      minframes = minframes, $
      deconv_bolo_RC = doconv_bolo_RC, $
      lp_filt = lp_filt, $
      DAS_sampling_offset_file = DAS_sampling_offset_file, $
      flux_cal_file = flux_cal_file

; NAME:
;	process_ncdf
;
; PURPOSE:
;	Simple routine to perform processing on bolocam data stream
;       that cannot or is best not done as part of the cleaning
;       pipeline.  Includes deconvolution of filters, despiking,
;       and downsampling (with antialiasing).
;       
; CALLING SEQUENCE:
;       preprocess, $
;          input_file, output_file, $
;          downsample_factor = downsample_factor, $
;          deconv_elec_flag = deconv_elec_flag, $
;          deconv_bolo_tau = deconv_bolo_tau, $
;          despike_flag = despike_flag
;
; INPUTS:
;	input_file: input netcdf file
;       output_file: output netcdf file
;
; OPTIONAL KEYWORD PARAMETERS:
;       downsample_factor: factor by which to downsample; 
;          must be an integer > 1.  An antialiasing filter is
;          automatically applied and deconvolved.
;       deconv_elec_flag: set this to force deconvolution of 
;          electronics transfer function from ac_bolos and
;          dc_bolos traces.  For ac_bolos, the deconvolution involves
;          the lockin HP filter, for dc_bolos it does not.
;       deconv_bolo_tau: an array of bolometer time constants to use
;          for deconvolution of the bolometer thermal time constant.
;          Simple 1-pole low-pass filter is assumed.  The time
;          constants that are used are stored to the output file.
;       despike_flag: set this to despike the bolometer timestreams
;          NOT CURRENTLY IMPLEMENTED.
;       AT LEAST ONE OF THE ABOVE KEYWORDS MUST BE SET IN ORDER FOR
;       THIS ROUTINE TO DO ANYTHING.
;       keep_all_frames: if this keyword is not set the new file will
;          have all frames before the first scan and after the last
;          scan dropped (setting this keywrod keeps all frames). 
;       precise_scans_offset_file: if this keyword is set the precise
;          scans offset parameters will be used to more accurately
;          allign the telescope data with the DAS data.  This keyword
;          can be set equal to a filename corresponding to the
;          appropriate file in cleaning/parameters/
;       beam_locations_file: analogous to precise_scans_offset_file
;       bolo_params_file: analogous to precise_scans_offset_file
;       array_params_file: analogous to precise_scans_offset_file
;       das_start: user can input a vector with nscans elements that
;          define the frame numbers for dasstart in the INPUT file.
;       das_end: analogous to das_start
;       scans_offset: vector with nscans elements that is defined as
;          scans_offset = dasstart-telstart (again, defined for INPUT file).
;       nframesperscan: nframes per scan is calculated automatically by scans.
;          if you want a different number then set this keyword equal to 
;          that number
;       turnaround: set this to the number of seconds of turnaround time
;          you want to include in a scan.  default is 0.
;       minframes: set this to the minimum number of frames per scan you want
;       lp_filt: set this keyword to have an antialiasing lp filter applied to
;          the data, but no downsampling is applied.  This allows you to remove
;          60 Hz noise without downsampling.  Set the keyword to the value
;          (in Hz) where you want the filter to cut off.
;       DAS_sampling_offset_file: set this keyword to the file that contains
;          an offset (in sec) for each bolometer due to the order the DAS
;          samples the data.  This keyword should not be set if the data is
;          not downsampled, as the high frequency noise can make the 
;          interpolation needed to shift the data go bad.
;       flux_cal_file: set keyword to flux_cal_file_mmmyy.sav
;
; MODIFICATION HISTORY:
; 	2004/06/27 SG created, added error checking and downsampling/
;          filtering of bolo data.
;       2004/08/04 JS continuing where Sunil left off.  implementing
;          scans info, added many keywords and wrote code
;          to drop useless frames.
;       2004/08/05 JS added precise scans info stuff, now the telescope
;          data can be alligned using these parameters instead of
;          the offset from scans.
;       2004/09/24 JS added deconv_bolo_RC keyword
;       2004/10/05 SG Mistyped bolo_dimid instead of bolos_dimid in
;          one place, fixed
;             bolo_params variable was being defined in transposed 
;          sense, fixed
;       2004/10/29 JS fixed problem when downsample factor=0 and many files
;          are cleaned
;       2004/12/29 SG Fixed stupid little problem that occurs if
;          offset is scalar
;       2005/02/07 JS changed how the number of samples was determined to
;          make sure that it is a number factorable by 64 instead of 2.  This
;          SIGNIFICANTLY speeds up the fft for some obs.
;       2005/02/08 JS added lp_filt keyword
;       2005/06/15 JS made compatable with new array params file style
;       2005/06/16 JS made creation of pixel offsets compatible with new linear fit
;	2005/09/27 GL fixed bug with calculating scanspeed
;       2005/09/27 JS fixed bug with scanspeed/pixel_offsets if program was run
;          on data which had already been processed.
;       2005/10/05 JS added DAS_sampling_offset_file
;       2005/12/01 JS added flux_cal_file keyword and changed a-a filt
;       2005/12/13 JS changed form of anti-aliasing filter so that 60 Hz
;          lines are removed more efficiently and there are fewer
;          correlations introduced in the time stream.
;       2005/12/14 JS added offset_vs_az fit to array_params
;       2006/04/04 JS fixed bug with flux_cal_file and long observations
;       2006/04/08 DJH fixed bug when using DAS_sampling_offset_file
;          on files that are not downsampled. 
;       2006/06/05 JS changed how the buffer of a few samples
;                     before/after first/last scan is computed
;                     and how many extras to add for fft
;       2006/06/12 JS removed samples that were being added to ac_bolos
;          when DAS_sampling_offset_file keyword is set.  With new
;          method of determining nframes this buffering isn't needed,
;          and it can slow down the fft
;	2006/06/14 JS fixed bug with start_frame after optimizing
;	   calculation of nframes for fft
;       2006/07/17 JS fixed minor bugs in how nframes,startframe, etc.
;          are calculated.
;       2006/08/17 JS fixed bug when nscans changes and num_cleaned ne 0
;       2006/08/31 JS another tweak to nframes/startframe/etc.
;       2006/11/11 JS modified to allow for lissajous, box, and dither
;       2006/11/11 JS moved creation of psd variables to psd_module
;	2007/04/03 JS several changes between today and 2007/03/31 
;                     commented in code
;       2007/04/15 JS I guess merging no longer creates rel_resp?
;                     so I added code to put it in the file
;       2007/08/09 MF Adjusted array_params section so it works with
;                  lissajous
;       2007/10/15 JS fixed an error I had made with the filter
;                  corresponding to DAS_sampling_offset.  This error
;                  should not have caused any noticeable problems.
;       2007/10/22 MF fixed typo of "infile" to "input_file"
;-

; versions for the history attribute
despike_version = 1.0
deconv_elec_version = 1.0
deconv_bolo_tau_version = 1.0
downsample_version = 1.1

;------------------------------------------------------------------------------
; error checking
;------------------------------------------------------------------------------

if (n_params() ne 2) then begin
   message, 'Requires 2 calling parameters.'
endif

if keyword_set(despike_flag) then begin
   message, 'despike_flag keyword parameter not implemented.'
endif

; error check input file
if (size(input_file, /type) ne 7) then begin
   message, 'input_file calling parameter must be a string type.'
endif
if (n_elements(input_file) ne 1) then begin
   message, 'input_file calling parameter must be a scalar'
endif
info = file_info(input_file)
if (info.exists ne 1) then begin
   message, 'Unable to find input file ' + input_file
endif
if (info.read ne 1) then begin
   message, 'Insufficient privileges to read file ' + input_file
endif

; error check precise_scans_offset_file
if keyword_set(precise_scans_offset_file) then begin
  if (size(precise_scans_offset_file, /type) ne 7) then $
    message, 'precise_scans_offset_file must be a string.' 
  info = file_info(precise_scans_offset_file)
  if (info.exists ne 1) then begin
     message, 'Unable to find ' + precise_scans_offset_file
  endif
  if (info.read ne 1) then begin
     message, 'Insufficient privileges to read file ' + $
              precise_scans_offset_file
  endif
endif

; error check array_params_files
if keyword_set(array_params_files) then begin
  if (size(array_params_files, /type) ne 7) then $
    message, 'array_params_files must be a string.' 
  info = file_info(array_params_files)
  if (info.exists ne 1) then begin
     message, 'Unable to find file ' + array_params_file
  endif
  if (info.read ne 1) then begin
     message, 'Insufficient privileges to read file ' + array_params_file
  endif
endif

; error check beam_locations_file
if keyword_set(beam_locations_file) then begin
  if (size(beam_locations_file, /type) ne 7) then $
    message, 'beam_locations_file must be a string.' 
  info = file_info(beam_locations_file)
  if (info.exists ne 1) then begin
     message, 'Unable to find file ' + beam_locations_file
  endif
  if (info.read ne 1) then begin
     message, 'Insufficient privileges to read file ' + beam_locations_file
  endif
endif

; error check bolo_params_file
if keyword_set(bolo_params_file) then begin
  if (size(bolo_params_file, /type) ne 7) then $
    message, 'bolo_params_file must be a string.' 
  info = file_info(bolo_params_file)
  if (info.exists ne 1) then begin
     message, 'Unable to find file ' + bolo_params_file
  endif
  if (info.read ne 1) then begin
     message, 'Insufficient privileges to read file ' + bolo_params_file
  endif
endif

; error check bolo_params_file
if keyword_set(DAS_sampling_offset_file) then begin
  if (size(DAS_sampling_offset_file, /type) ne 7) then $
    message, 'DAS_sampling_offset_file must be a string.' 
  info = file_info(DAS_sampling_offset_file)
  if (info.exists ne 1) then begin
     message, 'Unable to find file ' + DAS_sampling_offset_file
  endif
  if (info.read ne 1) then begin
     message, 'Insufficient privileges to read file ' + DAS_sampling_offset_file
  endif
endif

; error check output_file
if (size(output_file, /type) ne 7) then begin
   message, 'output_file calling parameter must be a string type.'
endif
if (n_elements(output_file) ne 1) then begin
   message, 'output_file calling parameter must be a scalar'
endif
; check that output file directory exists and is writeable
temp = break_filename(output_file)
info = file_info(temp[0])
if (info.exists ne 1) then begin
   message, $
   'Directory for output file does not exist, directory = ' + temp[0]
endif
if (info.directory ne 1) then begin
   message, 'Path to output file is not a directory, directory = ' + temp[0]
endif
if (info.write ne 1) then begin
   message, $
   'Insufficient privileges to write to output file directory, directory = ' $
      + temp[0]
endif
; check that if output file exists we can overwrite
info = file_info(output_file)
if (info.exists eq 1) then begin
   message, /info, $
   'Output file already exists, output file = ' + output_file
   if (info.write ne 1) then begin
      message, 'Insufficient privileges to overwrite output file.'
   endif else begin
      message, /info, 'Will overwrite existing output file.'
   endelse
endif
;make sure output file is different from input_file
if output_file eq input_file then $
  message, 'Output file must be different from input file'

; error check downsample_factor
if keyword_set(downsample_factor) then begin
   if (size(downsample_factor, /type) lt 1 $
      or size(downsample_factor, /type) gt 3) then begin
      message, 'downsample_factor calling parameter must be an integer type.'
   endif
   if (n_elements(downsample_factor) ne 1) then begin
      message, 'downsample_factor calling parameter must be a scalar'
   endif
   if (downsample_factor lt 1) then begin
      message, 'factor calling parameter must be an integer >= 1'
   endif
endif else begin
  no_ds_flag = 1
  downsample_factor = 1L
endelse

;error check lp_filt and downsample_factor
if keyword_set(lp_filt) and downsample_factor ne 1 then $
  message, 'lp_filt keyword cannot be used with downsample_factor keyword'

ncid = ncdf_open(input_file, /nowrite)
ncdf_attget, ncid, /global, 'history', history
history = string(history)
ncdf_close, ncid
check_de = strpos(history, 'deconv_elec')
check_dbt = strpos(history, 'deconv_bolo_tau')

if not keyword_set(deconv_elec_flag) or check_de ge 0 $
   then deconv_elec_flag = 0 $
   else deconv_elec_flag = 1

; error check deconv_bolo_tau
if keyword_set(deconv_bolo_tau) then begin
   if (size(deconv_bolo_tau, /type) lt 1 $
      or size(deconv_bolo_tau, /type) gt 5) then begin
      message, $
         'deconv_bolo_tau calling parameter must be a real numerical type.'
   endif
   ncid = ncdf_open(input_file[0])
   dimid = ncdf_dimid(ncid, 'bolodim')
   ncdf_diminq, ncid, dimid, dummy, nbolos
   ncdf_close, ncid
   if (n_elements(deconv_bolo_tau) ne 1 $
       and n_elements(deconv_bolo_tau) ne nbolos) then begin
      message, /cont, $
         'deconv_bolo_tau calling parameter must be a scalar or an array'
      message, $
         'of length nbolos = ' + string(format = '(I)', nbolos)
   endif
   if (total(deconv_bolo_tau lt 0) ne 0) then begin
      message, $
         'deconv_bolo_tau calling parameter may not be negative'
   endif
endif
if check_dbt ge 0 then deconv_bolo_tau = 0

ncid = ncdf_open(input_file[0], /nowrite)
check = ncdf_attinq(ncid, 'sample_interval', 'scale_factor')
if(check.datatype eq 'UNKNOWN' or check.length ne 1) then begin
   ncdf_close, ncid
   temp = add_sample_interval(input_file[0])
   ncid = ncdf_open(input_file[0], /nowrite)
endif

ncdf_varget, ncid, ncdf_varid(ncid, 'sample_interval'), sample_interval
ncdf_close, ncid

if not keyword_set(despike_flag) $
   then despike_flag = 0 $
   else despike_flag = 1

if keyword_set(deconv_bolo_RC) then $
  if deconv_bolo_RC eq 1 then deconv_bolo_RC = 75. * 10.^(-12.)
  

;------------------------------------------------------------------------------
; preliminaries to get important information, set up assorted things
;------------------------------------------------------------------------------

; for speed
fft_flag = $
   downsample_factor ne 1 $
   or keyword_set(deconv_elec_flag) $
   or keyword_set(deconv_bolo_tau) $
   or keyword_set(lp_filt) $
   or keyword_set(DAS_sampling_offset_file)

; prepare the scans information
; it's tricky because truncation may require dropping a scan, which
; requires changing the scan dimension

; get scans info for input data
ncid = ncdf_open(input_file[0], /nowrite)
scan_dimid = ncdf_dimid(ncid, 'scan')
new_scan_flag = 0

; MF 2007/08/09 - determine what observing mode we used, useful later 
obs_mode = ncdf_varid(ncid,'obs_mode')

if (scan_dimid ne -1) then begin
   ; get scans info
   ncdf_varget_scale, ncid, /noclose, 'scans_info', dummy
   if (n_elements(dummy[*,0]) eq 2) then begin
     ;this means the file has already been run through this routine, so
     ;telstart = dasstart and offset = 0
     nscans = n_elements(dummy[0,*])
     dasstart = reform(dummy[0,*])
     dasend = reform(dummy[1,*])
     telstart = dasstart
     telend = dasend
     offset = replicate(0., nscans)
   endif
endif else begin
  new_scan_flag = 1
; If we're looking at old sliced data which doesn't have this
; variable, we'ver pretty much got to be in raster scan mode.
  if (obs_mode eq -1) then obs_mode = 0 else $
    ncdf_varget, ncid, 'obs_mode', obs_mode
  if obs_mode eq 0 then begin ;we have a raster scan obs
    ncdf_varget_scale, ncid, /noclose, 'trck_das', trck_das
    ncdf_varget_scale, ncid, /noclose, 'trck_tel', trck_tel
    scans, nscans, dasstart,dasend, telstart, telend, offset, $
       trck_das, trck_tel, nframesperscan = nframesperscan,$
       turnaround = turnaround, minframes = minframes,$
       sample_interval = sample_interval
  endif else begin ;we have a special obs
    ;use acq_das and acq_tel to determine offset
    ncdf_varget_scale, ncid, /noclose, 'acq_das', acq_das
    ncdf_varget_scale, ncid, /noclose, 'acq_tel', acq_tel
    scans, dummy1, dummy2, dummy3, dummy4, dummy5, offset, $
       acq_das, acq_tel, nframesperscan = nframesperscan,$
       turnaround = turnaround, minframes = minframes,$
       sample_interval=sample_interval
    ;use executing_tel to determine start/end of "scan"
    ncdf_varget_scale, ncid, /noclose, 'executing_tel', executing_tel
    executing_tel = 1 - executing_tel
    scans, nscans, dasstart, dasend, telstart, telend, dummy6, $
       executing_tel*5., executing_tel, nframesperscan = nframesperscan,$
       turnaround = turnaround, minframes = minframes,$
       sample_interval=sample_interval
    if n_elements(dasstart) ne n_elements(offset) then $
      offset = offset[0:n_elements(dasstart)-1]
    dasstart = dasstart + offset
    dasend = dasend + offset
  endelse
endelse
ncdf_close, ncid

;see if the user has input scans_info by hand
if keyword_set(das_start) then begin
  if n_elements(das_start) eq nscans then begin
    dasstart = das_start
    telstart = dasstart - offset
  endif else begin
    message, 'das_start input by user has incorrect dimensions.'
  endelse
endif
if keyword_set(das_end) then begin
  if n_elements(das_end) eq nscans then begin
    dasend = das_end
    telend = dasend - offset
  endif else begin
    message, 'das_end input by user has incorrect dimensions.'
  endelse
endif
if keyword_set(scans_offset) then begin
  if n_elements(scans_offset) eq nscans then begin
    offset = scans_offset
    telstart = dasstart - offset
    telend = dasend - offset
  endif else begin
    message, 'scans_offset input by user has incorrect dimensions.'
  endelse
endif

; get nbolos, onehz, and frames_written from input file
ncid = ncdf_open(input_file[0], /nowrite)
ncdf_diminq, ncid, ncdf_dimid(ncid, 'bolodim'), dummy, nbolos
char_len_dimid = ncdf_dimid(ncid, 'char_len')
time_dimid = ncdf_dimid(ncid, 'time')
onehz_dimid = ncdf_dimid(ncid, 'onehertz')
ncdf_varget, ncid, ncdf_varid(ncid, 'frames_written'), nframes_raw
ncdf_varget, ncid, ncdf_varid(ncid, 'sample_interval'), sample_interval
nframes_onehz_raw = ceil(nframes_raw * sample_interval)
ncdf_close, ncid

;determine how many frames will be read in from input file
if keyword_set(keep_all_frames) then begin
  ;we want to keep all frames, but that probably won't be possible
  ;due to the offset between telescope and das - so we will only
  ;keep all the frames that have telescope data.
  ;I have chopped an extra frame from both the start and finish in
  ;case precise scans offset is called.
  if offset[0] ge 0 then $
    start_frame = offset[0] +1L $
  else $
    start_frame = 0L
  if offset[nscans-1] le 0 then $
    nframes = nframes_raw - start_frame + offset[nscans-1] -1L $
  else $
    nframes = nframes_raw - start_frame
endif else begin
  start_frame = long(max([dasstart[0]-round(60./sample_interval),0, offset]))
  nframes = long(min([dasend[nscans-1]-start_frame+1L+(60./sample_interval),nframes_raw-start_frame]))
endelse

start_frame_onehz = floor(float(start_frame)*sample_interval)
nframes_onehz = ceil(nframes * sample_interval)
nframes_out = nframes

; get the number of samples straight
; note that we will not downsample onehz, but we may need to truncate
; depending on whether samples are lost off the end
;
; nframes_raw: # frames in input file
; start_frame: first frame read in from input file
; nframes: # frames read in from input file, 
;    truncated or expanded to be a multiple of 2*downsample_factor
; nframes_out: # frames in output file, i.e., scaled down by
;    downsample_factor if necessary
;
; nframes_onehz_raw: # of 1hz frames in input file
; start_frame_onehz: first frame of 1hz data read in
; nframes_onehz: # of 1hz frames in output file, may be truncated
;    depending on how many samples are lost off the end
;  
; truncate/expand to an even number of samples if we will fft

;try to expand the number of frames to make the number
;of samples divisible by the largest factor of 2 possible, 
;I've set it up so the largest block that will be fft'd has
;a length of 100
;JS 2005/02/07

; Moreover, if we're going to downsample, truncate/expand so that the
; _output_ file will have an even number of samples (because we will
; definitely use Fourier transforms to deconvolve the downsampling
; antialias filter)
if fft_flag or downsample_factor ne 1 then begin

  ;JS 2006/08/31 if offset=0, then don't need extra frames
  if max(abs(offset)) ne 0 then $
    extra_frames_needed = fix(2*max(abs(offset)+1)) $
  else extra_frames_needed = 0L
  max_factor = floor(alog10(nframes/100.) / alog10(2.))

  ;let's expand nframes if we can
  for i=1, max_factor do begin
    if((2^i*downsample_factor) * $
      ceil(float(nframes)/(2.^i*downsample_factor)) $
      gt (nframes_raw - extra_frames_needed)) then break
  endfor
  i = i-1

  ;if we couldn't expand, let's try to contract
  ;JS 2006/07/17 fixed small bug in this loop
  ;JS 2007/03/26 changed this loop to happen even if there's only
  ;              one scan
  ;JS 2007/04/02 put extra_frames_needed in (ceil(float(..))
  if i lt max_factor then begin
    for j=2, max_factor do begin
      if ((2^j*downsample_factor) * $
        (ceil(float(nframes_raw-extra_frames_needed) / $
        (2.^j*downsample_factor))-1)) lt $
        (dasend[nscans-1] - dasstart[0] + 1L + extra_frames_needed) then break
    endfor
    j = j-1
  endif else begin
    j = 0
  endelse

  ;see which method was better  
  if i ge j then begin
    nframes = (2^i*downsample_factor) * $
      (ceil(float(nframes)/(2.^i*downsample_factor)))   
  endif else begin
    nframes = (2^j*downsample_factor) * $
      (ceil(float(nframes_raw-extra_frames_needed) / $
      (2.^j*downsample_factor))-1)
  endelse

  ;JS 2007/04/03 figure out range of start_frame
  max_start_frame = long(min([nframes_raw - $
    extra_frames_needed/2L - nframes - 1L, $
    max([dasstart[0], telstart[0]]) - extra_frames_needed/2L]))
  min_start_frame = long(max([extra_frames_needed/2L, $
    min([dasend[nscans-1], telend[nscans-1]]) + $
    extra_frames_needed/2L - nframes + 1L]))

  if start_frame lt min_start_frame or $
     start_frame gt max_start_frame then $ 
     start_frame = long(mean([max_start_frame,min_start_frame]))

; JS 2007/04/03 I think all of this code is obsolete now...
;  ;JS 2006/06/14 see if we need to increase or decrease start_frame
;  ;JS 2006/07/17 changed extra_frames_needed to extra_frames_needed/2
;  ;because we are modifying a single endpoint, not the total 
;  ;number of frames.
;  if((nframes + start_frame) gt (nframes_raw - extra_frames_needed / 2L)) then begin
;      if (nframes_raw - extra_frames_needed/2L - nframes) ge 0 then $
;        start_frame = (nframes_raw - extra_frames_needed / 2L) - nframes $
;      else nframes = nframes_raw - extra_frames_needed - start_frame
;      ;JS 2007/04/02 removed extra_frames_needed from long(max(..))
;      if start_frame + nframes lt long(max([dasend,telend])) then $
;        start_frame = long(max([dasend,telend]))-nframes
;      if start_frame ge long(min([dasstart,telstart])) then $
;        start_frame = long(min([dasstart,telstart]))-1L
;  endif

;  ;JS 2007/04/02 changed how overflow defined
;  overflow = long(max([dasend,telend])+1) - nframes - start_frame
;  if overflow ge 0 then begin
;    if dasstart[0] ge overflow then begin
;      ;JS 2006/08/31 removed additional factor of downsample_factor    
;      start_frame = start_frame + overflow + 1L 
;    endif else begin
;      ;JS 2007/03/31 still might need to adjust start_frame even
;      ;if dasstart is less than overflow
;      max_buffer = nframes - (dasend[nscans-1]-dasstart[0]+1L)
;      start_frame = long(max([dasstart[0]-max_buffer/2L,0L]))
;    endelse
;  endif

  start_frame_onehz = floor(float(start_frame) * sample_interval)
  nframes_onehz = ceil(nframes * sample_interval)
  nframes_out = nframes / downsample_factor

endif

; now, we check to see if, thanks to the change in length of the file,
; we have overflowed the file and need to drop a scan
if new_scan_flag ne 0 then begin
  index_drop = where((dasend ge (nframes+start_frame)) or $
                   (dasstart lt start_frame) or $
                   (telstart lt 1L) or $
                   (telend ge (nframes_raw-1L)))
endif else begin
  new_scan_flag = 0
  index_drop = where((dasend ge (nframes+start_frame)) or $
                   (dasstart lt start_frame) or $
                   (telstart lt start_frame) or $
                   (telend ge (nframes+start_frame)))
endelse

if (index_drop[0] ne -1) then begin
    ; the following line will discard any -1's also
    index_keep = setdifference(lindgen(nscans), index_drop)
    if (index_keep[0] eq -1) then begin
      message, /cont, 'Input file: '
      message, /cont, input_file[0]
      message, $
         'Redefinition of file length results in loss of all scans.'
    endif
    nscans = n_elements(index_keep)
    dasstart = dasstart[index_keep]
    telstart = telstart[index_keep]
    dasend = dasend[index_keep]
    telend = telend[index_keep]
    offset = offset[index_keep]
endif

;determine the new scanstart and scanend values
scans_len = dasend - dasstart + 1L
scans_len = 2 * floor(float(scans_len) / (2. * float(downsample_factor)) )
new_scanstart = ceil(float(dasstart-start_frame) / float(downsample_factor))
new_scanend = new_scanstart + scans_len - 1L

;------------------------------------------------------------------------------
; create the output file
;------------------------------------------------------------------------------

; in general, we will modify the time dimension, which requires
; creating a new file from scratch (not just copying), so just
; do that for all cases

; get variable information from input file
ncid = ncdf_open(input_file[0], /nowrite)
inq = ncdf_inquire(ncid)

; create output file
ncidout = ncdf_create(output_file[0], /clobber)

; copy the global attributes
for gattid = 0, inq.ngatts-1 do begin
   gattname = ncdf_attname(ncid, /global, gattid)
   gattid_new $
      = ncdf_attcopy(ncid, /in_global, gattname, ncidout, /out_global)
   if gattid_new lt 0 then begin
      message, /cont, 'Input file: '
      message, /cont, input_file[0]
      message, /cont, 'Output file: '
      message, /cont, output_file[0]
      message, $
   'Unable to copy global attribute ' + gattname
   endif
endfor

; update num_cleaned attribute because this is, effectively, a
; cleaning of the file
ncdf_attget, ncidout, /global, 'num_cleaned', num_cleaned
ncdf_attput, ncidout, /global, 'num_cleaned', num_cleaned+1

if num_cleaned ne 0 then begin
      precise_scans_offset_file = 0
      das_start = 0
      das_end = 0
      scans_offset = 0
      nframesperscan = 0
      turnaround = 0
      minframes = 0
      message, /cont, 'Data has already been preprocessed, so none ' + $
              'of the scans keywords will be used.'
endif

; define the dimensions in the output file
; 1) define the dimensions that won't be modified
dimid_new_arr = make_array(inq.ndims, /long)
for dimid = 0, inq.ndims-1 do begin    
   if (dimid ne time_dimid and dimid ne onehz_dimid $
      and dimid ne scan_dimid) then begin
      ncdf_diminq, ncid, dimid, dim_name, dim_size
      dimid_new = ncdf_dimdef(ncidout, dim_name, dim_size)
      dimid_new_arr[dimid] = dimid_new
   endif
endfor
; 2) define the modified time and onehz dimensions
time_dimid_new = ncdf_dimdef(ncidout, 'time', nframes_out)
dimid_new_arr[time_dimid] = time_dimid_new
onehz_dimid_new = ncdf_dimdef(ncidout, 'onehertz', nframes_onehz)
dimid_new_arr[onehz_dimid] = onehz_dimid_new
scan_dimid_new = ncdf_dimdef(ncidout, 'scan', nscans)
if scan_dimid ge 0 then dimid_new_arr[scan_dimid] = scan_dimid_new $
  else dimid_new_arr = [dimid_new_arr, scan_dimid_new]

;now define any other dimension we will need
if new_scan_flag then begin
  two_dimid_new = ncdf_dimdef(ncidout, 'two', 2)
  dimid_new_arr = [dimid_new_arr, two_dimid_new]
endif else begin
  two_dimid_new = ncdf_dimid(ncidout, 'two')
endelse

if num_cleaned eq 0 then begin

    bolos_dimid = ncdf_dimid(ncidout, 'bolodim')

    create_bolo_param = 0
    create_arr_param = 0
    bolo_param_dimid = ncdf_dimid(ncidout, 'bolo_param')
    if bolo_param_dimid eq -1 then begin
      bolo_param_dimid = ncdf_dimdef(ncidout, 'bolo_param', 3)
      dimid_new_arr = [dimid_new_arr, bolo_param_dimid]
      create_bolo_param = 1
    endif
    arr_param_dimid = ncdf_dimid(ncidout, 'array_param')
    if arr_param_dimid eq -1 then begin
      arr_param_dimid = ncdf_dimdef(ncidout, 'array_param', 5)
      dimid_new_arr = [dimid_new_arr, arr_param_dimid]
      create_arr_param = 1
    endif

  ;make sure we have array and bolo params
  if not keyword_set(array_params_file) then $ 
     read,prompt='Please provide array parameters file: ',array_params_file  
  if not keyword_set(bolo_params_file) then $
     read,prompt='Please provide bolometer parameters file: ',bolo_params_file

  ;read in some useful dimid's
  bolos_dimid=ncdf_dimid(ncidout,'bolodim')	
  bolo_param_dimid=ncdf_dimid(ncidout,'bolo_param')
  two_dimid=ncdf_dimid(ncidout,'two')
  
  ;create pixel_offsets dimension/variable/attributes:
  pixid=ncdf_vardef( $
     ncidout,'pixel_offsets',[two_dimid,two_dimid,bolos_dimid,scan_dimid_new],/float)
  ncdf_attput,ncidout,pixid,'scale_factor',1,/float
  ncdf_attput,ncidout,pixid,'add_offset',0,/float
  ncdf_attput,ncidout,pixid,'units','arcseconds',/char
  ncdf_attput,ncidout,pixid,'names','ra_offset,dec_offset',/char

  ;create rmsnoise variable/attributes:
  rmsid=ncdf_vardef(ncidout,'rmsnoise',[bolos_dimid,scan_dimid_new],/float)
  ncdf_attput,ncidout,rmsid,'scale_factor',1,/float
  ncdf_attput,ncidout,rmsid,'add_offset',0,/float

endif

; update the history of the output file
date = systime(0)
ncdf_attget, ncidout, /global, 'history', history
history = string(history)
if keyword_set(despike_flag) then $
   history = $
      string( $
         format = '(%"%s%s %s version: %s\n")', $
         history, date, 'preprocess_despike', despike_version)
if keyword_set(deconv_elec_flag) then $
   history = $
      string( $
         format = '(%"%s%s %s version: %s\n")', $
         history, date, 'preprocess_deconv_elec', deconv_elec_version)
if keyword_set(deconv_bolo_tau) then $
   history = $
      string( $
         format = '(%"%s%s %s version: %s\n")', $
         history, date, 'preprocess_deconv_bolo_tau', deconv_bolo_tau_version)
if downsample_factor ne 1 then $
   history = $
      string( $
         format = '(%"%s%s %s version: %s\n")', $
         history, date, 'preprocess_downsample', downsample_version)
if keyword_set(precise_scans_offset_file) then $
   history = $
      string( $
         format = '(%"%s%s %s version: %s\n")', $
         history, date, 'preprocess_precise_scans_offset', 1.0)
if keyword_set(lp_filt) then $
   history = $
      string( $
         format = '(%"%s%s %s frequency (Hz): %s\n")', $
         history, date, 'preprocess_lp_filter', lp_filt)
if keyword_set(DAS_sampling_offset_file) then $
   history = $
      string( $
         format = '(%"%s%s %s version: %s\n")', $
         history, date, 'DAS_sampling_offset', 1.0)
ncdf_attput, ncidout, /global, 'history', history, /char

; copy variable definitions to output file
varid_new_arr = make_array(inq.nvars, /long)
for varid = 0, inq.nvars-1 do begin
   ; get information about the old variable
   inq_v = ncdf_varinq(ncid, varid)

; if (inq_v.name ne 'scans_info' or new_scan_flag eq 0) and $
;    inq_v.name ne 'scanspeed' then begin
;050927 GL
  if (inq_v.name ne 'scans_info') then begin

   ; create the string that will be used to create the new variable
   str = 'varid_new = ncdf_vardef(ncidout, inq_v.name, /' + inq_v.datatype

   ; get the dimensions of the new variable and add to creation
   ; string
   if inq_v.ndims gt 0 then begin
      var_dimid_arr = dimid_new_arr[inq_v.dim]
      str = str + ', var_dimid_arr'
   endif
   ; add the last parenthesis and execute
   str = str + ')'
   dummy = execute(str)
   ; and save the new variable id
   varid_new_arr[varid] = varid_new

   ; create the attributes for this variable
   for attid = 0, inq_v.natts-1 do begin
      attname = ncdf_attname(ncid, varid, attid)
      ncdf_attget, ncid, varid, attname, attval
      attid_new = ncdf_attcopy(ncid, varid, attname, ncidout, varid_new)
      if attid_new lt 0 then begin
         message, /cont, 'Input file: '
         message, /cont, input_file[0]
         message, /cont, 'Output file: '
         message, /cont, output_file[0]
         message, $
   'Unable to copy attribute ' + attname + ' for variable ' + inq_v.name
      endif
   endfor ; for attid = 0, inq_v.natts-1 do begin
 endif else begin
  varid_new_arr[varid] = -1
 endelse
endfor ; for varid = 0, inq.nvars-1 do begin

;050927 GL put in if statement
if num_cleaned eq 0 then begin
	;create scanspeed
	scanspeedid=ncdf_vardef(ncidout,'scanspeed',/float)
	ncdf_attput,ncidout,scanspeedid,'scale_factor',1,/float
	ncdf_attput,ncidout,scanspeedid,'add_offset',0,/float
endif

; create scan variables
scans_info_varid_new = ncdf_vardef( $
ncidout, 'scans_info', /long, $
  [two_dimid_new, scan_dimid_new] )
ncdf_attput,ncidout,scans_info_varid_new,'scale_factor',1,/long
ncdf_attput,ncidout,scans_info_varid_new,'add_offset',0,/long
ncdf_attput,ncidout,scans_info_varid_new,'names', $
  'scanstart,scanend',/char

if num_cleaned eq 0 then begin

    ;create precise_scans_offset variable
    if keyword_set(precise_scans_offset_file) or num_cleaned eq 0 then begin
      prec_varid_new = ncdf_vardef( $
	    ncidout, 'precise_scans_offset', /float, [two_dimid_new] )
      ncdf_attput,ncidout,prec_varid_new,'scale_factor',1,/float
      ncdf_attput,ncidout,prec_varid_new,'add_offset',0,/float
      ncdf_attput,ncidout,prec_varid_new,'names', $
	   'intercept,slope',/char
    endif

    ;create beam_locations variable
    if keyword_set(beam_locations_file) or num_cleaned eq 0 then begin
      beam_varid_new = ncdf_vardef( $
	    ncidout,'beam_locations',[bolo_param_dimid,bolos_dimid],/float)
      ncdf_attput,ncidout,beam_varid_new,'scale_factor',1,/float
      ncdf_attput,ncidout,beam_varid_new,'add_offset',0,/float
      ncdf_attput,ncidout,beam_varid_new,'names', $
	   'bolo_dist,bolo_ang,bolo_position_rms',/char
    endif

    ;create array_params variable
    if create_arr_param eq 1 then begin
      arr_varid_new = ncdf_vardef( $
	    ncidout, 'array_params', /float, [arr_param_dimid] )
      ncdf_attput,ncidout,arr_varid_new,'scale_factor',1,/float
      ncdf_attput,ncidout,arr_varid_new,'add_offset',0,/float
      ncdf_attput,ncidout,arr_varid_new,'names', $
	   'platescale(arcsec/mm),beamsize(arcsec_fwhm),arr_angle(deg),bore_x_off(in),bore_y_off(in)',/char
    endif

    ;create bolo_params variable
    if create_bolo_param eq 1 then begin
      bolo_varid_new = ncdf_vardef( $
	    ncidout, 'bolo_params', /float, [bolo_param_dimid, bolos_dimid] )
      ncdf_attput,ncidout,bolo_varid_new,'scale_factor',1,/float
      ncdf_attput,ncidout,bolo_varid_new,'add_offset',0,/float
      ncdf_attput,ncidout,bolo_varid_new,'names', $
	   'bolo_flag,bolo_dist(nbolo),bolo_ang(deg)',/char
    endif

    ;JS 2007/04/15 create rel_resp variable if needed
    if keyword_set(beam_locations_file) or num_cleaned eq 0 then begin
      test = ncdf_varid(ncidout, 'rel_resp')
      if test lt 0 then begin
        relresp_varid_new = ncdf_vardef( $
	      ncidout,'rel_resp',[bolos_dimid],/float)
        ncdf_attput,ncidout,relresp_varid_new,'scale_factor',1,/float
        ncdf_attput,ncidout,relresp_varid_new,'add_offset',0,/float
      endif
    endif

endif ;num_cleaned eq 0

; exit def mode
ncdf_control, ncidout, /endef

if num_cleaned eq 0 then begin
  ;initialize some variables
  ncdf_varput,ncidout,pixid, $
     replicate(0.,2,2,144,nscans),offset=[0,0,0,0],count=[2,2,144,nscans]
  ncdf_varput,ncidout,beam_varid_new, $
     replicate(0.,3,144),offset=[0,0],count=[3,144]
  ncdf_varput,ncidout,prec_varid_new,[0.,0.],offset=[0]
  ncdf_varput,ncidout,rmsid, $
     replicate(0.,144,nscans),offset=[0,0],count=[144,nscans]
endif

;050917 GL add if statement	
if num_cleaned eq 0 then begin
	;calculate the scanspeed
	ncdf_varget_scale, ncid, 'dec', temp_dec
	ncdf_varget_scale, ncid, 'ra', temp_ra
	scanspeed = fltarr(nscans)
	for iscan=0, nscans-1 do begin
	  dec = temp_dec[telstart[iscan]:telend[iscan]]
	  ra = temp_ra[telstart[iscan]:telend[iscan]]
	  scanspeed[iscan] = getscanspeed(ra,dec,sample_interval=sample_interval)
	endfor
	temp_ra = 0 & temp_dec = 0
	scanspeed = median(scanspeed)
	ncdf_varput, ncidout, scanspeedid, scanspeed, count = [0], offset = [0]
endif	

;------------------------------------------------------------------------------
; copy all non-time variables directly from input file to output file
;------------------------------------------------------------------------------

for varid = 0, inq.nvars-1 do begin
 if varid_new_arr[varid] ge 0 then begin
   ; get information about the old variable
   inq_v = ncdf_varinq(ncid, varid)
   ; if scalar, just copy the variable, though may need to modify
   ; its value if it is frames_written or sample_interval

   if inq_v.ndims eq 0 then begin
      ncdf_varget, ncid, varid, val
;      ;050927 GL  modified next line 'cause there is some strange bug here
 ;     if varid ne 67 then 
	ncdf_varput, ncidout, varid_new_arr[varid], val
      if ( strmatch(inq_v.name, 'frames_written') eq 1) then $
         ncdf_varput, ncidout, varid_new_arr[varid], nframes_out
      if ( strmatch(inq_v.name, 'sample_interval') eq 1) then $
         ncdf_varput, ncidout, varid_new_arr[varid], val * downsample_factor
   endif else begin
      var_dimid_arr = inq_v.dim
      index_time_dim = where(var_dimid_arr eq time_dimid)
      index_onehz_dim = where(var_dimid_arr eq onehz_dimid)
      index_scan_dim = where(var_dimid_arr eq scan_dimid)
      if (index_time_dim[0] eq -1 and index_onehz_dim[0] eq -1 and $
         index_scan_dim[0] eq -1) then begin
         ; no time, onehz, or scans dimension, just copy the variable
         ncdf_varget, ncid, varid, val
         ncdf_varput, ncidout, varid_new_arr[varid], val
      endif
      if (index_onehz_dim[0] ne -1) then begin
         ; one of the dimensions is onehz, so we have to 
         ; be more careful
         ; it's easier to modify how we read in than to index how
         ; we write out
         count = fltarr(inq_v.ndims)
         for dim_index = 0, inq_v.ndims-1 do begin
            ncdf_diminq, ncid, var_dimid_arr[dim_index], dummy, count_this
            count[dim_index] = count_this
         endfor
         temp_offset = lonarr(n_elements(count))
         temp_offset[index_onehz_dim[0]] = start_frame_onehz
         count[index_onehz_dim[0]] = nframes_onehz
         ; get the truncated variable, and put to output file
         ncdf_varget, ncid, varid, val, count = count, offset = temp_offset
         ncdf_varput, ncidout, varid_new_arr[varid], val
      endif
      if (index_scan_dim[0] ne -1) then begin
         count = fltarr(inq_v.ndims)
         for dim_index = 0, inq_v.ndims-1 do begin
            ncdf_diminq, ncid, var_dimid_arr[dim_index], dummy, count_this
            count[dim_index] = count_this
         endfor
         temp_offset = lonarr(n_elements(count))
         count[index_scan_dim[0]] = nscans
         ; get the truncated variable, and put to output file
         ncdf_varget, ncid, varid, val, count = count, offset = temp_offset
         ncdf_varput, ncidout, varid_new_arr[varid], val
      endif
   endelse
 endif
endfor

; write scans variable specially, method doesn't care whether
; scans existed in input file or not
; we will allign the telescope and DAS timestreams in the new file,
; so offset will be zero and dasstart = telstart.
message, /cont, 'Writing new scans_info to ' + output_file + '...
scans_info = lonarr(2, nscans)
scans_info[0,*] = new_scanstart
scans_info[1,*] = new_scanend
if num_cleaned ne 0 then scans_info_varid_new=ncdf_varid(ncidout,'scans_info')
ncdf_varput, ncidout, scans_info_varid_new, scans_info

;write the precise_scans_offset values
prec_scans = [0.,0.]
if keyword_set(precise_scans_offset_file) then begin
  message,/cont,'Writing precise scans offset info to '+output_file+'...'
  readcol, precise_scans_offset_file, date, min_obs, max_obs, $
           intercept, slope, format = '(L,I,I,F,X,F,X,X,X,X)', comment=';', $
           /silent
  index = strpos(output_file, '/', /reverse_search)
  yymmdd_obs = yymmdd_obsnum_str_to_num(strmid(output_file, index+1, 10))
  index = where(date eq yymmdd_obs[0] and min_obs le yymmdd_obs[1] and $
                max_obs ge yymmdd_obs[1])
  if(n_elements(index) ne 1 or index[0] eq -1) then $
    message, 'Error with precise_scans_offset_file, ' + $
             'finding 0 or >1 entries for 0' + $
             strtrim(string(yymmdd_obs[0]),1) + '_' + $
             strtrim(string(yymmdd_obs[1]),1)
  intercept = intercept[index[0]]
  slope = slope[index[0]]
  prec_scans = [intercept, slope]      		
  ncdf_varput, ncidout, prec_varid_new, prec_scans 
  ncdf_control,ncidout,/redef
      ncdf_attput,ncidout,prec_varid_new,'file',precise_scans_offset_file,/char
  ncdf_control,ncidout,/endef
endif

;write the beam locations
if keyword_set(beam_locations_file) then begin
  message,/cont,'Writing beam locations to '+output_file+'...'
  temp = read_ascii(beam_locations_file, comment = ';')
  temp = temp.field1
  ncdf_varput,ncidout,'beam_locations',reform(temp[1,*]), $
       count=[1,144],offset=[0,0]
  ncdf_varput,ncidout,'beam_locations',reform(temp[2,*]), $
       count=[1,144],offset=[1,0]
  ncdf_varput,ncidout,'beam_locations',reform(temp[3,*]), $
       count=[1,144],offset=[2,0]
  ncdf_control,ncidout,/redef
       ncdf_attput,ncidout,'beam_locations','file',beam_locations_file,/char
  ncdf_control,ncidout,/endef
endif

;write the array params - adjusted for new file format (JS 2005/06)
if keyword_set(array_params_file) then begin
  message,/cont,'Writing array parameters to '+output_file+'...'
  readcol,array_params_file,temp,format='X,F',/silent

  ;check to see if array params file was the old style
  if total(temp) ne 0 then begin
    ;we have the old style, so just print it out
    ncdf_varput_scale,ncidout,'array_params',temp
    ncdf_control,ncidout,/redef
      ncdf_attput,ncidout,'array_params','file',array_params_file,/char
    ncdf_control,ncidout,/endef
  endif else begin
    ;we have the new style, so now we need some info from the file
    common USER_COMMON
    restore, array_params_file
    if obs_mode eq 0 then begin
        ncdf_varget_scale,ncid,'trck_tel',trck_tel
    endif else begin
        ncdf_varget_scale,ncid,'executing_tel',exec_tel
        trck_tel = 1-exec_tel ;MF - 2007/08/09 - adjust for lissajous convention
    endelse 
    ncdf_varget_scale, ncid, 'el', temp_el, /noclose
    temp_el = median(temp_el[where(trck_tel eq 0)])
    ncdf_varget_scale, ncid, 'az', temp_az, /noclose
    temp_az = median(temp_az[where(trck_tel eq 0)])
    ind = strpos(input_file, IDL_FILESEP, /reverse_search)
    date = (yymmdd_obsnum_str_to_num(strmid(input_file, ind+1, 10)))[0]
    field = strmid(input_file, 0, ind)
    field = strmid(field, strpos(field, IDL_FILESEP, /reverse_search)+1)

    ;determine which struct in the pointing model corresponds to this ob 
    pointing_index = where(pointing_model.blankfield eq field and $
                           pointing_model.valid_dates[0] le date and $
                           pointing_model.valid_dates[1] ge date and $
                           pointing_model.az_range[0] le temp_az and $
                           pointing_model.az_range[1] ge temp_az)
    if pointing_index[0] eq -1 or n_elements(pointing_index) gt 1 then $
      message, 'Error with pointing model in array params file.  ' + $
               'Either 0 or >1 models valid for this observation.  ' + $
               'Observation = ' + input_file
    pointing_model = pointing_model[pointing_index]

    ;now, determine the array params from the pointing model
    platescale = pointing_model.platescale
    eloffset = poly(temp_el, pointing_model.eloffset_vs_el) / platescale / 25.4
    azoffset = poly(temp_el, pointing_model.azoffset_vs_el) / platescale / 25.4

    ;check to see if an offset_vs_az was included
    tags = tag_names(pointing_model)
    if total(strmatch(tags, 'eloffset_vs_az', /fold_case) gt 0) then begin
      eloffset = eloffset + $
        poly(temp_az, pointing_model.eloffset_vs_az) / platescale / 25.4
      azoffset = azoffset + $
        poly(temp_az, pointing_model.azoffset_vs_az) / platescale / 25.4
    endif

    temp = [platescale, pointing_model.beam_fwhm, pointing_model.fid_arr_ang, $
            azoffset, eloffset]
    ncdf_varput_scale,ncidout,'array_params',temp
    ncdf_control,ncidout,/redef
      ncdf_attput,ncidout,'array_params','file',array_params_file,/char
    ncdf_control,ncidout,/endef
  endelse
endif

;write bolo params
if keyword_set(bolo_params_file) then begin
  message,/cont,'Writing bolometer parameters to '+output_file+'...'
  readcol,bolo_params_file,flags,boloang,bolodist,format='X,F,F,F',/silent
  ncdf_varput_scale,ncidout,'bolo_params',flags,count=[1,144],offset=[0,0]
  ncdf_varput_scale,ncidout,'bolo_params',boloang,count=[1,144],offset=[1,0]
  ncdf_varput_scale,ncidout,'bolo_params',bolodist,count=[1,144],offset=[2,0]
  ncdf_control,ncidout,/redef
    ncdf_attput,ncidout,'bolo_params','file',bolo_params_file,/char
  ncdf_control,ncidout,/endef
endif

;get flux calibration from flux_cal_file if set (JS 2005/04/19)
if keyword_set(flux_cal_file) then begin
  rel_resp = fltarr(144)
  restore, flux_cal_file
  file_date = yymmdd_obsnum_str_to_num($
		strmid(input_file, strpos(input_file, '/', /reverse_search)+1, 10))
  file_date = float(file_date[0]) + float(file_date[1])/1000.
  calib_start_dates = float(calibration.valid_dates[0]) + $
		      float(calibration.valid_obs[0])/1000.
  calib_end_dates = float(calibration.valid_dates[1]) + $
		    float(calibration.valid_obs[1])/1000.
  valid_index = where(file_date ge calib_start_dates and file_date le calib_end_dates)
  if n_elements(valid_index) gt 1 or valid_index[0] lt 0 then $
    message, 'flux_cal_file does not contain data for this observation,' + $ 
	     'or it contains more than one calibration.  Filename = ' + input_file ;MF - 2007-10-22 corrected typo

  ;ok, so we have calibration data for this file, but we will need
  ;to know the dc level for it to help
  ncdf_varget_scale, input_file, 'dc_bolos', temp_dc, $
    offset = [0,start_frame], count = [nbolos,nframes]
  med_dc = median(temp_dc[calibration[valid_index].goodbolos,*])
  temp_dc = 1B
  temp_goodbolos = calibration[valid_index].goodbolos

  ;now determine relative responsivities
  for ind_bolo=0, n_elements(temp_goodbolos-1)-1 do $
    rel_resp[temp_goodbolos[ind_bolo]] = $
       poly(med_dc,[calibration[valid_index].polyfit_med_dc_vs_rel_resp[*,ind_bolo],0.])

  ncdf_varput_scale, ncidout, 'rel_resp', rel_resp, count = 144, offset = 0
  ncdf_control, ncidout, /redef
  ncdf_attput, ncidout, 'rel_resp', 'file', flux_cal_file, /char
  ncdf_control, ncidout, /endef
endif

;------------------------------------------------------------------------------
; filter/downsample the ac and dc bolo data and write to new file
;------------------------------------------------------------------------------

; all variables with a time dimension will be explicitly written out,
; perhaps after some sort of processing

; frequency array pre-downsampling
if (fft_flag) then begin
   freq = fft_mkfreq(sample_interval, nframes)
   message, /cont, 'Fourier transforming bolometer data for filtering....' + $
          '(this may take a while)'
endif
filt_ac = replicate(1., nframes)
filt_dc = replicate(1., nframes)

; electronics deconvolution filter
if keyword_set(deconv_elec_flag) then begin
   filt_ac = $
      filt_ac $
      / ( eps(/float) + lockin_filter_fn(freq, /unity_gain_flag) )
   filt_ac[0] = 0.
   filt_dc = $
      filt_dc $
      / ( eps(/float) + lockin_filter_fn(freq, /unity_gain_flag, /dc_flag) )
endif

; downsampling anti-alias filter, as well as deconvolution of same filter
if downsample_factor ne 1 or keyword_set(lp_filt) then begin
   if keyword_set(lp_filt) then begin
      old_sample_interval = sample_interval
      sample_interval = 1. / (2.*float(lp_filt))
   endif
   fnyq = 1./(2. * sample_interval)
   fnyq_out = fnyq / downsample_factor
   filt_ac = filt_ac/(1. + 10.^(abs(freq/(fnyq_out))^3.))
   filt_dc = filt_dc/(1. + 10.^(abs(freq/(fnyq_out))^3.))
   freq_out = fft_mkfreq(sample_interval * downsample_factor, nframes_out)
   ; SG 2007/02/07 
   ; old method could result in one frame too many, which causes
   ; all hell to break loose below (filt and data not aligned!)
   ;index_ds = where(lindgen(nframes) mod downsample_factor eq 0)
   index_ds = $
      where(lindgen(nframes) mod downsample_factor eq downsample_factor-1)
   filt_ds_deconv = (1. + 10.^(abs(freq_out/(fnyq_out))^3.))
   if keyword_set(lp_filt) then sample_interval = old_sample_interval
endif 

; process the ac and dc data first
data = fltarr(nframes)
data_out = fltarr(nframes_out)
data_ft = complexarr(nframes)
data_out_ft = complexarr(nframes_out)

;check if we are correcting for the DAS
if keyword_set(DAS_sampling_offset_file) then begin
  readcol, DAS_sampling_offset_file, format = '(X,F)', DAS_offset, /silent
  DAS_offset = DAS_offset / sample_interval 
endif

for ibolo = 0, nbolos-1 do begin

    ;read in the bolometer data
    ncdf_varget_scale, ncid, /noclose, 'ac_bolos', ac, $
	   offset = [ibolo,start_frame], count = [1,nframes]
    ncdf_varget_scale, ncid, /noclose, 'dc_bolos', dc, $
	   offset = [ibolo,start_frame], count = [1,nframes]

   ; for ac_bolos
   data = reform(ac)
   if keyword_set(deconv_elec_flag) or downsample_factor ne 1 $
      or keyword_set(deconv_bolo_tau) or keyword_set(lp_filt) $
      or keyword_set(DAS_sampling_offset_file) then begin
     data_ft = fft(data, -1)
     data_ft = data_ft * filt_ac
     ; deconvolve the bolometer time constant
     ; we don't precalculate because we would have to store 
     ; nbolos x nsamples entries
     if keyword_set(deconv_bolo_tau) then $
        data_ft = $
           data_ft / ( eps(/float) + lpf_1pole(freq, deconv_bolo_tau[ibolo]) )
     if keyword_set(DAS_sampling_offset_file) then begin
       ;2007/10/15 JS fixed error in filter.  Should have been
       ;the absolute value of the previous incorrect filter.  
       ;This should not
       ;have caused any problems, from simulation I _think_
       ;the phase error caused by my error
       ;is less than 1% below about 10-15 Hz,
       ;and less than .01% below 1-2 Hz which is the HWHM of our beam.
       filter = abs((1-abs(DAS_offset[ibolo])) + $
                 abs(DAS_offset[ibolo])*exp(complex(0.,-2.*!pi*freq*sample_interval*sign(DAS_offset[ibolo]))))
       data_ft = data_ft / filter
     endif
     data = float(fft(data_ft, 1))
   endif

   ;correct for DAS offset, add 0's in case we didn't have an extra sample to
   ;shift so that we don't "wrap around" on our shift
   if keyword_set(DAS_sampling_offset_file) then begin
     data = [data[0],data,data[n_elements(data)-1]]
     data = (1.-abs(DAS_offset[ibolo])) * data + $
                abs(DAS_offset[ibolo]) * shift(data, sign(DAS_offset[ibolo]))
     data = data[1:n_elements(data)-2]
   endif

   if downsample_factor ne 1 then begin
      ; downsample and deconvolve the downsampling filter
      data_out = data[index_ds]
      data_out_ft = fft(data_out, -1)
      data_out_ft = data_out_ft * filt_ds_deconv
      data_out = float(fft(data_out_ft, 1))
   endif else begin
      data_out = data
   endelse

   ; and spit out to output file
   ncdf_varput_scale, ncidout, /noclose, 'ac_bolos', data_out, $
      offset = [ibolo, 0], count = [1, nframes_out]    

   ; for dc_bolos
   data = reform(dc)
   if keyword_set(deconv_elec_flag) or downsample_factor ne 1 $
      or keyword_set(deconv_bolo_tau) or keyword_set(lp_filt) $
      or keyword_set(DAS_sampling_offset_file) then begin
     data_ft = fft(data, -1)
     data_ft = data_ft * filt_dc
     ; deconvolve the bolometer time constant
     ; we don't precalculate because we would have to store 
     ; nbolos x nsamples entries
     if keyword_set(deconv_bolo_tau) then $
        data_ft = $
           data_ft / ( eps(/float) + lpf_1pole(freq, deconv_bolo_tau[ibolo]) )
     if keyword_set(DAS_sampling_offset_file) then begin
       filter = ((1-abs(DAS_offset[ibolo])) + $
                 abs(DAS_offset[ibolo])*exp(complex(0.,-2.*!pi*freq*sample_interval*sign(DAS_offset[ibolo])))) * $
                exp(complex(0.,2.*!pi*freq*DAS_offset[ibolo]*sample_interval))
       data_ft = data_ft / filter
     endif
     data = float(fft(data_ft, 1))
   endif

   ;correct for DAS offset, add 0's in case we didn't have an extra sample to
   ;shift so that we don't "wrap around" on our shift
   if keyword_set(DAS_sampling_offset_file) then begin
     data = [data[0],data,data[n_elements(data)-1]]
     data = (1.-abs(DAS_offset[ibolo])) * data + $
                abs(DAS_offset[ibolo]) * shift(data, sign(DAS_offset[ibolo]))
     data = data[1:n_elements(data)-2]
   endif

   if downsample_factor ne 1 then begin
      ; downsample and deconvolve the downsampling filter
      data_out = data[index_ds]
      data_out_ft = fft(data_out, -1)
      data_out_ft = data_out_ft * filt_ds_deconv
      data_out = float(fft(data_out_ft, 1))
   endif else begin
      data_out = data
   endelse

   ; and spit out to output file
   ncdf_varput_scale, ncidout, /noclose, 'dc_bolos', data_out, $
      offset = [ibolo, 0], count = [1, nframes_out]    

endfor
ac = 0 & dc = 0

;------------------------------------------------------------------------------
; downsample and transfer the remaining time_dim variables
;------------------------------------------------------------------------------

; for the rest of the variables, we just copy, possibly with a
; downsampling.  We assume noise is not an issue elsewhere, so
; no anti-alias filtering

das_var_names = ['flags', 'ac_bias', 'dc_bias', $
                 'ref_acbias', 'ref_dcbias', 'rgrt', $
                 'chop_enc', 'acq_das', 'trck_das', $
                 'tran_das', 'rot_enab', 'rotating', $
                 'rot_lim']
if keyword_set(precise_scans_offset_file) then $
  ncdf_varget_scale, ncid, 'ut', old_ut 

message, /cont, 'Transferring all time dimension variables....' + $
         '(this may take a while)'
for varid = 0, inq.nvars-1 do begin
 if varid_new_arr[varid] ge 0 then begin
   inq_v = ncdf_varinq(ncid, varid)
   if (inq_v.ndims ne 0) then begin
      ; not a scalar, so there may be a time dimension
      var_dimid_arr = inq_v.dim
      index_time_dim = where(var_dimid_arr eq time_dimid)
      if (index_time_dim[0] ne -1) then begin

         ; we have a time dimension, make sure the variable is not
         ; one that we have already processed
         if not total(strmatch(['ac_bolos','dc_bolos','trck_das','trck_tel'], $
                               inq_v.name, /fold_case)) then begin

           ; ok, it's a variable we can copy, possibly with downsampling,
           ; so construct the count and stride arrays
           count = fltarr(inq_v.ndims)
           stride = replicate(1, inq_v.ndims)
           for dim_index = 0, inq_v.ndims-1 do begin
              ncdf_diminq, ncid, var_dimid_arr[dim_index], dummy, count_this
              count[dim_index] = count_this
           endfor
           if downsample_factor ne 1 then $
              stride[index_time_dim[0]] = downsample_factor
           count[index_time_dim[0]] = nframes_out
           temp_offset = lonarr(n_elements(count))

           ;------------------------------------------------------------------
           ;we are reading in DAS data or the data has already been 
           ;downsampled, so scans offset isn't applied
           ;------------------------------------------------------------------
           if (total(strmatch(das_var_names,inq_v.name,/fold_case)) gt 0 or $
               num_cleaned ne 0) then begin
             temp_offset[index_time_dim[0]] = start_frame  
             ncdf_varget, ncid, varid, val, count = count, stride = stride, $
                                            offset = temp_offset

           ;------------------------------------------------------------------
           ;we are reading in tel data, so need to apply scans offset
           ;-----------------------------------------------------------------
           endif else begin

             ;----------------------------------------------------------------
             ;precise scans offset wasn't set, so we just need to apply
             ;the scans offset when reading the data in
             ;---------------------------------------------------------------
             if not keyword_set(precise_scans_offset_file) then begin

               ;first, let's see if the scans offset stays the same for
               ;the entire observation, this is easier if it does
               if n_elements(offset) gt 1 then begin
       	         delta_offset = shift(offset,-1) - offset
                 offset_change = where(delta_offset ne 0)
                 ;have to throw away last point because we subtracted
                 ;the first offset from the last
                 offset_change = offset_change[$
                        where(offset_change ne (n_elements(offset)-1))]
               endif else begin
                 offset_change = -1
               endelse 
               if offset_change[0] eq -1 then begin
                 ; 2004/12/29 SG add [ ] around offset in case offset
                 ; is scalar

                 temp_offset[index_time_dim[0]] = $
                        start_frame - long(median([offset]))
                 ncdf_varget, ncid, varid, val, count = count, $
                        stride = stride, offset = temp_offset

               ;well, the scans offset changes so we need to account for it.
               ;Throw away or add samples in between scans to make
               ;up for the changing offset.  Unless data in the exact
               ;middle between 2 scans is used this will not affect
               ;any of the analysis.
               ;IF YOU WANT TO USE THAT DATA THEN CALL PRECISE SCANS OFFSET!
               endif else begin
                 n_offsets = n_elements(offset_change)+1

                 ;first, determine how many samples are in a block, and the
                 ;starting point of that block.  We have to be careful when
                 ;calculating the starting point, if the starting point (mod)
                 ;downsample_factor is not correct then the data will not
                 ;line up properly!
                 between_scans = [0L,long(.5 *(new_scanend[offset_change] + $
                    new_scanstart[offset_change+1])),nframes_out] 
                 temp_nframes_out = shift(between_scans,-1) - between_scans
                 temp_nframes_out = temp_nframes_out[indgen(n_offsets)]
                 new_start_frame = start_frame - offset[0]
                 temp_start = [new_start_frame,lonarr(n_offsets-1)]

                 for i_start=1, n_offsets-1 do $
                   temp_start[i_start] = temp_start[i_start-1]+ $
                      stride * temp_nframes_out[i_start-1] - $
                      delta_offset[offset_change[i_start-1]]

                 ;now read in the data from each block with the same value
                 ;for scans offset
                 for i_offset=0, n_offsets-1 do begin
                   count[index_time_dim[0]] = temp_nframes_out[i_offset]
                   temp_offset[index_time_dim[0]] = temp_start[i_offset]
                   ncdf_varget, ncid, varid, temp_val, count = count, $
                          stride = stride, offset = temp_offset
                   if i_offset eq 0 then val = temp_val $

                   ;at this point we need to be careful because of how idl
                   ;concatenates arrays.  Currently, all tel variables are 
                   ;1-dimensional so this works.  If, for some reason, a 
                   ;tel variable has dimensions (n,time) then to concatenate
                   ;you would need to put val = [[val],[temp_val]]. 
                   else val = [val,temp_val]
                 endfor

               endelse

             ;----------------------------------------------------------------
             ;precise scans offset was set, so let's do it
             ;----------------------------------------------------------------
             endif else begin
               
               ;first, we need to make sure we read in enough data
               ;so that after applying the offset we have values
               ;for every frame
               fit_offset = old_ut * slope + intercept
               max_offset = long(max(ceil(abs(fit_offset))))+1L
               new_start_frame = long(max([start_frame - max_offset,0L]))
               temp_offset[index_time_dim[0]] = new_start_frame
	       ;JS 2007/04/03 change how temp_nframes defined
               temp_nframes = long(min([nframes + 2 * max_offset,$
	       nframes_raw-new_start_frame-1L]))
               count[index_time_dim[0]] = temp_nframes

               ;now read in the data WITHOUT DOWNSAMPLING IT.  We need
               ;to apply the precise scans offset to data before it's
               ;downsampled.
               ncdf_varget, ncid, varid, temp_val, count = count, $
                  offset = temp_offset
               ;the precise scans offset is calculated as a function of 
               ;ut, so we need the ut times corresponding to this data
               temp_ut = $
                  old_ut[new_start_frame : new_start_frame+temp_nframes-1L]
               ;apply the offset, then trim the "extra" samples that were
               ;used as a buffer for the offset and downsample
               val = apply_precise_scans_offset($
                             temp_ut, temp_val, intercept, slope)
               temp_start = min([start_frame,max_offset])
               val = val[temp_start : temp_start+nframes-1L]
               if downsample_factor ne 1 then val = val[index_ds]

             endelse ; if precise scans offset called
           endelse ; if das variable
      
           ncdf_varput, ncidout, varid_new_arr[varid], val

         endif else begin  ; if (strmatch ..
           if (inq_v.name eq 'trck_das') then begin
             ;if we read in trck das then we want to make trck_das equal to 0 or
             ;5 depending on if we are scanning, according to scans_info
             val = replicate(5, nframes_out)
             for i_scan=0, nscans-1 do $
             val[new_scanstart[i_scan] : new_scanend[i_scan]] = 0
             ncdf_varput_scale, ncidout, varid_new_arr[varid], val,/noclose
           endif 
           if (inq_v.name eq 'trck_tel') then begin
             ;if we read in trck tel then we want to make trck_das equal to 0 or
             ;1 depending on if we are scanning, according to scans_info
             val = replicate(1B, nframes_out)
             for i_scan=0, nscans-1 do $
             val[new_scanstart[i_scan] : new_scanend[i_scan]] = 0
             ncdf_varput_scale, ncidout, varid_new_arr[varid], val, /noclose
           endif
         endelse
      endif ; if (index_time_dim[0] ne -1)
   endif ; if (inq_v.ndims ne 0)
 endif
endfor ; for varid = 0, inq.nvars-1

; close files
ncdf_close, ncid
ncdf_close, ncidout

;reset downsample factor if needed
if n_elements(no_ds_flag) gt 0 then downsample_factor = 0

end
