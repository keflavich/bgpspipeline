import pyfits
from pylab import *
"""
Number density conversions to determine cutoffs:
    NH2 = 1.8e20 cm^-2 / K km/s
    NH2 = 2.5e22 cm^-2 / Jy
    BGPS / CO = 138.888
    CO / BGPS = .0072
    300 mJy <-> 41.7 K km/s
    200 mJy <-> 27.8 K km/s
    100 mJy <-> 13.9 K km/s
    50 K km/s <-> 360 mJy
    100 K km/s <-> 720 mJy
    150 K km/s <-> 1080 mJy
    300 mJy/bm <-> 14.1 mJy <-> 1.96 K km/s <-> 6.72 K km/s / bm

    1 Jy/bm = 55.6 MJy / sr

    BGPS beamsize:
    In [26]: (31.2/2/3600/180*pi)**2*pi
    Out[26]: 1.7970030037622326e-08
    or 21.3 pixels/beam

    Dame beamsize:
    In [41]: (8.1/2/60/180*pi)**2*pi
    Out[41]: 4.3602576581671602e-06
    or 3.43 pixels/beam

"""

def averageplot(file,outf,binsize=.1,lmin=-10.5,lmax=84.5):

    fitsfile = pyfits.open(file)
    hdr = fitsfile[0].header
    map = fitsfile[0].data.T

    if hdr.has_key('CD1_1'):
        cd11=hdr['CD1_1']
        cd22=hdr['CD2_2']
    else:
        cd11=hdr['CDELT1']
        cd22=hdr['CDELT2']
    crval1=hdr['CRVAL1']
    crval2=hdr['CRVAL2']
    crpix1=hdr['CRPIX1']
    crpix2=hdr['CRPIX2']

    nx,ny = map.shape
    xind,yind = arange(nx),arange(ny)

    lind = (xind-crpix1)*cd11+crval1
    bind = (yind-crpix2)*cd22+crval2
    lind[lind > 360] -= 360
    if lmax < max(lind):
        eastmost = argmin(abs(lind-lmax))
    else:
        eastmost=0
    if lmin > min(lind):
        westmost = argmin(abs(lind-lmin))
    else:
        westmost=nx

    avgs=[]
    meds=[]
    lowsigs=[]
    highsigs=[]
    low2sigs=[]
    high2sigs=[]

    for j in xrange(len(binsize)):
        outfile=open(outf.replace(".txt","_binsize%2.2f.txt" % binsize[j]),'w')
        print >>outfile,"%16s%2.2f" % ("longitude_bin",binsize[j]),
        print >>outfile,"%25s%25s%25s%25s%25s%25s" % ("avg","med","lowsig","highsig","low2sig","high2sig")

        npix = round(abs(1/cd11) * binsize[j])

        lzero = argmin(abs(lind))
        bzero = argmin(abs(bind))
        neast = int(floor((lzero-eastmost) / npix))
        nwest = int(floor((abs(westmost-lzero)) / npix))
        least = lzero - npix * neast

        yu = floor(bzero + .5/cd22)
        yl = ceil(bzero - .5/cd22)

        nperbin = npix * ceil(yu-yl)
        lbin = zeros(neast+nwest)
        avg = zeros(neast+nwest)
        med = zeros(neast+nwest)
        lowsig = zeros(neast+nwest)
        highsig = zeros(neast+nwest)
        low2sig = zeros(neast+nwest)
        high2sig = zeros(neast+nwest)

        for i in xrange(neast+nwest):
            xl = floor(least + npix * i)
            xu = floor(least + npix * (i+1))
            lbin[i] = lind[floor(least + npix * (i+.5))]
            mapcrop = map[xl:xu,yl:yu]
            avg[i] = mapcrop.mean()
            med[i] = median(mapcrop)
            lowsig[i] = sort(mapcrop.ravel())[round((xu-xl)*(yu-yl) * 0.158655)]
            highsig[i] = sort(mapcrop.ravel())[round((xu-xl)*(yu-yl) * 0.8413447)]
            low2sig[i] = sort(mapcrop.ravel())[round((xu-xl)*(yu-yl) * 0.02275)]
            high2sig[i] = sort(mapcrop.ravel())[round((xu-xl)*(yu-yl) * 0.97725)]
            if lowsig[i] > highsig[i]:
                import pdb; pdb.set_trace()

        avgs.append(avg)
        meds.append(med)
        lowsigs.append(lowsig)
        highsigs.append(highsig)
        low2sigs.append(low2sig)
        high2sigs.append(high2sig)

        lbin[lbin>180] -= 360
        outarray = concatenate((lbin[newaxis,:],asarray(avgs),asarray(meds),asarray(lowsigs),asarray(highsigs),asarray(low2sigs),asarray(high2sigs))).T
        print >>outfile,"\n".join(
                ["%20f%25f%25f%25f%25f%25f%25f" % tuple(outarray[c,:].tolist())
                    for c in xrange(outarray.shape[0]) ] )
        outfile.close()
        avgs=[]
        meds=[]
        lowsigs=[]
        highsigs=[]
        low2sigs=[]
        high2sigs=[]

