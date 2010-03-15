
set_plot,'ps'
loadct,39
device,filename=getenv('WORKINGDIR')+'/sim_figures/singleimage_fluxrecov_mars_jitter.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov10, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,jitter=1,aperture=10
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov20, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,jitter=1,aperture=20
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov40, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,jitter=1,aperture=40
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov60, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,jitter=1,aperture=60
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov80, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,jitter=1,aperture=80
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov100,amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,jitter=1,aperture=100
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov120,amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,jitter=1,aperture=120
amplitudes=[findgen(50)*2,findgen(40)*20+100]
plot, amplitudes[49:89],flux_recov10[49:89],psym=1,color=0,xtitle="!6Peak Amplitude (Jy)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xrange=[min(amplitudes),max(amplitudes)],yrange=[0,1.2],/ys
oplot,amplitudes[49:89],flux_recov20[49:89],psym=6,color=050
oplot,amplitudes[49:89],flux_recov40[49:89],psym=2,color=100
oplot,amplitudes[49:89],flux_recov60[49:89],psym=4,color=250
oplot,amplitudes[49:89],flux_recov80[49:89],psym=5,color=150
oplot,amplitudes[49:89],flux_recov100[49:89],psym=7,color=200
oplot,amplitudes[49:89],flux_recov120[49:89],psym=1,color=75
oplot,amplitudes[0:49],flux_recov10[0:49],psym=3,color=0
oplot,amplitudes[0:49],flux_recov20[0:49],psym=3,color=050
oplot,amplitudes[0:49],flux_recov40[0:49],psym=3,color=100
oplot,amplitudes[0:49],flux_recov60[0:49],psym=3,color=250
oplot,amplitudes[0:49],flux_recov80[0:49],psym=3,color=150
oplot,amplitudes[0:49],flux_recov100[0:49],psym=3,color=200
oplot,amplitudes[0:49],flux_recov120[0:49],psym=3,color=75
legend,['10"','20"','40"','60"','80"','100"','120"'],psym=[1,6,2,4,5,7,1],color=[0,50,100,250,150,200,75],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
device,/close_file

end

set_plot,'ps'
loadct,39
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_psf_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_psf_smooth_sim_sim_measurements.sav'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_psf_smooth_sim_mapcube.sav'
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
plot,mapcube[xcen[0],ycen[0],1:niter-1]/mapcube[xcen[0],ycen[0],0],xtitle="!6Iteration Number",ytitle="!6Recovery Fraction (peak)",yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  oplot,mapcube[xcen[src],ycen[src],1:niter-1]/mapcube[xcen[src],ycen[src],0],color=50+205*float(s)/n_e(sources) 
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=0.5,charthick=1,thick=1,/bottom ;,/right
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_100arc_l111_psf_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
out = measure_cube(mapcube,xcen[sources[0]],ycen[sources[0]],xwidth[sources[0]],ywidth[sources[0]],aperture=100/7.2,drange=4,/ellipse)
plot,out[1:n_e(out)-1]/out[0],xtitle="!6Iteration Number",ytitle='!6Recovery Fraction (r=100" aperture)',yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  out = measure_cube(mapcube,xcen[src],ycen[src],xwidth[src],ywidth[src],aperture=100/7.2,/ellipse,drange=4)
  oplot,out[1:n_e(out)-1]/out[0],color=50+205*float(s)/n_e(sources)
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=1,charthick=2,thick=3,/bottom ;,/right
device,/close_file

end

