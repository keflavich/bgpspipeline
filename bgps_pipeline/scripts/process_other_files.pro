retall
@/home/milkyway/student/ginsbura/.idl_startup_publish
array_params   = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jun05.txt'
bolo_params    = '/home/milkyway/student/ginsbura/array_params/bolo_params_jun05.txt'
beam_locations_jul05 = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/beam_locations_jul05.txt'
beam_locations_default = '/scratch/adam_work/beam_locations_default.txt'

array_params_jun05     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jun05.txt'
array_params_jul05     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jul05.txt'
array_params_nov06     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_nov06.txt'
array_params_jun06     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jun06_rotating.txt'
array_params_jan07     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jan07_60as.txt'
array_params_jan07     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jan07.txt'
array_params_feb07     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_feb07_60as.txt'
array_params_feb07     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_feb07.txt'
array_params_jun07     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jun07.txt'
array_params_sep07     = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_sep07_no_rot.txt'
array_params_sep07_rot = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_sep07.txt'

bolo_params_feb05      = '/home/milkyway/student/ginsbura/array_params/bolo_params_feb05.txt'
bolo_params_jun05      = '/home/milkyway/student/ginsbura/array_params/bolo_params_jun05.txt'
bolo_params_sep05      = '/home/milkyway/student/ginsbura/array_params/bolo_params_sep05.txt'
bolo_params_jun06      = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/bolo_params_jun06.txt'
bolo_params_nov06      = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/bolo_params_nov06.txt'
bolo_params_jan07      = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/bolo_params_jan07.txt'
bolo_params_jun07      = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/bolo_params_jun07_mmd.txt'
bolo_params_jun07      = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/bolo_params_jun07.txt'
bolo_params_sep07      = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/bolo_params_sep07.txt'

.run process_file_list
@load_process_vars
;process_file_list,'/scratch/adam_work/texts/0709_raw_pointing.txt',array_params=array_params_sep07,bolo_params=bolo_params_sep07,$
;    beam_locations=beam_locations_default,downsample_factor=1
;process_file_list,'/scratch/sliced/l047/l047_rawlist_0707.txt',array_params=array_params_sep07,bolo_params=bolo_params_sep07,$
;    beam_locations=beam_locations_default,downsample_factor=5
;process_file_list,'/scratch/sliced/l047/l047_rawlist_0606.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,$
;    beam_locations=beam_locations_default,downsample_factor=5
;process_file_list,'/scratch/sliced/l047/l047_rawlist_0609.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,$
;    beam_locations=beam_locations_default,downsample_factor=5
process_file_list,'/scratch/sliced/l052/l052_rawlist.txt',array_params=array_params_jul07,bolo_params=bolo_params_jul07,$
    beam_locations=beam_locations_default,downsample_factor=5

