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

    outfile=open(outf,'w')
    print >>outfile,"%20s" % "longitude",
    print >>outfile,"".join([ "%25s%25s" % ("n_over_%2.2f" % cutoff[i % len(cutoff)],"fraction_over_%2.2f" % cutoff[i % len(cutoff)])
        for i in xrange(len(binsize)*len(cutoff))])
    for j in xrange(len(binsize)):
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
        outarray = concatenate((lbin[newaxis,:],asarray(novers),asarray(fracs))).T
        print >>outfile,"\n".join(
                ["".join(["%20f" % outarray[c,0]]+["%25f%25f" % (outarray[c,1+d],outarray[c,1+len(novers)+d])
                    for d in xrange(len(novers))]) 
                    for c in xrange(outarray.shape[0]) ] )
        fracs=[]
        novers=[]
#    legend()
