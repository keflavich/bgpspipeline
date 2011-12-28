import mpl_toolkits.axes_grid.parasite_axes as mpltk
import copy
import aplpy
import glob
import pyfits
from agpy import gaussfitter
import numpy
import pylab

#filelist = glob.glob("*13pca_map49.fits")

filelist = [
'3c279_050703_ob1-2_13pca_map49.fits',
'3c279_050703_ob1-2_ds5_13pca_map49.fits',
#'g34.3_070630_o34-5_13pca_map49.fits',
'mars_050627_o31-2_13pca_map49.fits',
'mars_050911_o22-3_13pca_map49.fits',
'mars_060605_ob1-2_13pca_map49.fits',
#'mars_070913_o22-3_13pca_map49.fits',
#'neptune_070902_ob5-6_13pca_map49.fits',
'uranus_050619_o23-4_13pca_map49.fits',
'uranus_050628_o33-4_13pca_map49.fits',
#'uranus_050904_o31-2_13pca_map49.fits',
'uranus_060621_o29-30_13pca_map49.fits',
'uranus_070702_o41-2_13pca_map49.fits',
]        

wxarr,wyarr = numpy.zeros(len(filelist)),numpy.zeros(len(filelist))
frac20,frac40,frac60 = numpy.zeros(len(filelist)),numpy.zeros(len(filelist)),numpy.zeros(len(filelist))


for jj,file in enumerate(filelist):
    fitsfile = pyfits.open(file)
    img = fitsfile[0].data
    header = fitsfile[0].header
    img[img!=img]=0

    xx,yy = numpy.indices(img.shape)

    fitpars = gaussfitter.gaussfit(img,params=[img.max(),img.shape[0]/2,img.shape[1]/2,2,2,0],minpars=[0,0,0,0,1,1,0],vheight=0)
    gaussim = gaussfitter.twodgaussian(fitpars)(xx,yy)

    asperpix = -header['CD1_1']*3600.0

    cy,cx = fitpars[2:4]
    wxy = fitpars[4:6]*asperpix*numpy.sqrt(8*numpy.log(2))
    wxarr[jj],wyarr[jj] = max(wxy),min(wxy)

    rr = (numpy.sqrt((xx-cx)**2 + (yy-cy)**2))
    rrs = numpy.argsort(rr.flat)
    zz = img.flat[rrs]
    zzg = gaussim.flat[rrs]
    #dd = numpy.arange(rr.min(),rr.max())
    #zz = numpy.array([img[rr==ii].mean() for ii in dd])
    #zzg = numpy.array([gaussim[rr==ii].mean() for ii in dd])

    peak = fitpars[1]
    ddplot = numpy.sort(rr.ravel())*asperpix #dd*asperpix
    zz[ddplot>120] = 0
    zzplot = zz.cumsum()
    zzgplot = zzg.cumsum()
    d20,d40,d60 = numpy.argmin(numpy.abs(ddplot-20)),numpy.argmin(numpy.abs(ddplot-40)),numpy.argmin(numpy.abs(ddplot-60))
    frac20[jj] = zzplot[d20]/zz.sum()
    frac40[jj] = zzplot[d40]/zz.sum()
    frac60[jj] = zzplot[d60]/zz.sum()

    print file,wxarr[jj],wyarr[jj],cx,cy,peak,frac20[jj],frac40[jj],frac60[jj]
    #print fitpars

    fig1 = pylab.figure(1)
    pylab.clf()
    #sp1 = pylab.subplot(211)
    peakscale = 0.1
    ff = aplpy.FITSFigure(fitsfile,convention='calabretta',subplot=[0.1,0.5,0.38,0.4],figure=fig1,vmax=peak*peakscale,vmin=-1)
    ff.show_grayscale(invert=True,vmax=peak*peakscale,vmin=-1)
    ff._ax1.set_title('Image (top) / Residual (bottom)')
    ff.show_contour(fitsfile,levels=numpy.linspace(5,peak,10),convention='calabretta')

    resid = copy.copy(fitsfile)
    resid[0].data = img-gaussim
    ff2 = aplpy.FITSFigure(resid,convention='calabretta',subplot=[0.1,0.1,0.38,0.4],figure=fig1,vmax=peak*peakscale,vmin=-1)
    ff2.show_grayscale(invert=True,vmax=peak*peakscale,vmin=-1)
    #ff.save(file.replace('fits','png'))


    ax2 = mpltk.HostAxes(fig1,[0.52,0.1,0.4,0.8],adjustable='datalim')
    fig1.add_axes(ax2)

    pylab.plot(ddplot,zzplot,'--',label='Data')
    pylab.plot(ddplot,zzgplot,':',label='Elliptical Gaussian fit')

    pylab.plot([20],[zzplot[d20]],'co',label='40"  (%0.1f\\%%)' % (frac20[jj]*100))
    pylab.plot([40],[zzplot[d40]],'ro',label='80"  (%0.1f\\%%)' % (frac40[jj]*100))
    pylab.plot([60],[zzplot[d60]],'bo',label='120" (%0.1f\\%%)' % (frac60[jj]*100))
    pylab.vlines(wxarr[jj],0,zzgplot.sum(),colors='k',linestyles='dotted',label='FWHM Major (%0.2f")' % wxarr[jj])
    pylab.vlines(wyarr[jj],0,zzgplot.sum(),colors='k',linestyles='dashdot',label='FWHM Minor (%0.2f")' % wyarr[jj])
    pylab.legend(loc='best')
    pylab.xlabel('Radius from center (")')
    pylab.ylabel('Flux (Volts)')

    ax2.set_xlim(0,100)
    ax2.set_ylim(0,zzplot[ddplot<100].max())

    pylab.draw()

    pylab.savefig(file.replace('fits','png'))

#OK = (wxarr > 15) * (wxarr < 50) * (wyarr>15) * (wyarr<50)
OK = ( wxarr > 0 )

pylab.figure(2)
pylab.clf()
nx,wx,hx = pylab.hist(wxarr[OK],label='Major',bins=numpy.linspace(25,40,10),histtype='step',ls='dashed')
ny,wy,hy = pylab.hist(wyarr[OK],label='Minor',bins=numpy.linspace(25,40,10),histtype='step',ls='dotted')
wxavg = (wxarr+wyarr)/2.0
nn,ww,hh = pylab.hist(wxavg[OK],label='Average',bins=numpy.linspace(25,40,10),histtype='step',ls='solid',color='k')
pylab.legend(loc='best')
pylab.xlabel('FWHM (")')
pylab.ylabel('Number in bin')
pylab.title('Fitted FWHM')
print nx,ny,nn
pylab.gca().set_ylim(0,numpy.max(numpy.concatenate([nx,ny,nn]))+1)
pylab.savefig('FWHM_histogram.png')
pylab.show()

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
pylab.savefig('fraction_recovered_histogram.png')
pylab.show()

