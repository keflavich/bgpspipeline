# Goal: Make power spectra ratio from simulation maps
# Store as a "spectrum" .fits file
import agpy
from agpy import grep
import pyfits
import numpy as np

def make_powerspec_ratio(imname1, imname2, outname=None, clobber=False,
        pixsize=7.2, hanning=False, debug=False):
    im1 = pyfits.getdata(imname1)
    im2 = pyfits.getdata(imname2)
    f1,z1 = agpy.psds.power_spectrum(im1,hanning=hanning)
    f2,z2 = agpy.psds.power_spectrum(im2,hanning=hanning)
    
    if debug:
        print "Make_powerspec imsizes: ",im1.shape,im2.shape
        import pylab
        pylab.figure()
        pylab.loglog(f1,z1,label='z1')
        pylab.loglog(f2,z2,label='z2')
        pylab.figure()
        pylab.loglog(f1,z2/z1,label='ratio')
        pylab.axis([0,1,0,2])

    hdr = pyfits.getheader(imname1)

    for key in grep.grep("CR",hdr.keys()):
        del hdr[key]
    for key in grep.grep("CT",hdr.keys()):
        del hdr[key]
    for key in grep.grep("CD",hdr.keys()):
        del hdr[key]

    dx = np.median(f1[1:]-f1[:-1])/pixsize
    x0 = f1[0]

    hdr.update('CRPIX1',1)
    hdr.update('CRVAL1',x0)
    hdr.update('CDELT1',dx)
    hdr.update('CTYPE1',"wavenumber")
    hdr.update('CUNIT1',"Inverse Arcseconds")
    hdr.update('BUNIT',"Recovery Fraction")

    ratio = z2/z1

    hdu = pyfits.PrimaryHDU(data=ratio,header=hdr)
    if outname is None: outname = imname1.replace("_inputmap.fits","_psdratio.fits")
    hdu.writeto(outname,output_verify='fix',clobber=clobber)


if __name__ == "__main__":
    import optparse

    parser=optparse.OptionParser()
    parser.add_option("--clobber",help="Overwrite image?",default=False,action='store_true')
    parser.add_option("--outname","-o",help="Output Filename",default=None)
    parser.add_option("--hanning",help="Hanning smooth the input?",default=False,action='store_true')
    options,args = parser.parse_args()

    make_powerspec_ratio(*args,clobber=options.clobber,outname=options.outname,hanning=options.hanning)
