import os
import sys
sys.path.append("/Users/adam/work/bgps_pipeline/plotting/")
sys.path.append("/Users/adam/work/bgps_pipeline/analysis/")
import compare_images
import agpy
import pyfits
import numpy as np
from make_powerspec_ratio import make_powerspec_ratio 
import glob

recompare=False
plotfilters=True
makeratio=True

path = '/Volumes/disk3/adam_work/artificial_sims/filter_tests/'

for fn in glob.glob(path+"*reproject*.fits"):
    os.remove(fn)

if len(glob.glob(path+"*reproject*.fits")) > 0:
    raise Exception("Haven't cleared out reprojections")

exppath = '/Volumes/disk3/adam_work/artificial_sims/exp12_simple/'
infilename = 'exp12_ds2_astrosky_arrang45_atmotest_amp5.0E+02_sky00_seed00_peak050.00_nosmooth'
smoothfilename = 'exp12_ds2_astrosky_arrang45_atmotest_amp5.0E+02_sky00_seed00_peak050.00_smooth'
infile = exppath+infilename
smoothfile = exppath+smoothfilename

inputmappath = infile+"_inputmap.fits"
inputmap = pyfits.getdata(inputmappath)
hdr = pyfits.getheader(inputmappath)

smoothmappath = smoothfile+"_inputmap.fits"
smoothed_inputmap = agpy.smooth(inputmap,33.0/7.2/np.sqrt(8*np.log(2)))
smoothed_HDU = pyfits.PrimaryHDU(data=smoothed_inputmap,header=hdr)
smoothed_HDU.writeto(path+infilename+"_smoothed.fits",clobber=True,output_verify='fix')


savename = path+infilename
stfname = savename+"_stf.fits"

yy,xx = np.indices([512,512])
rr = np.sqrt((xx-255.5)**2+(yy-255.5)**2)
gg = np.exp(-(rr*7.2)**2/(2*(33/2.35)**2))
kk = rr/512.
gg_ft = np.exp(-(kk/7.2*np.pi)**2 * 2*(33.0/2.35)**2 ) # normalization sqrt(2*np.pi*(33.0/2.35)**2) 
gg_ft_large = np.exp(-(kk/7.2*np.pi)**2 * 2*(280.0/2.35)**2 ) 
psf = pyfits.getdata('/Users/adam/work/bgps_pipeline/simulation/model_psf_512.fits')
psf_ft = (np.fft.fftshift(np.fft.fft2(psf)))
gg_large =  np.abs(np.fft.fftshift(np.fft.ifft2(gg_ft_large)))
gginv_large = np.abs(np.fft.fftshift(np.fft.ifft2(1-gg_ft_large)))
gginv_ft_large = np.fft.fft2(gginv_large)

kernel_ft = psf_ft * (1-gg_ft_large)
kernel_ft /= kernel_ft.max()
kernel = (np.fft.ifft2(kernel_ft))

# DEBUG from pylab import *
# DEBUG figure(5); clf()
# DEBUG subplot(221); imshow(log10(real(kernel))); colorbar()
# DEBUG subplot(222); imshow(log10(imag(kernel))); colorbar()
# DEBUG subplot(223); imshow(log10(real(kernel_ft))); colorbar()
# DEBUG subplot(224); imshow(log10(imag(kernel_ft))); colorbar()

filtered_inputmap = np.fft.fftshift( np.abs( np.fft.ifft2( np.fft.fftshift(np.fft.fft2(inputmap)) * kernel_ft ) ) )
filtered_inputmap = agpy.convolve(inputmap,psf) - agpy.convolve(inputmap,gg_large)
filtered_HDU = pyfits.PrimaryHDU(data=filtered_inputmap,header=hdr)
filteredmappath = path+infilename+"_filtered.fits"
filtered_HDU.writeto(filteredmappath,clobber=True,output_verify='fix')

