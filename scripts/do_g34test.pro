@/home/milkyway/student/ginsbura/.idl_startup_publish
time_s,"START ALL DO_MEM_ITER",time_dmi
!EXCEPT=0
workingdir = '/scratch/adam_work/'
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.in','g34.3/g34.3_median',workingdir=workingdir,niter=intarr(20),/deconvolve,/pointing_model,/fits_nopca,iter0savename='g34.3/g34.3.sav',/dosave,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_baseline12',workingdir=workingdir,niter=intarr(20),/deconvolve,/pointing_model,/fromsave,/fits_nopca,minb=12
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_baseline10',workingdir=workingdir,niter=intarr(20),/deconvolve,/pointing_model,/fromsave,/fits_nopca,minb=10
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_baseline8',workingdir=workingdir,niter=intarr(20),/deconvolve,/pointing_model,/fromsave,/fits_nopca,minb=8
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_ascending',workingdir=workingdir,niter=indgen(50),/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_01pca',workingdir=workingdir,niter=intarr(20)+01,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_02pca',workingdir=workingdir,niter=intarr(20)+02,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_03pca',workingdir=workingdir,niter=intarr(20)+03,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_04pca',workingdir=workingdir,niter=intarr(20)+04,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_05pca',workingdir=workingdir,niter=intarr(20)+05,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_06pca',workingdir=workingdir,niter=intarr(20)+06,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_07pca',workingdir=workingdir,niter=intarr(20)+07,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_08pca',workingdir=workingdir,niter=intarr(20)+08,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_09pca',workingdir=workingdir,niter=intarr(20)+09,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_10pca',workingdir=workingdir,niter=intarr(20)+10,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_11pca',workingdir=workingdir,niter=intarr(20)+11,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_12pca',workingdir=workingdir,niter=intarr(20)+12,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_13pca',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_14pca',workingdir=workingdir,niter=intarr(20)+14,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_15pca',workingdir=workingdir,niter=intarr(20)+15,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_16pca',workingdir=workingdir,niter=intarr(20)+16,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_17pca',workingdir=workingdir,niter=intarr(20)+17,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_18pca',workingdir=workingdir,niter=intarr(20)+18,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_19pca',workingdir=workingdir,niter=intarr(20)+19,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_20pca',workingdir=workingdir,niter=intarr(20)+20,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
time_e,time_dmi,prtmsg="END DO_MEM_ITER "