set_plot,'ps'
loadct,39
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_sim_sim_measurements.sav'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_sim_mapcube.sav'
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
plot,mapcube[xcen[0],ycen[0],1:niter-1]/mapcube[xcen[0],ycen[0],0],xtitle="!6Iteration Number",ytitle="!6Recovery Fraction (peak)",yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  oplot,mapcube[xcen[src],ycen[src],1:niter-1]/mapcube[xcen[src],ycen[src],0],color=50+205*float(s)/n_e(sources) 
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=1,charthick=2,thick=3,/bottom ;,/right
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_50arc_l111_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
out = measure_cube(mapcube,xcen[sources[0]],ycen[sources[0]],xwidth[sources[0]],ywidth[sources[0]],aperture=50/7.2,drange=4,/ellipse)
plot,out[1:n_e(out)-1]/out[0],xtitle="!6Iteration Number",ytitle='!6Recovery Fraction (r=50" aperture)',yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  out = measure_cube(mapcube,xcen[src],ycen[src],xwidth[src],ywidth[src],aperture=50/7.2,/ellipse,drange=4)
  oplot,out[1:n_e(out)-1]/out[0],color=50+205*float(s)/n_e(sources)
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=1,charthick=2,thick=3,/bottom ;,/right
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_100arc_l111_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
out = measure_cube(mapcube,xcen[sources[0]],ycen[sources[0]],xwidth[sources[0]],ywidth[sources[0]],aperture=100/7.2,drange=4,/ellipse)
plot,out[1:n_e(out)-1]/out[0],xtitle="!6Iteration Number",ytitle='!6Recovery Fraction (r=100" aperture)',yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  out = measure_cube(mapcube,xcen[src],ycen[src],xwidth[src],ywidth[src],aperture=100/7.2,/ellipse,drange=4)
  oplot,out[1:n_e(out)-1]/out[0],color=50+205*float(s)/n_e(sources)
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=1,charthick=2,thick=3,/bottom ;,/right
device,/close_file


end


set_plot,'ps'
loadct,39
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_psf_jitter_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_psf_smooth_jitter_sim_sim_measurements.sav'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_psf_smooth_jitter_sim_mapcube.sav'
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
plot,mapcube[xcen[0],ycen[0],1:niter-1]/mapcube[xcen[0],ycen[0],0],xtitle="!6Iteration Number",ytitle="!6Recovery Fraction (peak)",yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  oplot,mapcube[xcen[src],ycen[src],1:niter-1]/mapcube[xcen[src],ycen[src],0],color=50+205*float(s)/n_e(sources) 
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=0.5,charthick=1,thick=1,/bottom ;,/right
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_100arc_l111_psf_jitter_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
out = measure_cube(mapcube,xcen[sources[0]],ycen[sources[0]],xwidth[sources[0]],ywidth[sources[0]],aperture=100/7.2,drange=4,/ellipse)
plot,out[1:n_e(out)-1]/out[0],xtitle="!6Iteration Number",ytitle='!6Recovery Fraction (r=100" aperture)',yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  out = measure_cube(mapcube,xcen[src],ycen[src],xwidth[src],ywidth[src],aperture=100/7.2,/ellipse,drange=4)
  oplot,out[1:n_e(out)-1]/out[0],color=50+205*float(s)/n_e(sources)
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=1,charthick=2,thick=3,/bottom ;,/right
device,/close_file

end




set_plot,'ps'
loadct,39
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_psf_bigjitter_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_psf_smooth_bigjitter_sim_sim_measurements.sav'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_psf_smooth_bigjitter_sim_mapcube.sav'
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
plot,mapcube[xcen[0],ycen[0],1:niter-1]/mapcube[xcen[0],ycen[0],0],xtitle="!6Iteration Number",ytitle="!6Recovery Fraction (peak)",yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  oplot,mapcube[xcen[src],ycen[src],1:niter-1]/mapcube[xcen[src],ycen[src],0],color=50+205*float(s)/n_e(sources) 
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=0.5,charthick=1,thick=1,/bottom ;,/right
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_100arc_l111_psf_bigjitter_iteration_peak.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
uniqamp = amplitudes[uniq(amplitudes)]
sources = where(amplitudes eq uniqamp[5])
niter = (size(mapcube,/dim))[2]
out = measure_cube(mapcube,xcen[sources[0]],ycen[sources[0]],xwidth[sources[0]],ywidth[sources[0]],aperture=100/7.2,drange=4,/ellipse)
plot,out[1:n_e(out)-1]/out[0],xtitle="!6Iteration Number",ytitle='!6Recovery Fraction (r=100" aperture)',yrange=[0,1.2],/ys
for s=1,n_e(sources)-1 do begin 
  src=sources[s] 
  out = measure_cube(mapcube,xcen[src],ycen[src],xwidth[src],ywidth[src],aperture=100/7.2,/ellipse,drange=4)
  oplot,out[1:n_e(out)-1]/out[0],color=50+205*float(s)/n_e(sources)
endfor
legend,strc(xwidth[sources]*7.2*2.35),color=[0,50+205*(findgen(n_e(sources)-1)+1)/n_e(sources)],psym=1,/right,charsize=1,charthick=2,thick=3,/bottom ;,/right
device,/close_file

