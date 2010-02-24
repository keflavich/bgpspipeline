mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_00',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],dorotang=0,doposang=0,workingdir=workingdir   
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_10',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],dorotang=1,doposang=0,workingdir=workingdir  
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_01',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],dorotang=0,doposang=1,workingdir=workingdir  
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_11',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],dorotang=1,doposang=1,workingdir=workingdir  

spawn,'pwd',workingdir
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_doboth',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],workingdir=workingdir  
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_dontrotang',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],dorotate=0,workingdir=workingdir  
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_dontposang',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],doposang=0,workingdir=workingdir  
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','l24_070717_o15_doneither',/dosave,iter0savename='test_l24_070717.sav',niter=[13,13],dorotate=0,doposang=0,workingdir=workingdir   

spawn,'pwd',workingdir
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','ROT_TEST/l24_070717_o15_prappa',niter=[13,13],workingdir=workingdir,/pra,/ppa 
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','ROT_TEST/l24_070717_o15_mrappa',niter=[13,13],workingdir=workingdir,/mra,/ppa 
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','ROT_TEST/l24_070717_o15_prampa',niter=[13,13],workingdir=workingdir,/pra,/mpa 
mem_iter_pc,'/scratch/sliced/l024/070717_o15_raw_ds5.nc','ROT_TEST/l24_070717_o15_mrampa',niter=[13,13],workingdir=workingdir,/mra,/mpa 

mem_iter_pc,'/scratch/sliced/l024/060603_o16_raw_ds5.nc','ROT_TEST/l24_060603_o16_prappa',niter=[13,13],workingdir=workingdir,/pra,/ppa  
mem_iter_pc,'/scratch/sliced/l024/060603_o16_raw_ds5.nc','ROT_TEST/l24_060603_o16_mrappa',niter=[13,13],workingdir=workingdir,/mra,/ppa  
mem_iter_pc,'/scratch/sliced/l024/060603_o16_raw_ds5.nc','ROT_TEST/l24_060603_o16_prampa',niter=[13,13],workingdir=workingdir,/pra,/mpa  
mem_iter_pc,'/scratch/sliced/l024/060603_o16_raw_ds5.nc','ROT_TEST/l24_060603_o16_mrampa',niter=[13,13],workingdir=workingdir,/mra,/mpa  


