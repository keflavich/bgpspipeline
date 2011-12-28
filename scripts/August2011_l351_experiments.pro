; do this using original data
coalign_field,'l351','070725_ob3',premap=1,deconvolve=1,prefix='v1.0.2_ds5_original',niter=replicate(13,51),fits_out=[0,1,20,50],dosave=0,infile="l351_infile.txt",refim='/Volumes/disk2/ref_fields/v0.6.2_l351_13pca_map09.fits',mvperjy=[ -3.26472e-15,0.398740,3.32002],/pointing_model

setenv,'sliced=/Volumes/WD_1/sliced'
setenv,'sliced_poly=/Volumes/WD_1/sliced'
setenv,'SLICED=/Volumes/WD_1/sliced'
setenv,'SLICED_POLY=/Volumes/WD_1/sliced'
setenv,'INFILES=/Users/adam/work/bgps_pipeline/mapping_lists/INFILES/'

; v1 mvperjy was this:
mvperjy = [ -3.26472e-15,0.398740,3.32002]
; v2 mvperjy is this:
mvperjy = [0.0,0.773362,4.56406]
; I don't include it because mvperjy should be read directly from the file

coalign_field,'l351','reference_v1',premap=1,coalign=0,deconvolve=1,prefix='v1.0.2_ds2_',dsfactor=2,niter=replicate(13,51),fits_out=[0,1,20,50],dosave=0,infile="l351_ds2_infile.txt",refim=getenv('REFDIR')+'/l351_ref.fits',/pointing_model,indiv_prefix='indiv_v1.0.2'
coalign_field,'l351','reference_v1',premap=0,coalign=0,deconvolve=1,prefix='v1.0.2_ds5_',dsfactor=5,niter=replicate(13,51),fits_out=[0,1,20,50],dosave=0,infile="l351_ds5_infile.txt",refim=getenv('REFDIR')+'/l351_ref.fits',/pointing_model

; original fromsave
; mem_iter,'/scratch/adam_work/l351/l351.sav','/scratch/adam_work/l351/v0.6.2_l351_13pca',workingdir='/scratch/adam_work',deconvolve=0,/pointing_model,/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(15)+13
;
; coalign_field,'l351','070725_ob3',premap=0,deconvolve=1,prefix='v1.0.2_',scratchdir='/usb/scratch1'                    ,niter=[13],dosave=1,infile="l351_infile.txt",refim='/data/bgps/releases/v0.6/v0.6.2_l351_13pca_map09.fits',mvperjy=[ -3.26472e-15,0.398740,3.32002]
; mem_iter,'/usb/scratch1/l351/v1.0.2_l351_13pca_preiter.sav','/usb/scratch1/l351/v1.0.2_l351_13pca',workingdir='/usb/scratch1',deconvolve=1,/pointing_model,/fromsave,dosave=1,fits_timestream=0,ts_map=0,niter=intarr(51)+13
; mem_iter,'/usb/scratch1/l351/v1.0.2_l351_13pca_preiter.sav','/usb/scratch1/l351/v1.0.2_l351_31pca',workingdir='/usb/scratch1',deconvolve=1,/pointing_model,/fromsave,dosave=1,fits_timestream=0,ts_map=0,niter=intarr(51)+31

l351dir = '/Volumes/disk3/adam_work/l351/'
v2fn = 'v2.0_ds2_l351_13pca'
v1ds5fn = 'v1.0.2_ds5_l351_13pca'
v1ds2fn = 'v1.0.2_ds2_l351_13pca'

compare_images,emptyplaceholder,prefix2=l351dir+v2fn,prefix1=l351dir+v1ds5fn,suffix2="_map20.fits",suffix1="_map20.fits",$
   output_name=l351dir+"compare_l351_v1v2",in1='v1ds5',in2='v2',/samescale,wcsaperture=" ",cuts='0.5,3.0'
compare_images,emptyplaceholder,prefix2=l351dir+v1ds2,prefix1=l351dir+v1ds5fn,suffix2="_map20.fits",suffix1="_map20.fits",$
   output_name=l351dir+"compare_l351_v1v2",in1='v1ds5',in2='v1ds2',/samescale,wcsaperture=" ",cuts='0.5,3.0'

v2_from_v1_labels,l351,v2version='v1.0.2_',v2mapdir=l351dir,v2noisemapdir=l351dir,savedir=l351dir,savesuffix='_v1ds2_bolocat_compare.sav',dsfactor=2
v2_from_v1_labels,l351,v2version='v1.0.2_',v2mapdir=l351dir,v2noisemapdir=l351dir,savedir=l351dir,savesuffix='_v1ds5_bolocat_compare.sav',dsfactor=5

end

