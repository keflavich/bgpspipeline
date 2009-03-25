function grs_namelookup, l

  lout = strcompress(string(round(l/2)*2), /rem)

  filename = 'GRS_'+lout+'_C.fits'

  return, filename
end
