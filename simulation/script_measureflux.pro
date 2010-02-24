

set_plot,'ps'
loadct,39
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison_ic1396.ps',/encapsulated,bits=16,/color
path = '/usb/scratch1/ic1396/'
measure_flux,path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_ic1396_13pca_deconv_21.6_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_21.6_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_ic1396_13pca_deconv_31.2_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_31.2_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_ic1396_13pca_deconv_7.2_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_7.2_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_7.2_sim_initial.fits',/doplot,/overplot,color=100,thick=3,xax=xax4,yax=yax4
legend,['7.2"','14.4"','21.6"','31.2"'],psym=[1,1,1,1],color=[100,0,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison_nolegend_ic1396.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=150
oplot,xax4,yax4,thick=3,color=100
device,/close_file

device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison_ic1396.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_ic1396_31pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_31pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_31pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_ic1396_26pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_26pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_26pca_deconv_sim_initial.fits',/doplot,/overplot,color=175,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_ic1396_21pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_21pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_21pca_deconv_sim_initial.fits',/doplot,/overplot,color=125,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_ic1396_16pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_16pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_16pca_deconv_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_ic1396_13pca_deconv_14.4_sim_initial.fits',/doplot,/overplot,color=225,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_ic1396_10pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_10pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_10pca_deconv_sim_initial.fits',/doplot,/overplot,color=200,thick=3,xax=xax4,yax=yax4
measure_flux,path+'v1.0.2_ic1396_7pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_7pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_7pca_deconv_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax5,yax=yax5
measure_flux,path+'v1.0.2_ic1396_3pca_deconv_sim_sim_sources.sav',path+'v1.0.2_ic1396_3pca_deconv_sim_map20.fits',path+'v1.0.2_ic1396_3pca_deconv_sim_initial.fits',/doplot,/overplot,color=50,thick=3,xax=xax6,yax=yax6
legend,['31','26','21','16','13','10','7','3'],psym=[1,1,1,1,1,1,1,1],color=[0,175,125,250,225,200,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison_nolegend_ic1396.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
oplot,xax4,yax4,thick=3,color=150
oplot,xax5,yax5,thick=3,color=100
oplot,xax6,yax6,thick=3,color=50
device,/close_file


; loadct,39
; path = '/usb/scratch1/l111/'
; device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison_l111.ps',/encapsulated,bits=16,/color
; measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
; measure_flux,path+'v1.0.2_l111_13pca_deconv_21.6_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_21.6_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
; measure_flux,path+'v1.0.2_l111_13pca_deconv_31.2_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_31.2_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
; measure_flux,path+'v1.0.2_l111_13pca_deconv_7.2_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_7.2_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_7.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
; legend,['7.2"','14.4"','21.6"','31.2"'],psym=[1,1,1,1],color=[100,0,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
; device,/close_file
; device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison_nolegend_l111.ps',/encapsulated,bits=16,/color
; plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
; oplot,xax2,yax2,thick=3,color=250
; oplot,xax3,yax3,thick=3,color=200
; device,/close_file
; 
; device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison_l111.ps',/encapsulated,bits=16,/color
; measure_flux,path+'v1.0.2_l111_31pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_31pca_deconv_sim_map20.fits',path+'v1.0.2_l111_31pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
; measure_flux,path+'v1.0.2_l111_26pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_26pca_deconv_sim_map20.fits',path+'v1.0.2_l111_26pca_deconv_sim_initial.fits',/doplot,/overplot,color=175,thick=3,xax=xax2,yax=yax2
; measure_flux,path+'v1.0.2_l111_21pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_21pca_deconv_sim_map20.fits',path+'v1.0.2_l111_21pca_deconv_sim_initial.fits',/doplot,/overplot,color=125,thick=3,xax=xax2,yax=yax2
; measure_flux,path+'v1.0.2_l111_16pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_16pca_deconv_sim_map20.fits',path+'v1.0.2_l111_16pca_deconv_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
; measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',/doplot,/overplot,color=225,thick=3,xax=xax3,yax=yax3
; measure_flux,path+'v1.0.2_l111_10pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_10pca_deconv_sim_map20.fits',path+'v1.0.2_l111_10pca_deconv_sim_initial.fits',/doplot,/overplot,color=200,thick=3,xax=xax4,yax=yax4
; measure_flux,path+'v1.0.2_l111_7pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_7pca_deconv_sim_map20.fits',path+'v1.0.2_l111_7pca_deconv_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax5,yax=yax5
; measure_flux,path+'v1.0.2_l111_3pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_3pca_deconv_sim_map20.fits',path+'v1.0.2_l111_3pca_deconv_sim_initial.fits',/doplot,/overplot,color=50,thick=3,xax=xax6,yax=yax6
; legend,['31','26','21','16','13','10','7','3'],psym=[1,1,1,1,1,1,1,1],color=[0,175,125,250,225,200,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
; device,/close_file
; device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison_nolegend_l111.ps',/encapsulated,bits=16,/color
; plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
; oplot,xax2,yax2,thick=3,color=250
; oplot,xax3,yax3,thick=3,color=200
; oplot,xax4,yax4,thick=3,color=150
; oplot,xax5,yax5,thick=3,color=100
; oplot,xax6,yax6,thick=3,color=50
; device,/close_file


loadct,39
path = '/scratch/adam_work/l072/'
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison_l072.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_l072_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_14.4_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_l072_13pca_deconv_21.6_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_21.6_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_21.6_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_13pca_deconv_31.2_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_31.2_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_31.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_l072_13pca_deconv_7.2_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_7.2_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_7.2_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax4,yax=yax4
legend,['7.2"','14.4"','21.6"','31.2"'],psym=[1,1,1,1],color=[100,0,250,150],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename='/home/milkyway/student/ginsbura/sim_figures/deconvolution_comparison_nolegend_l072.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=150
oplot,xax4,yax4,thick=3,color=100
device,/close_file

device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison_l072.ps',/encapsulated,bits=16,/color
measure_flux,path+'v1.0.2_l072_31pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_31pca_deconv_sim_map20.fits',path+'v1.0.2_l072_31pca_deconv_sim_initial.fits',/doplot,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1
measure_flux,path+'v1.0.2_l072_26pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_26pca_deconv_sim_map20.fits',path+'v1.0.2_l072_26pca_deconv_sim_initial.fits',/doplot,/overplot,color=175,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_21pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_21pca_deconv_sim_map20.fits',path+'v1.0.2_l072_21pca_deconv_sim_initial.fits',/doplot,/overplot,color=125,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_16pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_16pca_deconv_sim_map20.fits',path+'v1.0.2_l072_16pca_deconv_sim_initial.fits',/doplot,/overplot,color=250,thick=3,xax=xax2,yax=yax2
measure_flux,path+'v1.0.2_l072_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l072_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l072_13pca_deconv_14.4_sim_initial.fits',/doplot,/overplot,color=225,thick=3,xax=xax3,yax=yax3
measure_flux,path+'v1.0.2_l072_10pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_10pca_deconv_sim_map20.fits',path+'v1.0.2_l072_10pca_deconv_sim_initial.fits',/doplot,/overplot,color=200,thick=3,xax=xax4,yax=yax4
measure_flux,path+'v1.0.2_l072_7pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_7pca_deconv_sim_map20.fits',path+'v1.0.2_l072_7pca_deconv_sim_initial.fits',/doplot,/overplot,color=150,thick=3,xax=xax5,yax=yax5
measure_flux,path+'v1.0.2_l072_3pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l072_3pca_deconv_sim_map20.fits',path+'v1.0.2_l072_3pca_deconv_sim_initial.fits',/doplot,/overplot,color=50,thick=3,xax=xax6,yax=yax6
legend,['31','26','21','16','13','10','7','3'],psym=[1,1,1,1,1,1,1,1],color=[0,175,125,250,225,200,150,50],/right,charsize=1.5,charthick=2,thick=3 ;,/right
device,/close_file
device,filename='/home/milkyway/student/ginsbura/sim_figures/pca_comparison_nolegend_l072.ps',/encapsulated,bits=16,/color
plot,xax1,yax1,xtitle="!6Object size (arcsec)",ytitle="!6Fraction of flux recovered",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
oplot,xax4,yax4,thick=3,color=150
oplot,xax5,yax5,thick=3,color=100
oplot,xax6,yax6,thick=3,color=50
device,/close_file

end
