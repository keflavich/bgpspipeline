function objectid, data, all_neighbors = all_neighbors, $
                   minpix = minpix, CLIP = clipflag, WATERSHED = watershed, $
                   thresh = thresh, error = error_map, expand = expand, $
                   delta = delta, absdelta = absdelta, $
                   absthresh = absthresh, absexpand = absexpand, round = round
;+
; NAME:
;     OBJECTID
; PURPOSE:
;     To identify objects in BOLOCAM maps
; CALLING SEQUENCE:
;     objects = objectid(data, error = error [, /watershed, /clip, 
;                        delta = delta,
;                        /all_neighbors, thresh = thresh, 
;                        expand = expand, minpix = minpix])
;
; INPUTS:
;     DATA -- An image array
; OPTIONAL INPUTS:
;     ERROR -- An estimate of the uncertainty in the value of each point
;
; KEYWORD PARAMETERS: 
;    /WATERSHED -- Use a seeded watershed decomposition on regions to
;                  determine objects
;    /CLIP -- Identify objects by clipping with no decomposition.
;    DELTA -- Saddle point criterion parameter: Set this parameter to
;             the difference (IN UNITS OF THE LOCAL RMS) a local
;             maximum must be above a saddle-point to represent a
;             unique object.  Default: 2
;    ABSDELTA -- As DELTA but sets the decomposition in units of the
;                original map.  Use for a uniform decomposition across
;                the maps.
;    /ALL_NEIGHBORS -- Swith that controls the number of neighbors a
;                      pixel has.  Default is 4 neighbors; set the
;                      switch if a pixel should have 8 neighbors.
;    THRESH -- Initial thresholding value for determining significant
;              emission in units of the local RMS.  Default: 3
;    MINPIX -- Significant regions with fewer pixels than MINPIX are
;              rejected.  Default: 10.  
;    EXPAND -- After rejecting small regions, the remaining regions
;              are expanded to include all connected emission down to
;              this threshold (in units of the local RMS).  Default: 2.
;    ROUND -- Size of rounding element used in the mask.
;
; OUTPUTS:
;   OBJ -- An object mask of the same dimensions as the input image
;          with the pixels corresponding to the kth element of props
;          labeled with the value k.

; MODIFICATION HISTORY:
;
;       Tue May 29 12:27:00 2007, Erik <eros@yggdrasil.local>
;
;		Documented.
;
;-
  
  if n_elements(minpix) eq 0 then minpix = 10
  if n_elements(thresh) eq 0 then thresh = 3
  if n_elements(expand) eq 0 then expand = 2
  if n_elements(delta) eq 0 then delta = 2.0
  if n_elements(round) eq 0 then round = 2
  CLIP = 1b

  nparam = max([n_elements(minpix), n_elements(thresh), $
                n_elements(expand), n_elements(delta)]) 
  if nparam gt 1 then begin
    minpix = n_elements(minpix) eq 1 ? rebin([minpix], nparam) : minpix
    thresh = n_elements(thresh) eq 1 ? rebin([thresh], nparam) : thresh
    expand = n_elements(expand) eq 1 ? rebin([expand], nparam) : expand
    delta = n_elements(delta) eq 1 ? rebin([delta], nparam) : delta
    absdelta = n_elements(absdelta) eq 1 ? rebin([absdelta], nparam) : absdelta
  endif

  sz = size(data)

; ERROR ESTIMATE MAP HERE
  if n_elements(error_map) eq 0 then $ 
    error_map = fltarr(sz[1], sz[2])+mad(data)

  if keyword_set(absdelta) then begin
    error_map = 1.0+fltarr(sz[1], sz[2])
    if keyword_set(absthresh) then thresh = absthresh else thresh = mad(data)*thresh

    if keyword_set(absexpand) then expand = absexpand else expand = mad(DatA)*expand
  endif 

; MAP TO SIGNIFICANCE SPACE
  signif_map = data/error_map