def fillingfactorplot(file,outf,cutoff=.3,binsize=.1,lmin=-10.5,lmax=84.5):

    fitsfile = pyfits.open(file)
    hdr = fitsfile[0].header
    map = fitsfile[0].data.T

    if hdr.has_key('CD1_1'):
        cd11=hdr['CD1_1']
        cd22=hdr['CD2_2']
    else:
        cd11=hdr['CDELT1']
        cd22=hdr['CDELT2']
    crval1=hdr['CRVAL1']
    crval2=hdr['CRVAL2']
    crpix1=hdr['CRPIX1']
    crpix2=hdr['CRPIX2']

    nx,ny = map.shape
    xind,yind = arange(nx),arange(ny)

    lind = (xind-crpix1)*cd11+crval1
    bind = (yind-crpix2)*cd22+crval2
    lind[lind > 360] -= 360
    if lmax < max(lind):
        eastmost = argmin(abs(lind-lmax))
    else:
        eastmost=0
    if lmin > min(lind):
        westmost = argmin(abs(lind-lmin))
    else:
        westmost=nx

    novers=[]
    fracs=[]

#    clf()

    for j in xrange(len(binsize)):
        outfile=open(outf.replace(".txt","_binsize%2.2f.txt" % binsize[j]),'w')
        print >>outfile,"%16s%2.2f" % ("longitude_bin",binsize[j]),
        print >>outfile,"".join([ "%25s%25s" % ("n_over_%2.2f" % cutoff[i % len(cutoff)],"fraction_over_%2.2f" % cutoff[i % len(cutoff)])
            for i in xrange(len(cutoff))])
        for k in xrange(len(cutoff)):
            npix = round(abs(1/cd11) * binsize[j])

            lzero = argmin(abs(lind))
            bzero = argmin(abs(bind))
            neast = int(floor((lzero-eastmost) / npix))
            nwest = int(floor((abs(westmost-lzero)) / npix))
            least = lzero - npix * neast

            yu = floor(bzero + .5/cd22)
            yl = ceil(bzero - .5/cd22)

            nperbin = npix * ceil(yu-yl)
            lbin = zeros(neast+nwest)
            nover = zeros(neast+nwest)
            frac = zeros(neast+nwest)

            for i in xrange(neast+nwest):
                xl = floor(least + npix * i)
                xu = floor(least + npix * (i+1))
                lbin[i] = lind[floor(least + npix * (i+.5))]
                nover[i] = (map[xl:xu,yl:yu] > cutoff[k]).sum()
                frac[i] = double(nover[i]) / double(nperbin)
#            import pdb; pdb.set_trace()

            fracs.append(frac)
            novers.append(nover)

#            xlabel('Galactic Longitude'); ylabel('Fraction over cutoff')
#            plot(lbin,frac,ls='steps',label='Cutoff %2.2f' % cutoff[k])
        lbin[lbin>180] -= 360
        outarray = concatenate((lbin[newaxis,:],asarray(novers),asarray(fracs))).T
        print >>outfile,"\n".join(
                ["".join(["%20f" % outarray[c,0]]+["%25f%25f" % (outarray[c,1+d],outarray[c,1+len(novers)+d])
                    for d in xrange(len(novers))]) 
                    for c in xrange(outarray.shape[0]) ] )
        outfile.close()
        fracs=[]
        novers=[]
#    legend()

