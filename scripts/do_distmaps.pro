@/home/milkyway/student/ginsbura/.idl_startup_publish
@/home/milkyway/student/ginsbura/bgps_pipeline/support/compiled_modules.pro
!except=0

doplot=0
fixgrid=0
fixscale=1

distmap_comp,getenv('SLICED_POLY')+'/uranus/050619_o23_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o23',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/050619_o24_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050619_o24',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/050628_o33_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o33',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/050628_o34_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_050628_o34',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/neptune/050626_o19_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o19',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/neptune/050626_o20_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_050626_o20',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/mars/050627_o31_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o31',/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/mars/050627_o32_raw_ds1.nc','/scratch/adam_work/distmaps/mars_050627_o32',/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/050904_o31_raw_ds1.nc','/scratch/adam_work/distmaps/uranus_050904_o31',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/050904_o32_raw_ds1.nc','/scratch/adam_work/distmaps/uranus_050904_o32',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/050911_ob8_raw_ds1.nc','/scratch/adam_work/distmaps/uranus_050911_ob8',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale

distmap_comp,getenv('SLICED_POLY')+'/3c279/050703_ob1_raw_ds5.nc','/scratch/adam_work/distmaps/3c279_050703_ob1',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/3c279/050703_ob2_raw_ds5.nc','/scratch/adam_work/distmaps/3c279_050703_ob2',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale


if file_test(getenv('SLICED')+'/neptune/060602_o30_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/neptune/060602_o30_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_060602_o30',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED')+'/neptune/060602_o31_raw_ds5.nc','/scratch/adam_work/distmaps/neptune_060602_o31',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/mars/060605_ob1_raw_ds1.nc','/scratch/adam_work/distmaps/mars_060605_ob1',/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/mars/060605_ob2_raw_ds1.nc','/scratch/adam_work/distmaps/mars_060605_ob2',/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060621_o29_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060621_o29_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060621_o29',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060621_o30_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060621_o30_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060621_o30',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060625_o46_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060625_o46_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060625_o46',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale

if file_test(getenv('SLICED')+'/uranus/060905_ob6_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060905_ob6_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060905_ob6',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060906_o12_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060906_o12_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060906_o12',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060908_o13_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060908_o13_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060908_o13',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060909_o12_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060909_o12_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060909_o12',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060910_o12_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060910_o12_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060910_o12',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060911_ob8_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060911_ob8_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060911_ob8',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060914_o10_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060914_o10_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060914_o10',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060914_o11_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060914_o11_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060914_o11',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060916_ob4_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060916_ob4_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060916_ob4',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060917_ob9_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060917_ob9_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060917_ob9',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
if file_test(getenv('SLICED')+'/uranus/060919_ob9_raw_ds5.nc') then distmap_comp,getenv('SLICED')+'/uranus/060919_ob9_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_060919_ob9',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale

distmap_comp,getenv('SLICED_POLY')+'/g34.3/070630_o34_raw_ds1.nc','/scratch/adam_work/distmaps/g34.3_070630_o34',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/g34.3/070630_o35_raw_ds1.nc','/scratch/adam_work/distmaps/g34.3_070630_o35',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/070702_o42_raw_ds1.nc','/scratch/adam_work/distmaps/uranus_070702_o42',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/070701_o38_raw_ds1.nc','/scratch/adam_work/distmaps/uranus_070701_o38',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED_POLY')+'/uranus/070702_o41_raw_ds1.nc','/scratch/adam_work/distmaps/uranus_070702_o41',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale

distmap_comp,getenv('SLICED')+'/uranus/070912_o27_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_070912_o27',doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
; all ut times are negative distmap_comp,getenv('SLICED')+'/uranus/070912_o28_raw_ds5.nc','/scratch/adam_work/distmaps/uranus_070912_o28',/doplot,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED')+'/mars/070913_o22_raw_ds5.nc','/scratch/adam_work/distmaps/mars_070913_o22',/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale
distmap_comp,getenv('SLICED')+'/mars/070913_o23_raw_ds5.nc','/scratch/adam_work/distmaps/mars_070913_o23',/mars,doplot=doplot,fixgrid=fixgrid,fixscale=fixscale

average_beamloc,'/scratch/adam_work/distmaps/0506_BLfiles.txt','/scratch/adam_work/distmaps/0506_average_beamloc.txt',doplot=doplot
average_beamloc,'/scratch/adam_work/distmaps/0506_BLfiles.txt','/scratch/adam_work/distmaps/0506_average_beamloc_fixgrid.txt',doplot=doplot

