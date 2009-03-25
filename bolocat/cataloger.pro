pro cataloger, searchpath, atlas = atlas

  get_bgps_files, searchpath, $
            nfields = nfields, $
            maps = maps, $
            errormaps = errormaps, $
            smoothmaps = smoothmaps, $
            model = model
  


  for i = 0, nfields-1 do begin
    if maps[i] eq '' then continue
    data = mrdfits(maps[i], 0, hd)
    if model[i] ne '' then begin
      error = bolocam_emap2(data-mrdfits(model[i], 0, hd))
    endif else begin
      if errormaps[i] ne '' then error = bolocam_emap2(mrdfits(errormaps[i], 0, hd)) else error = bolocam_emap(data)
    endelse
    
    bolocat, maps[i], props = props, /zero2nan, obj = obj, $
             /watershed, delta = 2, $
             all_neighbors = all_neighbors, expand = 0.5, $
             minpix = [22, 5], thresh = [1.0, 3.0], $
             error = error, corect = corect
    if corect eq 0 then continue 
    if n_elements(bgps) eq 0 then bgps = props else bgps = [bgps, props]


  save, file = 'bgps.catalog.dat', bgps
  endfor

  mwrfits, bgps, 'bgps.fits', /create
  if keyword_set(atlas) then atlasplot, bgps

  return
end
