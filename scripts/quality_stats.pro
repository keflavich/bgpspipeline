readcol,'/scratch/sliced/INFILES/INFILE_LIST.txt',infiles,format='A80',comment='#'

outf = '/usb/scratch1/texts/quality_stats.txt' 
openw,outfile,outf,/get_lun
printf,outfile,"file","meandc","middc","moddc","meanac","midac","modac",format='(A80,A20,A20,A20,A20,A20,A20)'

for i=0,n_e(infiles)-1 do begin
    readcol,infiles[i],files,format='A80',comment='#'
    for j=0,n_e(files)-1 do begin
        ncdf_varget_scale,files[j],'dc_bolos',dc_bolos
        ncdf_varget_scale,files[j],'ac_bolos',ac_bolos
        print,files[j],mean(dc_bolos),median(dc_bolos),mode(dc_bolos),mean(ac_bolos),median(ac_bolos),mode(ac_bolos),format='(A80,F20,F20,F20,F20,F20,F20)'
        printf,outfile,files[j],mean(dc_bolos),median(dc_bolos),mode(dc_bolos),mean(ac_bolos),median(ac_bolos),mode(ac_bolos),format='(A80,F20,F20,F20,F20,F20,F20)'
    endfor
endfor

close,outfile
free_lun,outfile

end
