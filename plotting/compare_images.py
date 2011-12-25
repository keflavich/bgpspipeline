#!/usr/bin/env python
import pyfits
import montage
from pylab import *
import pylab
import agpy
from agpy import mad
from agpy.gaussfitter import onedgaussfit,onedgaussian
from scipy import stats
import pywcs
from agpy import print_timing
from agpy.asinh_norm import AsinhNorm

from mpfit import mpfit

from matplotlib.colors import Normalize
import numpy
from numpy import ma

import sys
import os
pipeline_root = os.getenv('PIPELINE_ROOT')
if pipeline_root is None: pipeline_root = '/Users/adam/work/bgps_pipeline/'

sys.path.append(pipeline_root+'/analysis/')
sys.path.append(pipeline_root+'/plotting/')

import make_powerspec_ratio
from robust_fit import robust_fit 

ioff()

def linefit(xx,data,err=None,guess=[1,0],quiet=True,**kwargs):
    def line(p,x):
        return p[0]*x+p[1]

    def mpfitfun(x,data,err):
        if err == None:
            def f(p,fjac=None): return [0,data-line(p,x)]
        else:
            def f(p,fjac=None): return [0,(data-line(p,x))/err]
        return f

    mp = mpfit(mpfitfun(xx,data,err),guess,quiet=quiet,**kwargs)

    return mp.params

"""
class AsinhNorm(Normalize):
    def __call__(self,value,clip=None):
        if clip is None:
            clip = self.clip

        if cbook.iterable(value):
            vtype = 'array'
            val = ma.asarray(value).astype(np.float)
        else:
            vtype = 'scalar'
            val = ma.array([value]).astype(np.float)

        self.autoscale_None(val)
        vmin, vmax = self.vmin, self.vmax
        if vmin > vmax:
            raise ValueError("minvalue must be less than or equal to maxvalue")
        elif vmin==vmax:
            return 0.0 * val
        else:
            if clip:
                mask = ma.getmask(val)
                val = ma.array(np.clip(val.filled(vmax), vmin, vmax),
                                mask=mask)
            result = (ma.arcsinh(val)-np.arcsinh(vmin))/(np.arcsinh(vmax)-np.arcsinh(vmin))
        if vtype == 'scalar':
            result = result[0]
        return result
"""


