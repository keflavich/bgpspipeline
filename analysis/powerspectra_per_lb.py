from agpy import psds
from agpy import powerfit
from agpy import cubes
import numpy as np
import pyfits
import pywcs
import pylab
import os
from matplotlib.patches import Rectangle
from matplotlib.ticker import MultipleLocator, FormatStrFormatter, Locator, Base
import mpfit


def sinfunc(height, amplitude, offset, freq=2.0):
    return lambda(x): height+amplitude*np.sin(x/180.*np.pi*freq+offset)

def sinfit(angle,data,err=None,quiet=True):

    if err is None: err = np.ones(data.shape)*data.std()

    def mpfitfun(data,err):
        if err is None:
            def f(p,fjac=None): 
                return [0,np.ravel(data-sinfunc(*p)(angle))]
        else:
            def f(p,fjac=None): 
                return [0,np.ravel((data-sinfunc(*p)(angle))/err)]
        return f

    params = [data.mean(),(data.max()-data.min())/2.,0.0]
    mp = mpfit.mpfit(mpfitfun(data,err),params,quiet=quiet)

    return mp

class OffsetMultipleLocator(Locator):
    """
    Set a tick on every integer that is multiple of base in the
    view interval
    """

    def __init__(self, base=1.0, vmin=0.0):
        self._base = Base(base)
        self.vmin = vmin

    def __call__(self):
        'Return the locations of the ticks'
        vmin, vmax = self.axis.get_view_interval()
        if vmax<vmin:
            vmin, vmax = vmax, vmin
        vmin = self._base.ge(self.vmin)
        base = self._base.get_base()
        n = (vmax - self.vmin + 0.001*base)//base
        locs = self.vmin + np.arange(n+1) * base
        return self.raise_if_exceeds(locs)

    def view_limits(self, dmin, dmax):
        """
        Set the view limits to the nearest multiples of base that
        contain the data
        """
        vmin = self._base.le(dmin)
        vmax = self._base.ge(dmax)
        if vmin==vmax:
            vmin -=1
            vmax +=1

        return mtransforms.nonsingular(vmin, vmax)

