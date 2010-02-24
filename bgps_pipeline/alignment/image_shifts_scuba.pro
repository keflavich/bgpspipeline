; takes an image in RA/DEC coordinates, converts to
; l/b coordinates, then calculates offsets and prints
; to screen
pro image_shifts_scuba,scuba_file,bgps_file,outfile , check_shift = check_shift

    sc = readfits(scuba_file,schdr)
    heuler,schdr,/galactic
    writefits,outfile,sc,schdr

    shiftedfile = strsplit(outfile,'.fits',/extract,/regex)+'_test_aligned.fits'

    image_shifts,outfile,bgps_file,'/dev/tty' , check_shift = check_shift , shift_out = shiftedfile

end