@print_timing
def diffplot(im1, im2, name1, name2, fignum, figname=None, nzeros=1e5,
        cuts=[0.1,0.25], oneone=False, units='Jy', plottitle=None, title="",
        aperture=None, zoomaperture=True, samescale=False, histratio=False,
        ignoreval1=None,ignoreval2=None, round1=False, round2=False,
        debug=False, **kwargs):
    """
    Can set an aperture to plot points within.  Give coordinates and 
    radii in terms of pixels
    aperture = [xcen,ycen,radius,noiseannulusradius]
    """
    
    diff = im1-im2

    nonan = (im1==im1)*(im2==im2)
    OK = nonan*True
    if debug: print "n(OK): ",OK.sum()
    if ignoreval1 is not None: 
        if round1:
            OK *= (im1.round() != ignoreval1)
        else:
            OK *= (im1 != ignoreval1)
    if ignoreval2 is not None:
        if round1:
            OK *= (im2.round() != ignoreval2)
        else:
            OK *= (im2 != ignoreval2)
    if debug: print "n(OK) with ignoreval=",ignoreval1,ignoreval2,": ",OK.sum()," this many new: ",OK.sum() - nonan.sum()
    if aperture is not None:
        if len(aperture) >= 2:
            apxcen = aperture[0]
            apycen = aperture[1]
            aprad = 20.0
            noiseaprad = 40.0
        if len(aperture) >= 3:
            aprad  = aperture[2]
        if len(aperture) >= 4:
            noiseaprad = aperture[3]
        yy,xx = indices(im1.shape)
        rr = sqrt( (xx-apxcen)**2 + (yy-apycen)**2 )
        OK *= (rr<aprad)
        noiseOK = nonan * (rr>aprad) * (rr<noiseaprad)
        rms1    = "  rms=%5.4g" % (std(im1[noiseOK]))
        rms2    = "  rms=%5.4g" % (std(im2[noiseOK]))
        rmsdiff = "  rms=%5.4g" % (std((im1-im2)[noiseOK]))
    else:
        rms1 = "  rms=%5.4g"  % (mad.MAD(im1[OK]))
        rms2 = "  rms=%5.4g"  % (mad.MAD(im2[OK]))
        rmsdiff = "  rms=%5.4g"  % (mad.MAD((im1-im2)[OK]))
    P = polyfit(concatenate([im1[OK],zeros(nzeros)]),concatenate([im2[OK],zeros(nzeros)]),1)
    pr = stats.pearsonr(concatenate([im1[OK],zeros(nzeros)]),concatenate([im2[OK],zeros(nzeros)]))

    gtc,Pc,corrcoefs = [],[],[]
    for cut in cuts:
      gtc = (im1>cut)*(im2>cut) 
      Pi = polyfit(concatenate([im1[gtc],zeros(nzeros)]),concatenate([im2[gtc],zeros(nzeros)]),1)
      Pc.append( Pi )
      pearsonr,ppearsonr = stats.pearsonr(concatenate([im1[gtc],zeros(nzeros)]),concatenate([im2[gtc],zeros(nzeros)]))
      corrcoefs.append((pearsonr,ppearsonr))

      try: 
          lf = linefit(im1[gtc],im2[gtc],guess=[1.1,0])
      except ZeroDivisionError:
          lf = " linefit failed because it's stupid "
      print Pi,lf," pearson: ",pearsonr,ppearsonr

    figure(fignum,figsize=[12,12]); clf()

    subplot(221)
    if plottitle: pylab.title(plottitle)
    if OK.sum() > 0:
        plot(im1[OK],im2[OK],'k,')
        xx1 = linspace(0.01,im1[OK].max(),1000)
        plot(xx1,polyval(P ,xx1), label="All Data: m=%4.2f b=%4.2f  pr=%4.2f ppr=%5.4g" % (P[0] ,P[1], pr[0], pr[1]))
        for cut,params,pearsons in zip(cuts,Pc,corrcoefs):
          xxc = linspace(cut,im1[OK].max(),1000)
          plot(xxc,polyval(params,xxc),label="$>$%4.2f %s: m=%4.2f b=%4.2f  pr=%4.2f ppr=%5.4g" % (cut,units,params[0],params[1],pearsons[0],pearsons[1]))
        if oneone:
          plot(xx1,xx1,color=oneone,linestyle="--")
        #axis([0,5,0,5])
        #annotate("y=-3.34e-4 + 0.9848 x",[0.15,0.85],xycoords='figure fraction')
        xlabel('%s (%s)' % (name1,units))
        ylabel('%s (%s)' % (name2,units))
        axis([0,im1[OK].max(),0,im2[OK].max()])
        leg = legend(bbox_to_anchor=(0.0, 1.20), loc='upper left', borderaxespad=0.)
        for t in leg.get_texts():
            t.set_fontsize('small')
    else:
        xlabel("NO POINTS TO PLOT!")
        ylabel("NO POINTS TO PLOT!")
        print "WARNING: There were no points within the aperture acceptable for plotting!  Something about this image sucks."

    if kwargs.has_key('units'): del kwargs['units']

    if samescale:
        vmin = min([diff[OK].min(),im1[OK].min(),im2[OK].min()])
        vmax = max([diff[OK].max(),im1[OK].max(),im2[OK].max()])
    else:
        vmin,vmax = None,None
    # kwargs overrides
    if kwargs.has_key('vmin'):
        if kwargs['vmin'] is not None: vmin = kwargs['vmin']
        del kwargs['vmin']
    if kwargs.has_key('vmax'):
        if kwargs['vmax'] is not None: vmax = kwargs['vmax']
        del kwargs['vmax']

    subplot(222)
    imgplotDiff = imshow(diff,norm=AsinhNorm(), vmin=vmin, vmax=vmax, **kwargs)
    colorbar(norm=AsinhNorm())
    pylab.title("%s - %s" % (name1,name2) + rmsdiff)
    if aperture and zoomaperture: imgplotDiff.axes.axis([apxcen-noiseaprad*1.1,apxcen+noiseaprad*1.1,apycen-noiseaprad*1.1,apycen+noiseaprad*1.1])

    subplot(223)
    imgplot1 = imshow(im1,norm=AsinhNorm(), vmin=vmin, vmax=vmax, **kwargs)
    if aperture:
        imgplot1.axes.add_patch(Circle([apxcen,apycen],aprad,fill=False,edgecolor='k',linestyle='solid',linewidth=1))
        imgplot1.axes.add_patch(Circle([apxcen,apycen],noiseaprad,fill=False,edgecolor='k',linestyle='dashed',linewidth=1))
        imgplot1.axes.annotate("Ap1sum = %g, Ap2sum = %g" % (im1[OK].sum(),im1[noiseOK].sum()),[0.05,0.05],xycoords='figure fraction')
        if zoomaperture: imgplot1.axes.axis([apxcen-noiseaprad*1.1,apxcen+noiseaprad*1.1,apycen-noiseaprad*1.1,apycen+noiseaprad*1.1])
    pylab.title(name1 + rms1)
    colorbar(norm=AsinhNorm())


    subplot(224)
    imgplot2 = imshow(im2,norm=AsinhNorm(), vmin=vmin, vmax=vmax, **kwargs)
    if aperture:
        imgplot2.axes.add_patch(Circle([apxcen,apycen],aprad,fill=False,edgecolor='k',linestyle='solid',linewidth=1))
        imgplot2.axes.add_patch(Circle([apxcen,apycen],noiseaprad,fill=False,edgecolor='k',linestyle='dashed',linewidth=1))
        imgplot2.axes.annotate("Ap1sum = %g, Ap2sum = %g" % (im2[OK].sum(),im2[noiseOK].sum()),[0.55,0.05],xycoords='figure fraction')
        if zoomaperture: imgplot2.axes.axis([apxcen-noiseaprad*1.1,apxcen+noiseaprad*1.1,apycen-noiseaprad*1.1,apycen+noiseaprad*1.1])
    pylab.title(name2 + rms2)
    colorbar(norm=AsinhNorm())

    pylab.annotate(title,[0.5,0.95],xycoords='figure fraction')

    #draw()
    if figname is not None: savefig(figname)

    if histratio:
        print "Making histograms for %s vs %s in %s " % (name1,name2,figname)
        ratio = im2/im1

        figure(fignum,figsize=[12,12]); clf()
        xlabel("%s / %s" % (name2,name1))
        ylabel('Normalized Fraction')

        #hist(ratio[ratio==ratio],bins=linspace(-5,5,21),histtype='stepfilled',alpha=0.2,label='all')
        #hist(ratio[OK],bins=linspace(-3,3,21),histtype='stepfilled',alpha=0.5,label='all',normed=True)

        for cut in cuts:
            gtc = (im1>cut)*(im2>cut) 
            h,l,p = hist(ratio[gtc],bins=linspace(0,3,21),histtype='stepfilled',alpha=0.3, normed=True, label='>%5f' % cut )
            l1 = (l[1:]+l[:-1])/2. 
            pars,model,perr,chi = onedgaussfit(l1,h,params=[0,h.max(),1.0,ratio[gtc].std()],fixed=[True,False,False,False])
            plot(linspace(0,3,201), onedgaussian(linspace(0,3,201),*pars), color=p[0].get_facecolor(), label="$\\mu=%0.2f;\\sigma=%0.2f $" % (pars[-2],pars[-1],) )
        legend(loc='best')

        if figname is not None: savefig(figname.replace(".png","_hist.png"))


