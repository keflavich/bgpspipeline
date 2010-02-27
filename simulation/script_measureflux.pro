

;set_plot,'ps'
;loadct,39
;device,filename=getenv('WORKINGDIR')+'/sim_figures/deconvolution_comparison_ic1396.ps',/encapsulated,bits=16,/color
;path = getenv('WORKINGDIR2')+'/ic1396/'
;measure_flux,path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_initial.fits',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
;measure_flux,path+'v1.0.2_ic1396_13pca_deconv_21.6_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_21.6_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
;measure_flux,path+'v1.0.2_ic1396_13pca_deconv_31.2_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_31.2_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
;measure_flux,path+'v1.0.2_ic1396_13pca_deconv_7.2_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_7.2_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_7.2_sim_initial.fits',/doplot,/overplot,color=100,thick=3,xax=xax4,yax=yax4
;legend,['7.2"','14.4"','21.6"','31.2"'],psym=[1,1,1,1],color=[100,0,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
;device,/close_file
;device,filename=getenv('WORKINGDIR')+'/sim_figures/deconvolution_comparison_nolegend_ic1396.ps',/encapsulated,bits=16,/color
;plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
;oplot,xax2,yax2,thick=3,color=250
;oplot,xax3,yax3,thick=3,color=150
;oplot,xax4,yax4,thick=3,color=100
;device,/close_file
;
;device,filename=getenv('WORKINGDIR')+'/sim_figures/pca_comparison_ic1396.ps',/encapsulated,bits=16,/color
;measure_flux,path+'v1.0.2_ic1396_31pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_31pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_31pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
;measure_flux,path+'v1.0.2_ic1396_26pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_26pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_26pca_deconv_sim_initial.fits',/doplot,/overplot,color=175,thick=3,xax=xax2,yax=yax2
;measure_flux,path+'v1.0.2_ic1396_21pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_21pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_21pca_deconv_sim_initial.fits',/doplot,/overplot,color=125,thick=3,xax=xax2,yax=yax2
;measure_flux,path+'v1.0.2_ic1396_16pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_16pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_16pca_deconv_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
;measure_flux,path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_initial.fits',/doplot,/overplot,color=225,thick=3,xax=xax3,yax=yax3
;measure_flux,path+'v1.0.2_ic1396_10pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_10pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_10pca_deconv_sim_initial.fits',/doplot,/overplot,color=200,thick=3,xax=xax4,yax=yax4
;measure_flux,path+'v1.0.2_ic1396_7pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_7pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_7pca_deconv_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax5,yax=yax5
;measure_flux,path+'v1.0.2_ic1396_3pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_3pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_3pca_deconv_sim_initial.fits',/doplot,/overplot,color=50,thick=3,xax=xax6,yax=yax6
;legend,['31','26','21','16','13','10','7','3'],psym=[1,1,1,1,1,1,1,1],color=[0,175,125,250,225,200,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
;device,/close_file
;device,filename=getenv('WORKINGDIR')+'/sim_figures/pca_comparison_nolegend_ic1396.ps',/encapsulated,bits=16,/color
;plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
;oplot,xax2,yax2,thick=3,color=250
;oplot,xax3,yax3,thick=3,color=200
;oplot,xax4,yax4,thick=3,color=150
;oplot,xax5,yax5,thick=3,color=100
;oplot,xax6,yax6,thick=3,color=50
;device,/close_file

set_plot,'ps'
loadct,39
path = getenv('WORKINGDIR2')+'/l111/'
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_aperture.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_20arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1,aperture=20/7.2   ,psym=1,color=0
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_40arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax2,yax=yax2,aperture=40/7.2   ,/overplot,color=100,psym=2
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_60arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax3,yax=yax3,aperture=60/7.2   ,/overplot,color=250,psym=4
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_80arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax4,yax=yax4,aperture=80/7.2   ,/overplot,color=150,psym=5
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_100arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax5,yax=yax5,aperture=100/7.2 ,/overplot,color=50,psym=6
legend,['20"','40"','60"','80"','100"'],psym=[1,2,4,5,6],color=[0,100,250,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_aperture_lines.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/singleimage_fluxrecov_sourcesize.ps',/encapsulated,bits=16,/color
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov20,aperture=20,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov40,aperture=40,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov60,aperture=60,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov80,aperture=80,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
sizes=(findgen(50)/49.*477.+33.)
plot,sizes,flux_recov20,psym=1,color=0,xtitle="!6Object FWHM (arsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,sizes,flux_recov40,psym=2,color=100
oplot,sizes,flux_recov60,psym=4,color=250
oplot,sizes,flux_recov80,psym=5,color=150
legend,['20"','40"','60"','80"'],psym=[1,2,4,5],color=[0,100,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file

set_plot,'x'

end

loadct,39
path = getenv('WORKINGDIR2')+'/l111/'
device,filename=getenv('WORKINGDIR')+'/sim_figures/deconvolution_comparison_l111.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_l111_13pca_deconv_21.6_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_21.6_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l111_13pca_deconv_31.2_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_31.2_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_l111_13pca_deconv_7.2_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_7.2_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_7.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
legend,['7.2"','14.4"','21.6"','31.2"'],psym=[1,1,1,1],color=[100,0,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/deconvolution_comparison_nolegend_l111.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/pca_comparison_l111.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_l111_31pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_31pca_deconv_sim_map20.fits',path+'v1.0.2_l111_31pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_l111_26pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_26pca_deconv_sim_map20.fits',path+'v1.0.2_l111_26pca_deconv_sim_initial.fits',/doplot,/overplot,color=175,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l111_21pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_21pca_deconv_sim_map20.fits',path+'v1.0.2_l111_21pca_deconv_sim_initial.fits',/doplot,/overplot,color=125,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l111_16pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_16pca_deconv_sim_map20.fits',path+'v1.0.2_l111_16pca_deconv_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',/doplot,/overplot,color=225,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_l111_10pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_10pca_deconv_sim_map20.fits',path+'v1.0.2_l111_10pca_deconv_sim_initial.fits',/doplot,/overplot,color=200,thick=3,xax=xax4,yax=yax4
measure_flux,path+'v1.0.2_l111_7pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_7pca_deconv_sim_map20.fits',path+'v1.0.2_l111_7pca_deconv_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax5,yax=yax5
measure_flux,path+'v1.0.2_l111_3pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_3pca_deconv_sim_map20.fits',path+'v1.0.2_l111_3pca_deconv_sim_initial.fits',/doplot,/overplot,color=50,thick=3,xax=xax6,yax=yax6
legend,['31','26','21','16','13','10','7','3'],psym=[1,1,1,1,1,1,1,1],color=[0,175,125,250,225,200,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/pca_comparison_nolegend_l111.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
oplot,xax4,yax4,thick=3,color=150
oplot,xax5,yax5,thick=3,color=100
oplot,xax6,yax6,thick=3,color=50
device,/close_file


loadct,39
path = '/scratch/adam_work/l072/'
device,filename=getenv('WORKINGDIR')+'/sim_figures/deconvolution_comparison_l072.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_l072_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_14.4_sim_initial.fits',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_l072_13pca_deconv_21.6_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_21.6_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_13pca_deconv_31.2_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_31.2_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_l072_13pca_deconv_7.2_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_7.2_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_7.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax4,yax=yax4
legend,['7.2"','14.4"','21.6"','31.2"'],psym=[1,1,1,1],color=[100,0,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/deconvolution_comparison_nolegend_l072.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=150
oplot,xax4,yax4,thick=3,color=100
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/pca_comparison_l072.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_l072_31pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_31pca_deconv_sim_map20.fits',path+'v1.0.2_l072_31pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_l072_26pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_26pca_deconv_sim_map20.fits',path+'v1.0.2_l072_26pca_deconv_sim_initial.fits',/doplot,/overplot,color=175,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_21pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_21pca_deconv_sim_map20.fits',path+'v1.0.2_l072_21pca_deconv_sim_initial.fits',/doplot,/overplot,color=125,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_16pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_16pca_deconv_sim_map20.fits',path+'v1.0.2_l072_16pca_deconv_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_14.4_sim_initial.fits',/doplot,/overplot,color=225,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_l072_10pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_10pca_deconv_sim_map20.fits',path+'v1.0.2_l072_10pca_deconv_sim_initial.fits',/doplot,/overplot,color=200,thick=3,xax=xax4,yax=yax4
measure_flux,path+'v1.0.2_l072_7pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_7pca_deconv_sim_map20.fits',path+'v1.0.2_l072_7pca_deconv_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax5,yax=yax5
measure_flux,path+'v1.0.2_l072_3pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_3pca_deconv_sim_map20.fits',path+'v1.0.2_l072_3pca_deconv_sim_initial.fits',/doplot,/overplot,color=50,thick=3,xax=xax6,yax=yax6
legend,['31','26','21','16','13','10','7','3'],psym=[1,1,1,1,1,1,1,1],color=[0,175,125,250,225,200,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/pca_comparison_nolegend_l072.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
oplot,xax4,yax4,thick=3,color=150
oplot,xax5,yax5,thick=3,color=100
oplot,xax6,yax6,thick=3,color=50
device,/close_file

end
