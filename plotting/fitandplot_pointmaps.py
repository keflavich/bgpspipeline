"""
Intense point source code.  This is the code that made model_psf.fits
"""
import mpl_toolkits.axes_grid.parasite_axes as mpltk
import time
import copy
import aplpy
import glob
import pyfits
from agpy import gaussfitter,readcol,timer
import numpy
import pylab
import re
import coords
import pywcs
from scipy.ndimage.interpolation import shift as imshift
import sys
sys.path.append("/Users/adam/work/bgps_pipeline/plotting/")
from robust_fit import robust_fit

bright=False
mask=False
pca=False
ds=True
text=True

sample='dec2010mask'
sample='dec2011'
sample='dec2011notmars'
if len(sys.argv) > 1:
    if ".fits" in sys.argv[1]:
        sample = "Command-Line Input File"
        filelist = [sys.argv[1]]
    else:
        sample = sys.argv[1]

print "Working on sample %s" % sample
raw=False

pointmaps = '/Volumes/disk3/adam_work/pointmaps/'
pointmapsv1 = '/Volumes/disk3/adam_work/pointmaps_v1.0/'
dec2010 = '/Volumes/disk3/adam_work/uranus/dec2010'
savefile = '/dev/tty'

if sample=='dec2010':
    filelist = glob.glob('%s/10120[89]*ds[15]*_map10.fits' % dec2010)
    savefile = '/Volumes/disk3/adam_work/uranus/dec2010/fitandplot_fits.txt'
if sample=='dec2010mask':
    filelist = glob.glob('%s/mask*10120[89]*ds[15]*_map10.fits' % dec2010)
    savefile = '/Volumes/disk3/adam_work/uranus/dec2010/fitandplot_fits_masked.txt'
if sample=='v1-v2':
    filelist = [
            pointmapsv1+'mars_050703_o32-3_v1.0_0pca_map10.fits',
            pointmapsv1+'mars_050703_o32-3_v1.0_3pca_map10.fits',
            pointmapsv1+'mars_050703_o32-3_v1.0_13pca_map10.fits',
            pointmapsv1+'mars_050703_o32-3_v1.0_scaleacb_13pca_map10.fits',
            pointmapsv1+'mars_050703_o32-3_v1.0_scaleacb_3pca_map10.fits',
            pointmapsv1+'mars_050703_o32-3_v1.0_scaleacb_0pca_map10.fits',
            pointmaps+'mars_050703_o32-3_0pca_map10.fits',
            pointmaps+'mars_050703_o32-3_3pca_map10.fits',
            pointmaps+'mars_050703_o32-3_13pca_map10.fits',
            pointmaps+'mars_050703_o32-3_13pca_scaleacb_map10.fits',
            pointmaps+'mars_050703_o32-3_3pca_scaleacb_map10.fits',
            pointmaps+'mars_050703_o32-3_0pca_scaleacb_map10.fits',
            ]
if sample=='maskvnot':
    filelist = [
            'mars_050911_o22-3_mask_0pca_map10.fits',
            'mars_050911_o22-3_0pca_map10.fits',
            'mars_050911_o22-3_0pca_scaleacb_map10.fits',
            'mars_050911_o22-3_mask_3pca_map10.fits',
            'mars_050911_o22-3_3pca_map10.fits',
            'mars_050911_o22-3_3pca_scaleacb_map10.fits',
            'mars_050911_o22-3_mask_13pca_map10.fits',
            'mars_050911_o22-3_13pca_map10.fits',
            'mars_050911_o22-3_13pca_scaleacb_map10.fits',
            'mars_050703_o32-3_mask_0pca_map10.fits',
            'mars_050703_o32-3_0pca_map10.fits',
            'mars_050703_o32-3_0pca_scaleacb_map10.fits',
            'mars_050703_o32-3_mask_3pca_map10.fits',
            'mars_050703_o32-3_3pca_map10.fits',
            'mars_050703_o32-3_3pca_scaleacb_map10.fits',
            'mars_050703_o32-3_mask_13pca_map10.fits',
            'mars_050703_o32-3_13pca_map10.fits',
            'mars_050703_o32-3_13pca_scaleacb_map10.fits',
            'uranus_070713_o28-9_mask_0pca_map10.fits',
            'uranus_070713_o28-9_0pca_map10.fits',
            'uranus_070713_o28-9_0pca_scaleacb_map10.fits',
            'uranus_070713_o28-9_mask_3pca_map10.fits',
            'uranus_070713_o28-9_3pca_map10.fits',
            'uranus_070713_o28-9_3pca_scaleacb_map10.fits',
            'uranus_070713_o28-9_mask_13pca_map10.fits',
            'uranus_070713_o28-9_13pca_map10.fits',
            'uranus_070713_o28-9_13pca_scaleacb_map10.fits',
            ]
