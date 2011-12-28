pro bgps2ds9, bgps

  fn = bgps.filename
  fn = fn[uniq(fn, sort(fn))]


  spawn, 'mkdir ds9reg'
  spawn, 'rm ds9reg/*', /sh
  for j = 0, n_elements(fn)-1 do begin 
    
    hits = where(fn[j] eq bgps.filename, ct)
    if ct eq 0 then continue
    startpos = strpos(fn[j], 'v1.0.2_')
    root = strmid(fn[j], startpos+7, 50)
    endpos = strpos(root, '_')
    root = strmid(root, 0, endpos)
    openw, lun, './ds9reg/'+root+'.reg', /get_lun    
    printf, lun, '# Region file format: DS9 version 3.0'
    printf, lun, 'GALACTIC'
    for i = 0, ct-1 do begin
      b = bgps[hits[i]]
      printf, lun, 'ellipse '+string(b.glon)+' '+string(b.glat)+' '+decimals(1.91*b.mommaj_as/3600, 5)+' '+decimals(1.91*b.mommin_as/3600., 5)+' '+decimals(b.posang*180/!pi, 0)+' # text={'+decimals(b.cloudnum,0)+'}'
      printf, lun, 'cross point '+string(b.glon_max)+' '+string(b.glat_max)
;      printf, lun, 'text '+string(b.glon_max)+' '+$
;              string(b.glat_max)+' {'+decimals(b.cloudnum,0)+'}'
    endfor
    
    close, lun
    free_lun, lun

endfor

  return
end
