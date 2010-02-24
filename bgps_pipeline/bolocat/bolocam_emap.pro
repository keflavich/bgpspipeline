function bolocam_emap, data, box = box, single = single, niter = niter, $
                       chauv = chauv


; Estimate a spatially-varying error map from the BOLOCAM data.  This
; needs massive improvement or the additional fits extension.

; Currently set to just return the median-absolute-devitation as the
; error at every pixel.  Could use a little help.


  if n_elements(niter) eq 0 then niter = 3
  if n_elements(chauv) eq 0 then chauv = 3

  if n_elements(box) eq 0 then box = 15
  sz = size(DatA)

  negs = fltarr(sz[1], sz[2])+!values.f_nan
  negs[where(data lt 0)] = data[where(data lt 0)]
  emap = fltarr(sz[1], sz[2])+!values.f_nan
  if keyword_set(single) then begin
    global = mad(data)+fltarr(sz[1], sz[2])
    return, global
  endif


  for i = 0, sz[1]-1 do begin
    for j = 0, sz[2]-1 do begin
      negvals = negs[(i-box) > 0 : (i+box) < (sz[1]-1), $
                  (j-box) > 0 : (j+box) < (sz[2]-1)]
      vals = data[(i-box) > 0 : (i+box) < (sz[1]-1), $
                  (j-box) > 0 : (j+box) < (sz[2]-1)]
      testerr = mad([negvals, -negvals])
      if testerr eq testerr then begin
        for k = 0, niter-1 do begin
          goodind = where(abs(vals) lt testerr*chauv, ct)
          if ct eq 0 then continue
          testvals = vals[goodind]
          testerr = mad(testvals)
        endfor
      endif  
      emap[i, j] = testerr
    endfor
  endfor
  
  global = mad(data)
  badind = where((emap eq 0), ct)
  if ct gt 0 then emap[badind] = global

  return, emap
end