def plot_connect_powerspec(fn,psdsize=32,largescalecutoff=250,savefigs=False,**kwargs):
        powerspec_grid = pyfits.getdata(os.path.splitext(fn)[0]+"_powerspec_grid_%i.fits" % psdsize)
        header = pyfits.getheader(os.path.splitext(fn)[0]+"_powerspec_grid_%i.fits" % psdsize)
        powerlaw_fit_grid = pyfits.getdata(os.path.splitext(fn)[0]+"_powerlaw_fit_grid_%i.fits" % psdsize)
        data = pyfits.getdata(fn)
        angle_grid = pyfits.getdata(os.path.splitext(fn)[0]+"_angle_fit_grid_%i.fits" % psdsize)
        anglespec_grid = pyfits.getdata(os.path.splitext(fn)[0]+"_anglespec_grid_%i.fits" % psdsize)
        angleheader = pyfits.getheader(os.path.splitext(fn)[0]+"_anglespec_grid_%i.fits" % psdsize)

        rr = ( np.arange(header.get('NAXIS3')) - header.get('CRPIX3') + 1 ) * header.get('CD3_3') + header.get('CRVAL3')
        rr_as = (header.get('CD2_2')/float(psdsize)*3600.)/rr
        az = ( np.arange(angleheader.get('NAXIS3')) - angleheader.get('CRPIX3') + 1 ) * angleheader.get('CD3_3') + angleheader.get('CRVAL3')
        OK = rr_as < largescalecutoff

        pylab.figure(1)
        pylab.clf()
        ax = pylab.imshow(np.arcsinh(data),**kwargs).axes
        modulus_lon = data.shape[1] % psdsize
        modulus_lat = data.shape[0] % psdsize
        ax.xaxis.set_major_locator(OffsetMultipleLocator(psdsize,modulus_lon/2.))
        ax.yaxis.set_major_locator(OffsetMultipleLocator(psdsize,modulus_lat/2.))
        ax.xaxis.grid(True,'major')
        ax.yaxis.grid(True,'major')

        def plot_powerfit(event,powerspec_grid=powerspec_grid):
            if event.xdata is not None and event.ydata is not None:
                print event.xdata,event.ydata, event.xdata/psdsize,event.ydata/psdsize
                zz = powerspec_grid[:,event.ydata/psdsize,event.xdata/psdsize]
                zaz = anglespec_grid[:,event.ydata/psdsize,event.xdata/psdsize]
                if zz.sum() == 0:
                    print "No data at that point"
                else:
                    (scale1,scale2,breakpoint,pow1,pow2),mpf = powerfit.brokenpowerfit(rr[OK],zz[OK],breakpoint=0.23,alphaguess1=-2.0,alphaguess2=0.0,scaleguess=np.median(zz))
                    pylab.figure(3)
                    pylab.clf()
                    pylab.loglog(rr,zz,'gray')
                    pylab.loglog(rr[OK],zz[OK],'k')
                    pylab.plot(rr,scale1*rr**pow1*(rr<breakpoint)+scale2*rr**pow2*(rr>=breakpoint),'r')
                    pylab.annotate("p1 =    %8.3f" % pow1,[0.75,0.85],xycoords='figure fraction')
                    pylab.annotate("p2 =    %8.3f" % pow2,[0.75,0.80],xycoords='figure fraction')
                    pylab.annotate("break = %8.3f" % breakpoint,[0.75,0.75],xycoords='figure fraction')
                    pylab.xlabel("Spatial Frequency (image size / length)")
                    pylab.ylabel("Azimuthally Averaged Flux$^2$")
                    pylab.title(os.path.split(fn)[1].replace(".fits",""))
                    if savefigs:
                        pylab.savefig(fn.replace(".fits","_powerspectrum_%i_%ix%i.png" % (psdsize,event.xdata/psdsize,event.ydata/psdsize)))
                    
                    pylab.figure(4)
                    pylab.clf()
                    pylab.plot(az,zaz,'k')
                    pylab.plot(az,sinfunc(*angle_grid[:,event.ydata/psdsize,event.xdata/psdsize])(az),'r')
                    pylab.xlabel("Position Angle")
                    pylab.ylabel("Radially Averaged Flux$^2$")
                    pylab.title(os.path.split(fn)[1].replace(".fits",""))
                    if savefigs:
                        pylab.savefig(fn.replace(".fits","_anglespectrum_%i_%ix%i.png" % (psdsize,event.xdata/psdsize,event.ydata/psdsize)))

                    pylab.draw()

                for R in pylab.figure(1).axes[0].patches:
                    R.set_visible(False)
                    pylab.figure(1).axes[0].patches.remove(R)
                print "Click point: %10.2f,%10.2f   Rectangle coords: %10.2f,%10.2f" % (event.xdata,event.ydata,event.xdata-event.xdata%psdsize,event.ydata-event.ydata%psdsize)
                rect = Rectangle([event.xdata-event.xdata%psdsize+modulus_lon/2.,event.ydata-event.ydata%psdsize+modulus_lat/2.],psdsize,psdsize,facecolor='none')
                pylab.figure(1).axes[0].add_patch(rect)
                pylab.figure(1).canvas.draw()
                return rr,zz

        fig = pylab.figure(2)
        for ii in range(256): fig.canvas.mpl_disconnect(ii)
        pylab.clf()
        vmin,vmax=None,None
        if powerlaw_fit_grid.min()<-7: vmin=-7
        if powerlaw_fit_grid.max()>0: vmax=0
        imax = pylab.imshow(powerlaw_fit_grid,vmin=vmin,vmax=vmax,extent=[0,powerlaw_fit_grid.shape[1]*psdsize,0,powerlaw_fit_grid.shape[0]*psdsize])
        ax = imax.axes
        yy,xx = np.indices(angle_grid.shape[1:])
        for x,y,z in zip(xx.ravel(),yy.ravel(),np.reshape(angle_grid.swapaxes(0,1).swapaxes(1,2),[angle_grid.shape[1]*angle_grid.shape[2],angle_grid.shape[0]])):
            arr = pylab.Arrow(x*psdsize+psdsize/2.,y*psdsize+psdsize/2.,
                    psdsize/2.*np.cos(z[2]-np.pi/2.)*np.abs(z[1]/z[0]),psdsize/2.*np.sin(z[2]-np.pi/2.)*np.abs(z[1]/z[0]),
                    edgecolor='white',facecolor='black',width=psdsize/4.)
            ax.add_patch(arr)
        pylab.colorbar()
        return fig.canvas.mpl_connect('button_press_event',plot_powerfit)