elif sample=='maskrad':
    filelist = [
        'mars_050911_o22-3_0pca_mask000_map10.fits',
        'mars_050911_o22-3_0pca_mask010_map10.fits',
        'mars_050911_o22-3_0pca_mask020_map10.fits',
        'mars_050911_o22-3_0pca_mask030_map10.fits',
        'mars_050911_o22-3_0pca_mask040_map10.fits',
        'mars_050911_o22-3_0pca_mask050_map10.fits',
        'mars_050911_o22-3_0pca_mask060_map10.fits',
        'mars_050911_o22-3_0pca_mask070_map10.fits',
        'mars_050911_o22-3_0pca_mask080_map10.fits',
        'mars_050911_o22-3_0pca_mask090_map10.fits',
        'mars_050911_o22-3_0pca_mask100_map10.fits',
        'mars_050911_o22-3_0pca_mask110_map10.fits',
        'mars_050911_o22-3_0pca_mask120_map10.fits',
        'mars_050911_o22-3_0pca_mask130_map10.fits',
        'mars_050911_o22-3_0pca_mask140_map10.fits',
    ]            
elif sample=='one':
    filelist = [
    '3c273_060604_o10_13pca_bright_map50.fits',
    '3c273_060604_o18_13pca_bright_map50.fits',
    '3c273_060614_ob5_13pca_bright_map50.fits',
    '3c273_060615_ob2_13pca_bright_map50.fits',
    '3c273_060615_ob4_13pca_bright_map50.fits',
    '3c273_060621_ob2_13pca_bright_map50.fits',
    '3c273_060623_ob1_13pca_bright_map50.fits',
    '3c273_070701_ob4_13pca_bright_map50.fits',
    '3c273_070703_ob4_13pca_bright_map50.fits',
    '3c273_070703_ob6_13pca_bright_map50.fits',
    '3c279_050629_ob1_13pca_bright_map50.fits',
    '3c279_050630_ob1_13pca_bright_map50.fits',
    '3c279_050703_ob1_13pca_bright_map50.fits',
    '3c279_050707_o15_13pca_bright_map50.fits',
    '3c279_050707_ob1_13pca_bright_map50.fits',
    '3c279_060602_o10_13pca_bright_map50.fits',
    '3c279_060602_o12_13pca_bright_map50.fits',
    '3c279_060602_ob2_13pca_bright_map50.fits',
    '3c279_060602_ob4_13pca_bright_map50.fits',
    '3c279_060602_ob6_13pca_bright_map50.fits',
    '3c279_060602_ob8_13pca_bright_map50.fits',
    '3c279_060604_o11_13pca_bright_map50.fits',
    '3c279_060604_o19_13pca_bright_map50.fits',
    '3c279_070630_o14_13pca_bright_map50.fits',
    '3c279_070630_ob1_13pca_bright_map50.fits',
    '3c279_070630_ob4_13pca_bright_map50.fits',
    '3c279_070630_ob6_13pca_bright_map50.fits',
    '3c279_070701_ob2_13pca_bright_map50.fits',
    '3c279_070703_ob2_13pca_bright_map50.fits',
    '3c279_070705_ob3_13pca_bright_map50.fits',
    '3c279_070706_ob3_13pca_bright_map50.fits',
    '3c279_070707_ob1_13pca_bright_map50.fits',
    '3c279_070709_ob5_13pca_bright_map50.fits',
    '3c345_050627_ob1_13pca_bright_map50.fits',  
    '3c345_050627_ob9_13pca_bright_map50.fits',
    '3c345_050628_ob2_13pca_bright_map50.fits',
    # bad pointing '3c345_060602_o22_13pca_bright_map50.fits',
    # '3c345_070629_ob2_13pca_bright_map50.fits',
    #'3c345_070630_o16_13pca_bright_map50.fits',
    #'3c345_070630_o18_13pca_bright_map50.fits',
    # '3c345_070630_o20_13pca_bright_map50.fits',
    #'3c345_070630_o22_13pca_bright_map50.fits',  # all of these 3c345 observations are blobby and weird
    # '3c345_070630_o24_13pca_bright_map50.fits',
    #'3c345_070630_o26_13pca_bright_map50.fits',
    #'3c345_070630_o28_13pca_bright_map50.fits',
    #'3c345_070701_o10_13pca_bright_map50.fits',
    #'3c345_070701_ob6_13pca_bright_map50.fits',
    #'3c345_070701_ob9_13pca_bright_map50.fits',
    #'3c345_070703_o13_13pca_bright_map50.fits',
    #'3c345_070703_o19_13pca_bright_map50.fits',
    #'3c345_070703_o27_13pca_bright_map50.fits',
    '3c345_070704_ob9_13pca_bright_map50.fits',
    '3c345_070705_o11_13pca_bright_map50.fits',
    '3c345_070707_o35_13pca_bright_map50.fits',
    '3c345_070707_ob7_13pca_bright_map50.fits',
    '3c345_070708_o19_13pca_bright_map50.fits',
    '3c345_070711_ob1_13pca_bright_map50.fits',
    ]        
elif sample=='two':
    filelist = [
        'neptune_070902_13pca_bright_map49.fits',
        'uranus_050619_o23_13pca_bright_map49.fits',
        'uranus_050628_o34_13pca_bright_map49.fits',
        'uranus_050904_o32_13pca_bright_map49.fits',
        'uranus_060621_13pca_bright_map49.fits',
        'uranus_070702_o42_13pca_bright_map49.fits',
        ]