if recompare:
    f1 = inputmappath
    f2 = path+infilename+"_smoothed.fits"

    imn1 = "Input"
    imn2 = "Smoothed (Gaussian)"
    CF = compare_images.compare_files(f1, f2, imn1, imn2, savename=savename+"_smoothcompare.png", 
            savename_psd=savename+"_smoothpsds.png", units="Jy", 
            oneone="black", 
            title="Input-Smooth Compare",
            savename_stf=savename+"_smoothed_stf.png" ,
            cuts=[1,5], header='subimage.hdr')

    f2 = filteredmappath
    imn2 = "Filtered"
    CF = compare_images.compare_files(f1, f2, imn1, imn2, savename=savename+"_filtercompare.png", 
            savename_psd=savename+"_filterpsds.png", units="Jy", 
            oneone="black", 
            title="Input-Filter Compare",
            savename_stf=savename+"_filtered_stf.png" ,
            cuts=[1,5], header='subimage.hdr')

    f1 = smoothfile+"_map20.fits"
    f2 = path+infilename+"_smoothed.fits"
    imn1 = "Map20"
    imn2 = "Smoothed"
    CF = compare_images.compare_files(f2, f1, imn2, imn1, savename=savename+"_map20smoothcompare.png", 
            savename_psd=savename+"_map20smoothpsds.png", units="Jy", 
            oneone="black", 
            title="Smooth-Map20 Compare",
            savename_stf=savename+"_map20smoothed_stf.png" ,
            cuts=[1,5], header='subimage.hdr')
    f2 = path+infilename+"_filtered.fits"
    imn2 = "Filtered"
    CF = compare_images.compare_files(f1, f2, imn1, imn2, savename=savename+"_map20filtercompare.png", 
            savename_psd=savename+"_map20filterpsds.png", units="Jy", 
            oneone="black", 
            title="Map20-Filter Compare",
            savename_stf=savename+"_map20filtered_stf.png" ,
            cuts=[1,5], header='subimage.hdr')
    CF = compare_images.compare_files(inputmappath, f1, "Input", "Map20", savename=savename+"_inputmap20compare.png", 
            savename_psd=savename+"_inputmap20psds.png", units="Jy", 
            oneone="black", 
            title="Input-Map20 Compare",
            savename_stf=savename+"_inputmap20_stf.png" ,
            cuts=[1,5], header='subimage.hdr')
    CF = compare_images.compare_files(inputmappath, smoothmappath, "Input", "Smoothed (PSF)", savename=savename+"_inputsmoothcompare.png", 
            savename_psd=savename+"_inputsmoothpsds.png", units="Jy", 
            oneone="black", 
            title="Input-Smooth Compare",
            savename_stf=savename+"_inputsmoothed_stf.png" ,
            cuts=[1,5], header='subimage.hdr')
    CF = compare_images.compare_files(filteredmappath, smoothmappath, "Filtered (PSF+large)", "Smoothed (PSF)", savename=savename+"_filteredsmoothcompare.png", 
            savename_psd=savename+"_filteredsmoothpsds.png", units="Jy", 
            oneone="black", 
            title="Filtered-Smooth Compare",
            savename_stf=savename+"_filteredsmoothed_stf.png" ,
            cuts=[1,5], header='subimage.hdr')

if makeratio:
    make_powerspec_ratio(inputmappath,path+infilename+"_smoothed.fits",stfname,clobber=True)
    make_powerspec_ratio(inputmappath,smoothfile+"_map20.fits",path+smoothfilename+"_map20stf.fits",clobber=True)
    make_powerspec_ratio(inputmappath,infile+"_map20.fits",path+infilename+"_map20stf.fits",clobber=True)
    make_powerspec_ratio(inputmappath,smoothmappath,path+infilename+"_smoothstf.fits",clobber=True)
    make_powerspec_ratio(inputmappath,filteredmappath,path+infilename+"_filteredstf.fits",clobber=True)

if plotfilters:
    import spectrum
    sp1 = spectrum.Spectrum(stfname)
    sp2 = spectrum.Spectrum(path+infilename+"_filteredstf.fits")
    sp3 = spectrum.Spectrum(path+smoothfilename+"_map20stf.fits")
    sp4 = spectrum.Spectrum(path+infilename+"_smoothstf.fits")
    sp5 = spectrum.Spectrum(path+infilename+"_map20stf.fits")
    sp1.plotter(figure=1,label='Smoothed (Theory)')
    sp2.plotter(figure=1,clear=False,color='r',label='Filtered')
    sp3.plotter(figure=1,clear=False,color='b',label='Map20')
    sp4.plotter(figure=1,clear=False,color='g',label='Smoothed')
    sp5.plotter(figure=1,clear=False,color='purple',label='Map20 (no smooth)')
    yticks = np.array([0.0,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1.0,1.1,1.2])
    sp1.plotter.axis.yaxis.set_ticks(yticks**2)
    sp1.plotter.axis.yaxis.set_ticklabels(["%0.2f" % s for s in yticks])
    sp1.plotter.reset_limits(ymin=0,ymax=1.5,xmin=0,xmax=0.05)
    sp1.plotter.axis.legend(loc='lower right')
    sp1.plotter.savefig('filterfunctions.png')
    sp1.smooth(2)
    sp2.smooth(2)
    sp3.smooth(2)
    sp4.smooth(2)
    sp5.smooth(2)
    sp1.plotter(figure=1,label='Smoothed (Theory)')
    sp2.plotter(figure=1,clear=False,color='r',label='Filtered')
    sp3.plotter(figure=1,clear=False,color='b',label='Map20')
    sp4.plotter(figure=1,clear=False,color='g',label='Smoothed')
    sp5.plotter(figure=1,clear=False,color='purple',label='Map20 (no smooth)')
    sp1.plotter.axis.yaxis.set_ticks(yticks**2)
    sp1.plotter.axis.yaxis.set_ticklabels(["%0.2f" % s for s in yticks])
    sp1.plotter.reset_limits(ymin=0,ymax=1.5,xmin=0,xmax=0.05)
    sp1.plotter.axis.legend(loc='lower right')
    sp1.plotter.savefig('filterfunctions_smoothedx2.png')

"""
xind = arange(512)*7.2
gaussian = exp(-xind**2/(2*(33.0/2.35)**2) ) 
gaussian_ft = abs(fft(gaussian/gaussian.sum()))
wavenum = fftfreq(512)
gaussian_ft_analytic = exp(-(wavenum/7.2*pi)**2 * 2*(33.0/2.35)**2 ) # normalization sqrt(2*pi*(33.0/2.35)**2) 
spatial_scale = 7.2/wavenum

sp.plotter.axis.plot(wavenum/7.2,gaussian_ft_analytic)
sp.plotter.axis.plot(wavenum/7.2,gaussian_ft)
"""