def fit_powerspectra(fn,psdsize=32,nanthreshold=0.05,doplot=False,dowait=False,largescalecutoff=250,fwhm=33,
        subdir='/powerspectra/'):
    data = pyfits.getdata(fn)
    header = pyfits.getheader(fn)
    wcs = pywcs.WCS(cubes.flatten_header(header),)
    savdir = os.path.split(fn)[0] + subdir
    savname = os.path.split(fn)[1]

    if data.shape[0] < psdsize or data.shape[1] < psdsize: return

    lmin,bmin = wcs.wcs_pix2sky(0.,0.,0)
    lmax,bmax = wcs.wcs_pix2sky(data.shape[1],data.shape[0],0)
    if hasattr(wcs.wcs,'cd'): cdelt = wcs.wcs.cd[1,1]
    else: cdelt = wcs.wcs.cdelt[1]

    if lmin>lmax: lmin,lmax = lmax,lmin
    if bmin>bmax: bmin,bmax = bmax,bmin

    lonlength_pix = (lmax-lmin) / cdelt
    latlength_pix = (bmax-bmin) / cdelt

    number_lon = np.floor(lonlength_pix[0] / psdsize)
    number_lat = np.floor(latlength_pix[0] / psdsize)
    modulus_lon = data.shape[1] % psdsize
    modulus_lat = data.shape[0] % psdsize

    powerlaw_fit_grid = np.zeros([number_lat,number_lon])
    angle_grid        = np.zeros([3,number_lat,number_lon])
    powerspec_grid    = np.zeros([np.round((psdsize-1.0)/np.sqrt(2))+1,number_lat,number_lon])
    anglespec_grid    = np.zeros([12,number_lat,number_lon])

    nskips = 0
    for ll in range(number_lon):
        for bb in range(number_lat):
            bcen = bmin + (modulus_lat/2. + psdsize/2 + psdsize*bb)*cdelt
            lcen = lmin + (modulus_lon/2. + psdsize/2 + psdsize*ll)*cdelt
            lcen_pix,bcen_pix = wcs.wcs_sky2pix(lcen,bcen,0)
            lcen_pix = np.round(lcen_pix)[0]
            bcen_pix = np.round(bcen_pix)[0]

            subimage = data[bcen_pix - psdsize/2:bcen_pix + psdsize/2,
                            lcen_pix - psdsize/2:lcen_pix + psdsize/2]

            if (subimage.shape[0] > 0  and subimage.shape[1] > 0):
                subimage2 = np.zeros([psdsize,psdsize]) + np.nan
                subimage2[:subimage.shape[0],:subimage.shape[1]] = subimage
                subimage = subimage2

            if np.isnan(subimage).sum() / float(psdsize**2) > nanthreshold:
                print "Skipping position %f,%f because nan %% = %5.1f" % (lcen,bcen,np.isnan(subimage).sum() / float(psdsize**2) * 100.0)
                nskips += 1
                continue
            if subimage.shape[0] != subimage.shape[1] or subimage.shape[0] == 0 or subimage.shape[1] == 0:
                print "Skipping position %f,%f because image dimensions are asymmetric." % (lcen,bcen)
                nskips += 1
                continue

            #print "Computing PSD.  np.nansum(subimage) = %g" % np.nansum(subimage)
            rr,zz = psds.power_spectrum(subimage)
            rr_as = (cdelt*3600.)/rr
            OK = rr_as < largescalecutoff

            (scale1,scale2,breakpoint,pow1,pow2),mpf = powerfit.brokenpowerfit(rr[OK],zz[OK],breakpoint=0.23,alphaguess1=-2.0,alphaguess2=0.0,scaleguess=np.median(zz))
            params = mpf.params
            perror = mpf.perror

            rmax = np.min( [(rr_as<fwhm).argmax(), (rr>breakpoint).argmax()] )
            rmin = np.max( [2,(rr_as>largescalecutoff).argmax()] )
            az,zaz = psds.power_spectrum(subimage-subimage.mean(),radial=True,radbins=np.array([rmin,rmax]),binsize=30.0)

            mpangle = sinfit(az,zaz)
            angle_grid[:,bb,number_lon-1-ll] = mpangle.params
            anglespec_grid[:,bb,number_lon-1-ll] = zaz

            powerlaw_fit_grid[bb,number_lon-1-ll] = pow1
            powerspec_grid[:,bb,number_lon-1-ll] = zz
            print "Position %7.3g,%7.3g has mean %8.2g and fit parameters %8.2g,%8.2g,%8.2g,%8.2g,%8.2g and angles %8.2g,%8.2g,%8.2g" % (lcen,bcen,subimage.mean(),scale1,scale2,breakpoint,pow1,pow2,mpangle.params[0],mpangle.params[1],mpangle.params[2])
            #print "                                            %5.2g,%5.2g,%5.2g,%5.2g,%5.2g" % (perror[0],perror[0],perror[1],perror[2],perror[3]) 

            if doplot:
                pylab.figure(1)
                pylab.clf()
                pylab.loglog(rr,zz,'gray')
                pylab.loglog(rr[OK],zz[OK],'k')
                pylab.plot(rr,scale1*rr**pow1*(rr<breakpoint)+scale2*rr**pow2*(rr>=breakpoint))
                pylab.annotate("p1 =    %8.3f" % pow1,[0.75,0.85],xycoords='figure fraction')
                pylab.annotate("p2 =    %8.3f" % pow2,[0.75,0.80],xycoords='figure fraction')
                pylab.annotate("break = %8.3f" % breakpoint,[0.75,0.75],xycoords='figure fraction')
                pylab.draw()
                if dowait: raw_input("WAIT")

    if ll==0 and bb==0: return
    if nskips >= number_lat*number_lon: return

    bcen = bmin + (modulus_lat/2. + psdsize/2)*cdelt
    lcen = lmin + (modulus_lon/2. + psdsize/2)*cdelt
    new_cdelt = cdelt*psdsize
    header.update('CD1_1',-1*new_cdelt)
    header.update('CD2_2',   new_cdelt)
    header.update('CRPIX1',number_lon)
    header.update('CRPIX2',1.0)
    #lcen,bcen = wcs.wcs_pix2sky(np.floor(number_lon)/2.*psdsize,np.floor(number_lat)/2.*psdsize,1)
    header.update('CRVAL1',lcen[0])
    header.update('CRVAL2',bcen[0])

    newHDU_powerfit = pyfits.PrimaryHDU(powerlaw_fit_grid,header=header)
    newHDU_powerfit.writeto(savdir+savname+"_powerlaw_fit_grid_%i.fits" % psdsize,clobber=True)
    newHDU_powerfit = pyfits.PrimaryHDU(angle_grid,header=header)
    newHDU_powerfit.writeto(savdir+savname+"_angle_fit_grid_%i.fits" % psdsize,clobber=True)

    header.update('CD3_3',np.median(rr[1:]-rr[:-1]))
    header.update('CRVAL3',rr[0])
    header.update('CRPIX3',1.0)
    header.update('CUNIT3','Jy^2')
    header.update('CTYPE3','PowerSpec')
    newHDU = pyfits.PrimaryHDU(powerspec_grid,header=header)
    newHDU.writeto(savdir+savname+"_powerspec_grid_%i.fits" % psdsize,clobber=True)

    header.update('CD3_3',np.median(az[1:]-az[:-1]))
    header.update('CRVAL3',az[0])
    header.update('CUNIT3','Jy^2')
    header.update('CTYPE3','AngularPowerSpec')
    newHDU_powerfit = pyfits.PrimaryHDU(anglespec_grid,header=header)
    newHDU_powerfit.writeto(savdir+savname+"_anglespec_grid_%i.fits" % psdsize,clobber=True)

    fig = pylab.figure(2)
    pylab.clf()
    pylab.spectral()
    ax=pylab.subplot(121)
    pylab.imshow(np.arcsinh(data))
    #pylab.imshow(np.log10(data-np.nanmin(data)+1),vmin=-1,vmax=1)
    ax.xaxis.set_major_locator(OffsetMultipleLocator(psdsize,modulus_lon/2.))
    ax.yaxis.set_major_locator(OffsetMultipleLocator(psdsize,modulus_lat/2.))
    ax.xaxis.grid(True,'major')
    ax.yaxis.grid(True,'major')
    pylab.subplot(122)
    pylab.imshow(powerlaw_fit_grid,vmin=-7,vmax=0,extent=[0,powerlaw_fit_grid.shape[1]*psdsize,0,powerlaw_fit_grid.shape[0]*psdsize])
    cax = pylab.axes([0.9225,0.1,0.020,0.80],axisbg='w',frameon=False)
    pylab.colorbar(cax=cax)
    pylab.savefig(savdir+savname+"_powerlaw_fit_grid_%i.png" % (psdsize))


