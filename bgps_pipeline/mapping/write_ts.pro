; small wrapper to write out the timestream-to-map mapping with
; the header parameters required to reshape it properly
pro write_ts,ts,hdr,outmap,scans_info,nbolos=nbolos,ntime=ntime
    hdrcopy = hdr
    nscans = n_e(scans_info[0,*])
    scanlen = scans_info[1,0]-scans_info[0,0]
    fxaddpar,hdrcopy,"nscans",nscans,"number of scans"
    fxaddpar,hdrcopy,"scanlen",scanlen,"lenth of scans"
    sxdelpar,hdrcopy,['LONPOLE2','LATPOLE2','CTYPE1','CTYPE2','CD1_1','CD1_2','CD2_1','CD2_2','CRPIX1','CRPIX2','CRVAL1','CRVAL2']
    rsts = reshape_timestream(ts,scans_info,nbolos=nbolos,ntime=ntime)
    writefits,outmap+'_tstomap.fits',rsts,hdrcopy
end
