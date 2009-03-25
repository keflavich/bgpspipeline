function decimate_catalog, p, mindist
  
; Cataloging the same piece of sky imaged in multiple tiles results in
; multiple entries.  To eliminate double counting run this routine.
; It removes double entries with < 20'' separation.  


  if n_elements(mindist) eq 0 then mindist = 20

  dmat = fltarr(n_elements(p), n_elements(p))
  
  keep = intarr(n_elements(p)) 
  for k = 0, n_elements(p)-1 do begin 
    gcirc, 2, p.ra, p.dec, p[k].ra, p[k].dec, dist
    dmat[*, k] = dist
    ind = where(dist lt mindist and p.filename ne p[k].filename, ct)
    if ct eq 0 then keep[k] = k else begin
      ind = [k, ind]
      null = max([p[k].mn_s2n, p[ind[1:*]].mn_s2n], thisone)
      keep[k] = ind[thisone]
    endelse
  endfor
  
  keep = keep[uniq(keep, sort(keep))]
  

  pout = p[keep]


  return, pout
end