if __name__ == "__main__":
    import glob
    l30test=False
    GRS=True
    GalPlaneV1=False
    GalPlane=True

    if l30test:
        filelist = ['/Volumes/disk3/adam_work/l030/v2.0_l030_13pca_map20.fits','/Users/adam/work/l030/FITS_SDP/bin_l30_plw_projl030.fits']
        l30path = '/Users/adam/work/l030/powerspec_comparison/'
        for psdsize in [512,256,128,64,32]:
            #fit_powerspectra(filelist[0],psdsize=psdsize,doplot=False,nanthreshold=0.25)
            #fit_powerspectra(filelist[1],psdsize=psdsize,doplot=False,nanthreshold=0.25,fwhm=30,largescalecutoff=7200)
            #fit_powerspectra(l30path+'bgps_v2.0_l030_13pca_map20_column.fits', psdsize=psdsize,doplot=False,nanthreshold=0.25)
            #fit_powerspectra(l30path+'bgps_v1.0_l030_13pca_map50_column.fits', psdsize=psdsize,doplot=False,nanthreshold=0.25)
            #fit_powerspectra(l30path+'grs_13CO_mosaic_column.fits',            psdsize=psdsize,doplot=False,nanthreshold=0.25,fwhm=30,largescalecutoff=7200)
            #for fn in glob.glob(l30path+"grs_13CO_mosaic_integ*_column.fits"):
            #    fit_powerspectra(fn,psdsize=psdsize,doplot=False,nanthreshold=0.25,fwhm=30,largescalecutoff=7200)
            fit_powerspectra(l30path+'herschel_250um_column.fits',             psdsize=psdsize,doplot=False,nanthreshold=0.25,fwhm=18,largescalecutoff=7200)
            fit_powerspectra(l30path+'herschel_350um_column.fits',             psdsize=psdsize,doplot=False,nanthreshold=0.25,fwhm=25,largescalecutoff=7200)
            fit_powerspectra(l30path+'herschel_500um_column.fits',             psdsize=psdsize,doplot=False,nanthreshold=0.25,fwhm=36,largescalecutoff=7200)
            

    if GalPlaneV1:
        filelist = glob.glob('/Volumes/disk2/data/bgps/releases/v1.0/v1.0.2/v1*_map50.fits')
        for psdsize in [512,256,128,64,32]:
            for fn in filelist:
                print "Powerspecing file %s with size %i" % (fn,psdsize)
                fit_powerspectra(fn,psdsize=psdsize,doplot=False,nanthreshold=0.25)
    if GalPlane:
        filelist = glob.glob('/Volumes/disk2/data/bgps/releases/v2.0/June2011/v2*_map20.fits')
        for psdsize in [512,256,128,64,32]:
            for fn in filelist:
                print "Powerspecing file %s with size %i" % (fn,psdsize)
                fit_powerspectra(fn,psdsize=psdsize,doplot=False,nanthreshold=0.25)

    if GRS:
        filelist = glob.glob('/Volumes/disk2/data/grs/*int.fits')
        for psdsize in [512,256,128,64,32]:
            for fn in filelist:
                print "Powerspecing file %s with size %i" % (fn,psdsize)
                fit_powerspectra(fn,psdsize=psdsize,doplot=False,nanthreshold=0.25,fwhm=45,largescalecutoff=7200)
