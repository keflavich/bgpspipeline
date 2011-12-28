function boundary_mask, filein, file = file

  if n_elements(file) eq 0 then file = 'bounds.txt'
  readcol, file, filename, lmin, lmax, bmin, bmax, format = 'A,F,F,F,F'
  
; Trim to the root filename

  slashpos = strpos(filename, '/', /reverse_search)
  root = strmid(filename, slashpos[0]+1, 40)
  
  catroots = filein

  slashpos = strpos(catroots, '/', /reverse_search)
  catroots = strmid(catroots, slashpos[0]+1, 40)
  catroots = catroots[uniq(catroots, sort(catroots))]


  hd = headfits(filein)
  nx = sxpar(hd, 'NAXIS1')
  ny = sxpar(hd, 'NAXIS2')


;  x = dindgen(nx)#replicate(1, ny)
;  y = replicate(1, nx)#dindgen(ny)

  x = dindgen(nx)
  y = dindgen(ny)
  extast, hd, astrom
  xy2ad, x, ny/2, astrom, l, null
  xy2ad, nx/2, y, astrom, null, b
  

; Yay for the CAR projection
  l = l#replicate(1, ny)
  b = replicate(1, nx)#b 

  ind = where(root eq catroots, ct)
  mask = bytarr(nx, ny)
  bdr = 0.05
  for i = 0, ct-1 do begin
    mask = mask or (l ge (lmin[ind[i]]-bdr) and $
                    l lt (lmax[ind[i]]+bdr) and $
                    b ge (bmin[ind[i]]-bdr) and $
                    b lt (bmax[ind[i]]+bdr))
  endfor
  return, 1b-mask
end