@print_timing
def powerspecplot(im1, im2, name1, name2, savename=None, pixsize=7.2,
        beamline=True, title="", fignum=3,  hanning=False,  xcorr=False,
        debug=False, **kwargs):
    figure(fignum)
    clf()
    subplot(211)
    if debug:
        print "im1 has %i nans" % (np.isnan(im1).sum())
        print "im2 has %i nans" % (np.isnan(im2).sum())
        print "im1 stats: %10f +/- %10f" % (im1[im1==im1].mean(),im1[im1==im1].std())
        print "im2 stats: %10f +/- %10f" % (im2[im2==im2].mean(),im2[im2==im2].std())
    f1,z1 = agpy.psds.power_spectrum(im1,hanning=hanning)
    f2,z2 = agpy.psds.power_spectrum(im2,hanning=hanning)
    if debug:
        print "z1 stats: %10f +/- %10f" % (z1.mean(),z1.std())
        print "z2 stats: %10f +/- %10f" % (z2.mean(),z2.std())
    loglog(pixsize/f1,z1,label=name1,color='k')
    loglog(pixsize/f2,z2,label=name2,color='r')
    if xcorr:
        f3,z3 = agpy.psds.power_spectrum(im1,im2,hanning=hanning)
        print "Cross-correlated images. z3.sum()=%g" % z3.sum()
        loglog(pixsize/f3,z3,label="X-corr",color='b')

    #leg = legend(loc='best')
    leg = legend(bbox_to_anchor=(0.0, 1.20), loc='upper left', borderaxespad=0.)
    fmin = min( concatenate([pixsize/f1,pixsize/f2]) )
    fmax = max( concatenate([pixsize/f1,pixsize/f2]) )
    zmin = min( concatenate([z1,z2]) )
    zmax = max( concatenate([z1,z2]) )
    if beamline:
      vlines(33,zmin,zmax,'k','--')
      text(34,zmax/5,'33"')
    xlabel("Arcseconds")
    axis([fmin,fmax,zmin,zmax])
    subplot(212)
    #semilogx(pixsize/f1,sqrt(z1/z2),label="%s/%s" % (name1,name2),color='b')
    semilogx(pixsize/f1,sqrt(z2/z1),label="%s/%s" % (name2,name1),color='g')
    axis([fmin,fmax,0,2])
    grid()
    xlabel("Arcseconds")
    ylabel("$\\sqrt{Power Ratio}$")
    pylab.title(title)
    legend(loc='best')
    if savename:
      savefig(savename)
  
