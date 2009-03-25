@/home/milkyway/student/ginsbura/.idl_startup_publish
time_s,"START ALL DO_MEM_ITER",time_dmi
!EXCEPT=0
workingdir = '/scratch/adam_work/'
;mem_iter_pc,'/scratch/adam_work/texts/cygnus_for_pat_secondpart.in','cygnus/cygnus',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,iter0savename='cygnus/cygnus_pt1.sav',/fits_psd,/pointing_model,/fits_timestream,/dosave
;mem_iter_pc,'/scratch/adam_work/texts/cygnus_for_pat_secondpart.in','cygnus/cygnus_bigpix',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,iter0savename='cygnus/cygnus_bigpix.sav',pixsize=14.,/fits_psd,/pointing_model,/fits_timestream,/fits_model,/dosave
;mem_iter_pc,'/scratch/adam_work/cygnus/cygnus_bigpix.sav','cygnus/cygnus_bigpix_nodeconv',workingdir=workingdir,niter=intarr(20)+13,pixsize=14.,/fits_psd,/pointing_model,/fits_timestream,/fromsave
;mem_iter_pc,'/scratch/adam_work/l033/l33.in','l033/l033_13pca',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,iter0savename='l033/l033.sav',/fits_psd,/pointing_model,/dosave
;mem_iter_pc,'/scratch/adam_work/l033/l033.sav','l033/l033_20pca',workingdir=workingdir,niter=intarr(20)+20,/deconvolve,/fits_psd,/pointing_model,/fromsave
mem_iter_pc,'/scratch/adam_work/l111/l111.in','l111/l111_13pca',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,iter0savename='l111/l111.sav',/fits_psd,/dosave,/pointing_model
mem_iter_pc,'/scratch/sliced/l111/l111_infile_testmmdoffsets.txt','l111/l111_mmdoffsets',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
;mem_iter_pc,'/scratch/adam_work/l111/l111.sav','l111/l111_20pca',workingdir=workingdir,niter=intarr(20)+20,/deconvolve,/fits_psd,/fromsave
;mem_iter_pc,'/scratch/adam_work/l111/l111.in','l111/l111',workingdir=workingdir,niter=intarr(2)+13,/deconvolve,iter0savename='l111/l111.sav'
;mem_iter_pc,'/scratch/adam_work/l111/l111.in','l111/l111radec',workingdir=workingdir,niter=intarr(2)+13,/deconvolve,iter0savename='l111/l111radec.sav',projection='TAN',coordsys='radec'
;mem_iter_pc,'/scratch/adam_work/l111/l111.sav','l111/l111ascend',workingdir=workingdir,niter=indgen(40),/deconvolve,/fits_psd,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/gc/gc_05.in','gc/gc_05_13pca',workingdir=workingdir,niter=intarr(40)+13,/deconvolve,iter0savename="gc/gc_05.sav",/fits_psd,/fits_timestream,/pointing_model,/dosave
;mem_iter_pc,'/scratch/adam_work/gc/gc_05.sav','gc/gcdescend',workingdir=workingdir,niter=39-indgen(40),/deconvolve,/fits_psd,/fits_timestream,/pointing_model,/fromsave
;mem_iter_pc,'/scratch/adam_work/gc/gc_05.sav','gc/gc3pca',workingdir=workingdir,niter=intarr(20)+3,/deconvolve,/fits_psd,/fits_timestream,/pointing_model,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/gc/gc_05.sav','gc/gc13pca',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/fits_psd,/fits_timestream,/pointing_model,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/gc/gc_05.sav','gc/gc13pca_nodeconv',workingdir=workingdir,niter=intarr(20)+13,/fits_psd,/fits_timestream,/pointing_model,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/gc/gc_05.sav','gc/gc20pca',workingdir=workingdir,niter=intarr(20)+20,/deconvolve,/fits_psd,/fits_timestream,/pointing_model,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/gc/gc_05.sav','gc/gc30pca',workingdir=workingdir,niter=intarr(50)+30,/deconvolve,/fits_psd,/fits_timestream,/pointing_model,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/gc/gc_06.in','gc/gc_06_13pca',workingdir=workingdir,niter=intarr(40)+13,/deconvolve,iter0savename="gc/gc_06.sav",/fits_psd,/fits_timestream,/pointing_model,/dosave
mem_iter_pc,'/scratch/adam_work/gc/gc.in','gc/gc_13pca_flag',workingdir=workingdir,niter=intarr(40)+13,/deconvolve,iter0savename="gc/gc_flag.sav",/fits_psd,/fits_timestream,/pointing_model,/dosave,/psd_flag
mem_iter_pc,'/scratch/adam_work/gc/gc.in','gc/gc_13pca',workingdir=workingdir,niter=intarr(40)+13,/deconvolve,iter0savename="gc/gc.sav",/fits_psd,/fits_timestream,/pointing_model,/dosave
mem_iter_pc,'/scratch/adam_work/gc/gc.sav','gc/gc_7pca',workingdir=workingdir,niter=intarr(40)+7,/deconvolve,/fromsave,/fits_psd,/fits_timestream,/pointing_model
;mem_iter_pc,'/scratch/sliced/w5/w5_infile.txt','w5/w5',workingdir=workingdir,niter=intarr(20)+3,/deconvolve,iter0savename='w5/w5.sav',/pointing_model,/dosave
;mem_iter_pc,'/scratch/adam_work/w5/w5.sav','w5/w5_13pca',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model,/fromsave
;mem_iter_pc,'/scratch/adam_work/w5/w5.sav','w5/w5_20pca',workingdir=workingdir,niter=intarr(20)+20,/deconvolve,/pointing_model,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/w5/w5.sav','w5/w5_30pca',workingdir=workingdir,niter=intarr(30)+30,/deconvolve,/pointing_model,/fromsave,/fits_nopca
;mem_iter_pc,'/scratch/adam_work/w5/w5.sav','w5/w5_ascend',workingdir=workingdir,niter=indgen(40),/deconvolve,/pointing_model,/fromsave,/fits_nopca
mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.in','g34.3/g34.3_20pca',workingdir=workingdir,niter=20+intarr(20),/deconvolve,/pointing_model,/fits_nopca,iter0savename='g34.3/g34.3.sav',/dosave,/median_sky
mem_iter_pc,'/scratch/sliced/l006/l006_infile.txt','l006/l006',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l009/l009_infile.txt','l009/l009',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l012/l012_infile.txt','l012/l012',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l015/l015_infile.txt','l015/l015',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l018/l018_infile.txt','l018/l018',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l021/l021_infile.txt','l021/l021',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l024/l024_infile.txt','l024/l024',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l027/l027_infile.txt','l027/l027',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l030/l030_infile.txt','l030/l030',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
mem_iter_pc,'/scratch/sliced/l056/l056_infile.txt','l056/l056',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_baseline12',workingdir=workingdir,niter=intarr(20),/deconvolve,/pointing_model,/fromsave,/fits_nopca,minb=12
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_baseline10',workingdir=workingdir,niter=intarr(20),/deconvolve,/pointing_model,/fromsave,/fits_nopca,minb=10
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_baseline8',workingdir=workingdir,niter=intarr(20),/deconvolve,/pointing_model,/fromsave,/fits_nopca,minb=8
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_ascending',workingdir=workingdir,niter=indgen(50),/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_01pca',workingdir=workingdir,niter=intarr(20)+01,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_02pca',workingdir=workingdir,niter=intarr(20)+02,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_03pca',workingdir=workingdir,niter=intarr(20)+03,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_04pca',workingdir=workingdir,niter=intarr(20)+04,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_05pca',workingdir=workingdir,niter=intarr(20)+05,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_06pca',workingdir=workingdir,niter=intarr(20)+06,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_07pca',workingdir=workingdir,niter=intarr(20)+07,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_08pca',workingdir=workingdir,niter=intarr(20)+08,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_09pca',workingdir=workingdir,niter=intarr(20)+09,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_10pca',workingdir=workingdir,niter=intarr(20)+10,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_11pca',workingdir=workingdir,niter=intarr(20)+11,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_12pca',workingdir=workingdir,niter=intarr(20)+12,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_13pca',workingdir=workingdir,niter=intarr(20)+13,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_14pca',workingdir=workingdir,niter=intarr(20)+14,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_15pca',workingdir=workingdir,niter=intarr(20)+15,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_16pca',workingdir=workingdir,niter=intarr(20)+16,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_17pca',workingdir=workingdir,niter=intarr(20)+17,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_18pca',workingdir=workingdir,niter=intarr(20)+18,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_19pca',workingdir=workingdir,niter=intarr(20)+19,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
;mem_iter_pc,'/scratch/adam_work/g34.3/g34.3.sav','g34.3/g34.3_20pca',workingdir=workingdir,niter=intarr(20)+20,/deconvolve,/pointing_model,/fromsave,/fits_nopca,/median_sky
time_e,time_dmi,prtmsg="END DO_MEM_ITER "
;mem_iter_pc,'/scratch/adam_work/texts/cygnus_for_pat.in','cygnus/cygnus',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3,7,7,10,10,13,13],/deconvolve,iter0savename='cygnus/cygnus.sav',/fits_psd,/pointing_model
;mem_iter_pc,'/scratch/adam_work/texts/cygnus_for_pat_firstpart.in','cygnus/cygnus_pt1',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3,7,7,10,10,13,13],/deconvolve,iter0savename='cygnus/cygnus_pt1.sav',/fits_psd,/pointing_model
;mem_iter_pc,'/scratch/adam_work/texts/cygnus_for_pat_secondpart.in','cygnus/cygnus_pt2',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3,7,7,10,10,13,13],/deconvolve,iter0savename='cygnus/cygnus_pt2.sav',/fits_psd,/pointing_model
;mem_iter_pc,'/scratch/adam_work/texts/cygnus_for_pat_thirdpart.in','cygnus/cygnus_pt3',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3,7,7,10,10,13,13],/deconvolve,iter0savename='cygnus/cygnus_pt3.sav',/fits_psd,/pointing_model
;mem_iter_pc,'/scratch/adam_work/texts/w345.in','w345/w345_noptg',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3],/deconvolve,iter0savename='w345/w345.sav',/fits_psd
;mem_iter_pc,'/scratch/adam_work/texts/w345.in','w345/w345',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3],/deconvolve,iter0savename='w345/w345.sav',/pointing_model,/fits_psd
;mem_iter_pc,'/scratch/adam_work/texts/g10.62.in','g10.62/g10.62',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3],/deconvolve,iter0savename='g10.62/g10.62.sav',/pointing_model,/fits_psd
;mem_iter_pc,'/scratch/adam_work/l033/l33.in','l033/l033',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3],/deconvolve,iter0savename='l033/l033.sav',/pointing_model,/fits_psd
;mem_iter_pc,'/scratch/adam_work/l111/l111.in','l111/l111',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3],/deconvolve,iter0savename='l111/l111.sav',/pointing_model,/fits_psd
;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001/l001_ascending',workingdir=workingdir,niter=[0,0,1,1,2,2,3,3,4,4,5,6,7,8,9,10,11,12,13],/deconvolve,iter0savename='l001/l001_ascending.sav',/pointing_model,/fits_psd ;,/fits_timestream

