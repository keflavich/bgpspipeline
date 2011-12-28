from agpy.region_positions import *
import pyregion
import pyfits
import numpy as np
import pywcs

bgps = pyfits.open('/Volumes/disk2/data/bgps/releases/IPAC/MOSAIC.fits')
wcs = pywcs.WCS(bgps[0].header)
bgpsdata = bgps[0].data
glonmin = wcs.wcs_pix2sky(0,0,0)[0]
glonmax = wcs.wcs_pix2sky(bgpsdata.shape[1],0,0)[0]
PPBEAM = 23.8
# 50" aperture_correction = 1.21 # derived using the Uranus PSF scaled to the published value
flux_correction = 1.5
bgpsdata *= flux_correction

def get_bgps_fluxes(regfile, outfile, inneraprad=35, outeraprad=60):

    reglist = pyregion.open(regfile)

    outf = open(outfile,'w')

    print "".join("%16s" % s for s in ['Source_Name','SumJy','ApSumJy','MeanApSumJy','SumJyBm','ApSumJyBm','BgMed','BgMean','BgStd','FracErrBg'])
    print >>outf,"".join("%16s" % s for s in ['Source_Name','SumJy','ApSumJy','MeanApSumJy','SumJyBm','ApSumJyBm','BgMed','BgMean','BgStd','FracErrBg'])

    for reg in reglist:
        glon,glat = position_region(reg).galactic()
        xc,yc = wcs.wcs_sky2pix(glon,glat,0)
        if xc < 0 or xc > bgpsdata.shape[1] or yc < 0 or yc > bgpsdata.shape[0]:
            continue
        elif glat > glonmin and glon < glonmax:
            # these are the limits of the survey
            continue
        else:
            print "Extracting source ",reg
        regL = pyregion.ShapeList()
        reg.name = 'circle'
        while len(reg.coord_list) < 3:
            reg.coord_list.append(0)
        while len(reg.coord_list) > 3:
            reg.coord_list.pop(3)
        reg.coord_list[2] = inneraprad/3600.0  # set inner aperture (foreground) to R=25"
        regL.append(reg)
        innerap = regL.get_mask(hdu=bgps[0])
        if innerap.sum() == 0:
            # BGPS doesn't necessarily cover everything
            print "Skipped a source that was in the boundaries: ",reg
            continue
        regL[0].coord_list[2] = outeraprad/3600.0  # set outer aperture (background) to R=100"
        regL.append(reg)
        outerap = regL.get_mask(hdu=bgps[0])
        backreg = outerap-innerap

        total = bgpsdata[innerap].sum()
        background = np.median(bgpsdata[backreg])
        backmean = bgpsdata[backreg].mean()
        backstd = bgpsdata[backreg].std()

        sourcename = pos_to_name(reg)

        if backstd > total or total < 0:
            print "%s set to zero" % reg.attr[1]['text']
            total = 0
            total_backsub  = 0
            total_mbacksub = 0
        else:
            total_backsub  = total - innerap.sum() * background
            total_mbacksub = total - innerap.sum() * backmean

        print "%16s" % sourcename,"".join("%16.5g" % f 
                for f in [total/PPBEAM,total_backsub/PPBEAM,total_mbacksub/PPBEAM,total,total_backsub,background,backmean,backstd,backstd/total_backsub])
        print >>outf,"%16s" % sourcename,"".join("%16.5g" % f 
                for f in [total/PPBEAM,total_backsub/PPBEAM,total_mbacksub/PPBEAM,total,total_backsub,background,backmean,backstd,backstd/total_backsub])

    outf.close()