elif sample=='three' or sample=="notmars":
    filelist = [
        # removed 'mars_070904_o47-8_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'mars_070904_o49-0_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'mars_070904_o51-2_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'mars_070904_o53-4_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_070905_o62-3_mask_v2.0_0pca_coalign_map10.fits',
        # removed blurry / probably before run was ready 'neptune_070902_ob5-6_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_070905_o33-4_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_070905_o46-7_mask_v2.0_0pca_coalign_map10.fits',
        # removed unknown failure 'mars_070910_o27-8_mask_v2.0_0pca_coalign_map10.fits', 
        # bad for stacking 'mars_070910_o31-2_mask_v2.0_0pca_coalign_map10.fits', 
        # bad for stacking 'mars_070913_o22-3_mask_v2.0_0pca_coalign_map10.fits', 
        # bad for stacking 'mars_070909_o24-5_mask_v2.0_0pca_coalign_map10.fits', 
        # removed 'uranus_070904_o11-2_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070904_o13-4_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070904_o15-6_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070904_o17-8_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070904_o19-0_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070904_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        #removed 'uranus_070904_o43-4_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070904_o45-6_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070905_o31-2_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'uranus_070908_o10-9_mask_v2.0_0pca_coalign_map10.fits', # bad 
        'neptune_050902_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050905_o10-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050905_o12-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050905_ob8-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050911_o22-3_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050906_ob7-8_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050907_ob3-4_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050908_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050911_ob7-8_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'neptune_050629_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_060602_o30-1_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_060603_o23-4_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_060604_o44-5_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_060605_o45-6_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_060609_o28-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'neptune_060615_o11-2_mask_v2.0_0pca_coalign_map10.fits',
        # bad offset 'neptune_070630_o44-5_mask_v2.0_0pca_coalign_map10.fits',
        'neptune_070703_o42-3_mask_v2.0_0pca_coalign_map10.fits',
        # removed negative ut times 'neptune_070703_o52-3_mask_v2.0_0pca_coalign_map10.fits',
        # removed negative ut times 'neptune_070703_o54-5_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070706_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070713_o36-7_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070713_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070714_o76-7_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070715_o45-6_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070717_o47-8_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070718_o41-2_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070725_o34-5_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070726_o33-4_mask_v2.0_0pca_coalign_map10.fits',
        'mars_070730_o23-4_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'uranus_070629_ob6-7_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070702_o41-2_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070703_o50-1_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070713_o28-9_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070715_o31-2_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070715_o43-4_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070717_o33-4_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070718_o32-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'uranus_070719_o35-6_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070727_o31-2_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070728_o30-1_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_070729_o43-4_mask_v2.0_0pca_coalign_map10.fits',
        'mars_060604_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        'mars_060605_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        'mars_060612_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        'mars_060612_ob3-4_mask_v2.0_0pca_coalign_map10.fits',
        'mars_060612_ob5-6_mask_v2.0_0pca_coalign_map10.fits',
        'mars_060628_ob5-6_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050627_o31-2_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050630_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050703_o32-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050703_o34-5_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050704_o15-6_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050705_o21-2_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050706_o63-4_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050707_o76-7_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050708_o46-7_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050708_o60-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_050709_o57-8_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'mars_060604_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        'mars_060605_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091210_o72-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091211_o78-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091215_o32-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091216_o31-2_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091217_o33-4_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091218_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091218_o40-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091219_o40-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091219_o42-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091222_o25-6_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091223_o27-8_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o24-5_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o26-7_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o28-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o30-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o32-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o34-5_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o36-7_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091224_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o30-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o32-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o34-5_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o36-7_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o38-9_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o40-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o42-3_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o44-5_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091225_o46-7_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'mars_091227_o26-7_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050619_o23-4_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050628_o33-4_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050629_o40-1_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_050630_o40-1_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_050710_o19-0_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_050904_o31-2_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_050905_ob6-7_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'uranus_060614_o14-5_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'uranus_060615_o15-6_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060615_o17-8_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060616_o11-2_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060616_o15-6_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060621_o27-8_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060621_o29-0_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'uranus_060624_o40-1_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060625_o46-7_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060626_o40-1_mask_v2.0_0pca_coalign_map10.fits',
        # bad for stacking 'uranus_060628_o50-1_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060629_o13-4_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060630_o31-2_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_060903_o10-1_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_060906_o12-3_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_060914_o10-1_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070927_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070927_ob3-4_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070927_ob5-6_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070927_ob7-8_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_070927_ob9-0_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_091210_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_091210_ob3-4_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_091210_ob5-6_mask_v2.0_0pca_coalign_map10.fits',
        # removed 'uranus_091210_ob7-8_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_091216_ob8-9_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_091219_o15-6_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_091220_ob1-2_mask_v2.0_0pca_coalign_map10.fits',
        'uranus_091224_o10-9_mask_v2.0_0pca_coalign_map10.fits',
        ]
    if sample=='notmars':
        #filelist = [ a for a in filelist  if a.find('mars')==-1 ]
        #filelist = filelist[:4]
        imstack = pylab.zeros([300,300,len(filelist)])
        xx,yy = pylab.indices([300,300])
elif sample=='dec2011':
    filelist = [a for b in readcol('/Users/adam/work/bgps_pipeline/plotting/lists/pointsource_ds2_13pca_default.list') for a in b ]
