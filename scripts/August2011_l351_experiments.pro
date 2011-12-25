setenv,'sliced=/Volumes/WD_1/sliced'
setenv,'sliced_poly=/Volumes/WD_1/sliced'
setenv,'SLICED=/Volumes/WD_1/sliced'
setenv,'SLICED_POLY=/Volumes/WD_1/sliced'
setenv,'INFILES=/Users/adam/work/bgps_pipeline/mapping_lists/INFILES/'

; v1 mvperjy was this:
mvperjy = [ -3.26472e-15,0.398740,3.32002]
; v2 mvperjy is this:
mvperjy = [0.0,0.773362,4.56406]

coalign_field,'l351','070725_ob3',premap=1,deconvolve=1,prefix='v1.0.2_ds5_',dsfactor=5,niter=replicate(13,21),dosave=0,infile="l351_ds5_infile.txt",refim=getenv('REFDIR')+'/l351_ref.fits'
coalign_field,'l351','070725_ob3',premap=1,deconvolve=1,prefix='v1.0.2_ds2_',dsfactor=2,niter=replicate(13,21),dosave=0,infile="l351_ds2_infile.txt",refim=getenv('REFDIR')+'/l351_ref.fits'


l351dir = '/Volumes/disk3/adam_work/l351/'
v2fn = 'v2.0_ds2_l351_13pca'
v1ds5fn = 'v1.0.2_ds5_l351_13pca'
v1ds2fn = 'v1.0.2_ds2_l351_13pca'

compare_images,emptyplaceholder,prefix2=l351dir+v2fn,prefix1=l351dir+v1ds5fn,suffix2="_map20.fits",suffix1="_map20.fits",$
   output_name=outdir+"compare_l351_v1v2",in1='v1ds5',in2='v2',/samescale,wcsaperture=" ",cuts='0.5,3.0'
compare_images,emptyplaceholder,prefix2=l351dir+v1ds2,prefix1=l351dir+v1ds5fn,suffix2="_map20.fits",suffix1="_map20.fits",$
   output_name=outdir+"compare_l351_v1v2",in1='v1ds5',in2='v1ds2',/samescale,wcsaperture=" ",cuts='0.5,3.0'

end

