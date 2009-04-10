@/home/milkyway/student/ginsbura/.idl_startup_publish
@/home/milkyway/student/ginsbura/bgps_pipeline/support/compiled_modules.pro
!except=0
!more=0

doplot=2
fixgrid=0
fixscale=1

outtxt = '/scratch/adam_work/distmaps/distmaptest_nofit.txt'
outfile_suf = '_nofit'
distmap_comp,['/scratch/sliced_polychrome/uranus/050619_o23_raw_ds5.nc','/scratch/sliced_polychrome/uranus/050619_o24_raw_ds5.nc'],'/scratch/adam_work/distmaps/uranus_050619_o23-4'+outfile_suf,doplot=doplot,outtxt=outtxt
distmap_comp,['/scratch/sliced_polychrome/uranus/050628_o33_raw_ds5.nc','/scratch/sliced_polychrome/uranus/050628_o34_raw_ds5.nc'],'/scratch/adam_work/distmaps/uranus_050628_o33-4'+outfile_suf,doplot=doplot,outtxt=outtxt
distmap_comp,['/scratch/sliced_polychrome/neptune/050626_o19_raw_ds5.nc','/scratch/sliced_polychrome/neptune/050626_o20_raw_ds5.nc'],'/scratch/adam_work/distmaps/neptune_050626_o19-20'+outfile_suf,doplot=doplot,outtxt=outtxt
distmap_comp,['/scratch/sliced_polychrome/mars/050627_o31_raw_ds1.nc','/scratch/sliced_polychrome/mars/050627_o32_raw_ds1.nc'],'/scratch/adam_work/distmaps/mars_050627_o31-2'+outfile_suf,/mars,doplot=doplot,outtxt=outtxt
$ls *_nofit.txt > 0506_nofitlist.txt
average_beamloc,'0506_nofitlist.txt','0506_nofit_averagebeamloc.txt'


outtxt = '/scratch/adam_work/distmaps/distmaptest_fixscale.txt'
outfile_suf = '_fixscale'
distmap_comp,['/scratch/sliced_polychrome/uranus/050619_o23_raw_ds5.nc','/scratch/sliced_polychrome/uranus/050619_o24_raw_ds5.nc'],'/scratch/adam_work/distmaps/uranus_050619_o23-4'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,['/scratch/sliced_polychrome/uranus/050628_o33_raw_ds5.nc','/scratch/sliced_polychrome/uranus/050628_o34_raw_ds5.nc'],'/scratch/adam_work/distmaps/uranus_050628_o33-4'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,['/scratch/sliced_polychrome/neptune/050626_o19_raw_ds5.nc','/scratch/sliced_polychrome/neptune/050626_o20_raw_ds5.nc'],'/scratch/adam_work/distmaps/neptune_050626_o19-20'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,['/scratch/sliced_polychrome/mars/050627_o31_raw_ds1.nc','/scratch/sliced_polychrome/mars/050627_o32_raw_ds1.nc'],'/scratch/adam_work/distmaps/mars_050627_o31-2'+outfile_suf,/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
$ls *_fixscale.txt > 0506_fixscalelist.txt
average_beamloc,'0506_fixscalelist.txt','0506_fixscale_averagebeamloc.txt'

fixgrid=1
fixscale=1
outtxt = '/scratch/adam_work/distmaps/distmaptest_fixscale_fixgrid.txt'
outfile_suf = '_fixscale_fixgrid'
distmap_comp,'/scratch/sliced_polychrome/uranus/050619_o23_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o23'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050619_o24_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o24'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050628_o33_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o33'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050628_o34_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o34'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/neptune/050626_o19_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o19'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/neptune/050626_o20_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o20'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/mars/050627_o31_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o31'+outfile_suf,/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/mars/050627_o32_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o32'+outfile_suf,/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
$ls *_fixscalegrid.txt > 0506_fixscalegridlist.txt
average_beamloc,'0506_fixscalegridlist.txt','0506_fixscalegrid_averagebeamloc.txt'

fixgrid=1
fixscale=0
outtxt = '/scratch/adam_work/distmaps/distmaptest_fixgrid.txt'
outfile_suf = '_fixgrid'
distmap_comp,'/scratch/sliced_polychrome/uranus/050619_o23_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o23'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050619_o24_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o24'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050628_o33_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o33'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050628_o34_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o34'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/neptune/050626_o19_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o19'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/neptune/050626_o20_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o20'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/mars/050627_o31_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o31'+outfile_suf,/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/mars/050627_o32_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o32'+outfile_suf,/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
$ls *_fixgrid.txt > 0506_fixgridlist.txt
average_beamloc,'0506_fixgridlist.txt','0506_fixgrid_averagebeamloc.txt'

fixgrid=0
fixscale=0
outtxt = '/scratch/adam_work/distmaps/distmaptest_nofixed.txt'
outfile_suf = '_nofix'
distmap_comp,'/scratch/sliced_polychrome/uranus/050619_o23_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o23'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050619_o24_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o24'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050628_o33_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o33'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/uranus/050628_o34_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o34'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/neptune/050626_o19_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o19'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/neptune/050626_o20_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o20'+outfile_suf,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/mars/050627_o31_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o31'+outfile_suf,/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
distmap_comp,'/scratch/sliced_polychrome/mars/050627_o32_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o32'+outfile_suf,/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale,outtxt=outtxt
$ls *_nofix.txt > 0506_nofixlist.txt
average_beamloc,'0506_nofixlist.txt','0506_nofix_averagebeamloc.txt'



; not really testing the distmapper but related....
coalign_field,'l018','070717_o10',premap=0,deconvolve=1,prefix='defaultdistcor_v1.0.2_',scratchdir='/usb/scratch1',niter=[13],dosave=1,infile="l018_infile.txt",refim='/data/bgps/releases/v0.6/l018_ref.fits',mvperjy=[ -3.26472e-15,0.398740,3.32002],distcor='~/bgps_pipeline/bgps_params/beam_locations_default.txt'
mem_iter,'/usb/scratch1/l018/defaultdistcor_v1.0.2_l018_13pca_preiter.sav','/usb/scratch1/l018/defaultdistcor_v1.0.2_l018_13pca',workingdir='/usb/scratch1',deconvolve=1,/pointing_model,/fromsave,dosave=1,fits_timestream=0,ts_map=0,niter=intarr(51)+13,fits_out=[0,1,10,20,30,40,50]





