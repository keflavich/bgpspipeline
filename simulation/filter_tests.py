from pylab import *
import numpy
from agpy import convolve,smooth
import pyfits
from mpi4py import MPI

l111 = pyfits.open('v1.0.2_l111_13pca_deconv_sim_map50.fits')
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
    for ii,rad in enumerate([100,210,240,270,300,330,360,400,500,600,700,800,900,1000]):
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
    