elif sample=='dec2011notmars':
    filelist = [a for b in readcol('/Users/adam/work/bgps_pipeline/plotting/lists/pointsource_ds2_13pca_default.list') for a in b if 'mars' not in a ]
    marslist = [a for b in readcol('/Users/adam/work/bgps_pipeline/plotting/lists/pointsource_ds2_13pca_default.list') for a in b if 'mars' in a ]
    imstack = pylab.zeros([300,300,len(filelist)])
    marsstack = pylab.zeros([300,300,len(marslist)])
    xx,yy = pylab.indices([300,300])


    
#filelist = ['uranus_070702_o41-2_mask_v2.0_0pca_coalign_map10.fits']
            
if raw:
    raw = 'raw'
    for ii,x in enumerate(filelist):
        filelist[ii] = x.replace('map50','rawmap')

def planetflux(planet,date):
    if planet=='mars':
        mars = readcol('/Users/adam/work/bgps_pipeline/calibration/MARS.DAT',asStruct=True)
        closest = numpy.argmin(numpy.abs(date-mars.MJD))
        return mars.fluxbeam[closest]
    elif planet=='uranus':
        uranus = readcol('/Users/adam/work/bgps_pipeline/calibration/URANUS.DAT',asStruct=True)
        closest = numpy.argmin(numpy.abs(date-uranus.MJD))
        return uranus.fluxbeam[closest]
    elif planet=='neptune':
        neptune = readcol('/Users/adam/work/bgps_pipeline/calibration/NEPTUNE.DAT',asStruct=True)
        closest = numpy.argmin(numpy.abs(date-neptune.MJD))
        return neptune.fluxbeam[closest]
    elif planet=='sgrb2':
        return 100.0



#wxarr,wyarr = numpy.zeros(len(filelist)),numpy.zeros(len(filelist))
#frac20,frac40,frac60 = numpy.zeros(len(filelist)),numpy.zeros(len(filelist)),numpy.zeros(len(filelist))
#flux20,flux40,flux60 = numpy.zeros(len(filelist)),numpy.zeros(len(filelist)),numpy.zeros(len(filelist))
#fluxnb20,fluxnb40,fluxnb60 = numpy.zeros(len(filelist)),numpy.zeros(len(filelist)),numpy.zeros(len(filelist))
#fluxr20,fluxr40,fluxr60 = numpy.zeros(len(filelist)),numpy.zeros(len(filelist)),numpy.zeros(len(filelist))
#fluxg20,fluxg40,fluxg60 = numpy.zeros(len(filelist)),numpy.zeros(len(filelist)),numpy.zeros(len(filelist))
vmin = -5

outf = open(savefile,'w')
print >>outf,"file","wxarr","wyarr","cx","cy","peak","frac20","frac40","frac60","flux20","flux40","flux60","fluxnb20","fluxnb40","fluxnb60","fluxr20","fluxr40","fluxr60","planetflux","meandc","stddc"

gaussfit = timer.print_timing(gaussfitter.gaussfit)

