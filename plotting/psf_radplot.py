from agpy import azimuthalAverage,gaussfitter
import pyfits
import numpy
import pylab

PSF = pyfits.getdata('PSF_median.fits')
PSF /= PSF.max()

azav = azimuthalAverage(PSF,center=[50,50])
rmsazav = azimuthalAverage(PSF,center=[50,50],stddev=True)
xax = numpy.arange(len(azav)) * 7.2

gf,gg = gaussfitter.gaussfit(PSF,returnfitimage=True,limitedmin=[1,1,0,0,0,0,0,0],fixed=[1,0,0,0,0,0,0])
gazav = azimuthalAverage(gg,center=[50,50])

dazav = azav-gazav

pylab.clf()
pylab.semilogy(xax,gazav,'k:',label="Best Fit Gaussian")
pylab.errorbar(xax,azav,yerr=rmsazav,fmt='-',ecolor='k',color='k',label="PSF",capsize=5,solid_capstyle='round')
pylab.semilogy(xax,numpy.abs(dazav),'k-.',label="|PSF - Best Fit|")
pylab.xlabel("Radius (arcseconds)")
pylab.ylabel("Mean Power (normalized)")
pylab.axis([0,120,1e-5,1])
pylab.savefig('PSF_radial_profile.png')
pylab.savefig('PSF_radial_profile.eps',bbox_inches='tight')
pylab.legend(loc='best')
pylab.savefig('PSF_radial_profile_legend.png')
pylab.savefig('PSF_radial_profile_legend.eps',bbox_inches='tight')

