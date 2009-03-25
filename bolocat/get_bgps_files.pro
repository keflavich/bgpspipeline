pro get_bgps_files, path, maps = maps, errormaps = errormaps, $
              smoothmaps = smoothmaps, model = model, nfields = nfield

  fl = file_search(path+'*.fits')

  hyph = strpos(fl, '/', /reverse_search)
  under = stregex(fl, '_')

  roots = strmid(fl, hyph+1, under-hyph-1)
  roots = roots[uniq(roots, sort(roots))]

  nfield = n_elements(roots) 
  maps = strarr(nfield)
  errormaps = strarr(nfield)
  smoothmaps = strarr(nfield)
  model = strarr(nfield)
  

  for i = 0, nfield-1 do begin
    mapind = where(stregex(fl, roots[i], /bool) and $
                   stregex(fl, '_map09', /bool), ct)
    if ct eq 1 then maps[i] = fl[mapind]
    emapind = where(stregex(fl, roots[i], /bool) and $
                   stregex(fl, '_noisemap09', /bool), ct)
    if ct eq 1 then errormaps[i] = fl[emapind]
    smind = where(stregex(fl, roots[i], /bool) and $
                   stregex(fl, '_smoothmap09', /bool), ct)
    if ct eq 1 then smoothmaps[i] = fl[smind]
    modind = where(stregex(fl, roots[i], /bool) and $
                   stregex(fl, '_model09', /bool), ct)
    if ct eq 1 then model[i] = fl[modind]
    if ct eq 0 then begin
      tag = strpos(maps[i], '_map09')
      slash = strpos(maps[i], '/', /reverse_search)
      start = strmid(maps[i], slash+1, tag-slash)
      fl2 = file_search('/scratch/adam_work/'+roots[i]+'/'+start+'model09.fits', count = ct2)
      if ct2 eq 1 then model[i] = fl2[0]
    endif
  endfor

  return
end
