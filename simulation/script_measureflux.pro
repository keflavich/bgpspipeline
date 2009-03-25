

set_plot,'ps'
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison.ps',/encapsulated,bits=16,/color
measure_flux,'v0.7_l111_13pca_deconv_sim_sim_sources.sav','v0.7_l111_13pca_deconv_sim_map20.fits','v0.7_l111_13pca_deconv_sim_initial.fits',/doplot,xtitle="Object size (arcsec)",ytitle="Fraction of flux recovered"
measure_flux,'v0.7_l111_13pca_deconv_21.6_sim_sim_sources.sav','v0.7_l111_13pca_deconv_21.6_sim_map20.fits','v0.7_l111_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250
measure_flux,'v0.7_l111_13pca_deconv_31.2_sim_sim_sources.sav','v0.7_l111_13pca_deconv_31.2_sim_map20.fits','v0.7_l111_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150
legend,['14.4"','21.6"','31.2"'],psym=[1,1,1],color=[0,250,150],/right
device,/close_file

device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison.ps',/encapsulated,bits=16,/color
measure_flux,'v0.7_l111_31pca_sim_sim_sources.sav','v0.7_l111_31pca_sim_map20.fits','v0.7_l111_31pca_sim_initial.fits',/doplot,xtitle="Object size (arcsec)",ytitle="Fraction of flux recovered"
measure_flux,'v0.7_l111_16pca_sim_sim_sources.sav','v0.7_l111_16pca_sim_map20.fits','v0.7_l111_16pca_sim_initial.fits',/doplot,/overplot,color=250
measure_flux,'v0.7_l111_13pca_sim_sim_sources.sav','v0.7_l111_13pca_sim_map20.fits','v0.7_l111_13pca_sim_initial.fits',/doplot,/overplot,color=225
measure_flux,'v0.7_l111_10pca_sim_sim_sources.sav','v0.7_l111_10pca_sim_map20.fits','v0.7_l111_10pca_sim_initial.fits',/doplot,/overplot,color=200
measure_flux,'v0.7_l111_7pca_sim_sim_sources.sav','v0.7_l111_7pca_sim_map20.fits','v0.7_l111_7pca_sim_initial.fits',/doplot,/overplot,color=150
measure_flux,'v0.7_l111_3pca_sim_sim_sources.sav','v0.7_l111_3pca_sim_map20.fits','v0.7_l111_3pca_sim_initial.fits',/doplot,/overplot,color=50
legend,['31','16','13','10','7','3'],psym=[1,1,1,1,1,1],color=[0,250,225,200,150,50],/right
device,/close_file

