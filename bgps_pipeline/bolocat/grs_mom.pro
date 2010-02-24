pro grs_mom

  nums = indgen(20)*2+18
  fname = '~/cso/GRS_'+strcompress(string(nums), /rem)+'_C.fits'
  outname = '~/cso/GRS_'+strcompress(string(nums), /rem)

  for k = 0, 19 do make_maps, fname[k], name = outname[k]

  return
end
