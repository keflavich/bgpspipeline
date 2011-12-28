from agpy import gaussfitter,readcol,timer
import re
import numpy
import pylab
import matplotlib

def robust_fit(img,cdelt=0.002,autocrop=True,verbose=True, printfit=True,
        maxsize=50, unshift=False, **kwargs):
    """
    This is an example of code I should have commented more carefully

    unshift - I THINK this is meant to undo the fake shift created by cropping...
    """

    img = img.copy()
    inshape = img.shape

    if verbose:
        gaussfit = timer.print_timing(gaussfitter.gaussfit)
    else:
        numpy.seterr(all='ignore')
        gaussfit = gaussfitter.gaussfit

    shift1,shift2 = 0,0
    if autocrop:
        if img.shape[0] > 2*maxsize:
            shift1 = img.shape[0]/2-maxsize
            img = img[img.shape[0]/2-maxsize:img.shape[0]/2+maxsize,:]
        if img.shape[1] > 2*maxsize:
            shift2 = img.shape[1]/2-maxsize
            img = img[:,img.shape[1]/2-maxsize:img.shape[1]/2+maxsize]
    
    # NAN handling
    err = 1e10 * (img!=img) + 1.0
    img[img!=img] = 0


    yy,xx = numpy.indices(img.shape)
    fitloop = 1
    while fitloop:
        if fitloop == 2:
            if verbose: print "Second gaussfit attempt: guess center is middle of image, 2 pix width, peak is img.max()"
            fitpars = gaussfit(img,err=err,params=[0,img.max(),img.shape[0]/2,img.shape[1]/2,2,2,0],minpars=[0,img.max()/10.0,0,0,1,1,0],maxpars=[0,0,0,0,6,6,360],
                    limitedmin=[False,True,False,False,True,True,True],limitedmax=[False,False,False,False,True,True,True],
                    fixed=[1,0,0,0,0,0,0],**kwargs)
        elif fitloop == 1:
            if verbose: print "First gaussfit attempt: 2 pix width, peak=img.max(), limited, use moments for centroid guess."
            fitpars = gaussfit(img,err=err,params=[0,img.max(),0,0,2,2,0],minpars=[0,img.max()/10.0,0,0,1,1,0],maxpars=[0,0,0,0,6,6,360],
                    limitedmin=[False,True,False,False,True,True,True],limitedmax=[False,False,False,False,True,True,True],
                    fixed=[1,0,0,0,0,0,0],usemoment=[0,0,1,1,0,0,0],**kwargs)
        elif fitloop == 3:
            if verbose: print "Third gaussfit attempt: guess center is moments, 1 pix width, peak is img.max()/10"
            fitpars = gaussfit(img,err=err,minpars=[0,img.max()/10.0,0,0,1,1,0],maxpars=[0,0,0,0,6,6,360],
                    limitedmin=[False,True,False,False,True,True,True],limitedmax=[False,False,False,False,True,True,True],**kwargs)
        elif fitloop == 4:
            if verbose: print "Fourth gaussfit attempt: all defaults"
            fitpars = gaussfit(img,err=err,**kwargs)
        else:
            fitpars = numpy.array(gaussfitter.moments(img,0,1,1))
            print "Gaussfitter failed; Using the parameters you specified: ",fitpars
            fitloop = -1
        if (img != img).any():
            raise ValueError("WTF?")
        if fitpars[-1] != fitpars[-1]:
            raise ValueError("Chi^2 is NAN; that's impossible.")

        gaussim = gaussfitter.twodgaussian(fitpars)(yy,xx)

        asperpix = -cdelt*3600.0

        height,ampl = fitpars[:2]
        cx,cy = fitpars[2:4]
        wxy = fitpars[4:6]*asperpix*numpy.sqrt(8*numpy.log(2))
        wxarr,wyarr = max(wxy),min(wxy)

        rr = (numpy.sqrt((xx-cx)**2 + (yy-cy)**2))
        rrs = numpy.argsort(rr.flat)
        zz = img.flat[rrs]
        zzg = gaussim.flat[rrs]
        #dd = numpy.arange(rr.min(),rr.max())
        #zz = numpy.array([img[rr==ii].mean() for ii in dd])
        #zzg = numpy.array([gaussim[rr==ii].mean() for ii in dd])

        mean_fwhm = wxy.sum()/2.0
        resid_data = (img-gaussim)[rr < mean_fwhm]
        resid_sum = resid_data.sum()
        resid_std = resid_data.std()

        # distance from center
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

        if mean_fwhm > 70:
            fitloop += 1
        else:
            if frac20 < 0.1 and fitloop == 4:
                fitloop = -1
                fitpars = numpy.array(gaussfitter.moments(img,0,1,1))
                #import pdb; pdb.set_trace()
            elif frac40 < 0.5 or frac60 < 0.6:
                fitloop += 1
            elif frac20 > 0.1:
                fitloop = 0
            else:
                fitloop += 1

    if unshift:
        if img.shape[0] > 2*maxsize and shift1 == 0: raise ValueError("Shift wasn't set to be the shifted amount.")
        if verbose: print "Undoing shifts %0.1f,%0.1f" % (shift1,shift2)
        fitpars[2] += shift1
        fitpars[3] += shift2
        nyy,nxx = numpy.indices(inshape)
        gaussim = gaussfitter.twodgaussian(fitpars)(nyy,nxx)

    if verbose: print "robust_fit finished on fitloop #%i with frac20=%g" % (fitloop,frac20)
    if printfit:
        print "Background: %10g  Amplitude: %10g" % (tuple(fitpars[:2].tolist())),
        print "X center:   %10g   Y center: %10g" % (tuple(fitpars[2:4].tolist()))
        print "X width:    %10g    Y width: %10g  X FWHM \": %10g  Y FWHM \": %10g" % \
                (tuple(fitpars[4:6].tolist()+(fitpars[4:6]*cdelt*3600.0*numpy.sqrt(8*numpy.log(2))).tolist()))
        print "Position Angle:   %g" % (fitpars[6])

    return fitpars, gaussim, img, zz, zzg

