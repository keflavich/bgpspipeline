pro getfiles, path, maps = maps, errormaps = errormaps, $
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
  endfor

  return
end