for jj,file in enumerate(filelist):
    print "Beginning loop for file %s" % file
    t0 = time.time()
    fitsfile = pyfits.open(file)
    img = fitsfile[0].data
    header = fitsfile[0].header
    img[img!=img]=0

    #if img.shape[0] > 220:
    #    img = img[img.shape[0]/2-100:img.shape[0]/2+100,:]
    #    fitsfile[0].header.update('NAXIS1',220)
    #if img.shape[1] > 220:
    #    img = img[:,img.shape[1]/2-100:img.shape[1]/2+100]
    #    fitsfile[0].header.update('NAXIS2',220)
    fitsfile[0].data = img

    cdelt = abs(header.get('CD1_1')) if header.get('CD1_1') else abs(header.get('CDELT1'))
    asperpix = cdelt * 3600.0

    fitpars, gaussim, fitimg, zz, zzg = robust_fit(img, autocrop=False)

    height,ampl = fitpars[:2]
    cy,cx = fitpars[2:4]
    wxy = fitpars[4:6]*asperpix*numpy.sqrt(8*numpy.log(2))
    wxarr,wyarr = max(wxy),min(wxy)

    mean_fwhm = wxy.sum()/2.0
    xx,yy = numpy.indices(img.shape)
    rr = (numpy.sqrt((xx-cx)**2 + (yy-cy)**2))
    resid_data = (fitimg-gaussim)[rr < mean_fwhm]
    resid_sum = resid_data.sum()
    resid_std = resid_data.std()

    rrs = numpy.argsort(rr.flat)
    ddplot = numpy.sort(rr.ravel())*asperpix #dd*asperpix
    zz[ddplot>120] = 0
    zzplot = zz.cumsum()
    zzgplot = zzg.cumsum()
    gausssum = gaussim.sum()

    d20,d40,d60,d300 = numpy.argmin(numpy.abs(ddplot-20)),numpy.argmin(numpy.abs(ddplot-40)),numpy.argmin(numpy.abs(ddplot-60)),numpy.argmin(numpy.abs(ddplot-300))
    dgauss = numpy.argmin(numpy.abs(zzplot-gausssum))
    fracgauss = gausssum/zzplot[d300]
    fluxg20 = zzgplot[d20]
    fluxg40 = zzgplot[d40]
    fluxg60 = zzgplot[d60]
    flux20 = zzplot[d20]
    flux40 = zzplot[d40]
    flux60 = zzplot[d60]
    frac20 = zzplot[d20]/zzplot[d300]
    frac40 = zzplot[d40]/zzplot[d300]
    frac60 = zzplot[d60]/zzplot[d300]
    peak = fitpars[1]

    nobrightimg = pyfits.getdata(file.replace("_bright",""))
    zznb = nobrightimg.flat[rrs]
    zznbplot = zznb.cumsum()
    fluxnb20,fluxnb40,fluxnb60 = zznbplot[d20],zznbplot[d40],zznbplot[d60]
    rawimg = pyfits.getdata(file.replace("_map50.fits","_rawmap.fits").replace("_map10.fits","_rawmap.fits").replace("_map49.fits","_rawmap.fits").replace("_map01.fits","_rawmap.fits"))
    zzr = rawimg.flat[rrs]
    zzrplot = zzr.cumsum()
    fluxr20,fluxr40,fluxr60 = zzrplot[d20],zzrplot[d40],zzrplot[d60]

    if 'notmars' in sample:
        padimg = pylab.zeros([300,300])
        padimg[:img.shape[0],:img.shape[1]] = img
        padimg[padimg!=padimg] = 0
        padimg = imshift(padimg,150-fitpars[3:1:-1])
        padimg /= ampl
        if 'mars' in file:
            marsstack[:,:,jj] = padimg
        else:
            imstack[:,:,jj] = padimg

    planet = re.compile("sgrb2|mars|uranus|neptune").search(file).group()
    if planet=='sgrb2':
        stretch='arcsinh'
        vmid=None
    else:
        stretch='log'
        vmid=vmin-1

    fig1 = pylab.figure(1,figsize=[16,12])
    pylab.clf()
    #sp1 = pylab.subplot(211)
    peakscale = 0.1
    ff = aplpy.FITSFigure(fitsfile,convention='calabretta',subplot=[0.1,0.5,0.38,0.4],figure=fig1,vmax=peak*peakscale,vmin=vmin)
    ff.show_grayscale(invert=True,vmax=peak*peakscale,vmin=vmin,stretch=stretch,vmid=vmid)
    ff._ax1.set_title('Image (top) / Residual (bottom)')
    #ff.show_contour(fitsfile,levels=numpy.linspace(0,peak,10),convention='calabretta')

    resid = copy.copy(fitsfile)
    resid[0].data = img-gaussim
    ff2 = aplpy.FITSFigure(resid,convention='calabretta',subplot=[0.1,0.1,0.38,0.4],figure=fig1,vmax=peak*peakscale,vmin=vmin)
    ff2.show_grayscale(invert=True,vmax=peak*peakscale,vmin=vmin,stretch=stretch,vmid=vmid)
    #ff.save(file.replace('fits','png'))


    if text:
        meandc = header['MEANDC']
        stddc = header['STDDC']
        try: 
            rad_as = header['MASKRAD']
            masked = True
        except:
            try:
                rad_as = float(re.compile('maske?d?([0-9]*)').search(file).groups()[0])
                masked = True
            except:
                rad_as = 80.0
                masked = False
        try:
            tgtra = header['TGT_RA']
            tgtdec = header['TGT_DEC']
            l,b = coords.Position([tgtra,tgtdec]).galactic()
            if masked: ff.show_circles(numpy.array([l]),numpy.array([b]),rad_as/3600.0,edgecolor='blue')
            ff.show_circles(numpy.array([l]),numpy.array([b]),300.0/3600.0,edgecolor='purple')
        except KeyError:
            print "No TGT_RA found"
        
        wcshead = pywcs.WCS(header)
        lbfit = wcshead.wcs_pix2sky(fitpars[2:3],fitpars[3:4],0)
    
        radecfit = coords.Position(numpy.concatenate(lbfit),system='galactic').j2000()

        try:
            JD = float(header['JD'])
            if JD > 2.4e6: JD -= 2.4e6
            pflux = planetflux(planet,JD)
            pylab.annotate('Model Flux:     %8.6g Jy  Volts/Jy: %6.3g     Error (resid/Jy): %6.3g' % 
                    (pflux,ampl/pflux,resid_std/pflux),[0.6,0.76],xycoords='figure fraction')
        except KeyError:
            print "No JD found"

        file_noprefix = re.compile("(.*/)?(.*)").search(file).groups()[1]
        pylab.annotate('%s' % file_noprefix,[0.5,0.94],xycoords='figure fraction',size='large',weight='bold')
        pylab.annotate('Fitted source_ra=%6.3f,source_dec=%6.3f' % radecfit,[0.6,0.88],xycoords='figure fraction')
        pylab.annotate('Mean DC: %3.2f            Std DC: %3.2f' % (meandc,stddc),[0.6,0.85],xycoords='figure fraction')
        pylab.annotate('Gaussian peak:  %8.3g V   Signal/Noise: %6.3g' % (ampl,ampl/resid_std),[0.6,0.82],xycoords='figure fraction')
        #pylab.annotate('Gaussian background: %6.5g' % (height),[0.6,0.79],xycoords='figure fraction')
        pylab.annotate('Residual Noise: %8.3g V   Residual Total: %6.3g V' % (resid_std,resid_sum),[0.6,0.79],xycoords='figure fraction')
        pylab.annotate('FWHM: %4.3g" , %4.3g"' % (wxarr,wyarr),[0.6,0.73],xycoords='figure fraction')
        pylab.annotate('300" total: %8.3g' % (zzplot[d300]),[0.6,0.5],xycoords='figure fraction')
        ff.show_ellipses(lbfit[0:1],lbfit[1:2],wxarr/3600.,wyarr/3600.    ,angle=fitpars[6],edgecolor='green')
        ff.show_ellipses(lbfit[0:1],lbfit[1:2],wxarr/3600.*2,wyarr/3600.*2,angle=fitpars[6],edgecolor='red')
        ff._ax1.annotate("Fit FWHM ellipse", [1.02,0.50],xycoords='axes fraction',color='green',weight='bold',size='large')
        ff._ax1.annotate("2*FWHM noise area",[1.02,0.45],xycoords='axes fraction',color='red',weight='bold',size='large')
        ff._ax1.annotate("Mask Region",      [1.02,0.40],xycoords='axes fraction',color='blue',weight='bold',size='large')
        ff._ax1.annotate("Total Region",     [1.02,0.35],xycoords='axes fraction',color='purple',weight='bold',size='large')
        ff.recenter(lbfit[0][0],lbfit[1][0],float(wxarr)*5/3600.)
        ff2.recenter(lbfit[0][0],lbfit[1][0],float(wxarr)*5/3600.)
        bluelabel = "Mask"
        redlabel = None
    else:
        try:
            if bright:
                otherimg = pyfits.getdata(file.replace('_bright',''))
            elif pca:
                otherimg = pyfits.getdata(file.replace('_0pca','_3pca'))
            elif mask:
                otherimg = pyfits.getdata(file.replace('_mask',''))
            elif ds:
                otherimg = pyfits.getdata(file.replace("_ds1","_ds5"))
            else:
                if sample=='one':
                    otherimg = pyfits.getdata(file.replace('50','09'))
                elif sample=='two':
                    otherimg = pyfits.getdata(file.replace('49','01'))
                elif sample=='three':
                    otherimg = pyfits.getdata(file.replace('10','01'))
        except:
            print "%s doesn't exist" % (file.replace('50','09'))
            continue
        if otherimg.shape[0] > 220:
            otherimg = otherimg[otherimg.shape[0]/2-100:otherimg.shape[0]/2+100,:]
        if otherimg.shape[1] > 220:
            otherimg = otherimg[:,otherimg.shape[1]/2-100:otherimg.shape[1]/2+100]
        if otherimg.shape != img.shape:
            continue

        zzother = otherimg.flat[rrs]
        zzother[ddplot>120] = 0
        zzotherplot = zzother.cumsum()
        iterdiff = copy.copy(fitsfile)
        iterdiff[0].data = img-otherimg
        ff3 = aplpy.FITSFigure(iterdiff,convention='calabretta',subplot=[0.55,0.5,0.38,0.4],figure=fig1,vmax=peak*peakscale,vmin=vmin)
        ff3.show_grayscale(invert=True,vmax=peak*peakscale,vmin=vmin,stretch='log')
        if bright:
            filetitle = re.compile('[mu][a-z]*s_[0-9]{6}').search(file).group().replace("_"," ") 
            ff3._ax1.set_title('Bright - Not: %s' % filetitle)
            bluelabel="Bright"
            redlabel="Not Bright"
        elif mask:
            filetitle = re.compile('[mu][a-z]*s_[0-9]{6}').search(file).group().replace("_"," ") 
            ff3._ax1.set_title('Mask - Not: %s' % filetitle)
            bluelabel="Mask"
            redlabel="Not Mask"
        elif pca:
            filetitle = re.compile('[mu][a-z]*s_[0-9]{6}').search(file).group().replace("_"," ") 
            ff3._ax1.set_title('0pca - 3pca: %s' % filetitle)
            bluelabel="0pca"
            redlabel="3pca"
        elif ds:
            filetitle = re.compile('[mu][a-z]*s_[0-9]{6}').search(file).group().replace("_"," ") 
            ff3._ax1.set_title('ds1 - ds5: %s' % filetitle)
            bluelabel="ds1"
            redlabel="ds5"
        else:
            ff3._ax1.set_title('50 - 09')
            bluelabel="51 iter"
            redlabel="10 iter"

    ax2 = mpltk.HostAxes(fig1,[0.55,0.1,0.38,0.37],adjustable='datalim')
    fig1.add_axes(ax2)

    pylab.plot(ddplot,zzplot,'b--',label=bluelabel)
    pylab.plot(ddplot,zzgplot,'g-.',label='Elliptical Gaussian fit')
    if redlabel:
        pylab.plot(ddplot,zzotherplot,'r:',label=redlabel)
    pylab.plot([20],[zzplot[d20]],'co',label='40"  (%0.1f%%)' % (frac20*100))
    pylab.plot([40],[zzplot[d40]],'ro',label='80"  (%0.1f%%)' % (frac40*100))
    pylab.plot([60],[zzplot[d60]],'bo',label='120" (%0.1f%%)' % (frac60*100))
    pylab.plot([ddplot[dgauss]],[zzplot[dgauss]],'go',label='Gaussian (%0.1f%%)' % (fracgauss*100))
    pylab.vlines(wxarr/2.,0,zzgplot.sum(),colors='k',linestyles='dotted',label='FWHM Major (%0.2f")' % wxarr)
    pylab.vlines(wyarr/2.,0,zzgplot.sum(),colors='k',linestyles='dashdot',label='FWHM Minor (%0.2f")' % wyarr)
    #pylab.rcParams['font.size']=6.0
    pylab.legend(loc='best')
    #pylab.rcParams['font.size']=12.0
    pylab.xlabel('Radius from center (")')
    pylab.ylabel('Flux (Volts)')

    ax2.set_xlim(0,100)
    ax2.set_ylim(0,zzplot[ddplot<100].max()*1.1)

    pylab.draw()

    print >>outf,file,wxarr,wyarr,cx,cy,peak,frac20,frac40,frac60,flux20,flux40,flux60,fluxnb20,fluxnb40,fluxnb60,fluxr20,fluxr40,fluxr60,pflux,meandc,stddc
    pylab.savefig(file.replace('fits','png'))
    print "Completed loop for file %s in %0.1fs" % (file,time.time()-t0)

