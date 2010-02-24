@~/.idl_startup_bgps.pro
.com calc_beam_locations.pro
.com op_cbl.pro

infiles = ['/scratch/distortion/centroid/uranus/060905_ob6.ctr']
infiles=['/scratch/distortion/centroid/uranus/060919_ob9.ctr']
infiles= ['/scratch/distortion/centroid/uranus/060905_ob6.ctr',$
          '/scratch/distortion/centroid/uranus/060906_o12.ctr',$
          '/scratch/distortion/centroid/uranus/060908_o13.ctr',$
          '/scratch/distortion/centroid/uranus/060909_o12.ctr',$
          '/scratch/distortion/centroid/uranus/060910_o12.ctr',$
          '/scratch/distortion/centroid/uranus/060914_o10.ctr',$
          '/scratch/distortion/centroid/uranus/060914_o11.ctr',$
          '/scratch/distortion/centroid/uranus/060919_ob9.ctr']

tol = 2.5
input_folder_root='/scratch/distortion/centroid'
params_folder_root='/scratch/distortion/centroid'
input_file_root='yymmdd_ooo'
params_file_root='array_params_yymmdd_ooo'
params_file_extension='txt'
out_file =  '/scratch/adam_work/distmaps/beam_locations_sep06_OP.txt'
bolo_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/bolo_params_jun06.txt'
global_array_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/array_params_jun06_rotating.txt'
ncfile='/scratch/sliced/uranus/060905_ob6_raw_ds5.nc'
ncfile=['/scratch/sliced/uranus/060919_ob9_raw_ds5.nc']
ncfile=['/scratch/sliced/uranus/060905_ob6_raw_ds5.nc',$
        '/scratch/sliced/uranus/060906_o12_raw_ds5.nc',$
        '/scratch/sliced/uranus/060908_o13_raw_ds5.nc',$
        '/scratch/sliced/uranus/060909_o12_raw_ds5.nc',$
        '/scratch/sliced/uranus/060910_o12_raw_ds5.nc',$
        '/scratch/sliced/uranus/060914_o10_raw_ds5.nc',$
        '/scratch/sliced/uranus/060914_o11_raw_ds5.nc',$
        '/scratch/sliced/uranus/060919_ob9_raw_ds5.nc']

;calc_beam_locations, $
;      infiles, tol = tol, bad_bolos = bad_bolos, $
;      out_file = out_file, /diag
  
op_cbl, $
    infiles, $
    input_folder_root = input_folder_root, $
    params_folder_root = params_folder_root, $
    params_file_root = params_file_root, $
    params_file_extension = params_file_extension, $
    bolo_params_file = bolo_params_file, $
    out_file = out_file, $
    /diagnostic_flag , $
    tolerance = tolerance, $
    global_array_params_file = global_array_params_file, $
    ncfile=ncfile

;    cleaned_folder_root = cleaned_folder_root, $
;    cleaned_file_root = cleaned_file_root, $
;    cleaned_file_extension = cleaned_file_extension


out_file =  '/scratch/adam_work/distmaps/beam_locations_jun06_OP.txt'
bolo_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/bolo_params_jun06.txt'
global_array_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/array_params_jun06_rotating.txt'

infiles = ['/scratch/distortion/centroid/neptune/060602_o30.ctr',$
           '/scratch/distortion/centroid/neptune/060602_o31.ctr',$
           '/scratch/distortion/centroid/uranus/060621_o29.ctr',$
           '/scratch/distortion/centroid/uranus/060621_o30.ctr',$
           '/scratch/distortion/centroid/uranus/060625_o46.ctr']


ncfiles=['/scratch/sliced/neptune/060602_o30_raw_ds5.nc',$
         '/scratch/sliced/neptune/060602_o31_raw_ds5.nc',$
         '/scratch/sliced/uranus/060621_o29_raw_ds5.nc',$
         '/scratch/sliced/uranus/060621_o30_raw_ds5.nc',$
         '/scratch/sliced/uranus/060625_o46_raw_ds5.nc']
  
op_cbl, $
    infiles, $
    input_folder_root = input_folder_root, $
    params_folder_root = params_folder_root, $
    params_file_root = params_file_root, $
    params_file_extension = params_file_extension, $
    bolo_params_file = bolo_params_file, $
    out_file = out_file, $
    /diagnostic_flag , $
    tolerance = tolerance, $
    global_array_params_file = global_array_params_file, $
    ncfile=ncfile

out_file =  '/scratch/adam_work/distmaps/beam_locations_jul07_OP.txt'
bolo_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/bolo_params_jun07.txt'
global_array_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/array_params_jun07.txt'

infiles = ['/scratch/distortion/centroid/uranus/070702_o42.ctr',$
           '/scratch/distortion/centroid/uranus/070702_o41.ctr']
;           '/scratch/distortion/centroid/uranus/070701_o38.ctr',$

ncfiles=['/scratch/sliced_polychrome/uranus/070702_o42_raw_ds1.nc',$
         '/scratch/sliced_polychrome/uranus/070702_o41_raw_ds1.nc']
;         '/scratch/sliced_polychrome/uranus/070701_o38_raw_ds1.nc',$
 
op_cbl, $
    infiles, $
    input_folder_root = input_folder_root, $
    params_folder_root = params_folder_root, $
    params_file_root = params_file_root, $
    params_file_extension = params_file_extension, $
    bolo_params_file = bolo_params_file, $
    out_file = out_file, $
    /diagnostic_flag , $
    tolerance = tolerance, $
    global_array_params_file = global_array_params_file, $
    ncfile=ncfile

out_file =  '/scratch/adam_work/distmaps/beam_locations_jun05_OP.txt'
bolo_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/bolo_params_jun05.txt'
global_array_params_file='/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/array_params_jun05.txt'

ncfiles=['/scratch/sliced_polychrome/uranus/050619_o23_raw_ds5.nc',$
         '/scratch/sliced_polychrome/uranus/050619_o24_raw_ds5.nc',$
         '/scratch/sliced_polychrome/neptune/050626_o19_raw_ds5.nc',$
         '/scratch/sliced_polychrome/neptune/050626_o20_raw_ds5.nc',$
         '/scratch/sliced_polychrome/mars/050627_o31_raw_ds1.nc',$
         '/scratch/sliced_polychrome/mars/050627_o32_raw_ds1.nc',$
         '/scratch/sliced_polychrome/uranus/050628_o33_raw_ds5.nc',$
         '/scratch/sliced_polychrome/uranus/050628_o34_raw_ds5.nc']

infiles=['/scratch/distortion/centroid/uranus/050619_o23.ctr',$
         '/scratch/distortion/centroid/uranus/050619_o24.ctr',$
         '/scratch/distortion/centroid/neptune/050626_o19.ctr',$
         '/scratch/distortion/centroid/neptune/050626_o20.ctr',$
         '/scratch/distortion/centroid/mars/050627_o31.ctr',$
         '/scratch/distortion/centroid/mars/050627_o32.ctr',$
         '/scratch/distortion/centroid/uranus/050628_o33.ctr',$
         '/scratch/distortion/centroid/uranus/050628_o34.ctr']


op_cbl, $
    infiles, $
    input_folder_root = input_folder_root, $
    params_folder_root = params_folder_root, $
    params_file_root = params_file_root, $
    params_file_extension = params_file_extension, $
    bolo_params_file = bolo_params_file, $
    out_file = out_file, $
    /diagnostic_flag , $
    tolerance = tolerance, $
    global_array_params_file = global_array_params_file, $
    ncfile=ncfile



