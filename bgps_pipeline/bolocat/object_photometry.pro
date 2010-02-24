function object_photometry, data, hd, error, props, diam_as, fluxerr = innerflux_err

; Reduced for increased speed!
  bootiter = 100

  if n_elements(diam_as) eq 0 then diam_as = 40.0
  
  getrot, hd, rot, cd
  rdhd, hd, s = h
  if h.ppbeam eq 0 then ppbeam = 1.0 else ppbeam = h.ppbeam
  if string(sxpar(hd, 'BUNIT')) eq 'JY/PIX' then ppbeam = 1.0
  if sxpar(hd, 'PPBEAM') gt 0 then ppbeam = sxpar(hd, 'PPBEAM')
  rad_pix = diam_as/abs(cd[1]*3.6d3)/2.0 ; Convert from diam -> radius
  if n_elements(rad_pix) eq 1 then rad_pix = rebin([rad_pix], n_elements(props))
  sz = size(data)
  x = findgen(sz[1])#replicatE(1, sz[2])
  y = replicate(1, sz[1])#findgen(sz[2])
  innerflux = fltarr(n_elements(props))+!values.f_nan
  innerflux_err = fltarr(n_elements(props))+!values.f_nan

  for k = 0, n_elements(props)-1 do begin
; Do gcirc distance here?   
    dist = sqrt((x-props[k].xdata)^2+(y-props[k].ydata)^2)

    bgind = where(dist ge rad_pix[k]*2 and dist le rad_pix[k]*4 and data eq data, ct)
    if ct lt 25 then continue
    mmm, data[bgind], background
    wtmask = dist le (rad_pix[k]-1)
    border = (dist le (rad_pix[k]+1))-wtmask
    ind = where(border)
    xborder = ind mod sz[1]
    yborder = ind / sz[1]
    border_wt = pixwt(props[k].xdata, props[k].ydata, $
                      rad_pix[k], xborder, yborder)
    wtmask = float(wtmask)
    wtmask[ind] = border_wt
    ind = where(wtmask gt 0, inner_ct)

    innerflux[k] = total(wtmask[ind]*data[ind], /nan)-$
                   background*total(wtmask[ind])

    if ct lt 50 then continue


    bgrun = fltarr(bootiter)
    for i = 0, bootiter-1 do begin
      subsample = floor(randomu(seed, ct)*ct)
      mmm, data[bgind[subsample]], bg
      bgrun[i] = bg
    endfor
    bgerr = mad(bgrun)


; Calculate the error as the weighted error over the object * sqrt(nbeams)    
    innerflux_err[k] =  sqrt((((total(wtmask[ind]*error[ind])/$
                                total(wtmask[ind])))^2+bgerr^2)*$
                             (total(wtmask[ind])/ppbeam))
  endfor 
  innerflux = innerflux/ppbeam


  return, innerflux
end
