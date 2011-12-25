pro cataloger, filelist, atlas = atlas, $
               boundary_file = boundary_file, rmsgen = rmsgen

  if n_elements(filelist) eq 0 then filelist = 'v0.6.2.txt'
  if n_elements(boundary_file) eq 0 then boundary_file = 'bounds.txt'

  if n_elements(directory) eq 0 then directory = '~/bgps/v1.0/'

  str = '09'
  str = '50'
  maps = file_search(directory+'*_map'+str+'.fits')
  nfields = n_elements(maps) 

  for i = 0, nfields-1 do begin
    if maps[i] eq '---' then continue
    message, 'Starting map '+maps[i], /con
  data = mrdfits(maps[i], 0, hd)
    ppbeam = sxpar(hd, 'PPBEAM')
    if ppbeam eq 0 then ppbeam = 23.8 ; For 33" beam and 7.2" pixels.
    
    char = stregex(maps[i], '_map'+str)
    weightmap = strmid(maps[i], 0, char+1)+'weight'+strmid(maps[i], char+1, 30)
    noisemap = strmid(maps[i], 0, char+1)+'noise'+strmid(maps[i], char+1, 30)
    smoothmap = strmid(maps[i], 0, char+1)+'smooth'+strmid(maps[i], char+1, 30)
    rmsmap = strmid(maps[i], 0, char+1)+'rms'+strmid(maps[i], char+1, 30)
    nhitsmap = strmid(maps[i], 0, strpos(maps[i], '_13pca_')+7)+'nhitsmap.fits'

    if file_test(nhitsmap) and file_test(noisemap) then begin
        nh = mrdfits(nhitsmap, 0, hd3)
        hastrom, nh, hd3, hd
        badind2 = where(nh eq 0, ct2)
        if ct2 eq 0 then continue
        edge = nh le 3
        edge = remove_islands(edge, 10)
        relt = 3
        elt = shift(dist(2*relt+1, 2*relt+1), relt, relt) le relt
        edge = 1b-(erode(1b-edge, elt))
        badind2 = where(edge, ct2)
        nh[badind2] = !values.f_nan

        if file_test(rmsmap) and (not keyword_set(rmsgen)) then begin 
          error = mrdfits(rmsmap, 0, hdn)
          message, 'Using Cached RMS Map', /con
        endif else begin
          noise = mrdfits(noisemap, 0, hd)
          weight = mrdfits(weightmap, 0, hd)
          error = errormap(noise, nh, weight)
          mwrfits, error, rmsmap, hd, /create
        endelse
      endif
;; ; Begin sharpening

    smoothdata = median(data, 5)
    smoothdata[where(edge)] = !values.f_nan
    
    signif_map = data/error
    bs = 0.025
    h = histogram(signif_map, min = -10, max = 10, binsize = bs)
    xvals = findgen(n_elements(h))*(bs)+bs/2-10
    a = [max(h), 0, mad(signif_map)]
    yfit = mpfitpeak(xvals, h, a, estimates = a, nterms = 3,  parinfo = pinfo)
;    error = error*a[2]
; 
    message, 'Deviation for Normality in RMS map: '+decimals(a[2], 2), /con
; Previously sp_minpix = ppbeam/2
    bolocat, maps[i], props = props, /zero2nan, obj = obj, $
             /watershed, delta = [0.5], $
             all_neighbors = 0b, expand = [1.00], $
             minpix = [ppbeam], thresh = [2.0], $
             error = error, corect = corect, round = [1], $
             sp_minpix = [2], smoothmap = smoothdata, $
             id_minpix = 2, beamuc = 1/33.
    if corect eq 0 then continue 
    if n_elements(bgps) eq 0 then bgps = props else bgps = [bgps, props]
    
    startpos = strpos(maps[i], 'v1.0.2_')
    root = strmid(maps[i], startpos+7, 50)
    endpos = strpos(root, '_')
    root = strmid(root, 0, endpos)
    file=root+'.dat'

    save, file = '~/bgps/catalogs/'+file, props
    save, file = '~/bgps/obj/'+root+'.obj.dat', obj
    save, file = 'bgps.catalog.dat', bgps
  endfor
  cull, bgps, file = boundary_file
  save, file = 'bgps.catalog.dat', bgps
  mwrfits, bgps, 'bgps.fits', /create
  if keyword_set(atlas) then atlasplot, bgps
  
  return
end