;mem_iter_pc,'/scratch/adam_work/texts/m51.in','m51/m51',workingdir=workingdir,niter=[13,13,13,13,13,13,13,13,13,13],/deconvolve,iter0savename='m51/m51.sav',/pointing_model,/fits_psd
;mem_iter_pc,'/scratch/adam_work/texts/m101.in','m101/m101',workingdir=workingdir,niter=[13,13,13,13,13,13,13,13,13,13],/deconvolve,iter0savename='m101/m101.sav',/pointing_model,/fits_psd






;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001_ascending',workingdir=workingdir,niter=[1,1,1,2,2,2,3,3,3,4,4,5,5],/deconvolve,iter0savename='l001_ascending.sav'
;mem_iter_pc,'l33_only05.in','l33_only05',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l33_only05.sav'
;mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','l000',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l000.sav'
;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l001.sav'
;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001/l001_forcepostest',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l001.sav'
;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001/l001_nopca',workingdir=workingdir,niter=[0,0,0,0,0,0,0],/deconvolve
;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001/l001_nopca_median',workingdir=workingdir,niter=[0,0,0,0,0,0,0],/deconvolve,/median_sky
;mem_iter_pc,'/scratch/sliced/l001/l001_good.txt','l001/l001_nopca',workingdir=workingdir,niter=[0,0,0,0,0,0,0],/deconvolve
;mem_iter_pc,'/scratch/sliced/l001/l001_good.txt','l001/l001_nopca_ascending',workingdir=workingdir,niter=[0,0,1,1,2,2,3,3],/deconvolve
;mem_iter_pc,'/scratch/sliced/l001/l001_good.txt','l001/l001_nopca_median',workingdir=workingdir,niter=[0,0,0,0,0,0,0],/deconvolve,/median_sky
;mem_iter_pc,'/scratch/sliced/l359/l359_infile.txt','l359',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l359.sav'

