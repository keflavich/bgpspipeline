@/home/milkyway/student/ginsbura/.idl_startup_publish
workingdir = '/scratch/adam_work/'

mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_5pca'                    ,workingdir=workingdir,niter=intarr(20)+5,/deconvolve,/fits_smooth,/pointing_model    
mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_5pca_nodeconv'           ,workingdir=workingdir,niter=intarr(20)+5,/fits_smooth,/pointing_model    
mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_5pca_baseline10'         ,workingdir=workingdir,niter=intarr(20)+5,/deconvolve,/fits_smooth,/pointing_model,minlen=10    
mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_5pca_nodeconv_baseline10',workingdir=workingdir,niter=intarr(20)+5,/fits_smooth,/pointing_model,minlen=10    

mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_21pca'                    ,workingdir=workingdir,niter=intarr(20)+21,/deconvolve,/fits_smooth,/pointing_model    
mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_21pca_nodeconv'           ,workingdir=workingdir,niter=intarr(20)+21,/fits_smooth,/pointing_model    
mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_21pca_baseline10'         ,workingdir=workingdir,niter=intarr(20)+21,/deconvolve,/fits_smooth,/pointing_model,minlen=10    
mem_iter_pc,'/scratch/sliced/l000/l000_infile.txt','/scratch/adam_work/l000/l000_comparisons/l000_21pca_nodeconv_baseline10',workingdir=workingdir,niter=intarr(20)+21,/fits_smooth,/pointing_model,minlen=10    



