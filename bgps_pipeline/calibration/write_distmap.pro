
pro write_distmap,infile,beam_loc_file
    ncdf_varget_scale,infile,'beam_locations',bl
    readcol,beam_loc_file,bolonum,bolodist,boloang,err,comment="#;",format="(I, F, F, F)",/silent
    bl[0,*] = bolodist
    bl[1,*] = boloang
    bl[2,*] = err
    ncdf_varput_scale,infile,'beam_locations',bl
end