if __name__=="__main__":
    rcParams['text.usetex']=True
    rcParams['font.family'] = 'serif'
    rcParams['font.serif'][0] = 'Times New Roman'
    rcParams['font.size'] = 16.0
    prefix = '/Volumes/disk2/data/bgps/releases/v1.0/v1.0.2/'
    #mosaic = prefix+'MOSAIC.fits'
    mosaic = '/Volumes/disk2/data/bgps/releases/IPAC/MOSAIC_snmap.fits'
    outf = prefix+'fillfact_v1.0.2.txt'
    #fillingfactorplot(mosaic,outf,cutoff=[0.1,0.3,0.5],binsize=[0.1,0.5,1.0],lmin=-10.5,lmax=90.5)
    fillingfactorplot(mosaic,outf,cutoff=[3,9,12],binsize=[0.1,0.5,1.0],lmin=-10.5,lmax=90.5)
    from agpy import readcol
    binpt1 = readcol(prefix+'fillfact_v1.0.2_binsize0.10.txt',asStruct=True)
    binpt5 = readcol(prefix+'fillfact_v1.0.2_binsize0.50.txt',asStruct=True)
    bin1   = readcol(prefix+'fillfact_v1.0.2_binsize1.00.txt',asStruct=True)

    comosaic = '/Volumes/disk2/data/co/Wco_DHT2001.fits'
    cooutf = prefix+'cofillfact_v1.0.2.txt'
    fillingfactorplot(comosaic,cooutf,cutoff=[50,100,150],binsize=[0.1,0.5,1.0],lmin=-10.5,lmax=90.5)
    cobinpt1 = readcol(prefix+'cofillfact_v1.0.2_binsize0.10.txt',asStruct=True)
    cobinpt5 = readcol(prefix+'cofillfact_v1.0.2_binsize0.50.txt',asStruct=True)
    cobin1   = readcol(prefix+'cofillfact_v1.0.2_binsize1.00.txt',asStruct=True)

    fig = figure(1); clf();
    from mpl_toolkits.axes_grid.parasite_axes import SubplotHost
    host = SubplotHost(fig,111)
    rcParams[ 'xtick.labelsize' ] = 24
    rcParams[ 'ytick.labelsize' ] = 24
    rcParams[ 'font.size' ] = 24
    import scipy.stats as stats
    sig3 = 1-stats.halfnorm.cdf(3)
    host.plot(bin1.longitude_bin100,bin1.fraction_over_300-sig3,'k',drawstyle='steps-mid')
    host.set_xlim(-10.5,90.5)
    host.set_ylim(0,0.35)
    host.set_xlabel("Galactic Longitude",fontsize='24')
    host.set_ylabel("Fraction above 3$\sigma$ ",fontsize='24')
    ax2 = host.twinx()
    ax2.plot(cobin1.longitude_bin100,cobin1.fraction_over_10000,'k--',drawstyle='steps-mid')
    ax2.set_ylabel("Fraction over 100 K km s$^{-1}$")
    ax2.set_xlim(-10.5,90.5)
    fig.add_axes(host)
    fig.add_axes(ax2)
    
    savefig('/Users/adam/work/bgps_pipeline/methods/fillingfactor_0.1jy.eps',bbox_inches='tight')
    savefig('/Users/adam/work/bgps_pipeline/methods/fillingfactor_0.1jy.pdf',bbox_inches='tight')

    ax3 = host.twinx()
    ax3.plot(cobin1.longitude_bin100,cobin1.fraction_over_5000,'k:',drawstyle='steps-mid')
    #new_axisline = ax3.get_grid_helper().new_fixed_axis
    #ax3.axis['right2'] = new_axisline(loc='right',axes=ax3,offset=[60,0])
    #ax3.axis['right2'].label.set_visible(True)
    #ax3.axis['right2'].set_label("Fraction over 50 K km s$^{-1}$")
    ax2.set_ylabel("Fraction over 50 (..) 100 (- -) K km s$^{-1}$")
    ax3.set_xlim(-10.5,90.5)
    fig.add_axes(ax3)
    savefig('/Users/adam/work/bgps_pipeline/methods/fillingfactor_0.1jy_bothCO.eps',bbox_inches='tight')
    savefig('/Users/adam/work/bgps_pipeline/methods/fillingfactor_0.1jy_bothCO.pdf',bbox_inches='tight')

    fig2 = figure(2); clf()
    noisemap = '/Volumes/disk2/data/bgps/releases/IPAC/MOSAIC_noisemap.fits'
    averageplot(noisemap,prefix+"meannoise_v1.0.2.txt",binsize=[0.1,0.5,1.0],lmin=-10.5,lmax=90.5)
    bin1noise = readcol(prefix+'meannoise_v1.0.2_binsize1.00.txt',asStruct=True)
    binpt5noise = readcol(prefix+'meannoise_v1.0.2_binsize0.50.txt',asStruct=True)
    plot(binpt5noise.longitude_bin050,binpt5noise.med,'k') #,drawstyle='steps')
    xlabel('Galactic Longitude',fontsize='24')
    ylabel('RMS noise (Jy/bm)',fontsize='24')
    axis([-10,90.5,0,0.06])
    grid()
    savefig('/Users/adam/work/bgps_pipeline/methods/noiseperdegree.eps',bbox_inches='tight')
    savefig('/Users/adam/work/bgps_pipeline/methods/noiseperdegree.pdf',bbox_inches='tight')
    fill_between(binpt5noise.longitude_bin050,binpt5noise.lowsig,binpt5noise.highsig,color='#CCCCCC')
    axis([-10,90.5,0,0.06])
    savefig('/Users/adam/work/bgps_pipeline/methods/noiseperdegree_1sigfill.eps',bbox_inches='tight')
    savefig('/Users/adam/work/bgps_pipeline/methods/noiseperdegree_1sigfill.pdf',bbox_inches='tight')
    draw()