end

set_plot,'ps'
loadct,39
path = getenv('WORKINGDIR2')+'/l111/'
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_sourcesize_aperture.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_20arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1,aperture=20/7.2   ,psym=1,color=0,background=-1
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_40arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax2,yax=yax2,aperture=40/7.2   ,/overplot,color=100,psym=2
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_60arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax3,yax=yax3,aperture=60/7.2   ,/overplot,color=250,psym=4
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_80arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax4,yax=yax4,aperture=80/7.2   ,/overplot,color=150,psym=5
measure_flux,path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_14.4_sim_map20.fits',path+'v1.0.2_l111_13pca_deconv_14.4_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_14.4_sim_sim_measurements_100arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax5,yax=yax5,aperture=100/7.2 ,/overplot,color=50,psym=6
legend,['20"','40"','60"','80"','100"'],psym=[1,2,4,5,6],color=[0,100,250,150,50],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_sourcesize_aperture_lines.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
device,/close_file

set_plot,'ps'
loadct,39
path = getenv('WORKINGDIR2')+'/l111/'
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_big_sourcesize_aperture.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
measure_flux,path+'v1.0.2_l111_13pca_deconv_big_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_big_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_big_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_big_sim_sim_measurements_20arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1,aperture=20/7.2   ,psym=1,color=0,background=-1
measure_flux,path+'v1.0.2_l111_13pca_deconv_big_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_big_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_big_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_big_sim_sim_measurements_40arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax2,yax=yax2,aperture=40/7.2   ,/overplot,color=100,psym=2
measure_flux,path+'v1.0.2_l111_13pca_deconv_big_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_big_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_big_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_big_sim_sim_measurements_60arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax3,yax=yax3,aperture=60/7.2   ,/overplot,color=250,psym=4
measure_flux,path+'v1.0.2_l111_13pca_deconv_big_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_big_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_big_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_big_sim_sim_measurements_80arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax4,yax=yax4,aperture=80/7.2   ,/overplot,color=150,psym=5
measure_flux,path+'v1.0.2_l111_13pca_deconv_big_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_big_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_big_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_big_sim_sim_measurements_100arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax5,yax=yax5,aperture=100/7.2 ,/overplot,color=50,psym=6
legend,['20"','40"','60"','80"','100"'],psym=[1,2,4,5,6],color=[0,100,250,150,50],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_big_aperture_lines.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
device,/close_file


set_plot,'ps'
loadct,39
path = getenv('WORKINGDIR2')+'/l111/'
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_sourcesize_aperture_B.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
!p.background=255
measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_sim_sim_measurements_20arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1,aperture=20/7.2   ,psym=1,color=0,background=-1
measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_sim_sim_measurements_40arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax2,yax=yax2,aperture=40/7.2   ,/overplot,color=100,psym=2
measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_sim_sim_measurements_60arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax3,yax=yax3,aperture=60/7.2   ,/overplot,color=250,psym=4
measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_sim_sim_measurements_80arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax4,yax=yax4,aperture=80/7.2   ,/overplot,color=150,psym=5
measure_flux,path+'v1.0.2_l111_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l111_13pca_deconv_sim_map50.fits',path+'v1.0.2_l111_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l111_13pca_deconv_sim_sim_measurements_100arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax5,yax=yax5,aperture=100/7.2 ,/overplot,color=50,psym=6
legend,['20"','40"','60"','80"','100"'],psym=[1,2,4,5,6],color=[0,100,250,150,50],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
device,/close_file
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l111_sourcesize_aperture_B_lines.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
plot,xax1,yax1,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,xax2,yax2,thick=3,color=250
oplot,xax3,yax3,thick=3,color=200
device,/close_file

