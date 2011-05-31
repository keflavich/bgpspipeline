
function prep_gaussfitstxt,outdir
    outfile = outdir+"gaussfits.txt"
    openw,outf,outfile,/get_lun
    printf,outf,string("file1","file2","apsum1","noiseap1","apstd1","noisestdap1","background1","amp1","xcen1","ycen1","xwidth1","ywidth1","PA1","apsum2","noiseap2","apstd2","noisestdap2","background2","amp2","xcen2","ycen2","xwidth2","ywidth2","PA2",format="(2A80,22A15)",/print)
    close,outf
    free_lun,outf
    return,outfile
end
