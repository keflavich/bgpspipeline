from pylab import *
import numpy
from agpy import convolve,smooth,psds,correlate2d
import pyfits
from mpi4py import MPI

l111 = pyfits.open('v1.0.2_l111_13pca_deconv_sim_map50.fits')
l111_20 = pyfits.open('v1.0.2_l111_13pca_deconv_sim_map20.fits')
l111n = pyfits.open('v1.0.2_l111_13pca_lastnoisemap.fits')
l111m = pyfits.open('v1.0.2_l111_13pca_lastmap.fits')
l111i = pyfits.open('v1.0.2_l111_13pca_deconv_sim_initial.fits')
img = l111i[0].data
pipeimg = l111[0].data

imgf = zeros([1280,1280])
pipeimgf = zeros([1280,1280])
xx,yy = indices([1280,1280])
rr = 7.2 * sqrt((xx-1280/2.0)**2+(yy-1280/2.0)**2)

imgf[:1155,:1151] = img
pipeimgf[:1155,:1151] = pipeimg
imgf[imgf!=imgf] = 0

brfs={}
brsms={}

myrank = MPI.COMM_WORLD.Get_rank()
nprocs = MPI.COMM_WORLD.Get_size()
procnm = MPI.Get_processor_name()

if 1:
    psdi = psds.PSD2(l111i[0].data)
    psdm = psds.PSD2(l111m[0].data)
    psdp = psds.PSD2(l111[0].data)
    psdp20 = psds.PSD2(l111_20[0].data)
    psdn = psds.PSD2(l111n[0].data)    
    figure(1)
    clf()
    loglog(7.2/psdn[0],psdn[1],label='Noise')
    loglog(7.2/psdi[0],psdi[1],label='Initial')
    loglog(7.2/psdm[0],psdm[1],label='Original L111 field')
    loglog(7.2/psdp20[0],psdp20[1],label='20 iter')
    loglog(7.2/psdp[0],psdp[1],label='50 iter')
    legend(loc='best')
    xlabel('Spatial Scale (")')
    ylabel('Power (arbitrary units - maybe Jy$^2$)')
    axis([7,6e3,5e2,1e10])
    savefig('deconv_sim_PSDSs.png')

    figure(2)
    clf()
    loglog(psdn[0]/7.2,psdn[1],label='Noise')
    loglog(psdi[0]/7.2,psdi[1],label='Initial')
    loglog(psdm[0]/7.2,psdm[1],label='Original L111 field')
    loglog(psdp20[0]/7.2,psdp20[1],label='20 iter')
    loglog(psdp[0]/7.2,psdp[1],label='50 iter')
    legend(loc='best')
    xlabel('Spatial Frequency (1/")')
    ylabel('Power (Jy$^2$)')
    axis([0.00015,0.15,5e2,1e10])
    savefig('deconv_sim_wavenum_PSDSs.png')

    

if 0: 
    for ii,rad in enumerate([100]): #,210,240,270,300,330,360,400,500,600,700,800,900,1000]):
        if (ii % nprocs != myrank):
            continue
        #brfs[rad] = exp(-(rr*7.2)**2/(2.0*(rad/2.35)**2)) / exp(-(rr*7.2)**2/(2.0*(rad/2.35)**2)).sum()
        #kernel = numpy.sinc(2*numpy.pi*rr/rad) 
        #kernel /= kernel.sum()
        #brsms[rad] = convolve(imgf,kernel)
        brickwalled = smooth(imgf,rad/7.2,'brickwall')
        gaussianed = smooth(imgf,rad/2.35/7.2,'gaussian')
        tophatted = smooth(imgf,rad/7.2,'tophat')
        figure(ii); clf()
        spectral()
        subplot(221)
        imshow(img,vmin=-1,vmax=10)
        title("Input Image")
        colorbar()
        subplot(222)
        imshow((img-pipeimg)-tophatted[:1155,:1151],vmin=-1,vmax=1)
        title('Filtered with %i" radius tophat' % rad)
        colorbar()
        subplot(223)
        imshow((img-pipeimg)-gaussianed[:1155,:1151],vmin=-1,vmax=1)
        title("Filtered with %i\" FWHM Gaussian" % rad)
        colorbar()
        subplot(224)
        imshow((img-pipeimg)-brickwalled[:1155,:1151],vmin=-1,vmax=1)
        title('Filtered with %i" Brick Wall' % rad)
        colorbar()
        savefig("%iarc_brickwall_filter_sim.png" % rad)
        figure(ii); clf()
        spectral()
        subplot(221)
        imshow(img-pipeimg,vmin=-1,vmax=10)
        title("Input Image - Pipeline Image")
        colorbar()
        subplot(222)
        imshow(tophatted[:1155,:1151],vmin=-1,vmax=10)
        title('Smoothed with %i" radius tophat' % rad)
        colorbar()
        subplot(223)
        imshow(gaussianed[:1155,:1151],vmin=-1,vmax=10)
        title("Smoothed with %i\" FWHM Gaussian" % rad)
        colorbar()
        subplot(224)
        imshow(brickwalled[:1155,:1151],vmin=-1,vmax=10)
        title('Smoothed with %i" Brick Wall' % rad)
        colorbar()
        savefig("%iarc_smooth_sim.png" % rad)

if 0:
    subplot(221)
    imshow(img)
    colorbar()
    title("Input Image")
    subplot(222)
    img_gs = (smooth(imgf,300/7.2,'gaussian'))[:1155,:1151]
    imshow(img_gs)
    colorbar()
    title("Convolved with 300\" Sigma Gaussian")
    subplot(223)
    img_th = (smooth(imgf,300/7.2,'tophat'))[:1155,:1151]
    imshow(img_th)
    colorbar()
    title("Convolved with 300\" radius tophat")
    subplot(224)
    img_th = (smooth(imgf,300/7.2,'brickwall'))[:1155,:1151]
    imshow(img_th)
    colorbar()
    title("Convolved with 300\" radius 2D sinc (300\" Brick Wall)")
    savefig("smoothing_comparison.png")
    