outf.close()

if sample in ("notmars","dec2011notmars"):
    PSF = numpy.median(imstack,axis=2)[100:200,100:200]
    gf,gg = gaussfitter.gaussfit(PSF,returnfitimage=True,limitedmin=[1,1,0,0,0,0,0,0])
    fitsfile[0].data = PSF
    fitsfile[0].header['CRVAL1'] = 0
    fitsfile[0].header['CRVAL2'] = 0
    fitsfile[0].header['CRPIX1'] = 0
    fitsfile[0].header['CRPIX2'] = 0
    fitsfile[0].header['CD1_1'] = -0.002
    fitsfile[0].header['CD2_2'] = 0.002
    fitsfile[0].header.update('OBJECT',"Uranus & Neptune")
    fitsfile[0].header['BMAJ'] = gf[4]*numpy.sqrt(8*numpy.log(2))*7.2/3600.0
    fitsfile[0].header['BMIN'] = gf[5]*numpy.sqrt(8*numpy.log(2))*7.2/3600.0

    for key in ['TGT_RA','TGT_DEC','JD','MEANDC','STDDC','BUNIT','CALIB_0','CALIB_1','CALIB_2','PTMDLAZ','PTMDLALT','HISTORY']:
        del fitsfile[0].header[key]

    PSF = numpy.median(imstack,axis=2)[100:200,100:200]
    fitsfile[0].data = PSF
    fitsfile.writeto("PSF_median.fits",clobber=True)
    PSF = numpy.mean(imstack,axis=2)[100:200,100:200]
    fitsfile[0].data = PSF
    gf,gg = gaussfitter.gaussfit(PSF,returnfitimage=True,limitedmin=[1,1,0,0,0,0,0,0])
    fitsfile.writeto("PSF_average.fits",clobber=True)
    #from scipy.stats import mode
    #PSF = mode(imstack[100:200,100:200,:],axis=2)
    #fitsfile[0].data = PSF
    #gf,gg = gaussfitter.gaussfit(PSF,returnfitimage=True,limitedmin=[1,1,0,0,0,0,0,0])
    #fitsfile.writeto("PSF_mode.fits",clobber=True)

    xx,yy = numpy.indices(PSF.shape)
    rr = numpy.sqrt((xx-PSF.shape[0]/2.)**2+(yy-PSF.shape[1]/2.)**2)
    zzr = numpy.array( [PSF[(rr>=a)*(rr<a+1)].mean() for a in numpy.arange(numpy.ceil(numpy.max(rr)))] )
    zzgr = numpy.array( [gg[(rr>=a)*(rr<a+1)].mean() for a in numpy.arange(numpy.ceil(numpy.max(rr)))] )
    zzrs = numpy.array( [PSF[(rr>=a)*(rr<a+1)].sum() for a in numpy.arange(numpy.ceil(numpy.max(rr)))] )
    zzgrs = numpy.array( [gg[(rr>=a)*(rr<a+1)].sum() for a in numpy.arange(numpy.ceil(numpy.max(rr)))] )
    zzrs/=zzrs.max()
    zzgrs/=zzgrs.max()
    dd = numpy.arange(numpy.ceil(numpy.max(rr)))
    rrs = numpy.argsort(rr.flat)
    PSF[rr*7.2>150.0] = 0
    zz = PSF.flat[rrs]
    zzcum = zz.cumsum()/PSF.sum()
    zzg = gg.flat[rrs]
    zzgcum = zzg.cumsum()/PSF.sum()
    rrc = rr.flat[rrs]

    oldpsf = pyfits.getdata('/Users/adam/work/bgps_pipeline/methods/paperfigs/PSF_median.fits')
    oldzzr = numpy.array( [oldpsf[(rr>=a)*(rr<a+1)].mean() for a in numpy.arange(numpy.ceil(numpy.max(rr)))] )

    diffim=PSF-gg
    sidelobe = diffim[(rr*7.2>25)*(rr*7.2<150)].sum()
    sidelobe_fraction = sidelobe/PSF.sum()

    from pylab import *
    figure(2);
    clf()
    #subplot(211)
    semilogy(dd*7.2,zzr,label="PSF Uranus + Neptune",color='k',linestyle='-')
    semilogy(dd*7.2,oldzzr,label="PSF Uranus + Neptune",color='r',linestyle='-')
    semilogy(dd*7.2,zzgr,label="Best Fit Gaussian",color='k',linestyle=':')
    xlabel("Radius (arcseconds)")
    ylabel("Mean Power (normalized)")
    semilogy(dd*7.2,zzr-zzgr,label="PSF - Gaussian",color='k',linestyle='-.')
    axis([0,120,1e-5,1])
    savefig('PSF_radial_profile.png')
    savefig('PSF_radial_profile.eps')
    legend(loc='best')
    savefig('PSF_radial_profile_legend.png')
    savefig('PSF_radial_profile_legend.eps')