@print_timing
def spatial_transfer_function(im1,im2,name1,name2,savename=None,pixsize=7.2,beamline=True,title="",hanning=False, fignum=5, **kwargs):
    figure(fignum)
    clf()
    f1,z1 = agpy.psds.power_spectrum(im1,hanning=hanning)
    f2,z2 = agpy.psds.power_spectrum(im2,hanning=hanning)
    semilogx(pixsize/f1,(z2/z1),label="%s/%s" % (name2,name1),color='b')
    ax=gca()
    fmin = min( concatenate([pixsize/f1,pixsize/f2]) )
    fmax = max( concatenate([pixsize/f1,pixsize/f2]) )
    hlines(1.0,pixsize,1e6,'k',':')
    if beamline:
      vlines(33,0.0,1.1,'k','--',label="33\"")
      #text(34,zmax/5,'33"')
    axis([fmin,fmax,0.0,1.1])
    yticks = np.array([0.0,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1.0])
    ax.yaxis.set_ticks(yticks**2)
    ax.yaxis.set_ticklabels(["%0.2f" % s for s in yticks])
    #grid()
    xlabel("Arcseconds")
    ylabel("$\\sqrt{Power Ratio}$")
    pylab.title(title)
    legend(loc='best')
    if savename:
      savefig(savename)


