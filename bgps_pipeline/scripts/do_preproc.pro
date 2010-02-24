@/home/milkyway/student/ginsbura/.idl_startup_publish
;process_file_list,'/scratch/sliced_polychrome/l017/l017_rawlist.txt',downsample_factor=5
;$ls /scratch/sliced_polychrome/l017/*_raw.nc > /scratch/sliced_polychrome/l017/l017_rawlist.txt 
;$cat /scratch/sliced_polychrome/l017/l017_rawlist.txt  | sed 's/_raw.nc/_raw_ds5.nc/' > /scratch/sliced_polychrome/l017/l017_infile.txt 
;
;process_file_list,'/scratch/sliced/l004/l004_rawlist.txt',downsample_factor=5
;$ls /scratch/sliced/l004/*_raw.nc > /scratch/sliced/l004/l004_rawlist.txt 
;$cat /scratch/sliced/l004/l004_rawlist.txt  | sed 's/_raw.nc/_raw_ds5.nc/' > /scratch/sliced/l004/l004_infile.txt 

process_file_list,'/scratch/sliced/l031/l031_rawlist.txt',downsample_factor=5
$ls /scratch/sliced/l031/*_raw.nc > /scratch/sliced/l031/l031_rawlist.txt 
$cat /scratch/sliced/l031/l031_rawlist.txt  | sed 's/_raw.nc/_raw_ds5.nc/' > /scratch/sliced/l031/l031_infile.txt 


process_file_list,'/scratch/sliced/l000/l000_rawlist.txt',downsample_factor=5
