

set_plot,'ps'
loadct,39
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison.ps',/encapsulated,bits=16,/color
measure_flux,'v0.7_l111_13pca_deconv_sim_sim_sources.sav','v0.7_l111_13pca_deconv_sim_map20.fits','v0.7_l111_13pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
measure_flux,'v0.7_l111_13pca_deconv_21.6_sim_sim_sources.sav','v0.7_l111_13pca_deconv_21.6_sim_map20.fits','v0.7_l111_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
measure_flux,'v0.7_l111_13pca_deconv_31.2_sim_sim_sources.sav','v0.7_l111_13pca_deconv_31.2_sim_map20.fits','v0.7_l111_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
legend,['14.4"','21.6"','31.2"'],psym=[1,1,1],color=[0,250,150],pos=[0.83,0.82,0.96,0.95] ;,/right
device,/close_file

device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison.ps',/encapsulated,bits=16,/color
measure_flux,'v0.7_l111_31pca_sim_sim_sources.sav','v0.7_l111_31pca_sim_map20.fits','v0.7_l111_31pca_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
measure_flux,'v0.7_l111_16pca_sim_sim_sources.sav','v0.7_l111_16pca_sim_map20.fits','v0.7_l111_16pca_sim_initial.fits',/doplot,/overplot,color=250,charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
measure_flux,'v0.7_l111_13pca_sim_sim_sources.sav','v0.7_l111_13pca_sim_map20.fits','v0.7_l111_13pca_sim_initial.fits',/doplot,/overplot,color=225,charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
measure_flux,'v0.7_l111_10pca_sim_sim_sources.sav','v0.7_l111_10pca_sim_map20.fits','v0.7_l111_10pca_sim_initial.fits',/doplot,/overplot,color=200,charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
measure_flux,'v0.7_l111_7pca_sim_sim_sources.sav','v0.7_l111_7pca_sim_map20.fits','v0.7_l111_7pca_sim_initial.fits',/doplot,/overplot,color=150,charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
measure_flux,'v0.7_l111_3pca_sim_sim_sources.sav','v0.7_l111_3pca_sim_map20.fits','v0.7_l111_3pca_sim_initial.fits',/doplot,/overplot,color=50,charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
legend,['31','16','13','10','7','3'],psym=[1,1,1,1,1,1],color=[0,250,225,200,150,50],pos=[0.83,0.74,0.93,0.96] ;,/right
device,/close_file

end