@print_timing
def compare_files(file1, file2, imname1="im1", imname2='im2',
        savename="default.png", fignum=1, savename_psd="", header=None,
        savename_pointcompare=None, wcsaperture=None, savename_stf="",
        debug=False, xcorr=False, scalefactor1=1.0, scalefactor2=1.0,
        subsection=None,
        **kwargs):
    """
    Wrapper to read in, reproject, and dance with input files...
    """
    if header is None:
        header='temp.hdr'
        montage.mGetHdr(file1,header)
        hdname = ""
    else:
        hdname = header.replace(".hdr","")
        outfile1 = file1.replace(".fits","_reproject%s.fits" % hdname)
        try: 
            im1 = pyfits.getdata(outfile1)
            print "Loaded pre-projected file %s" % outfile1
        except:
            print "Projecting %s to %s with %s" % (file1,outfile1,header)
            montage.wrappers.reproject(file1,outfile1,header,exact_size=True)
        file1 = outfile1
    im1 = pyfits.getdata(file1)
    im2 = pyfits.getdata(file2)
    if debug: print "TESTS: im1[im1==im1].mean: %g  im2[im2==im2].mean: %g" % (im1[im1==im1].mean(),im2[im2==im2].mean())
    if im1.shape != im2.shape:
        outfile = file2.replace('.fits','_reproject%s.fits' % hdname)
        try:
            im2 = pyfits.getdata(outfile)
            if im1.shape != im2.shape:
                raise Exception("Continue")
            else:
                print "Loaded pre-projected file %s" % outfile
                file2 = outfile
        except:
            print "Projecting %s to %s with %s" % (file2,outfile,header)
            montage.wrappers.reproject(file2,outfile,header,exact_size=True)
            im2 = pyfits.getdata(outfile)
            file2 = outfile
    else:
        print "Loaded pre-projected file %s" % file2
    
    if wcsaperture:
        wcs = pywcs.WCS(pyfits.getheader(file1))
        lon,lat = wcs.wcs_sky2pix(wcsaperture[0],wcsaperture[1],0)
        if hasattr(wcs.wcs,'cd'):
            cdelt = abs(wcs.wcs.cd[0,0])
            rad = wcsaperture[2] / 3600.0 / cdelt
            noiserad = wcsaperture[3] / 3600.0 / cdelt
        elif hasattr(wcs.wcs,'cdelt'):
            cdelt = abs(wcs.wcs.cdelt[0])
            rad = wcsaperture[2] / 3600.0 / cdelt
            noiserad = wcsaperture[3] / 3600.0 / cdelt
        else:
            raise Exception()
        kwargs['aperture'] = [lon[0],lat[0],rad,noiserad]
        if debug:
            print "wcsaperture: ",kwargs['aperture']
            print "lon: %f lat: %f cdelt: %f  rad: %f  noiserad: %f" % (lon,lat,cdelt,rad,noiserad)
    elif subsection:
        im1 = im1[subsection[2]:subsection[3],subsection[0]:subsection[1]]
        im2 = im2[subsection[2]:subsection[3],subsection[0]:subsection[1]]
    else:
        cdelt=0.002

    im1 *= scalefactor1
    im2 *= scalefactor2

    if debug: print "TESTS: im1.shape: ",im1.shape," im2.shape: ",im2.shape
    if debug: print "TESTS: im1[im1==im1].mean: %g  im2[im2==im2].mean: %g" % (im1[im1==im1].mean(),im2[im2==im2].mean())
    diffplot(im1,im2,imname1,imname2,fignum,savename,debug=debug,**kwargs)
    if debug: print "TESTS: im1[im1==im1].mean: %g  im2[im2==im2].mean: %g" % (im1[im1==im1].mean(),im2[im2==im2].mean())
    if isinstance(savename_psd,str):
        powerspecplot(im1,im2,imname1,imname2,savename=savename_psd,xcorr=xcorr,debug=debug, **kwargs)
    elif savename_psd:
        powerspecplot(im1,im2,imname1,imname2,savename=savename.replace('.png','_psd.png'),xcorr=xcorr, debug=debug, **kwargs)

    if debug: print "file1: %s  file2: %s " % (file1,file2)
    if isinstance(savename_stf,str):
        spatial_transfer_function(im1,im2,imname1,imname2,savename=savename_stf,**kwargs)
        if debug: print "STF: TESTS: im1[im1==im1].mean: %g  im2[im2==im2].mean: %g" % (im1[im1==im1].mean(),im2[im2==im2].mean())
        if savename_stf is not "":
            make_powerspec_ratio.make_powerspec_ratio(file1,file2,clobber=True,outname=savename_stf.replace("png","fits"), debug=debug)
            if debug: print "MakePowRat: TESTS: im1[im1==im1].mean: %g  im2[im2==im2].mean: %g" % (im1[im1==im1].mean(),im2[im2==im2].mean())
    elif savename_stf:
        spatial_transfer_function(im1,im2,imname1,imname2,savename=savename.replace('.png','_stf.png'),**kwargs)
        if debug: print "STF: TESTS: im1[im1==im1].mean: %g  im2[im2==im2].mean: %g" % (im1[im1==im1].mean(),im2[im2==im2].mean())
        make_powerspec_ratio.make_powerspec_ratio(file1,file2,clobber=True,outname=savename.replace('.png','_stf.fits'), debug=debug)
        if debug: print "MakePowRat: TESTS: im1[im1==im1].mean: %g  im2[im2==im2].mean: %g" % (im1[im1==im1].mean(),im2[im2==im2].mean())

    if isinstance(savename_pointcompare,str):
        return compare_pointsources(im1,im2,imname1,imname2,savename=savename_pointcompare,cdelt=cdelt,debug=debug,**kwargs)
    elif savename_pointcompare:
        return compare_pointsources(im1,im2,imname1,imname2,savename=savename.replace('.png','_pointcompare.png'),debug=debug,cdelt=cdelt,**kwargs)
    else:
        return im1,im2