#subplot(212)
#semilogy(dd*7.2,zzrs,label="PSF Uranus + Neptune")
#semilogy(dd*7.2,zzgrs,label="Best Fit Gaussian")
#xlabel("Radius (arcseconds)")
#ylabel("Azimuthally Summed Power")
#semilogy(dd*7.2,zzrs-zzgrs,label="PSF - Gaussian")
#axis([0,150,5e-4,1])



#subplot(212)
#semilogy(rrc*7.2,zzcum,label="PSF Uranus + Neptune")
#semilogy(rrc*7.2,zzgcum,label="Best Fit Gaussian")
#semilogy(rrc*7.2,zzcum-zzgcum,label="PSF - Gaussian")
#xlabel("Radius (arcseconds)")
#ylabel("Cumulative Power")
#axis([0,150,1e-3,1.1])

#semilogy(dd*14.4,(zzr-zzgr)*(dd*7.2)*2*pi*7.2,label="PSF - Gaussian")
#xlabel("Radius (arcseconds)")
#ylabel("Difference Mean Power (normalized)")
#axis([0,120,1e-4,1])

#zzrA = (zzr*(dd+1)) / (zzr*(dd+1)).max()
#zzgrA = (zzgr*(dd+1)) / (zzgr*(dd+1)).max()
#semilogy(dd*7.2,zzrA,label="PSF Uranus + Neptune")
#semilogy(dd*7.2,zzgrA,label="Best Fit Gaussian")
#xlabel("Radius (arcseconds)")
#ylabel("Mean Power * Area (normalized)")
#axis([0,120,1e-3,1])

