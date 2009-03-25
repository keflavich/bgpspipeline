;---------------------------------------------------------------------------------
;
; expsub_module
;
; PURPOSE:
; To subtract out the exponential decay tail of the ac bolometers.
; These decay tails can be caused by rotator spikes, or telescope
; movement at the beginning of a raster or drift.  The decay always
; occurs at the beginning of the subscan and always has a time
; constant of 10.4s from the filter on the lockin amp, so we only fit
; amplitude and offset.
;
; Explanation:
;
; Inputs:
;       chan: structure containing bolocam data (read in by clean_sub_scan)
;
; KEYWORDS:
;       return_mode: set equal to 'version' to have the version number
;         returned, 'input_variables' to have the ncdf variables required
;         by this module returned, or 'output_variables' to have the ncdf
;         variables modified by this program returned.
;         example: temp = 'version'
;                  module, return_mode = temp 
;
; Outputs:
;       Exponential-subtracted data written to timestream
; Special note: 
;	This module uses the IDL curvefit routine, which calls a separate
;	procedure, 'boloexp', to calculate the fit. This procedure is 
;	appended to the end of this file. 
;
; Version History: 
;       1.1 - original
;       1.2 - 2004/08/10 JS modified to conform with new module format
;       1.3 - 2008/08/11 Adam Ginsburg made it NOT modify the input parameters!
;----------------------------------------------------------------------------------

function exponent_sub, timestream, scans_info=scans_info, flags=flags, bolo_params=bolo_params,$
    sample_interval=sample_interval
  goodbolos=where(bolo_params[0,*] eq 1,ngood)
  nscans = n_e(scans_info[0,*])
  timestream_copy = timestream

  for i=0, nscans-1 do begin    ;loop through subscans
    lb = scans_info[0,i]   
    ub = scans_info[1,i]   
    nperscan = ub-lb+1
    flag_scan=fltarr(nperscan)
    data_scan=flag_scan
    for j=0, ngood-1 do begin
      jbolo=goodbolos[j]
      data_scan(*) = timestream_copy[jbolo,lb:ub]
      flagbytes = flags[jbolo,lb:ub]
      if total(flagbytes) lt n_e(flagbytes) - 1 then begin
          good=where(flagbytes eq 0)
          bad=where(flagbytes ne 0)
          if n_e(good) lt n_e(bad) then continue
          if ((size(good))[0] gt 0) then flag_scan(good) = 1
          if ((size(bad))[0] gt 0) then flag_scan(bad) = 0
                                    ; estimate the inital values of a and
                                    ; b for the curvefit function
                                    ; Function we are fitting is:
                                    ; a*exp(-x/10.4sec*50) + b
          a_est=data_scan(good[0])
          b_est=0.
          ;JS 2004/08/13 now that we have a sample interval variable
          ;we need to scale our input to the exponential fit accordingly
          scale = sample_interval / .02
          t = fix(findgen(nperscan) * scale)
          expfit=curvefit(t,data_scan,(1./flag_scan),$
                          [a_est,b_est],$
                          function_name='boloexp',status=status)
                                    ; tol = 1e-4 was here before the
                                    ; default is 1e-3, trying the default
          if (size(expfit))[0] ne 0 then timestream_copy[jbolo,lb:ub]=data_scan-expfit
      endif
    endfor
  endfor
  return,timestream_copy
end













