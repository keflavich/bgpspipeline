import mpl_toolkits.axes_grid.parasite_axes as mpltk
import copy
import aplpy
import glob
import pyfits
from agpy import gaussfitter,readcol,azimuthalAverage
import numpy
import pylab
import re
import coords
import pywcs
from scipy.ndimage.interpolation import shift as imshift


targetlist = [
'l012pps','l027pps',            'l044pps','l079pps_2','l080pps','l357pps',
'l000pps','l015pps','l029pps_6',          'l048pps',            'l082pps',
          'l018pps','l029pps_2','l035pps','l050pps','l079pps_4','l351pps',
'l006pps','l021pps','l029pps_3','l040pps','l076pps',            'l354pps',
'l009pps','l024pps','l029pps_4','l042pps','l079pps',            'l357pps']

releaselist = [
'l012',    'l024',       'l045','l079','l079','l357',
'super_gc','l018','l029',       'l050',       'l082',
           'l018','l029','l035','l050','l079','l351',
'l006',    'l024','l029','l040','l077',       'l006',
'l009',    'l024','l029','l045','l079',       'l357']

datedict = {
        'l000pps':['070719_o12-3'],
        #'l002pps':['070718_o14-5'],
        'l006pps':['070714_ob5-6','070715_ob3-4'],
        'l009pps':['070714_o10-9','070717_ob3-4'],
        'l012pps':['070714_o13-4','070715_ob8-9'],
        'l015pps':['070714_o18-9','070714_o34-5'],
        'l018pps':['070714_o22-3','070717_ob8-9'],
        'l021pps':['070714_o26-7','070715_o13-4'],
        'l024pps':['070714_o30-1','070717_o13-4'],
        'l027pps':['070714_o39-0','070715_o18-9'],
        #'l029pps':['070717_o18-9'],#'070731_o10-1'],#,,'070731_o40-1'], all zeros?!
        'l029pps_2':['070731_o12-3','070731_o42-3'],
        'l029pps_3':['070731_o14-5'],#,'070731_o44-5'],
        'l029pps_4':['070731_o17-8'],
        # no source 'l029pps_5':['070731_o19-0'],
        'l029pps_6':['070731_o21-2'],
        #'l030pps_3':['070902_ob3-4'],
        #'l030pps_4':['070902_ob7-8'],
        #'l030pps_5':['070902_o10-9'],
        #'l030pps_6':['070902_o13-4'],
        #'l033pps':['070718_ob3-4'],
        'l035pps':['070714_o43-4','070715_o23-4'],
        'l040pps':['070717_o23-4'],
        'l042pps':['070714_o47-8','070715_o28-9'],
        'l044pps':['070714_o52-3','070718_o22-3'],
        'l048pps':['070714_o56-7','070717_o28-9'],
        'l050pps':['070718_o27-8'], # '070714_o60-1',
        'l076pps':['070718_o36-7'],
        'l079pps':['070714_o64-5','070715_o35-6','070729_o23-4','070731_o27-8','070731_o48-9'],
        'l079pps_2':['070731_o29-0'],
        #'l079pps_3':['070731_o31-2'],
        'l079pps_4':['070731_o34-5'],
        # very weak 'l079pps_5':['070731_o36-7'],
        # 'l080_1pps':['070719_o19-0'], # very weak PPS... why?
        'l080pps':['070714_o68-9','070715_o40-1','070717_o42-3','070729_o25-6'],
        'l082pps':['070714_o72-3','070717_o37-8','070729_o27-8'],
        'l351pps':['070729_o17-8'],
        'l354pps':['070729_o15-6'],
        'l357pps':['070729_o13-4'],
        }