; STRAIGHT CONTOUR CLIP

  if keyword_set(CLIPFLAG) then begin
    clip = signif_map gt thresh
    l = label_region(clip, all_neighbors = all_neighbors, /ulong)
    h = histogram(l, min = 1)
    goodobj = where(h gt minpix, ct)
    if ct eq 0 then return, 0UL
    outmask = byte(clip*0)
    for k = 0, ct-1 do outmask[where(l eq goodobj[k]+1)] = 1b
; speed up here?
    outmask = dilate_mask(outmask, constraint = (signif_map gt expand), $
                          all_neighbors = all_neighbors)
; Experimental rounding of mask
    relt = 3
    elt = shift(dist(2*relt+1, 2*relt+1), relt, relt) le relt
    outmask = morph_close(outmask, elt)
    objects = label_region(outmask, all_neighbors = all_neighbors, /ulong)
  endif 


; RUN A SEEDED WATERSHED

  if keyword_set(WATERSHED) then begin
    mask = make_array(size = size(signif_map), /byte)

    for i = 0, n_elements(thresh)-1 do begin 
      clip = signif_map gt thresh[i]

      relt = round
      elt = shift(dist(2*relt+1, 2*relt+1), relt, relt) le relt
      clip = morph_open(clip, elt)
      l = label_region(clip, all_neighbors = all_neighbors, /ulong)
      if total(l gt 0) eq 0 then continue
      h = histogram(l, min = 1)
      
      goodobj = where(h gt minpix[i], ct)
      if ct eq 0 then continue
; speed up here?
      outmask = byte(clip*0)
      for k = 0, ct-1 do outmask[where(l eq goodobj[k]+1)] = 1b
      
      outmask = dilate_mask(outmask, constraint = (signif_map gt expand[i]), $
                            all_neighbors = all_neighbors)
      outmask = morph_close(outmask, elt)
      
      objects = label_region(outmask, all_neighbors = all_neighbors, /ulong)
      
      l = label_region(objects, all_neighbors = all_neighbors, /ulong)
      if total(l gt 0) eq 0 then continue
      h = histogram(l, min = 1)
      goodobj = where(h gt minpix[i], ct)
      if ct eq 0 then continue

      for k = 0, ct-1 do outmask[where(l eq goodobj[k]+1)] = 1b
      
      ind = where(outmask eq 0)
      
      if keyword_set(absdelta) then begin 
        masked_map = data
        masked_map[ind] = !values.f_nan
        sigma = mad(data)
      endif else begin
        masked_map = signif_map
        masked_map[ind] = !values.f_nan
        sigma = 1
      endelse
      sz = size(masked_map)
      
; Apply a small random dither to prevent peaks with exactly the same
; value being undiscovered.
      dither = 1e-3*(randomn(seed, sz[1], sz[2]))
      
      kset = alllocmax(masked_map+dither, $
                          friends = 5)
      if keyword_set(absdelta) then d = absdelta[i] else d = delta[i]
      
      kernels = (n_elements(kernels) eq 0) ? $
                decimate_kernels(kset, masked_map+dither, $
                                 minpix = minpix[i], $
                                 delta = d, sigma = sigma) : $
                [kernels, decimate_kernels(kset, masked_map+dither, $
                                 minpix = minpix[i], $
                                 delta = d, sigma = sigma)]
      mask = mask or outmask
    endfor
    if n_elements(kernels) eq 0 then return, 0UL
    kernels = kernels[uniq(kernels, sort(kernels))]
    if total(mask) gt 0 then begin
      masked_map = make_array(size = size(signif_map))+!values.f_nan
      masked_map[where(mask)] = signif_map[where(mask)]
      objects = seeded_watershed(masked_map, kernels)
    endif
  endif 
  if n_elements(absdelta) gt 0 then $ 
    error_map = fltarr(sz[1], sz[2])+mad(data)

  return, objects
end
