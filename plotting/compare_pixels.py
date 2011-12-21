# This file is rendered obsolete by compare_images.py 
#from scipy.stats import mode,mean
from numpy import polyval,polyfit,Inf
import numpy
import pylab

def nantomask(arr):
    mask = (arr != arr)
    return numpy.ma.masked_where(mask,arr)


def linfit(x,y,err=None):
    if err is None:
        err = numpy.ones(x.shape)
    delta = numpy.sum(1/err**2)*numpy.sum(x**2/err**2) - numpy.sum(x/err**2)**2
    a = 1/delta * ( numpy.sum(x**2/err**2) * numpy.sum(y/err**2) - numpy.sum(x/err**2)*numpy.sum(x*y/err**2) )
    b = 1/delta * ( numpy.sum(1/err**2) * numpy.sum(x*y/err**2) - numpy.sum(x/err**2)*numpy.sum(y/err**2) )

    return a,b

def compare_pixels(im1,im2,thresh=None,plotdata=True,**kwargs):

    if thresh:
        xxt = im1[(im1>thresh)*(im2>thresh)]
        yyt = im2[(im1>thresh)*(im2>thresh)]
    else:
        xxt = im1[(im1==im1)*(im2==im2)].ravel()
        yyt = im2[(im1==im1)*(im2==im2)].ravel()

    if plotdata:
        pylab.plot(xxt,yyt,'k,')
    rr = yyt/xxt
    rr = rr[(rr==rr)*(rr!=Inf)*(rr!=-Inf)]
    OK = (xxt != 0)
    fit = linfit(xxt[OK],yyt[OK])
    #print fit,polyfit(xxt[OK],yyt[OK],1)
    fit = polyfit(xxt[OK],yyt[OK],1)
    yyf = polyval(fit,xxt)
    pylab.plot(xxt,yyf,**kwargs)
    return fit

def plotcomp(ii,sim,imname1=None,imname2=None):
    pylab.figure(ii)
    pylab.clf()
    if imname1 is None: imname1 = 'v1.0.2_l111_13pca_deconv_%s_initial.fits' % sim
    if imname2 is None: imname2 = 'v1.0.2_l111_13pca_deconv_%s_map50.fits' % sim
    im1 = pyfits.getdata(imname1)
    im2 = pyfits.getdata(imname2)
    if im1.shape != im2.shape:
        im1 = pyfits.getdata('v1.0.2_l111_13pca_deconv_%s_jitter.fits' % sim)
    b1,a1 = compare_pixels(im1,im2,thresh=0.1,color='g')
    b2,a2 = compare_pixels(im1,im2,plotdata=False,thresh=0.5,color='r')
    if sim.find("faint") == -1:
        b3,a3 = compare_pixels(im1,im2,plotdata=False,thresh=1.0,color='b')
    else:
        b3 = 0
    pylab.title(sim)
    pylab.xlabel("initial (Jy)")
    pylab.ylabel("recovered 50 iter (Jy)")
    ax = pylab.gca()
    xmax = ax.axis()[1]
    pylab.plot([0,xmax],[0,xmax],'m')
    pylab.text(0.05,0.90,">1.0Jy y=%0.5fx" % b3,transform = ax.transAxes,color='b')
    pylab.text(0.05,0.85,">0.5Jy y=%0.5fx" % b2,transform = ax.transAxes,color='r')
    pylab.text(0.05,0.80,">0.1Jy y=%0.5fx" % b1,transform = ax.transAxes,color='g')
    pylab.text(0.05,0.75,"1-1 line",transform = ax.transAxes,color='m')
    print "Sim %s: >0.1: %f, >0.5: %f, >1.0: %f" % (sim,b1,b2,b3)

if __name__=="__main__":
    pylab.clf()
    import pyfits
    simlist = ["sim","big_sim","bigjitter_sim","jitter_sim","faint_sim","psf_smooth_bigjitter_sim","psf_smooth_jitter_sim","psf_smooth_sim"]
    for ii,sim in enumerate(simlist):
        plotcomp(ii,sim)
    #import montage
    #montage.wrappers.reproject('v1.0.2_l111_13pca_map50.fits','v1.0.2_l111_13pca_map50_reprojv2.0.fits',header='v2.0.hdr')
    plotcomp(ii+1,"v1v2 compare",'v1.0.2_l111_13pca_map50_reprojv2.0.fits','v2.0_l111_13pca_map50.fits')
    pylab.show()

    # cygnuscompare