#figure(3);
#clf()
#semilogy(dd*7.2,zzr-zzgr,label="PSF - Gaussian")
##semilogy(dd*14.4,(zzr-zzgr)*(dd*7.2)*2*pi*7.2,label="PSF - Gaussian")
#xlabel("Radius (arcseconds)")
#ylabel("Difference Mean Power (normalized)")
#axis([7,100,0,0.02])



"""
OK = wxarr > 0
pylab.figure(2)
pylab.clf()
nx,wx,hx = pylab.hist(wxarr[OK],label='Major',bins=numpy.linspace(25,70,20),histtype='step',ls='dashed')
ny,wy,hy = pylab.hist(wyarr[OK],label='Minor',bins=numpy.linspace(25,70,20),histtype='step',ls='dotted')
wxavg = (wxarr+wyarr)/2.0
nn,ww,hh = pylab.hist(wxavg[OK],label='Average',bins=numpy.linspace(25,70,20),histtype='step',ls='solid',color='k')
pylab.legend(loc='best')
pylab.gca().set_ylim(0,numpy.max(numpy.concatenate([nx,ny,nn]))+1)
pylab.xlabel('FWHM (")')
pylab.ylabel('Number in bin')
pylab.title('Fitted FWHM')
pylab.savefig('FWHM_histogram_%ssample%s.png' % (sample,raw))

pylab.figure(3)
pylab.clf()
n20,f20,h20 = pylab.hist(frac20,label='40" ',bins=numpy.linspace(0,1.2,12),histtype='step',ls='dashed')
n40,f40,h40 = pylab.hist(frac40,label='80" ',bins=numpy.linspace(0,1.2,12),histtype='step',ls='dotted')
n60,f60,h60 = pylab.hist(frac60,label='120"',bins=numpy.linspace(0,1.2,12),histtype='step',ls='solid',color='k')
pylab.legend(loc='best')
pylab.title('Fraction of flux recovered')
pylab.xlabel('Fraction of total flux')
pylab.ylabel('Number in bin')
pylab.gca().set_ylim(0,numpy.max(numpy.concatenate([n20,n40,n60]))+1)
pylab.savefig('fraction_recovered_histogram_%ssample%s.png' % (sample,raw))

pylab.figure(4)
pylab.clf()
pylab.ylabel('Bright / Not Bright')
pylab.xlabel('S(120)')
pylab.plot(flux60,flux40/fluxnb40,'bo',label='80"')
pylab.plot(flux60,flux20/fluxnb20,'ro',label='40"')
pylab.legend(loc='best')
#plot(flux60,fluxg/fluxnb20,'bo',label='Gaussian')
"""

#import pdb; pdb.set_trace()
#pylab.show()
