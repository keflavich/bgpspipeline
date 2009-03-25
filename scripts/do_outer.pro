

individual_obs,'/scratch/adam_work/texts/w5_allnc.txt','/scratch/adam_work/w5/',/fits_smooth,npca=[13,13],/pointing_model,/no_offsets
spawn,'ls /scratch/adam_work/w5/0*_map01.fits > /scratch/adam_work/w5/w5_fitslist.txt'
image_shifts,'/scratch/adam_work/w5/070911_o25_raw_ds5.nc_indiv13pca_map01.fits','/scratch/adam_work/w5/w5_fitslist.txt',$
    '/scratch/adam_work/w5/w5_align_to_070911_o25.txt'
write_imshifts,'/scratch/adam_work/w5/w5_align_to_070911_o25.txt'
ncdf_varput_scale,'/scratch/sliced/l133/070911_o25_raw_ds5.nc','radec_offsets',[0,0] 
individual_obs,'/scratch/adam_work/texts/w5_allnc.txt','/scratch/adam_work/w5/lbcorrected',/fits_smooth,npca=[13,13],/pointing_model,/no_offsets
mem_iter_pc,'/scratch/adam_work/texts/w5_allnc.txt','/scratch/adam_work/w5/w5_13pca',/deconvolve,niter=intarr(10)+13,/deconvolve,/fits_smooth,/pointing_model,workingdir='/scratch/adam_work'