def make_figure(img,gaussim,zz,zzg,fitpars,savename,cdelt=0.002,filename=""):
    """
    Create a figure based on the robust fit
    """

    pylab.figure(1)
    pylab.clf()
    pylab.subplot(221)
    aximg = pylab.imshow(img)
    pylab.title("Input image")
    fwhm = numpy.sqrt(8*numpy.log(2))
    aximg.axes.add_artist(matplotlib.patches.Ellipse(fitpars[2:4],fwhm*fitpars[5],fwhm*fitpars[4],angle=fitpars[6],facecolor='none'))
    pylab.colorbar()
    pylab.draw()
    
    pylab.subplot(223)
    pylab.imshow(img-gaussim)
    pylab.colorbar()
    pylab.title("Residual")

    subplot4 = pylab.subplot(224)
    xx,yy = numpy.indices(img.shape)
    rr = (numpy.sqrt((xx-fitpars[2])**2 + (yy-fitpars[3])**2))
    rrs = numpy.argsort(rr.flat)
    ddplot = numpy.sort(rr.ravel())*(cdelt*3600.0)

    zzplot = zz.cumsum()
    zzgplot = zzg.cumsum()
    pylab.plot(ddplot,zzplot,'b',label='Input Image')
    pylab.plot(ddplot,zzgplot,'g',label='Elliptical Gaussian fit')
    pylab.vlines(fitpars[4]*fwhm*(cd*3600)/2.,0,zzgplot.sum(),colors='k',linestyles='dotted',label='FWHM Major (%0.2f")' % (fitpars[4]*cd*3600*fwhm))
    pylab.vlines(fitpars[5]*fwhm*(cd*3600)/2.,0,zzgplot.sum(),colors='k',linestyles='dashdot',label='FWHM Minor (%0.2f")' % (fitpars[5]*cd*3600*fwhm))
    #pylab.rcParams['font.size']=6.0
    pylab.legend(loc='best')
    pylab.hlines(0,100,zzplot[-1],colors='k',linestyles='dashed')
    #pylab.rcParams['font.size']=12.0
    pylab.xlabel('Radius from center (")')
    pylab.ylabel('Flux')

    subplot4.set_xlim(0,100)
    subplot4.set_ylim(0,zzplot[ddplot<100].max()*1.1)

    file_noprefix = re.compile("(.*/)?(.*)").search(filename).groups()[1]
    pylab.annotate('%s' % file_noprefix,[0.5,0.94],xycoords='figure fraction',size='large',weight='bold')
    pylab.annotate('Fitted xcen,ycen: %12.5g, %12.5g' % (fitpars[2],fitpars[3]),[0.6,0.88],xycoords='figure fraction')
    pylab.annotate('Gaussian peak:  %12.5g ' % (fitpars[1]),[0.6,0.82],xycoords='figure fraction')
    pylab.annotate('FWHM: %4.3g" , %4.3g"' % (fitpars[4]*cd*3600.0*fwhm,fitpars[5]*cd*3600.0*fwhm),[0.6,0.73],xycoords='figure fraction')
    pylab.annotate('300" total: %8.3g' % (zzplot[numpy.argmin(numpy.abs(ddplot-300))]),[0.6,0.5],xycoords='figure fraction')
    pylab.annotate("Fit FWHM ellipse", [0.6,0.55],xycoords='figure fraction',color='green',weight='bold',size='large')

    pylab.draw()
    pylab.savefig(savename)



