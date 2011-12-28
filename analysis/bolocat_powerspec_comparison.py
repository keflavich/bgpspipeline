import plfit
import atpy
import idlsave
from pylab import *

def compare_distributions():
    pass


if __name__ == "__main__":

    path = '/Volumes/disk3/adam_work/artificial_sims/exp12_simple/'
    bolocat = idlsave.read(path+'exp12_ds2_astrosky_arrang45_atmotest_amp5.0E+02_sky00_seed00_peak050.00_nosmooth_bolocat.sav')
    bolocat_in = idlsave.read(path+'exp12_ds2_astrosky_arrang45_atmotest_amp5.0E+02_sky00_seed00_peak050.00_nosmooth_bolocat_input.sav')
    bolocat_filt = idlsave.read(path+'exp12_ds2_astrosky_arrang45_atmotest_amp5.0E+02_sky00_seed00_peak050.00_nosmooth_filtered_bolocat.sav')
    bolocat_bgps = atpy.Table('/Users/adam/work/catalogs/bolocam_gps_v1_0_1.tbl')
    
    print "Bolocat"
    PL40 = plfit.plfit(bolocat.bolocat_struct.flux_40)
    PLS = plfit.plfit(bolocat.bolocat_struct.flux)
    print "Input"
    PL40in = plfit.plfit(bolocat_in.bolocat.flux_40)
    PLSin = plfit.plfit(bolocat_in.bolocat.flux)
    print "Filtered"
    PL40filt = plfit.plfit(bolocat_filt.bolocat.flux_40-bolocat_filt.bolocat.flux_40.min())
    PLSfilt = plfit.plfit(bolocat_filt.bolocat.flux)
    print "L30"
    L30 = (bolocat_bgps.glon_peak<31)*(bolocat_bgps.glon_peak>30)
    PLS_L30 = plfit.plfit(bolocat_bgps.flux[L30])
    PL40_L30 = plfit.plfit(bolocat_bgps.flux_40[L30])

    figure(1)
    clf()
    PL40.plotpdf(histcolor='b',plcolor='b',nbins=30)
    PL40in.plotpdf(histcolor='r',plcolor='r',nbins=30)
    PL40filt.plotpdf(histcolor='g',plcolor='g',nbins=30)
    PL40_L30.plotpdf(histcolor='k',plcolor='k',nbins=30)

    figure(2)
    clf()
    PLS.plotpdf(histcolor='b',plcolor='b',nbins=30)
    PLSin.plotpdf(histcolor='r',plcolor='r',nbins=30)
    PLSfilt.plotpdf(histcolor='g',plcolor='g',nbins=30)
    PLS_L30.plotpdf(histcolor='k',plcolor='k',nbins=30)
