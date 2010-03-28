
coalign_field,'perseus','030128_o03',premap=1,deconvolve=1,version='1.0_distcor',scratchdir=getenv('WORKINGDIR2') ,niter=replicate(13,51),dosave=2,infile="perseus_infile.txt",refim=getenv('REFDIR')+'/perseus_menoch.fits',/scale_acb,mvperjy=[-46.1937,27.1943,-1.63024],fits_out=[0,1,2,3,4,5,10,20,30,40,50],beam_loc_file=getenv('PIPELINE_ROOT')+'/bgps_params/beam_locations_jan03.txt',pointing_model=0
coalign_field,'perseus','030128_o03',premap=0,deconvolve=1,version='1.0_distcor',scratchdir=getenv('WORKINGDIR2') ,niter=replicate(3,51),dosave=2,infile="perseus_infile.txt",refim=getenv('REFDIR')+'/perseus_menoch.fits',/scale_acb,mvperjy=[-46.1937,27.1943,-1.63024],fits_out=[0,1,2,3,4,5,10,20,30,40,50],beam_loc_file=getenv('PIPELINE_ROOT')+'/bgps_params/beam_locations_jan03.txt',pointing_model=0
coalign_field,'perseus','030128_o03',premap=0,deconvolve=1,version='1.0',scratchdir=getenv('WORKINGDIR2') ,niter=replicate(13,51),dosave=2,infile="perseus_infile.txt",refim=getenv('REFDIR')+'/perseus_menoch.fits',/scale_acb,mvperjy=[-46.1937,27.1943,-1.63024],fits_out=[0,1,2,3,4,5,10,20,30,40,50],pointing_model=0
coalign_field,'perseus','030128_o03',premap=0,deconvolve=1,version='1.0',scratchdir=getenv('WORKINGDIR2') ,niter=replicate(3,51),dosave=2,infile="perseus_infile.txt",refim=getenv('REFDIR')+'/perseus_menoch.fits',/scale_acb,mvperjy=[-46.1937,27.1943,-1.63024],fits_out=[0,1,2,3,4,5,10,20,30,40,50],pointing_model=0

end


