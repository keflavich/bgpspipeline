; pixshift.pro
; example call: 
;   m = readfits('master.fits',mh)
;   i = readfits('image.fits',ih)
;   pixshift,m,i,hd1=mh,hd2=ih,xoff=xoff,yoff=yoff
; OR
; pixshift,'master.fits','image.fits',xoff=xoff,yoff=yoff
;
; 'master' is the image you are aligning to.  It should be a 2d array
; 'image' is the image you're aligning, also a 2d array
; 'hd1' and 'hd2' are FITS headers with WCS coordinates in them
; If hd1,hd2 are not set, the master/image keywords are assumed to be 
; .fits file names.
;
pro pixshift, master, image, hd1=hd1, hd2=hd2, xoff = xoff, yoff = yoff, maxoff = maxoff , check_shift = check_shift, $
    xerr = xerr , yerr = yerr, stamp_residual_fraction = stamp_residual_fraction, check_error = check_error ,         $
    savestamps=savestamps,circular=circular,planefit=planefit

  if n_elements(maxoff) eq 0 then maxoff = 42 
  maxoff0 = maxoff
  if n_elements(planefit) eq 0 then planefit=1
  if n_elements(circular) eq 0 then circular=1

  if ~keyword_set(hd1) then im1 = float(readfits(master, hd1, /silent)) else im1 = float(master)
  if ~keyword_set(hd2) then im2 = float(readfits(image, hd2, /silent)) else im2 = float(image)
  hastrom, im2, hd2, hd1, missing = !values.f_nan

  ;perform NAN checking - this was added 9/18/09 and was NEVER needed before today, but there
  ;is no obvious change to have required it.... scary.  Downright frightening.  What happened?
  ;im1[where(finite(im1,/nan))] = 0
  ;im2[where(finite(im2,/nan))] = 0

  ; only use places where im2 has data to avoid weird correlations with non-common regions
  ; this should also make the cross-correlation computation faster
  ; (we don't need to check on im1 because of the hastrom routine: it will automatically
  ; crop im2 to im1 if im2 is larger)
  xax = total(abs(im2),2,/nan)
  yax = total(abs(im2),1,/nan)
  sz1 = size(im1,/dim)
  minx = min(where(xax gt 0))
  maxx = max(where(xax gt 0))
  miny = min(where(yax gt 0))
  maxy = max(where(yax gt 0))
  ; have to make sure that im2 doesn't have data outside of im1's size
  if maxx ge sz1[0] then maxx = sz1[0]-1
  if maxy ge sz1[1] then maxy = sz1[1]-1

  subim1 = im1[minx:maxx,miny:maxy]
  subim2 = im2[minx:maxx,miny:maxy]

  ppbeam = sxpar(hd1, 'PPBEAM')
  sigbeam = sqrt(ppbeam/2/!pi)*2 
  width = sqrt(ppbeam/8/alog(2))*2

  noise1 = mad(subim1)
  noise2 = mad(subim2)

  ind1 = where(subim1 gt 2*noise1,nhi1)
  ind2 = where(subim2 gt 2*noise2,nhi2)

  ; shifts are zero if there is zero signal
  if nhi1 eq 0 or nhi2 eq 0 then begin
      xoff=0
      yoff=0
      xerr=0
      yerr=0
      return
  endif
  
  sz = size(subim1)
  clean1 = fltarr(sz[1], sz[2])
  clean2 = clean1
  clean1[ind1] = subim1[ind1]
  clean2[ind2] = subim2[ind2]

  corr = convolve(clean1, clean2, /correl)
  
  x0 = sz[1]/2-maxoff
  x1 = x0+2*maxoff+1
  y0 = sz[2]/2-maxoff
  y1 = y0+2*maxoff+1
  ; error checking: don't try to index larger than array
  ; but we have to add back in any shift in the lower left down below
  ; because that's how xoff/yoff are determined
  extra_x = 0
  extra_y = 0
  if x0 lt 0 then begin
      extra_x = x0
      x0 = 0
  endif
  if y0 lt 0 then begin
      extra_y = y0
      y0 = 0
  endif
  if x1 ge sz[1] then x1 = sz[1]-1
  if y1 ge sz[2] then y1 = sz[2]-1

  stamp = corr[x0:x1, y0:y1]

  amp = max(stamp, ind)
  szstamp = size(stamp)
  baseval = median(stamp)
  
  params = [baseval, amp-baseval, sigbeam, sigbeam, ind mod szstamp[1], ind/szstamp[1] , 0]
  ; mpfit2dpeak requires 7 parameters
  parinfo = replicate({value:0.0,limited:[0,0],limits:[0.,0.]},7)
  parinfo[1].limited = [1,0]
  parinfo[2].limited = [1,1]
  parinfo[3].limited = [1,1]
  parinfo[2].limits = [1.0,sigbeam*2.]
  parinfo[3].limits = [1.0,sigbeam*2.]
  parinfo.value = params
  
  if keyword_set(planefit) then begin
      x = dindgen(szstamp[1])
      y = dindgen(szstamp[2])
      xx = x[*] # (y[*]*0 + 1)
      yy = (x[*]*0 + 1) # y[*]

      g=params[0]+params[1]*exp(-.5*( ((xx-params[4])/params[2])^2 + ((yy-params[5])/params[3])^2 ))

      plane = stamp-g
      p = fit_plane2d(plane,znew=fp,/dompfit)
  endif else fp=0

  test = mpfit2dpeak(stamp-fp, params, estimates=params, perror=perror, chisq=chisq, circular=circular, parinfo=parinfo, status=status, errmsg=errmsg)
  if status ne 1 then params = [baseval, amp-baseval, sigbeam, sigbeam, ind mod szstamp[1], ind/szstamp[1] , 0] ; reset and try again...

  if n_elements(perror) ne 7 or params[1] le 0 then begin
    xoff = -1e5 ; force bad 
    yoff = -1e5 ; force bad 
    xerr = -1e5 ; force bad 
    yerr = -1e5 ; force bad 
    test = stamp*0
    stamp_residual_fraction = 0
  endif else begin
      xoff = (params[4]-maxoff-1*(sz[1] mod 2 eq 1))-extra_x
      yoff = (params[5]-maxoff-1*(sz[2] mod 2 eq 1))-extra_y
      xerr = perror[4]
      yerr = perror[5]
      stamp_residual_fraction = total((stamp-test)^2)/total(stamp^2)
  endelse

  if ((max(stamp) ne max(corr)) and (abs(xoff) gt 10 and abs(yoff) gt 10)) and $
 (abs(xoff) lt 20 and abs(yoff) lt 20) then begin
     print,"WARNING WARNING WARNING *** OFFSETS GREATER THAN 10 BUT ACCEPTED **** WARNING WARNING WARNING"
     if keyword_set(check_error) then begin
         print,"xoff,yoff:",xoff,yoff
         print,"max(stamp):",max(stamp),"  max(corr):",max(corr)
         checkshift,stamp,fp,test,xoff,yoff,params,extra_x,extra_y,sz,maxoff,im1,im2,clean1,clean2,corr,subim1,subim2,sigbeam
     endif
 endif

 if keyword_set(check_error) then begin
     xoff1 = xoff
     yoff1 = yoff
     stamp1 = stamp
     test1 = test
     if keyword_set(planefit) then plane1 = fp
 endif
  
  ; check to make sure the right point is found
  if ((max(stamp) ne max(corr)) and (abs(xoff) gt 20 and abs(yoff) gt 20)) or $
    (abs(xoff) gt maxoff*.75 or abs(yoff) gt maxoff*.75) then begin
      print,"WARNING!  x,y offs were too large: ",xoff,yoff," so a different method is being attempted"

      m=max(corr,whmax)
      xc = whmax mod (size(corr,/dim))[0]
      yc = whmax / (size(corr,/dim))[0]
      x0a = xc - maxoff
      x1a = xc + maxoff + 1
      y0a = yc - maxoff
      y1a = yc + maxoff + 1
      extra_xa = 0
      extra_ya = 0
      if x0a lt 0 then begin
          extra_xa = x0a
          x0a = 0
      endif
      if y0a lt 0 then begin
          extra_ya = y0a
          y0a = 0
      endif
      if x1a gt sz[1] then x1a = sz[1]-1
      if y1a gt sz[2] then y1a = sz[2]-1
      stamp2 = corr[x0a:x1a,y0a:y1a]

      amp = max(stamp2, ind)
      szstamp = size(stamp2)
      baseval = median(stamp2)
      
      params = [baseval, amp-baseval, sigbeam, sigbeam, ind mod szstamp[1], ind/szstamp[1] , 0]
      
      test = mpfit2dpeak(stamp2, params, estimates=params, perror=perror, chisq=chisq, circular=circular, parinfo=parinfo, status=status, errmsg=errmsg)
      if status ne 1 then print,"Status ",status," params: ",params
      if errmsg ne '' then message,errmsg,/info

      if params[1] le 0 or n_elements(perror) ne 7 then xoff = -1e5 $
      else begin
          xoff = (params[4]-maxoff-1*(sz[1] mod 2 eq 1))-sz[1]/2+xc-extra_xa
          yoff = (params[5]-maxoff-1*(sz[2] mod 2 eq 1))-sz[2]/2+yc-extra_ya
          xerr = perror[4]
          yerr = perror[5]
          stamp_residual_fraction = sqrt(total((stamp2-test)^2)/total(stamp2^2))
      endelse

  endif

  if ((max(stamp) ne max(corr)) and (abs(xoff) gt 10 and abs(yoff) gt 10)) or $
    (abs(xoff) gt maxoff*.75 or abs(yoff) gt maxoff*.75) then begin
      print,"WARNING!  x,y offs were too large on the SECOND TRY too: ",xoff,yoff," so a third method is being attempted"
      print,"This third method is meant to deal with small overlap regions that may be confused by high noise, it restricts"
      print,"to a maximum 15 pixel offset (really less than that in practice) and therefore should be checked carefully."

      if keyword_set(check_error) then begin
          test2 = test
          stamp2 = stamp2
          xoff2 = xoff
          yoff2 = yoff
      endif
 
      if maxoff gt 15 then maxoff = 15
      x0 = sz[1]/2-maxoff
      x1 = x0+2*maxoff+1
      y0 = sz[2]/2-maxoff
      y1 = y0+2*maxoff+1
      ; error checking: don't try to index larger than array
      ; but we have to add back in any shift in the lower left down below
      ; because that's how xoff/yoff are determined
      extra_x = 0
      extra_y = 0
      if x0 lt 0 then begin
          extra_x = x0
          x0 = 0
      endif
      if y0 lt 0 then begin
          extra_y = y0
          y0 = 0
      endif
      if x1 ge sz[1] then x1 = sz[1]-1
      if y1 ge sz[2] then y1 = sz[2]-1

      stamp = corr[x0:x1, y0:y1]


      amp = max(stamp, ind)
      szstamp = size(stamp)
      baseval = median(stamp)
      
      params = [baseval, amp-baseval, sigbeam, sigbeam, ind mod szstamp[1], ind/szstamp[1], 0]

      x = dindgen(szstamp[1])
      y = dindgen(szstamp[2])
      xx = x[*] # (y[*]*0 + 1)
      yy = (x[*]*0 + 1) # y[*]

      g=params[0]+params[1]*exp(-.5*( ((xx-params[4])/params[2])^2 + ((yy-params[5])/params[3])^2 ))

      ; fit a plane to the moment-subtracted
      plane = stamp-g
      p = fit_plane2d(plane,znew=fp,/dompfit)
      
      test = mpfit2dpeak(stamp-fp, params, estimates=params, perror=perror, chisq=chisq, circular=circular, parinfo=parinfo, status=status, errmsg=errmsg)
      if errmsg ne '' then message,errmsg,/info

      if params[1] le 0 or n_elements(perror) ne 7 then begin
        xoff = -1e5 
        yoff = -1e5 
        xerr = -1e5 
        yerr = -1e5 
        test = stamp*0
      endif else begin
          xoff = (params[4]-maxoff-1*(sz[1] mod 2 eq 1))-extra_x
          yoff = (params[5]-maxoff-1*(sz[2] mod 2 eq 1))-extra_y
          xerr = perror[4]
          yerr = perror[5]
          stamp_residual_fraction = total((stamp-test)^2)/total(stamp^2)
      endelse
      if abs(xoff) gt maxoff or abs(yoff) gt maxoff then begin
          print,"Fitting failed.  X,Y offsets were ",xoff,yoff," but they have been set to ZERO"
          xoff=0
          yoff=0

          if keyword_set(check_error) then begin
              print,"Planar fit parameters:",p
              print,"Gaussian parameters:",params
              xoff3 = (params[4]-maxoff-1*(sz[1] mod 2 eq 1))-extra_x
              yoff3 = (params[5]-maxoff-1*(sz[2] mod 2 eq 1))-extra_y
              print,"xoff,yoff 3: ",xoff3,yoff3
              print,"xoff,yoff 2: ",xoff2,yoff2
              print,"xoff,yoff 1: ",xoff1,yoff1
              ;imdisp,stamp-fp
              ;stop
          endif
      endif 
      if keyword_set(check_error) then checkshift,stamp,fp,test,xoff,yoff,params,extra_x,extra_y,sz,maxoff,im1,im2,clean1,clean2,corr,subim1,subim2,sigbeam

  endif
      


  if keyword_set(check_shift) then begin
    checkshift,stamp,fp,test,xoff,yoff,params,extra_x,extra_y,sz,maxoff,im1,im2,clean1,clean2,corr,subim1,subim2,sigbeam
  endif
  maxoff = maxoff0

  return
end
