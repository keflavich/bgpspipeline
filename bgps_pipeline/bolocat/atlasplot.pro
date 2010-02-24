pro atlasplot, props_in

  ps, /ps, /def, /jour, file = 'bgps.atlas.ps', $
      xsize = 10.5, ysize = 7.5, xoff = 11.0, yoff = 0.5, $
      /color, /landscape
  loadct, 3
  reversect
  setcolors, /sys, /curr
  !p.color = !black
  
  fn = props_in.filename
  fn = fn[uniq(fn, sort(fn))]
  
  for i = 0, n_elements(fn)-1 do begin


    data = mrdfits(fn[i], 0, hd)
    rdhd, hd, s = h
    
    ind = where(props_in.filename eq fn[i], ct)
    if ct eq 0 then return
    props = props_in[ind]
    tn = replicatE(' ', 20)
    titlestr = strmid(fn[i], strpos(fn[i], '/')+1, 50)
    disp, sqrt(data), min = 0, max = 1, /sq, $
          title = titlestr, h.ra, h.dec, xtitle = '!6l (degrees)', $
        ytitle = '6b (degrees)'
    
    rms2rad = 2.354
; oplot, props.xdata, props.ydata, ps = 1
    p = props
    ct = n_elements(p) 
    phi = findgen(61)/60*2*!pi
    x = cos(phi)
    y = sin(phi)
 dx = abs(h.cdelt[1])
 for k = 0, ct-1 do begin
   posang = p[[k]].posang
   xrot = dx*rms2rad*(p[[k]].mommajpix*x*cos(posang)+p[[k]].momminpix*y*sin(posang))
   yrot = dx*rms2rad*(-p[[k]].mommajpix*x*sin(posang)+p[[k]].momminpix*y*cos(posang))
   oplot, xrot+p[k].glon, yrot+p[k].glat, color = !blue
 endfor
 
  shade_hist, props.flux_40, min = 0, max = 10, binsize = 0.5, position = [0.1, 0.65, 0.35, 0.95], color = !blue, /noerase, xtitle = 'Flux (40", Jy)'
  xyouts, 0.34,0.9, align = 1, 'N='+decimals(n_elements(p), 0), /normal


endfor
 
    ps, /x



  return
end
