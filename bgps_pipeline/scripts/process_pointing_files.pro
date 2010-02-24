retall
@/home/milkyway/student/ginsbura/.idl_startup_publish
array_params   = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/array_params_jun05.txt'
bolo_params    = '/home/milkyway/student/ginsbura/array_params/bolo_params_jun05.txt'
beam_locations_jul05 = '/home/milkyway/student/ginsbura/bolocam_cvs/pipeline/cleaning/parameters/beam_locations_jul05.txt'
beam_locations_default = '/scratch/adam_work/beam_locations_default.txt'
filelist       = '/scratch/sliced_polychrome/3c273/3c273_0506_list.txt'


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
;08/04/08:
;process_file_list,'/scratch/adam_work/texts/0506_raw_pointing.txt',array_params=array_params_jun05,bolo_params=bolo_params_jun05,beam_locations=beam_locations_default,downsample_factor=1
;@load_process_vars
;process_file_list,'/scratch/adam_work/texts/0507_raw_pointing.txt',array_params=array_params_jul05,bolo_params=bolo_params_jun05,beam_locations=beam_locations_default,downsample_factor=1
;@load_process_vars
;process_file_list,'/scratch/adam_work/texts/0509_raw_pointing.txt',array_params=array_params_jul05,bolo_params=bolo_params_sep05,beam_locations=beam_locations_default,downsample_factor=1
;@load_process_vars
;process_file_list,'/scratch/adam_work/texts/0606_raw_pointing.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations_default,downsample_factor=1
;@load_process_vars
;process_file_list,'/scratch/adam_work/texts/0609_raw_pointing.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations_default,downsample_factor=1
;@load_process_vars
;;process_file_list,'/scratch/adam_work/texts/0705_raw_pointing.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_default,downsample_factor=1
;process_file_list,'/scratch/adam_work/texts/0706_raw_pointing.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_default,downsample_factor=1
;@load_process_vars
;process_file_list,'/scratch/adam_work/texts/0707_raw_pointing.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_default,downsample_factor=1
@load_process_vars
process_file_list,'/scratch/adam_work/texts/0709_raw_pointing.txt',array_params=array_params_sep07,bolo_params=bolo_params_sep07,beam_locations=beam_locations_default,downsample_factor=1
@load_process_vars
process_file_list,'/scratch/adam_work/texts/process_list_0609_Aug62008.txt',array_params=array_params_sep07,bolo_params=bolo_params_sep07,beam_locations=beam_locations_default,downsample_factor=1
@load_process_vars
process_file_list,'/scratch/adam_work/texts/process_list_0706_Aug62008.txt',array_params=array_params_sep07,bolo_params=bolo_params_sep07,beam_locations=beam_locations_default,downsample_factor=1


;process_file_list,'/scratch/sliced_polychrome/3c273/3c273_0506_ds5list.txt',array_params=array_params_jun05,bolo_params=bolo_params_jun05,beam_locations=beam_locations_default
;process_file_list,'/scratch/sliced_polychrome/3c273/3c273_0606_rawlist.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations_default,downsample_factor=1
;process_file_list,'/scratch/sliced_polychrome/1749p096/1749p096_0506_rawlist.txt',array_params=array_params_jun05,bolo_params=bolo_params_jun05,beam_locations=beam_locations
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_05_rawlist.txt',array_params=array_params_jun05,bolo_params=bolo_params_jun05,beam_locations=beam_locations

;process_file_list,'/scratch/sliced_polychrome/1749p096/1749p096_0707_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_0606_rawlist.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations
;
;process_file_list,'/scratch/sliced_polychrome/3c273/3c273_0606_rawlist.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations
;process_file_list,'/scratch/sliced_polychrome/3c273/3c273_0707_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations,downsample=1

;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_05_rawlist.txt',array_params=array_params_jun05,bolo_params=bolo_params_jun05,beam_locations=beam_locations_default
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_0606_rawlist.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations_jul05
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_0706_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_jul05
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_0707_afterJul6_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_jul05
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_0707_afterJul6_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_jul05
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_0707_beforeJul6_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_jul05
;process_file_list,'/scratch/sliced_polychrome/3c279/3c279_0707_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_jul05


; 7/17/08:
;process_file_list,'/scratch/adam_work/all_0506_raw_pointing.txt',array_params=array_params_jun05,bolo_params=bolo_params_jun05,beam_locations=beam_locations_default,downsample_factor=1

; 7/18/08: testing processign of a map
;process_file_list,'/scratch/adam_work/SINGLE_FILE_TEST.txt',array_params=array_params_jul05,bolo_params=bolo_params_jun05,beam_locations=beam_locations_default,downsample_factor=1

; 7/22/08: process 1749+096
;process_file_list,'/scratch/sliced_polychrome/1749p096/1749p096_0506_rawlist.txt',array_params=array_params_jun05,bolo_params=bolo_params_jun05,beam_locations=beam_locations_default,downsample_factor=1
;process_file_list,'/scratch/sliced_polychrome/1749p096/1749p096_0707_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_default,downsample_factor=1

; find /scratch/sliced_polychrome/ -name "0606*_raw.nc" | grep -v "bad\|lissa\|old\|polar" > /scratch/adam_work/texts/all_0606_raw_pointing.txt
;process_file_list,'/scratch/adam_work/texts/all_0606_raw_pointing.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations_default,downsample_factor=1
;process_file_list,'/scratch/adam_work/texts/leftovers_0606.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations_default,downsample_factor=1

; 7/23/08
;process_file_list,'/scratch/sliced_polychrome/mars/mars_0707_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_default,downsample_factor=1
;process_file_list,'/scratch/sliced_polychrome/uranus/uranus_0707_rawlist.txt',array_params=array_params_jun07,bolo_params=bolo_params_jun07,beam_locations=beam_locations_default,downsample_factor=1

; 7/25/08:
;process_file_list,'/scratch/adam_work/texts/leftovers_0606.txt',array_params=array_params_jun06,bolo_params=bolo_params_jun06,beam_locations=beam_locations_default,downsample_factor=1,/precise_scans_offset_file


;7/31/08:
;process_file_list,'/scratch/adam_work/texts/all_0509_raw_pointing.txt',array_params=array_params_jul05,bolo_params=bolo_params_sep05,beam_locations=beam_locations_default,downsample_factor=1
;process_file_list,'/scratch/adam_work/texts/leftovers_0509.txt',array_params=array_params_jul05,bolo_params=bolo_params_sep05,beam_locations=beam_locations_default,downsample_factor=1

