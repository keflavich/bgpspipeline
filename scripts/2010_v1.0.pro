mem_iter,[getenv('SLICED_POLY')+'/mars/050703_o32_raw_ds1.nc',getenv('SLICED_POLY')+'/mars/050703_o33_raw_ds1.nc'],getenv('WORKINGDIR')+'/pointmaps_v1.0/mars_050703_o32-3_v1.0_0pca',niter=replicate(0,11),/deconvolve,pointing_model=0,mvperjy=[1,0,0],/mars
mem_iter,[getenv('SLICED_POLY')+'/mars/050703_o32_raw_ds1.nc',getenv('SLICED_POLY')+'/mars/050703_o33_raw_ds1.nc'],getenv('WORKINGDIR')+'/pointmaps_v1.0/mars_050703_o32-3_v1.0_3pca',niter=replicate(3,11),/deconvolve,pointing_model=0,mvperjy=[1,0,0],/mars
mem_iter,[getenv('SLICED_POLY')+'/mars/050703_o32_raw_ds1.nc',getenv('SLICED_POLY')+'/mars/050703_o33_raw_ds1.nc'],getenv('WORKINGDIR')+'/pointmaps_v1.0/mars_050703_o32-3_v1.0_13pca',niter=replicate(13,11),/deconvolve,pointing_model=0,mvperjy=[1,0,0],/mars

end

mem_iter,[getenv('SLICED_POLY')+'/mars/050911_o22_raw_ds1.nc',getenv('SLICED_POLY')+'/mars/050911_o23_raw_ds1.nc'],getenv('WORKINGDIR')+'/pointmaps_v1.0/mars_050911_o22-3_v1.0_0pca',niter=replicate(0,11),/deconvolve,pointing_model=0,mvperjy=[1,0,0],/mars,/nomadflagger
mem_iter,[getenv('SLICED_POLY')+'/mars/050911_o22_raw_ds1.nc',getenv('SLICED_POLY')+'/mars/050911_o23_raw_ds1.nc'],getenv('WORKINGDIR')+'/pointmaps_v1.0/mars_050911_o22-3_v1.0_3pca',niter=replicate(3,11),/deconvolve,pointing_model=0,mvperjy=[1,0,0],/mars,/nomadflagger
mem_iter,[getenv('SLICED_POLY')+'/mars/050911_o22_raw_ds1.nc',getenv('SLICED_POLY')+'/mars/050911_o23_raw_ds1.nc'],getenv('WORKINGDIR')+'/pointmaps_v1.0/mars_050911_o22-3_v1.0_13pca',niter=replicate(13,11),/deconvolve,pointing_model=0,mvperjy=[1,0,0],/mars,/nomadflagger

end