path = getenv('WORKINGDIR2')+'/l089/'
device,filename=getenv('WORKINGDIR')+'/sim_figures/fluxrecov_l089_sourcesize_aperture.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
measure_flux,path+'v1.0.2_l089_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l089_13pca_deconv_sim_map20.fits',path+'v1.0.2_l089_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l089_13pca_deconv_sim_sim_measurements_20arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax1,yax=yax1,aperture=20/7.2   ,psym=1,color=0
measure_flux,path+'v1.0.2_l089_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l089_13pca_deconv_sim_map20.fits',path+'v1.0.2_l089_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l089_13pca_deconv_sim_sim_measurements_40arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax2,yax=yax2,aperture=40/7.2   ,/overplot,color=100,psym=2
measure_flux,path+'v1.0.2_l089_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l089_13pca_deconv_sim_map20.fits',path+'v1.0.2_l089_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l089_13pca_deconv_sim_sim_measurements_60arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax3,yax=yax3,aperture=60/7.2   ,/overplot,color=250,psym=4
measure_flux,path+'v1.0.2_l089_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l089_13pca_deconv_sim_map20.fits',path+'v1.0.2_l089_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l089_13pca_deconv_sim_sim_measurements_80arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax4,yax=yax4,aperture=80/7.2   ,/overplot,color=150,psym=5
measure_flux,path+'v1.0.2_l089_13pca_deconv_sim_sim_sources.sav',path+'v1.0.2_l089_13pca_deconv_sim_map20.fits',path+'v1.0.2_l089_13pca_deconv_sim_initial.fits',outfile=path+'v1.0.2_l089_13pca_deconv_sim_sim_measurements_100arc.sav',/doplot,xtitle="!6Object FWHM (arcsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xax=xax5,yax=yax5,aperture=100/7.2 ,/overplot,color=50,psym=6
legend,['20"','40"','60"','80"','100"'],psym=[1,2,4,5,6],color=[0,100,250,150,50],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/singleimage_fluxrecov_sourcesize.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov10,aperture=10,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov20,aperture=20,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov40,aperture=40,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov60,aperture=60,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov80,aperture=80,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov100,aperture=100,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
smallmap_sim,flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov120,aperture=120,amplitudes=replicate(1,50),sizes=(findgen(50)/49.*477.+33.)
sizes=(findgen(50)/49.*477.+33.)
plot,sizes,flux_recov10,psym=1,color=0,xtitle="!6Object FWHM (arsec)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3
oplot,sizes,flux_recov20,psym=6,color=50
oplot,sizes,flux_recov40,psym=2,color=100
oplot,sizes,flux_recov60,psym=4,color=250
oplot,sizes,flux_recov80,psym=5,color=150
oplot,sizes,flux_recov100,psym=7,color=200
oplot,sizes,flux_recov120,psym=1,color=75
legend,['10"','20"','40"','60"','80"','100"','120"'],psym=[1,6,2,4,5,7,1],color=[0,50,100,250,150,200,75],/right,charsize=1.5,charthick=2,thick=3
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/singleimage_fluxrecov_mars.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov10, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,aperture=10
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov20, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,aperture=20
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov40, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,aperture=40
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov60, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,aperture=60
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov80, amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,aperture=80
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov100,amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,aperture=100
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov120,amplitudes=[findgen(50)*2,findgen(40)*20+100],/marspsf,aperture=120
amplitudes=[findgen(50)*2,findgen(40)*20+100]
plot, amplitudes[49:89],flux_recov10[49:89],psym=1,color=0,xtitle="!6Peak Amplitude (Jy)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xrange=[min(amplitudes),max(amplitudes)],yrange=[0,1.2],/ys
oplot,amplitudes[49:89],flux_recov20[49:89],psym=6,color=050
oplot,amplitudes[49:89],flux_recov40[49:89],psym=2,color=100
oplot,amplitudes[49:89],flux_recov60[49:89],psym=4,color=250
oplot,amplitudes[49:89],flux_recov80[49:89],psym=5,color=150
oplot,amplitudes[49:89],flux_recov100[49:89],psym=7,color=200
oplot,amplitudes[49:89],flux_recov120[49:89],psym=1,color=75
oplot,amplitudes[0:49],flux_recov10[0:49],psym=3,color=0
oplot,amplitudes[0:49],flux_recov20[0:49],psym=3,color=050
oplot,amplitudes[0:49],flux_recov40[0:49],psym=3,color=100
oplot,amplitudes[0:49],flux_recov60[0:49],psym=3,color=250
oplot,amplitudes[0:49],flux_recov80[0:49],psym=3,color=150
oplot,amplitudes[0:49],flux_recov100[0:49],psym=3,color=200
oplot,amplitudes[0:49],flux_recov120[0:49],psym=3,color=75
legend,['10"','20"','40"','60"','80"','100"','120"'],psym=[1,6,2,4,5,7,1],color=[0,50,100,250,150,200,75],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
device,/close_file


