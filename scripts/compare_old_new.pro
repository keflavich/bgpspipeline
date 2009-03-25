
filename = '/scratch/sliced_polychrome/pcal21/070719_o30_raw_ds1.nc'
thefiles = [filename]

OPENW, logfile, '/dev/tty', /GET_LUN, /MORE  
pointing_wrapper_wrapper,filename,beam_loc_file=beam_loc_file,ra=ra,dec=dec,$
    /nobeamloc,       $
    logfile=logfile,_extra=_extra
close,logfile
free_lun,logfile

mapstruct = map_ncdf_reading(filename,fazo=fazo,fzao=fzao,/nopixoff)
mapstruct_distort = map_ncdf_reading(filename,fazo=fazo,fzao=fzao,beam_loc='/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/beam_locations_jul05.txt')
ncdf_varget_scale,filename,'scans_info',orig_scans_info
ncdf_varget_scale,filename,'ra',orig_ra

lb = orig_scans_info[0]
ub = orig_scans_info[n_e(orig_scans_info)-1]

ra_vect_old = mapstruct.ra_all[0,*]*15
dec_vect_old = mapstruct.dec_all[0,*]
ra_vect_new = reform(ra[lb:ub])
dec_vect_new = reform(dec[lb:ub])

loadct,39
window,0
!P.MULTI = [0,1,2]
plot,(ra_vect_old-ra_vect_new)*3600.,/ys
plot,(dec_vect_old-dec_vect_new)*3600.,/ys


readall_pc,[filename],ac_bolos=ac_bolos,dc_bolos=dc_bolos,flags=flags,bolo_params=bolo_params, $
    ra_map=ra_map,dec_map=dec_map,wh_scan=wh_scan,blank_map=blank_map,goodbolos=goodbolos, $
    beam_loc='/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/beam_locations_jul05.txt',$
    jd=jd,_extra=_extra

set_plot,'ps'
device,filename='/scratch/adam_work/plots/compare_old_new.ps',/color
!P.MULTI=[0,2,4]
for i=0,n_e(ra_map[*,0])-1 do begin $ 
    & plot,(mapstruct_distort.ra_all[i,wh_scan-lb]*15 - ra_map[i,*])*3600,/ys $
    & plot,(mapstruct_distort.dec_all[i,wh_scan-lb] - dec_map[i,*])*3600,/ys $
& endfor
device,/close_file
set_plot,'x'


;ncdf_varget_scale,filename,'bolo_params',bolo_params
;goodbolos = where(bolo_params[0,*])
;ncdf_varget_scale,filename,'pa',pa
;ncdf_varget_scale,filename,'rotangle',rotangle
;pixoff=get_pixel_offsets(goodbolos,pa,rotangle,infile=filename,beam_locations='/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/beam_locations_jul05.txt')


