
pro mosaicer, fl

; Stitch together GRS tiles into a big map.


  for k = 0, n_elements(fl)-1 do begin
    hd = headfitS(fl[k])
    hd = degls(hd)    
    heuler, hd, /gal
    extast, hd, astrom
    s1 = sxpar(hd, 'NAXIS1')
    s2 = sxpar(hd, 'NAXIS2')
    xarr = findgen(s1)#replicate(1, s2)
    yarr = replicate(1, s1)#findgen(s2)
    xy2ad, xarr, yarr, astrom, l, b
    l = reform(l, n_elements(l))
    b = reform(b, n_elements(b)) 
    trouble = where(l gt 270, ct)
    if ct gt 0 then l[trouble] = l[trouble]-360
    if k eq 0 then begin
      l0 = min(l)
      l1 = max(l)
      b0 = min(b)
      b1 = max(b)
    endif else begin
      l0 = min(l) < l0
      l1 = max(l) > l1
      b0 = min(b) < b0
      b1 = max(b) > b1
    endelse
  endfor 
  hd = headfits(fl[0])
  getrot, hd, rot, cd
  sfac = 1.0
  psize = abs(cd[1])
  nx = ceil((l1-l0)/psize/sfac)
  ny = ceil((b1-b0)/psize/sfac)

  array = fltarr(nx, ny)
  sxaddpar, hd, 'NAXIS1', nx
  sxaddpar, hd, 'NAXIS2', ny
  
  sxaddpar, hd, 'CRPIX1', double(nx)/2
  sxaddpar, hd, 'CRPIX2', double(ny)/2
  sxaddpar, hd, 'CTYPE1', 'GLON-SFL'
  sxaddpar, hd, 'CTYPE2', 'GLAT-SFL'
  sxaddpar, hd, 'LONPOLE', 180.0
  sxaddpar, hd, 'LATPOLE', 90.0
  sxaddpar, hd, 'CRVAL1', mean([l1, l0])
  sxaddpar, hd, 'CRVAL2', mean([b1, b0])
  sxaddpar, hd, 'CDELT1', cd[0]*sfac
  sxaddpar, hd, 'CDELT2', cd[1]*sfac
  sxaddpar, hd, 'CD1_1', cd[0]*sfac
  sxaddpar, hd, 'CD2_2', cd[1]*sfac
  extast, hd, astrom
  sz = size(array)
  xarr = findgen(sz[1])#replicate(1, sz[2])
  yarr = replicate(1, sz[1])#findgen(sz[2])
  xy2ad, xarr, yarr, astrom, l, b
  count = fltarr(nx, ny)
  for k = 0, n_elements(fl)-1 do begin
    stamp = readfits(fl[k], hd2)
    char = stregex(fl[k], '_map')
    weight = readfits(strmid(fl[k], 0, char+1)+'weight'+strmid(fl[k], char+1, 30), hd3)
    if n_elements(err) eq 1 then err = bolocam_emap(stamp)
    hd2 = degls(hd2)

    heuler, hd2, /gal
    sz2 = size(stamp)
    extast, hd2, astrom2

    ad2xy, l, b, astrom2, xland, yland
    
    ind = where(xland ge -1 and xland le sz2[1] and $
                yland ge -1 and yland le sz2[2], ct)
    if ct gt 0 then begin
      data = interpolate(stamp, xland[ind], yland[ind])*$
                                    interpolate(weight, xland[ind], yland[ind])
      wts = interpolate(weight, xland[ind], yland[ind])
      ind2 = where(data eq data and wts eq wts)

      array[xarr[ind[ind2]], yarr[ind[ind2]]] = $
         array[xarr[ind[ind2]], yarr[ind[ind2]]]+data[ind2]
      count[xarr[ind[ind2]], yarr[ind[ind2]]] = $
        count[xarr[ind[ind2]], yarr[ind[ind2]]]+wts[ind2]

    endif
  endfor
  array = array/count
  writefits, 'mosaic.fits', array, hd
  mkhdr, exthdr, count, /image
  sxaddpar, exthdr, 'BUNIT', 'Jy/beam', ' map units'
  putast, exthdr, astrom
  writefits, 'error.fits', 1/sqrt(count), exthdr

  return
end