device,filename=getenv('WORKINGDIR')+'/sim_figures/singleimage_fluxrecov_faint_mars.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov10,amplitudes=findgen(50)*2,/marspsf,aperture=10
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov20,amplitudes=findgen(50)*2,/marspsf,aperture=20
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov40,amplitudes=findgen(50)*2,/marspsf,aperture=40
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov60,amplitudes=findgen(50)*2,/marspsf,aperture=60
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov80,amplitudes=findgen(50)*2,/marspsf,aperture=80
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov100,amplitudes=findgen(50)*2,/marspsf,aperture=100
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov120,amplitudes=findgen(50)*2,/marspsf,aperture=120
amplitudes=findgen(50)*2
plot,amplitudes,flux_recov10,psym=1,color=0,xtitle="!6Peak Amplitude (Jy)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,yrange=[0,1.2],/ys
oplot,amplitudes,flux_recov20,psym=6,color=050
oplot,amplitudes,flux_recov40,psym=2,color=100
oplot,amplitudes,flux_recov60,psym=4,color=250
oplot,amplitudes,flux_recov80,psym=5,color=150
oplot,amplitudes,flux_recov100,psym=7,color=200
oplot,amplitudes,flux_recov120,psym=1,color=75
legend,['10"','20"','40"','60"','80"','100"','120"'],psym=[1,6,2,4,5,7,1],color=[0,50,100,250,150,200,75],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
device,/close_file

device,filename=getenv('WORKINGDIR')+'/sim_figures/singleimage_fluxrecov_points.ps',/encapsulated,bits=16,/color
POLYFILL, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=255 
!p.noerase=1
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov10, amplitudes=[findgen(50)*2,findgen(40)*20+100],aperture=10
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov20, amplitudes=[findgen(50)*2,findgen(40)*20+100],aperture=20
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov40, amplitudes=[findgen(50)*2,findgen(40)*20+100],aperture=40
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov60, amplitudes=[findgen(50)*2,findgen(40)*20+100],aperture=60
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov80, amplitudes=[findgen(50)*2,findgen(40)*20+100],aperture=80
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov100,amplitudes=[findgen(50)*2,findgen(40)*20+100],aperture=100
smallmap_sim,sizerange=[33,33],flux_out=flux_out,flux_in=flux_in,flux_recov=flux_recov120,amplitudes=[findgen(50)*2,findgen(40)*20+100],aperture=120
amplitudes=[findgen(50)*2,findgen(40)*20+100]
plot, amplitudes[49:89],flux_recov10[49:89],psym=1,color=0,xtitle="!6Peak Amplitude (Jy)",ytitle="!6Recovered Fraction",charsize=1.5,charthick=2,xthick=2,ythick=2,thick=3,xrange=[min(amplitudes),max(amplitudes)],yrange=[0,1.2],/ys
oplot,amplitudes[49:89],flux_recov20[49:89],psym=6,color=050
oplot,amplitudes[49:89],flux_recov40[49:89],psym=2,color=100
oplot,amplitudes[49:89],flux_recov60[49:89],psym=4,color=250
oplot,amplitudes[49:89],flux_recov80[49:89],psym=5,color=150
oplot,amplitudes[49:89],flux_recov100[49:89],psym=7,color=200
oplot,amplitudes[49:89],flux_recov120[49:89],psym=1,color=75
oplot,amplitudes[0:49],flux_recov10[0:49],psym=3,color=0
oplot,amplitudes[0:49],flux_recov20[0:49],psym=3,color=050
oplot,amplitudes[0:49],flux_recov40[0:49],psym=3,color=100
oplot,amplitudes[0:49],flux_recov60[0:49],psym=3,color=250
oplot,amplitudes[0:49],flux_recov80[0:49],psym=3,color=150
oplot,amplitudes[0:49],flux_recov100[0:49],psym=3,color=200
oplot,amplitudes[0:49],flux_recov120[0:49],psym=3,color=75
legend,['10"','20"','40"','60"','80"','100"','120"'],psym=[1,6,2,4,5,7,1],color=[0,50,100,250,150,200,75],/right,charsize=1.5,charthick=2,thick=3,/bottom ;,/right
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