;;mem_iter_pc,'/scratch/sliced/l059/l059_infile.txt','l059',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l059.sav'
;mem_iter_pc,'/scratch/sliced/l068/l068_infile.txt','l068',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l068.sav'
;mem_iter_pc,'/scratch/sliced/l071/l071_infile.txt','l071',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l071.sav'
;mem_iter_pc,'/scratch/sliced/l351/l351_infile.txt','l351',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l351.sav'
;mem_iter_pc,'/scratch/sliced/l354/l354_infile.txt','l354',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l354.sav'
;mem_iter_pc,'/scratch/sliced/l357/l357_infile.txt','l357',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l357.sav'
;mem_iter_pc,'/scratch/sliced/l062/l062_infile.txt','l062',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l062.sav'
;mem_iter_pc,'/scratch/sliced/l065/l065_infile.txt','l065',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l065.sav'
;mem_iter_pc,'/scratch/sliced/l074/l074_infile.txt','l074/l074',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l074.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l076/l076_infile.txt','l076/l076',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l076.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l077/l077_infile.txt','l077/l077',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l077.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l078/l078_infile.txt','l078/l078',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l078.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l079/l079_infile.txt','l079/l079',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l079.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l080/l080_infile.txt','l080/l070',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l080.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l081/l081_infile.txt','l081/l081',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l081.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l082/l082_infile.txt','l082/l082',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l082.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l083/l083_infile.txt','l083/l083',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l083.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l084/l084_infile.txt','l084/l084',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l084.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l085/l085_infile.txt','l085/l085',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l085.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l086/l086_infile.txt','l086/l086',workingdir=workingdir,niter=[3,3,5,5,7,7,9,9,11,11,13,13,15,15],/deconvolve,iter0savename='l086.sav',/pointing_model
;mem_iter_pc,'/scratch/sliced/l133/l133_infile.txt','l133',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l133.sav'
;mem_iter_pc,'/scratch/sliced/lm006/m006_infile.txt','m006',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='m006.sav'
;mem_iter_pc,'/scratch/sliced/l086_1/086_1_infile.txt','l086_1',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l086_1.sav'
;mem_iter_pc,'/scratch/sliced/l083_m1/l083_m1_infile.txt','l083_m1',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l083_m1.sav'
;mem_iter_pc,'/scratch/sliced/l136p15/l136p15_infile.txt','l136p15',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l136p15.sav'
;mem_iter_pc,'/scratch/sliced/l137p05/l137p05_infile.txt','l137p05',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l137p05.sav'
;mem_iter_pc,'/scratch/sliced/l137p15/l137p15_infile.txt','l137p15',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l137p15.sav'
;mem_iter_pc,'/scratch/sliced/l137p15/w5_infile.txt','w5',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='w5.sav'
;mem_iter_pc,'/scratch/sliced/l137p25/l137p25_infile.txt','l137p25',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l137p25.sav'
;mem_iter_pc,'/scratch/sliced/l138p15/l138p15_infile.txt','l138p15',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l138p15.sav'
;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001_median',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3],/deconvolve,/median_sky,iter0savename='l001_median.sav'
;mem_iter_pc,'/scratch/sliced/l001/l001_infile.txt','l001_median_boloflat',workingdir=workingdir,niter=[3,3,3,3,3,3,3,3,3,3],/deconvolve,/median_sky,/boloflat,iter0savename='l001_median_boloflat.sav'
;; l003 causes problems
;mem_iter_pc,'/scratch/sliced/l003/l003_infile.txt','l003',workingdir=workingdir,niter=[3,3,3,3,3,3,3],/deconvolve,iter0savename='l003.sav'