def fit_pps(hdu=None,img=None,header=None,plot=True,figure=pylab.figure(1),
        return_profile=False,return_gaussian_profile=False,verbose=False):

    if hdu is not None:
        img = hdu[0].data
        header = hdu[0].header
    img[img!=img] = 0

    asperpix = -header['CD1_1']*3600.0

    xx,yy = numpy.indices(img.shape)

    # Try to fit, make sure fit is successful
    fitloop = 1
    while fitloop:
        if fitloop == 1:
            # this never works for no reason at all
            fitpars = gaussfitter.gaussfit(img,params=[0,img.max(),img.shape[0]/2,img.shape[1]/2,2,2,0],
                    minpars=[0,img.max()/50.0,0,0,1,1,0],maxpars=[0,0,0,0,6,6,360],
                    limitedmin=[False,True,False,False,True,True,True],limitedmax=[False,False,False,False,True,True,True],
                    fixed=[1,0,0,0,0,0,0])
        elif fitloop == 2:
            if verbose:
                print "Fitloop 1 failed: ",fitpars,".   Trying fitloop2"
            fitpars = gaussfitter.gaussfit(img,params=[0,img.max(),0,0,2,2,0],minpars=[0,img.max()/10.0,0,0,1,1,0],maxpars=[0,0,0,0,6,6,360],
                    limitedmin=[False,True,False,False,True,True,True],limitedmax=[False,False,False,False,True,True,True],
                    fixed=[1,0,0,0,0,0,0],usemoment=[0,0,1,1,0,0,0])
        elif fitloop == 3:
            if verbose:
                print "Fitloop 2 failed: ",fitpars,".   Trying fitloop3"
            fitpars = gaussfitter.gaussfit(img,minpars=[0,img.max()/10.0,0,0,1,1,0],maxpars=[0,0,0,0,6,6,360],
                    limitedmin=[False,True,False,False,True,True,True],limitedmax=[False,False,False,False,True,True,True])
        elif fitloop == 4:
            if verbose:
                print "Fitloop 3 failed: ",fitpars,".   Trying fitloop4"
            fitpars = gaussfitter.gaussfit(img)
        else:
            fitpars = numpy.array(gaussfitter.moments(img,0,1,1))
            print "Using the parameters you specified: ",fitpars
            fitloop = -1

        gaussim = gaussfitter.twodgaussian(fitpars)(xx,yy)

        wxy = fitpars[4:6]*asperpix*numpy.sqrt(8*numpy.log(2))
        mean_fwhm = wxy.sum()/2.0

        if mean_fwhm > 70:
            fitloop += 1
        else: # there were other conditions before...
            if 1:
                if verbose:
                    print "Success.  Fitpars: ",fitpars
                fitloop = 0
            else:
                fitloop += 1

    wcs = pywcs.WCS(header)
    glon,glat = wcs.wcs_pix2sky(fitpars[2:3],fitpars[3:4],0)

    if plot:
        ff = aplpy.FITSFigure(hdu,figure=figure)
        ff.show_grayscale()
        ff.show_circles([glon],[glat],[1./60.],edgecolor='r')
        ff.show_circles([glon],[glat],[2./60.],edgecolor='b')

    if return_gaussian_profile:
        return azimuthalAverage(gaussim,center=fitpars[2:4],returnradii=True)
    elif return_profile:
        return azimuthalAverage(img,center=fitpars[2:4],returnradii=True)
    else:
        return glon,glat

def apphot(hdu,glon,glat,rad_as=60,outerrad_as=120,return_profile=False):

    img = hdu[0].data
    img[img!=img] = 0
    header = hdu[0].header
    wcs = pywcs.WCS(header)

    xc,yc = wcs.wcs_sky2pix(glon,glat,0)

    nr,rr,rprof = azimuthalAverage(img,return_nr=True,center=[xc,yc])

    bmaj = float(header['BMAJ'])
    bmin = float(header['BMIN'])
    cdelt1,cdelt2 = wcs.wcs.cdelt[:2]
    cd1 = cdelt1 * wcs.wcs.cd[0,0]
    cd2 = cdelt2 * wcs.wcs.cd[1,1]
    ppbeam = 2*numpy.pi*bmin*bmaj / abs(cd1*cd2) / (8*numpy.log(2))

    rr_as = (rr) * numpy.abs(cd1) * 3600.0

    nr_cum = nr.cumsum()
    phot = ( rprof * nr ).cumsum() / ppbeam

    inner_ind = numpy.argmin(numpy.abs(rr_as-rad_as))
    outer_ind = numpy.argmin(numpy.abs(rr_as-outerrad_as))
    inner_ap = phot[inner_ind]
    outer_ap = (phot[outer_ind]-phot[inner_ind]) / ( nr_cum[outer_ind]-nr_cum[inner_ind] ) * nr_cum[inner_ind]

    if return_profile:
        return rr_as,phot,inner_ap-outer_ap,outer_ap
    else: 
        return inner_ap-outer_ap,outer_ap