#def plot_diff_fit(img,gaussim):
#    fig1 = pylab.figure(1,figsize=[16,12])
#    pylab.clf()
#    #sp1 = pylab.subplot(211)
#    peakscale = 0.1
#    ff = aplpy.FITSFigure(fitsfile,convention='calabretta',subplot=[0.1,0.5,0.38,0.4],figure=fig1,vmax=peak*peakscale,vmin=vmin)
#    ff.show_grayscale(invert=True,vmax=peak*peakscale,vmin=vmin,stretch=stretch)
#    ff._ax1.set_title('Image (top) / Residual (bottom)')
#    #ff.show_contour(fitsfile,levels=numpy.linspace(0,peak,10),convention='calabretta')
#
#    resid = copy.copy(fitsfile)
#    resid[0].data = img-gaussim
#    ff2 = aplpy.FITSFigure(resid,convention='calabretta',subplot=[0.1,0.1,0.38,0.4],figure=fig1,vmax=peak*peakscale,vmin=vmin)
#    ff2.show_grayscale(invert=True,vmax=peak*peakscale,vmin=vmin,stretch=stretch)
#    #ff.save(file.replace('fits','png'))
#
if __name__ == "__main__":
    import pyfits,sys

    import optparse
    parser=optparse.OptionParser()
    parser.add_option("--outfile","--file","-f",default=None)
    parser.add_option("--silent","-s",default=False)
    parser.add_option("--figure","--savename",default=None)
    options,args = parser.parse_args()

    if options.outfile:
        outf = open(options.outfile,'w')
        print >>outf,"%80s" % "Filename"+"".join("%10s" % s for s in ['height','amplitude','xcen','ycen','xwidth','ywidth','posang'])

    for filename in args:

        data = pyfits.getdata(filename)
        header = pyfits.getheader(filename)
        cd = numpy.abs(header.get('CDELT1')) if header.get('CDELT1') else numpy.abs(header.get('CD1_1'))

        fitpars,gaussim,img,zz,zzg = robust_fit(data,cdelt=cd,verbose=False,printfit=False)

        if not options.silent:
            print "Fit parameters for file %s " % (filename)
            print "Background: %10g  Amplitude: %10g" % (tuple(fitpars[:2].tolist())),
            print "X center:   %10g   Y center: %10g" % (tuple(fitpars[2:4].tolist()))
            print "X width:    %10g    Y width: %10g  X FWHM \": %10g  Y FWHM \": %10g" % \
                    (tuple(fitpars[4:6].tolist()+(fitpars[4:6]*cd*3600.0*numpy.sqrt(8*numpy.log(2))).tolist()))
            print "Position Angle:   %g" % (fitpars[6])

        if ".png" in options.figure:
            make_figure(img,gaussim,zz,zzg,fitpars,options.figure,cdelt=cd,filename=filename)
        elif options.figure:
            make_figure(img,gaussim,zz,zzg,fitpars,filename.replace(".fits","_robustfit.png"),cdelt=cd,filename=filename)

        if options.outfile:
            fitpars[4:6] *= cd*3600.0*numpy.sqrt(8*numpy.log(2))
            print >>outf,"%80s" % filename + "".join("%10.4g" % s for s in fitpars)

    if options.outfile:
        outf.close()
