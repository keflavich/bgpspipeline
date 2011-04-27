setenv,'SLICED=/arlstorage/data/student/meekja/BGPS/sliced'
setenv,'WORKINGDIR2=/arlstorage/home/student/ginsbura/v1pipetest'
breakpoint,'/arlstorage/home/student/meekja/Work/v1.0_bgps_pipeline/mapping/prepare_map.pro',103,/set
coalign_field, 'perseus', '030128_o03', premap=0,deconvolve=1,version='1.0_distcor',scratchdir=getenv('WORKINGDIR2'),niter=replicate(13,21),dosave=2,infile="perseus_infile_ds5.txt",refim=getenv('REFDIR')+'/perseus_rosolowsky.fits',mvperjy=[-46.1937,27.1943,-1.63024],fits_out=[0,1,2,3,4,5,10,20], beam_loc_file=getenv('PIPELINE_ROOT')+'/bgps_params/beam_locations_jan03.txt',pointing_model=0,coalign=1,/checkpointing,/check_shift,/check_pointing


; eta test:
;
coalign_field,'perseus_v1test','030128_o03',premap=0,deconvolve=1,version='1.0_distcor',scratchdir=getenv('WORKINGDIR2'),niter=replicate(13,21),dosave=2,infile="perseus_infile.txt",refim=getenv('REFDIR')+'/perseus_rosolowsky.fits',mvperjy=[-46.1937,27.1943,-1.63024],fits_out=[0,1,2,3,4,5,10,20,30,40,50],beam_loc_file=getenv('PIPELINE_ROOT')+'/bgps_params/beam_locations_jan03.txt', pointing_model=0,coalign=1,/checkpointing,/check_shift,/check_pointing