pro cull, bgps, file = file

; Culls a catalog based on a given set of boundary files.
  if n_elements(file) eq 0 then file = 'bounds.txt'
  readcol, file, filename, lmin, lmax, bmin, bmax, format = 'A,F,F,F,F'
  
; Trim to the root filename

  slashpos = strpos(filename, '/', /reverse_search)
  root = strmid(filename, slashpos[0]+1, 40)
  
  catroots = (bgps.filename)
  slashpos = strpos(catroots, '/', /reverse_search)
  catroots = strmid(catroots, slashpos[0]+1, 40)
  catroots = catroots[uniq(catroots, sort(catroots))]

  for i = 0, n_elements(catroots)-1 do begin
    ind = where(root eq catroots[i], ct)

    if ct eq 0 then continue
    for j = 0, ct-1 do begin
      if lmin[ind[j]] eq -1 then continue
      keep = where(strpos(bgps.filename, catroots[i]) ge 0 and $
                   bgps.glon_max ge lmin[ind[j]] and $
                   bgps.glon_max lt lmax[ind[j]] and $
                   bgps.glat_max ge bmin[ind[j]] and $
                   bgps.glat_max lt bmax[ind[j]], ct)
;    filk = where(strpos(bgps.filename, catroots[i]) ge 0)
;    print, catroots[i], root[ind], lmin[ind[0]], lmax[ind[0]]
;    stop
      if ct gt 0 then catout = (n_elements(catout) eq 0) ? bgps[keep] : [catout, bgps[keep]]
    endfor
  endfor
  bgps = catout



  return
end
