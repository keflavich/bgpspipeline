#!/usr/bin/env python
import sys
import os
pipeline_root = os.getenv('PIPELINE_ROOT')
if pipeline_root is None: pipeline_root = '/Users/adam/work/bgps_pipeline/'

sys.path.append(pipeline_root+'/analysis/')
sys.path.append(pipeline_root+'/plotting/')

import compare_images

import glob

def compare_mapnum(mapnum,point=True):

    for fn in glob.glob("*ds2*_map%02i.fits" % mapnum):
        if os.path.exists(fn.replace('ds2','ds5')):
            compare_images.compare_files(fn,fn.replace('ds2','ds5'),
                    imname1='ds2',imname2='ds5',
                    savename=fn.replace(".fits","_ds2ds5_compare.png"),
                    savename_psd=fn.replace(".fits","_ds2ds5_psds.png"),
                    savename_pointcompare=fn.replace(".fits","_ds2ds5_point.png"),
                    wcsaperture=(0,0,80,160)
                    )

if __name__ == "__main__":
    import optparse

    parser=optparse.OptionParser()
    parser.add_option("--mapnum",help="Which mapnumber to compare?",default=20)
    parser.add_option("--nopoint",help="Pointcompare?",default=False,action='store_true')
    options,args = parser.parse_args()

    compare_mapnum(options.mapnum, point=not options.nopoint)