def phot_compare(fname1,fname2,fname3,fignum=2,savename=None,doplot=True,vmin=-0.1,vmax=5.0,outfile=None):
    """
    fname1 = pps
    fname2 = v1.0
    fname2 = v2.0
    """
    fitsfile1 = pyfits.open(fname1)
    fitsfile2 = pyfits.open(fname2)
    fitsfile3 = pyfits.open(fname3)
    glon,glat = fit_pps(fitsfile1,plot=False)
    glon=glon[0]
    glat=glat[0]
    rr1,rprof1,phot1,bg1 = apphot(fitsfile1,glon,glat,return_profile=True)
    rr2,rprof2,phot2,bg2 = apphot(fitsfile2,glon,glat,return_profile=True)
    rr3,rprof3,phot3,bg3 = apphot(fitsfile3,glon,glat,return_profile=True)
    phot1_20,bg1_20 = apphot(fitsfile1,glon,glat,rad_as=20)
    phot2_20,bg2_20 = apphot(fitsfile2,glon,glat,rad_as=20)
    phot3_20,bg3_20 = apphot(fitsfile3,glon,glat,rad_as=20)
    phot1_120,bg1_120 = apphot(fitsfile1,glon,glat,rad_as=120,outerrad_as=240)
    phot2_120,bg2_120 = apphot(fitsfile2,glon,glat,rad_as=120,outerrad_as=240)
    phot3_120,bg3_120 = apphot(fitsfile3,glon,glat,rad_as=120,outerrad_as=240)

    if doplot:
        fig=pylab.figure(fignum)
        pylab.clf()
        #sp1=pylab.subplot(221)
        ff1 = aplpy.FITSFigure(fitsfile1,figure=fig,subplot=[0.1,0.7,0.35,0.3]) #[0.1,0.6,0.35,0.35])
        ff1.show_grayscale(vmin=vmin,vmax=vmax,invert=True)
        ff1.recenter(glon,glat,radius=5./60.)
        ff1.show_markers(glon,glat,marker='x',edgecolor='r')
        ff1.show_circles([glon],[glat],20./3600.,edgecolor='g')
        ff1.show_circles([glon],[glat],120./3600.,edgecolor='b')
        ff1.show_circles([glon],[glat],1./60.,edgecolor='r')
        ff1.show_circles([glon],[glat],4./60.,edgecolor='k')
        pylab.annotate("PPS",[0.9,0.9],xycoords="axes fraction")
        #sp2=pylab.subplot(222)
        ff2 = aplpy.FITSFigure(fitsfile2,figure=fig,subplot=[0.1,0.4,0.35,0.3]) #[0.6,0.6,0.35,0.35])
        ff2.show_grayscale(vmin=vmin,vmax=vmax,invert=True)
        ff2.recenter(glon,glat,radius=5./60.)
        ff2.show_markers(glon,glat,marker='x',edgecolor='r')
        ff2.show_circles([glon],[glat],20./3600.,edgecolor='g')
        ff2.show_circles([glon],[glat],120./3600.,edgecolor='b')
        ff2.show_circles([glon],[glat],1./60.,edgecolor='r')
        ff2.show_circles([glon],[glat],4./60.,edgecolor='k')
        pylab.annotate("v1.0",[0.9,0.9],xycoords="axes fraction")
        #sp3=pylab.subplot(223)
        ff3 = aplpy.FITSFigure(fitsfile3,figure=fig,subplot=[0.1,0.1,0.35,0.3]) #[0.1,0.1,0.35,0.35])
        ff3.show_grayscale(vmin=vmin,vmax=vmax,invert=True)
        ff3.recenter(glon,glat,radius=5./60.)
        ff3.show_markers(glon,glat,marker='x',edgecolor='r')
        ff3.show_circles([glon],[glat],20./3600.,edgecolor='g')
        ff3.show_circles([glon],[glat],120./3600.,edgecolor='b')
        ff3.show_circles([glon],[glat],1./60.,edgecolor='r')
        ff3.show_circles([glon],[glat],4./60.,edgecolor='k')
        pylab.annotate("v2.0",[0.9,0.9],xycoords="axes fraction")
        sp4=pylab.subplot(224)
        pylab.plot(rr1[rr1<=300],rprof1[rr1<=300],label='PPS')
        pylab.plot(rr2[rr2<=300],rprof2[rr2<=300],label='v1.0')
        pylab.plot(rr3[rr3<=300],rprof3[rr3<=300],label='v2.0')
        axlims = pylab.axis()
        pylab.annotate("PPS  120\" phot=%0.3f~%0.3f, 4' BG: %0.3f" % (phot1_120,1.0,bg1_120),[0.6,0.80],xycoords='figure fraction',ha='left',multialignment='left',color='b')
        pylab.annotate("v1.0 120\" phot=%0.3f~%0.3f, 4' BG: %0.3f" % (phot2_120,phot1_120/phot2_120,bg2_120),[0.6,0.775],xycoords='figure fraction',ha='left',multialignment='left',color='b')
        pylab.annotate("v2.0 120\" phot=%0.3f~%0.3f, 4' BG: %0.3f" % (phot3_120,phot1_120/phot3_120,bg3_120),[0.6,0.750],xycoords='figure fraction',ha='left',multialignment='left',color='b')
        pylab.annotate("PPS  ~20\" phot=%0.3f~%0.3f, 2' BG: %0.3f" % (phot1_20,1.0,bg1_20),[0.6,0.725],xycoords='figure fraction',ha='left',multialignment='left',color='g')
        pylab.annotate("v1.0 ~20\" phot=%0.3f~%0.3f, 2' BG: %0.3f" % (phot2_20,phot1_20/phot2_20,bg2_20),[0.6,0.70],xycoords='figure fraction',ha='left',multialignment='left',color='g')
        pylab.annotate("v2.0 ~20\" phot=%0.3f~%0.3f, 2' BG: %0.3f" % (phot3_20,phot1_20/phot3_20,bg3_20),[0.6,0.675],xycoords='figure fraction',ha='left',multialignment='left',color='g')
        pylab.annotate("PPS  ~60\" phot=%0.3f~%0.3f, 2' BG: %0.3f" % (phot1,1.0,bg1),[0.6,0.65],xycoords='figure fraction',ha='left',multialignment='left',color='r')
        pylab.annotate("v1.0 ~60\" phot=%0.3f~%0.3f, 2' BG: %0.3f" % (phot2,phot1/phot2,bg2),[0.6,0.625],xycoords='figure fraction',ha='left',multialignment='left',color='r')
        pylab.annotate("v2.0 ~60\" phot=%0.3f~%0.3f, 2' BG: %0.3f" % (phot3,phot1/phot3,bg3),[0.6,0.60],xycoords='figure fraction',ha='left',multialignment='left',color='r')
        pylab.legend(loc='upper right')
        pylab.vlines( 20,0,axlims[3],'g','--',label='')
        pylab.vlines( 60,0,axlims[3],'r','--',label='')
        pylab.vlines(120,0,axlims[3],'b','--',label='')
        pylab.vlines(240,0,axlims[3],'k','--',label='')
        pylab.axis(axlims)
        pylab.xlabel('Radius (")')
        pylab.ylabel('Integrated Flux Density (Jy)')

        if savename is not None:
            pylab.savefig(savename,bbox_inches='tight')
    #pylab.gca().set_xlim(0,300)

    if outfile is not None:
        print >>outfile,"".join("%20.3f" % p for p in [phot1,bg1,phot2,bg2,phot3,bg3,
            phot1_20,bg1_20,phot2_20,bg2_20,phot3_20,bg3_20,
            phot1_120,bg1_120,phot2_120,bg2_120,phot3_120,bg3_120 ])

    return phot1,phot2,phot3