@print_timing
def compare_pointsources(im1, im2, name1, name2, aperture=None, cdelt=0.002, fignum=4,
        savename=None, debug=False, **kwargs):
    """
    plot radial profiles of point sources...
    """

    nonan = (im1==im1)*(im2==im2)
    yy,xx = indices(im1.shape)
    asperpix = cdelt * 3600.0

    if aperture is not None:
        if len(aperture) >= 2:
            apxcen = aperture[0]
            apycen = aperture[1]
            aprad = 20.0
        if len(aperture) >= 3:
            aprad  = aperture[2]
        noiseaprad = aprad*sqrt(2)
        rr = sqrt( (xx-apxcen)**2 + (yy-apycen)**2 )
        OK = nonan * (rr<aprad)
        noiseOK = nonan * (rr>aprad) * (rr<noiseaprad)
    else:
        OK = nonan
        noiseOK = nonan
        aprad = im1.shape[1] / asperpix

    cropim1 = im1[apycen-aprad*2:apycen+aprad*2,apxcen-aprad*2:apxcen+aprad*2]
    cropim2 = im2[apycen-aprad*2:apycen+aprad*2,apxcen-aprad*2:apxcen+aprad*2]
    OKc = OK[apycen-aprad*2:apycen+aprad*2,apxcen-aprad*2:apxcen+aprad*2]
    noiseOKc = noiseOK[apycen-aprad*2:apycen+aprad*2,apxcen-aprad*2:apxcen+aprad*2]
    yyc,xxc = indices(cropim1.shape)

    fitpars1, gaussim1, img1, zz1, zzg1 = robust_fit(cropim1,cdelt=cdelt,unshift=True,**kwargs)
    fitpars2, gaussim2, img2, zz2, zzg2 = robust_fit(cropim2,cdelt=cdelt,unshift=True,**kwargs)
    rr1 = sqrt( (xxc-fitpars1[2])**2 + (yyc-fitpars1[3])**2 )
    rr2 = sqrt( (xxc-fitpars2[2])**2 + (yyc-fitpars2[3])**2 )

    figure(fignum)
    clf()
    sp1 = subplot(211)
    rrs1 = argsort(rr1[OKc].flat)
    plot(rr1[OKc][rrs1]*asperpix,cropim1[OKc][rrs1],',',label=name1,color='k')
    rrs2 = argsort(rr2[OKc].flat)
    plot(rr2[OKc][rrs2]*asperpix,cropim2[OKc][rrs2],',',label=name2,color='r')

    rrav1,azav1 = agpy.azimuthalAverage(cropim1,center=fitpars1[2:4],returnradii=True,binsize=0.5,interpnan=True,left=numpy.nan)
    rrav2,azav2 = agpy.azimuthalAverage(cropim2,center=fitpars2[2:4],returnradii=True,binsize=0.5,interpnan=True,left=numpy.nan)
    rravG1,azavG1 = agpy.azimuthalAverage(gaussim1,center=fitpars1[2:4],returnradii=True,binsize=0.5,interpnan=True,left=numpy.nan)
    rravG2,azavG2 = agpy.azimuthalAverage(gaussim2,center=fitpars2[2:4],returnradii=True,binsize=0.5,interpnan=True,left=numpy.nan)
    plot(rrav1*asperpix,azav1,color='k',linestyle='dashed')
    plot(rrav2*asperpix,azav2,color='r',linestyle='dashed')
    plot(rravG1*asperpix,azavG1,'g:',label='Gaussfit %s' % name1)
    plot(rravG2*asperpix,azavG2,'b:',label='Gaussfit %s' % name2)
    xlabel("Radius (\")")
    ylabel("Flux")
    legend(loc='best')
    sp1.set_xlim(0,aprad*asperpix)

    imgmax = max([cropim1.max(),cropim2.max()])
    imgmin = min([cropim1.min(),cropim2.min()])
    
    fwhm = numpy.sqrt(8*numpy.log(2))
    sp2 = subplot(223)
    imgplot1 = imshow(cropim1,norm=AsinhNorm(),vmin=imgmin,vmax=imgmax)
    imgplot1.axes.add_artist(matplotlib.patches.Ellipse(fitpars1[2:4],fwhm*fitpars1[5],fwhm*fitpars1[4],angle=fitpars1[6],facecolor='none'))
    zoomrad = sqrt(fitpars1[4]**2+fitpars1[5]**2)*3
    imgplot1.axes.axis([fitpars1[2]-zoomrad*1.1,fitpars1[2]+zoomrad*1.1,fitpars1[3]-zoomrad*1.1,fitpars1[3]+zoomrad*1.1])
    imgplot1.axes.annotate("Apsum = %g, NoiseApSum = %g" % (cropim1[OKc].sum(),im1[noiseOKc].sum()),[0.05,0.06],xycoords='figure fraction')
    imgplot1.axes.annotate("GaussApSum = %g, gausspeak = %g" % (gaussim1.sum(),fitpars1[1]),[0.05,0.04],xycoords='figure fraction')
    imgplot1.axes.annotate("Maj: %g  Min: %g" % (fitpars1[4]*asperpix*fwhm,fitpars1[5]*asperpix*fwhm),[0.05,0.02],xycoords='figure fraction')
    pylab.title(name1)
    colorbar(norm=AsinhNorm())

    sp3 = subplot(224)
    imgplot2 = imshow(cropim2,norm=AsinhNorm(),vmin=imgmin,vmax=imgmax)
    imgplot2.axes.add_artist(matplotlib.patches.Ellipse(fitpars2[2:4],fwhm*fitpars2[5],fwhm*fitpars2[4],angle=fitpars2[6],facecolor='none'))
    zoomrad = sqrt(fitpars2[4]**2+fitpars2[5]**2)*3
    imgplot2.axes.axis([fitpars2[2]-zoomrad*1.1,fitpars2[2]+zoomrad*1.1,fitpars2[3]-zoomrad*1.1,fitpars2[3]+zoomrad*1.1])
    imgplot2.axes.annotate("Apsum = %g, NoiseApSum = %g" % (cropim2[OKc].sum(),im2[noiseOKc].sum()),[0.55,0.06],xycoords='figure fraction')
    imgplot2.axes.annotate("GaussApSum = %g, gausspeak = %g" % (gaussim2.sum(),fitpars2[1]),[0.55,0.04],xycoords='figure fraction')
    imgplot2.axes.annotate("Maj: %g  Min: %g" % (fitpars2[4]*asperpix*fwhm,fitpars2[5]*asperpix*fwhm),[0.55,0.02],xycoords='figure fraction')
    pylab.title(name2)
    colorbar(norm=AsinhNorm())

    if debug:
        import pdb; pdb.set_trace()

    if savename:
      savefig(savename)

    return [cropim1[OKc].sum(),cropim1[noiseOKc].sum(),cropim1[OKc].std(),cropim1[noiseOKc].std()]+list(fitpars1),[cropim2[OKc].sum(),cropim2[noiseOKc].sum(),cropim2[OKc].std(),cropim2[noiseOKc].std()]+list(fitpars2)


