

set_plot,'ps'
loadct,39
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison.ps',/encapsulated,bits=16,/color
measure_flux,'v0.7_l111_13pca_deconv_sim_sim_sources.sav','v0.7_l111_13pca_deconv_sim_map20.fits','v0.7_l111_13pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,'v0.7_l111_13pca_deconv_21.6_sim_sim_sources.sav','v0.7_l111_13pca_deconv_21.6_sim_map20.fits','v0.7_l111_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,'v0.7_l111_13pca_deconv_31.2_sim_sim_sources.sav','v0.7_l111_13pca_deconv_31.2_sim_map20.fits','v0.7_l111_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
legend,['14.4"','21.6"','31.2"'],psym=[1,1,1],color=[0,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison_nolegend.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
device,/close_file

device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison.ps',/encapsulated,bits=16,/color
measure_flux,'v0.7_l111_31pca_sim_sim_sources.sav','v0.7_l111_31pca_sim_map20.fits','v0.7_l111_31pca_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,'v0.7_l111_16pca_sim_sim_sources.sav','v0.7_l111_16pca_sim_map20.fits','v0.7_l111_16pca_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,'v0.7_l111_13pca_sim_sim_sources.sav','v0.7_l111_13pca_sim_map20.fits','v0.7_l111_13pca_sim_initial.fits',/doplot,/overplot,color=225,thick=3,xax=xax3,yax=yax3
measure_flux,'v0.7_l111_10pca_sim_sim_sources.sav','v0.7_l111_10pca_sim_map20.fits','v0.7_l111_10pca_sim_initial.fits',/doplot,/overplot,color=200,thick=3,xax=xax4,yax=yax4
measure_flux,'v0.7_l111_7pca_sim_sim_sources.sav','v0.7_l111_7pca_sim_map20.fits','v0.7_l111_7pca_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax5,yax=yax5
measure_flux,'v0.7_l111_3pca_sim_sim_sources.sav','v0.7_l111_3pca_sim_map20.fits','v0.7_l111_3pca_sim_initial.fits',/doplot,/overplot,color=50,thick=3,xax=xax6,yax=yax6
legend,['31','16','13','10','7','3'],psym=[1,1,1,1,1,1],color=[0,250,225,200,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison_nolegend.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
oplot,xax4,yax4,thick=3,color=150
oplot,xax5,yax5,thick=3,color=100
oplot,xax6,yax6,thick=3,color=50
device,/close_file

end