def make_file_dict(targetlist,releaselist,datedict):
    ppsdir = '/Volumes/disk3/adam_work/ppsmaps/'
    v1dir = '/Volumes/disk2/data/bgps/releases/IPAC/map/'
    v2dir = '/Volumes/disk3/adam_work/'

    filedict = {}
    for name,release in zip(targetlist,releaselist):
        for ii,obsdate in enumerate(datedict[name]):
            newname = name+"_%i"%ii

            filedict[newname] = [ppsdir+name+'/'+obsdate+'_0pca_mask_map10.fits',
                    v1dir+"v1.0.2_"+release+"_13pca_map50_crop.fits",
                    v2dir+release+"/v2.0_"+release+"_13pca_map20.fits"]

    return filedict

if __name__ == "__main__":
    savedir = '/Volumes/disk3/adam_work/ppsmaps/compare_plots/'

    #fname1 = '/Volumes/disk3/adam_work/ppsmaps/l000pps/070719_o12-3_0pca_mask_map10.fits'
    #fname2 = '/Volumes/disk2/data/bgps/releases/IPAC/map/v1.0.2_super_gc_13pca_map50_crop.fits'
    #fname3 = '/Volumes/disk3/adam_work/super_gc/v2.0_super_gc_13pca_map20.fits'
    #phot_compare(fname1,fname2,fname3,savename=savedir+'l000pps_compare.png')
 
    filedict = make_file_dict(targetlist,releaselist,datedict)
    photometry = pylab.zeros([3,len(filedict.keys())])


    """
    outf = open(savedir+'compare_plot_data.txt','w')
    print >>outf,"%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s%20s" % ("Name",
            "PPS_60","PPS_60_bg","v1.0_60","v1.0_60_bg","v2.0_60","v2.0_60_bg",
            "PPS_20","PPS_20_bg","v1.0_20","v1.0_20_bg","v2.0_20","v2.0_20_bg",
            "PPS_120","PPS_120_bg","v1.0_120","v1.0_120_bg","v2.0_120","v2.0_120_bg")

    skip_until = 'l012pps_0' # first
    #skip_until = 'l079pps_2_0' # last
    skip = 1
    for ii,ppsname in enumerate(filedict.keys()):
        if ppsname == skip_until: skip = 0
        if not skip:
            print >>outf,"%20s" % ppsname,#"".join("%20.3f" % p for p in [phot1,phot2,phot3])
            phot1,phot2,phot3 = phot_compare(*filedict[ppsname],savename=savedir+ppsname+"_compare.png",doplot=False,outfile=outf)
            photometry[:,ii] = phot1,phot2,phot3
            print "%20s" % ppsname,"".join("%20.3f" % p for p in [phot1,phot2,phot3])

    outf.close()

    good = photometry[0,:] > 0 
    goodv1 = (photometry[0,:] > 0) * (photometry[1,:] > 0)
    goodv2 = (photometry[0,:] > 0) * (photometry[2,:] > 0)
    correction_factor_v1 = photometry[0,goodv1] / photometry[1,goodv1]
    correction_factor_v2 = photometry[0,goodv2] / photometry[2,goodv2]
    goodv1_lt2 = photometry[0,goodv1] > 2 # (correction_factor_v1 < 2)
    goodv2_lt2 = photometry[0,goodv2] > 2 # (correction_factor_v2 < 2)

    pf1 = pylab.polyfit(photometry[0,goodv1][goodv1_lt2],correction_factor_v1[goodv1_lt2],1)
    pf2 = pylab.polyfit(photometry[0,goodv2][goodv2_lt2],correction_factor_v2[goodv2_lt2],1)

    pylab.figure(3)
    pylab.clf()
    pylab.plot(photometry[0,goodv1],correction_factor_v1,'o',label='v1.0')
    pylab.plot(photometry[0,goodv2],correction_factor_v2,'s',label='v2.0')
    pylab.xlabel('60" flux density in PPS (Jy)')
    pylab.ylabel('S(PPS)/S(BGPS) ``Correction Factor" (60")')
    pylab.axis([0,12,0,2])
    xarr = pylab.linspace(0,12,100)
    pylab.plot(xarr,pylab.polyval(pf1,xarr),'b--',label='y=%0.2fx+%0.2f' % (pf1[0],pf1[1]))
    pylab.plot(xarr,pylab.polyval(pf2,xarr),'g:', label='y=%0.2fx+%0.2f' % (pf2[0],pf2[1]))
    pylab.legend(loc='best')
    pylab.savefig(savedir+'BGPS_correction_factors.png',bbox_inches='tight')

    pylab.figure(4)
    pylab.clf()
    pylab.hist(correction_factor_v1,bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='r')
    pylab.hist(correction_factor_v1[goodv1_lt2],bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='r')
    pylab.hist(correction_factor_v2,bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='b')
    pylab.hist(correction_factor_v2[goodv2_lt2],bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='b')
    pylab.xlabel("S(PPS)/S(BGPS) ``Correction Factor''")
    pylab.savefig(savedir+'BGPS_correction_factor_histograms.png',bbox_inches='tight')
"""

    dat = readcol(savedir+'compare_plot_data.txt',asStruct=True)

    pf1 = pylab.polyfit(dat.PPS_120,dat.PPS_120/dat.v10_120,1)
    pf2 = pylab.polyfit(dat.PPS_120,dat.PPS_120/dat.v20_120,1)

    pylab.figure(3)
    pylab.clf()
    pylab.plot(dat.PPS_120,dat.PPS_120/dat.v10_120,'o',label='v1.0')
    pylab.plot(dat.PPS_120,dat.PPS_120/dat.v20_120,'s',label='v2.0')
    pylab.xlabel('120" flux density in PPS (Jy)')
    pylab.ylabel('S(PPS)/S(BGPS) ``Correction Factor"')
    pylab.axis([0,20,0,2])
    xarr = pylab.linspace(0,20,100)
    pylab.plot(xarr,pylab.polyval(pf1,xarr),'b--',label='y=%0.2fx+%0.2f' % (pf1[0],pf1[1]))
    pylab.plot(xarr,pylab.polyval(pf2,xarr),'g:', label='y=%0.2fx+%0.2f' % (pf2[0],pf2[1]))
    pylab.legend(loc='best')
    pylab.savefig(savedir+'BGPS_correction_factors_120.png',bbox_inches='tight')

    pylab.figure(4)
    pylab.clf()
    pylab.hist(dat.PPS_120/dat.v10_120,bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='r')
    pylab.hist(dat.PPS_120/dat.v20_120,bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='b')
    pylab.xlabel("S(PPS)/S(BGPS) ``Correction Factor'' (120\")")
    pylab.savefig(savedir+'BGPS_correction_factor_histograms_120.png',bbox_inches='tight')


    pylab.figure(3)
    pylab.clf()
    pylab.plot(dat.PPS_20,dat.PPS_20/dat.v10_20,'o',label='v1.0')
    pylab.plot(dat.PPS_20,dat.PPS_20/dat.v20_20,'s',label='v2.0')
    pylab.xlabel('20" flux density in PPS (Jy)')
    pylab.ylabel('S(PPS)/S(BGPS) ``Correction Factor"')
    pylab.axis([0,5,0,2])
    xarr = pylab.linspace(0,5,100)
    pylab.plot(xarr,pylab.polyval(pf1,xarr),'b--',label='y=%0.2fx+%0.2f' % (pf1[0],pf1[1]))
    pylab.plot(xarr,pylab.polyval(pf2,xarr),'g:', label='y=%0.2fx+%0.2f' % (pf2[0],pf2[1]))
    pylab.legend(loc='best')
    pylab.savefig(savedir+'BGPS_correction_factors_20.png',bbox_inches='tight')

    pylab.figure(4)
    pylab.clf()
    pylab.hist(dat.PPS_20/dat.v10_20,bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='r')
    pylab.hist(dat.PPS_20/dat.v20_20,bins=pylab.linspace(0.5,2.0,20),alpha=0.5,color='b')
    pylab.xlabel("S(PPS)/S(BGPS) ``Correction Factor'' (20\")")
    pylab.savefig(savedir+'BGPS_correction_factor_histograms_20.png',bbox_inches='tight')

    
    

    pylab.show()