if __name__ == "__main__":
    import sys
    import os
    import optparse
    import re

    parser=optparse.OptionParser()
    parser.add_option("--psd","--psd_name","--savename_psd","-p",help="PSD figure file name.  Default is none.",default=[])
    parser.add_option("--stf","--stf_name","--savename_stf","-S",help="STF figure file name.  Default is none.",default=[])
    parser.add_option("--point","--point_name","--savename_point","--savename_pointcompare",help="Point source comparison figure file name.  Default is none.",default=False)
    parser.add_option("--savename","--name","-n",default="default.png")
    parser.add_option("--header","-H",help="Header to project both images to.  Default is none.")
    parser.add_option("--imname1","--imn1","--im1","-1",help="Image 1 name to use in titles",default="Im1")
    parser.add_option("--imname2","--imn2","--im2","-2",help="Image 2 name to use in titles",default="Im2")
    parser.add_option("--samescale",help="Plot images on same scale?",default=False,action="store_true")
    parser.add_option("--scalefactor1",help="Multiplicative factor by which to scale image 1",default=1.0)
    parser.add_option("--scalefactor2",help="Multiplicative factor by which to scale image 2",default=1.0)
    parser.add_option("--vmin",help="set minimum image scale",default=None)
    parser.add_option("--vmax",help="set maximum image scale",default=None)
    parser.add_option("--units","--unit","-u",help="Units - either Jy or Volts, most likely "+\
            "(could put in Jy/beam but that's a lot of text).  Default Jy",default="Jy")
    parser.add_option("--cuts","-c",help="List of cutoff values above which to fit a line.  "+\
            "Can be written as 0.1,0.25 or '0.1 0.25'.",default="0.1,0.25")
    parser.add_option("--aperture","-a",
            help="Only compare within an aperture, and include noise estimates in an aperture.  "+\
                    "Syntax: xcen,ycen,radius,noiseannulusradius",
            default=None)
    parser.add_option("--wcsaperture","-w",
            help="Only compare within an aperture, and include noise estimates in an aperture.  "+\
                    "Use world coordinates instead of pixel coordinates.  "+\
                    "Syntax: lon,lat,radius (arcsec),noiseannulusradius (arcsec)",
            default=None)
    parser.add_option("--datafile",help="Print best fits and aperture sums to a file?  Will append.",default=False)
    parser.add_option("--debug",help="Be very verbose / debug mode?",default=False, action='store_true')
    parser.add_option("--oneone","-o",help="Plot the one-one line?  Pass a color name (hex code) or False.  Defaults to yes/gray.",default="#888888")
    parser.add_option("--title","-t",help="Plot title",default="")
    parser.set_usage("%prog image1.fits image2.fits [options]")
    parser.set_description(
    """Produces a 4-panel image showing a pixel vs. pixel plot (top left), a
    difference image (top right), and image 1 and 2 (bottom left and right),
    all displayed with an arcsinh stretch.  The pixel vs. pixel plot also
    includes fits to all data above some cutoff, which can be specified with
    the --cuts keyword below as a "," or " " separated list.

    Additionally, if a PSD savename is passed, will produce a plot of the power
    spectra of both images (top) and their ratio (bottom).  
    """)

    options,args = parser.parse_args()

    print "Args: ",args
    f1,f2 = args
    imn1 = options.imname1
    imn2 = options.imname2
    savename = options.savename
    header = options.header
    if 'png' in options.stf:
        savename_stf = options.stf
    elif options.stf is not []:
        savename_stf = True
    if 'png' in options.psd:
        savename_psd = options.psd
    elif options.psd is not []:
        savename_psd = True
    if options.point is False:
        savename_point = False
    elif 'png' in options.point:
        savename_point = options.point
    elif options.point is not []:
        savename_point = True
    else:
        savename_point = False
    units = options.units
    cuts = [float(a) for a in re.split('[ ,]',options.cuts)]
    if options.aperture: aperture = [float(a) for a in re.split("[ ,]",options.aperture)]
    else: aperture = None
    if options.wcsaperture: wcsaperture = [float(a) for a in re.split("[ ,]",options.wcsaperture)]
    else: wcsaperture = None

    vmin = float(options.vmin) if options.vmin is not None else None
    vmax = float(options.vmax) if options.vmax is not None else None

    #f1,f2 = sys.argv[1:3]

    #if len(sys.argv) > 3:
    #    imn1,imn2 = sys.argv[3:5]
    #else:
    #    imn1,imn2 = "im1","im2"
    #if len(sys.argv) > 5:
    #    savename = sys.argv[5]
    #else:
    #    savename = "default.png"
    #if len(sys.argv) > 6:
    #    header = sys.argv[6]
    #else:
    #    header=None


    print "Comparing %s,%s,%s,%s,%s" % (f1,f2,imn1,imn2,savename)
    #if options.debug:
    #    import pdb
    #    print "DEBUG MODE"
    #    CF = pdb.runcall( compare_files,f1, f2, imn1, imn2, savename=savename, header=header,
    #            savename_psd=savename_psd, units=units, cuts=cuts,
    #            oneone=options.oneone, aperture=aperture, wcsaperture=wcsaperture,
    #            savename_pointcompare=savename_point, title=options.title,
    #            savename_stf=savename_stf, debug=options.debug, samescale=options.samescale) 
    #else:
    CF = compare_files(f1, f2, imn1, imn2, savename=savename, header=header,
            savename_psd=savename_psd, units=units, cuts=cuts,
            oneone=options.oneone, aperture=aperture, wcsaperture=wcsaperture,
            savename_pointcompare=savename_point, title=options.title,
            savename_stf=savename_stf, debug=options.debug,
            samescale=options.samescale, vmin=vmin, vmax=vmax,
            scalefactor1=float(options.scalefactor1),
            scalefactor2=float(options.scalefactor2),
            )

    if options.datafile:
        print "Appending fits to file %s" % options.datafile
        outf = open(options.datafile,'a')
        f1out = os.path.split(f1)[1]
        f2out = os.path.split(f2)[1]
        print >>outf,"%80s %80s " % (f1out,f2out) + "".join([" ".join(["%15g" % a for a in X]) for X in CF])
        outf.close()
