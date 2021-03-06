;analyze_point_sources.pro
;analyze a map with added point sources from bgps simulation
;
; Performs basic aperture photometry with annulus background subtraction to compare the fluxes of individual point sources added to bgps maps
; calculates a few relevant statistical components from the photometry results
;   -- currently calculates - pearson_r correlation coefficient between input and output flux recoveries
;   -- a linfit correlation to track underrecovery of source flux as a function of input source flux
;
; INPUTS: input_map, output_map -> bgps input maps and output maps (.fits or already read arrays, either will work) with sources generated with add_point_sources.pro
;         sources -> array of nsources sourcestructs as generated by add_point_sources.pro
;         outdir -> prefix for filenames created for plots, etc., if running an experiment that includes pipeline runs, simply use outmap
;         noisepeak -> pass the low peak sources cutoff through from the gaussian noise parameter passed into make_atmosphere 
;         apertures -> array of 3 apertures to be used in the photometry (input aperture diameters in arcseconds)
; 
; OUTPUTS: a series of .ps plots: 3 comparing input and output source fluxes and a histogram of source brightnesses of inputmap and outputmap\
;          analyzedSources -> the processed array of sourcestructs, passed back into experiment or idl so you can look at things like recovery fractions, etc.
;
; 
; things needed to be done: add in some keywords to allow customization of a few parameters (apertures, etc...)
;                         : improve user friendliness so that it may be run independently of an experiment script (may be relatively simple already)
;                         : how to deal with sources near edge so that recovered flux is nan? currently ignoring those sources


PRO analyze_point_sources, input_map, output_map, noisemap=noisemap, sources=sources, outdir=outdir, analyzedSources=analyzedSources, noisepeak=noisepeak, apertures=apertures
  
  ; read in the maps
  if datatype(input_map, 0) eq 'STR' then mapin = readfits(input_map, inhdr) else mapin = input_map
  if datatype(output_map, 0) eq 'STR' then mapout = readfits(output_map, outhdr) else mapout = output_map
  if datatype(noisemap, 0) eq 'STR' then noisemap = readfits(noisemap, noisehdr)
  
  nsources = n_e(sources)
 
  ;defaults
  if ~keyword_set(noisepeak) then noisepeak=0.12 ; simple default case for most experiments so far
  
  ; aperture photometry section:
  if ~keyword_set(apertures) then apertures = [40,80,120] ;set default apertures ( in arcseconds)
  apertures_rad = apertures/2.0 ; convert apertures to radii
  backsub_rad = apertures_rad*sqrt(2.0)
  aprad_pix = apertures_rad/7.2 ; 7.2 arcsecs per pixel
  backsub_rad_pix = backsub_rad/7.2
  FOR iSource=0, nsources-1 DO BEGIN
    FOR iap=0, n_elements(apertures)-1 DO BEGIN
      
      raw_flux = integrate_flux(mapin, [ sources[iSource].in_loc[0], sources[iSource].in_loc[1] ], aprad_pix[iap]) ; raw flux for the source
     ; backgrd_incSrc = integrate_flux(mapin, [ sources[iSource].in_loc[0], sources[iSource].in_loc[1] ], backsub_rad_pix[iap]) ; raw flux for skysub big radius
     ; skysub_flux = backgrd_incSrc - raw_flux ; get flux in annulus
     ; source_flux = raw_flux - skysub_flux ; subtract background
      sources[iSource].in_flux[iap]=raw_flux
 
      ;do it again for the output map
      raw_flux = integrate_flux(mapout, [ sources[iSource].in_loc[0], sources[iSource].in_loc[1] ], aprad_pix[iap]) ; raw flux for the source
     ; backgrd_incSrc = integrate_flux(mapout, [ sources[iSource].in_loc[0], sources[iSource].in_loc[1] ], backsub_rad_pix[iap]) ; raw flux for skysub big radius
     ; skysub_flux = backgrd_incSrc - raw_flux ; get flux in annulus
     ; source_flux = raw_flux - skysub_flux ; subtract background
      sources[iSource].out_flux[iap]=raw_flux

    ENDFOR ; each aperture
  ENDFOR ; each source

  ; object_photometry uses central pixels stored in a 'rprops' struct
  props = {BOLOPROPS,$
      maxxpix:0.0,maxypix:0.0, $
      flux_40:0.0, eflux_40:0.0,$
      flux_80:0.0, eflux_80:0.0,$
      flux_120:0.0, eflux_120:0.0,$
      flux_40_nobg:0.0, eflux_40_nobg:0.0,$
      flux_80_nobg:0.0, eflux_80_nobg:0.0,$
      flux_120_nobg:0.0, eflux_120_nobg:0.0$
      }
  props_in = replicate(props,nsources)
  props_in.maxxpix = sources.in_loc[0]
  props_in.maxypix =sources.in_loc[1]
  props_out = props_in
  help,props_in,props_out,input_map,output_map,outhdr,noisemap
  props_out.flux_40  = object_photometry(mapout, outhdr, noisemap, props_out, 40 , fluxerr=ef40 , nobg=0) & props_out.eflux_40  = ef40 
  props_out.flux_80  = object_photometry(mapout, outhdr, noisemap, props_out, 80 , fluxerr=ef80 , nobg=0) & props_out.eflux_80  = ef80 
  props_out.flux_120 = object_photometry(mapout, outhdr, noisemap, props_out, 120, fluxerr=ef120, nobg=0) & props_out.eflux_120 = ef120
  props_in.flux_40   = object_photometry(mapin,  outhdr, noisemap, props_in , 40 , fluxerr=ef40 , nobg=0) & props_in.eflux_40   = ef40 
  props_in.flux_80   = object_photometry(mapin,  outhdr, noisemap, props_in , 80 , fluxerr=ef80 , nobg=0) & props_in.eflux_80   = ef80 
  props_in.flux_120  = object_photometry(mapin,  outhdr, noisemap, props_in , 120, fluxerr=ef120, nobg=0) & props_in.eflux_120  = ef120
  props_out.flux_40_nobg  = object_photometry(mapout, outhdr, noisemap, props_out, 40 , fluxerr=ef40 , nobg=1) & props_out.eflux_40_nobg  = ef40 
  props_out.flux_80_nobg  = object_photometry(mapout, outhdr, noisemap, props_out, 80 , fluxerr=ef80 , nobg=1) & props_out.eflux_80_nobg  = ef80 
  props_out.flux_120_nobg = object_photometry(mapout, outhdr, noisemap, props_out, 120, fluxerr=ef120, nobg=1) & props_out.eflux_120_nobg = ef120
  props_in.flux_40_nobg   = object_photometry(mapin,  outhdr, noisemap, props_in , 40 , fluxerr=ef40 , nobg=1) & props_in.eflux_40_nobg   = ef40 
  props_in.flux_80_nobg   = object_photometry(mapin,  outhdr, noisemap, props_in , 80 , fluxerr=ef80 , nobg=1) & props_in.eflux_80_nobg   = ef80 
  props_in.flux_120_nobg  = object_photometry(mapin,  outhdr, noisemap, props_in , 120, fluxerr=ef120, nobg=1) & props_in.eflux_120_nobg  = ef120

  ; prep work for plots
  xmin = floor(min(sources.in_flux) - 10)
  xmax = ceil(max(sources.in_flux) + 10)
  ymin_diffresid = floor(min(sources.out_flux - sources.in_flux)*1.2)
  ymax_diffresid = ceil(max(sources.out_flux - sources.in_flux)*1.2)
  ymin_lin = floor(min(sources.out_flux)-5)
  ymax_lin = ceil(max(sources.out_flux)+5)
  ymin_relresid = floor(min(sources.out_flux/sources.in_flux))
  ymax_relresid = ceil(max(sources.out_flux/sources.in_flux))
  ; 1:1 line
  yline = 1000*findgen(11) - 5000
  xline = 1000*findgen(11) - 5000
 
  ; calculate pearsonr coefficients
  ; deal with nans
  wnan40 = where(finite(sources.out_flux[0,*], /nan), nnan40, complement = wgood40)
  wnan80 = where(finite(sources.out_flux[1,*], /nan), nnan80, complement = wgood80)
  wnan120 = where(finite(sources.out_flux[2,*], /nan), nnan120, complement = wgood120)
  wtrim = where( sources.in_peak GT noisepeak $   ; trim peaks below the noise level, (taken from individual_bolonoise_rms parameter for make_atmosphere, perhaps make this a passed parameter to generalize)
	      AND sources.in_flux[0,*] GT 0 $ ; trim integrated flux levels below zero
	      and sources.in_flux[1,*] GT 0 $
	      AND sources.in_flux[2,*] GT 0 $
	      AND finite(sources.out_flux[0,*]) $
	      AND finite(sources.out_flux[1,*]) $
	      AND finite(sources.out_flux[2,*])) ; deal with nans in wtrim


  ; so we're gonna pull the data out of the structures and simplify our arrays a bit to help with the pearson test and plotting
  ; 0,1, and 2 indices refer to 40,80, 120 arcsecond apertures respectively (by default, note apertures array above)
  influx40 = reform((sources.in_flux)[0,wgood40]) & outflux40 = reform((sources.out_flux)[0,wgood40])
  influx80 = reform((sources.in_flux)[1,wgood80]) & outflux80 = reform((sources.out_flux)[1,wgood80])
  influx120 = reform((sources.in_flux)[2,wgood120]) & outflux120 = reform((sources.out_flux)[2,wgood120])

  sources_trim = sources[wtrim]
  trim_influx40 = reform(sources_trim.in_flux[0,*]) & trim_outflux40 = reform(sources_trim.out_flux[0,*])
  trim_influx80 = reform(sources_trim.in_flux[1,*]) & trim_outflux80 = reform(sources_trim.out_flux[1,*])
  trim_influx120 = reform(sources_trim.in_flux[2,*]) & trim_outflux120 = reform(sources_trim.out_flux[2,*])

 
  ; calculate pearsonr values
  p_r_40 = pearsonr(influx40,outflux40)
  p_r_80 = pearsonr(influx80,outflux80)
  p_r_120 = pearsonr(influx120,outflux120)

  ;add pearson r values to sources structure
  sources.pear_r[0,*]=p_r_40
  sources.pear_r[1,*]=p_r_80
  sources.pear_r[2,*]=p_r_120
  
  ; calculate recovery fractions
  wrec40 = where( sources.in_flux[0,*] GT 0 and finite(sources.out_flux[0,*]) ) ; grab in_fluxes greater than 0 and nonnan outfluxes for 40" aperture
  wrec80 = where( sources.in_flux[1,*] GT 0 and finite(sources.out_flux[1,*]) )
  wrec120 = where( sources.in_flux[2,*] GT 0 and finite(sources.out_flux[2,*]) )

  rec_frac_40 = 1.0*n_elements( where( (sources.out_flux)[0,wrec40] / (sources.in_flux)[0,wrec40] GE 0.9 AND (sources.out_flux)[0,wrec40] / (sources.in_flux)[0,wrec40] LE 1.1 ) ) / n_elements(wrec40)
  rec_frac_80 = 1.0*n_elements( where( (sources.out_flux)[1,wrec80] / (sources.in_flux)[1,wrec80] GE 0.9 AND (sources.out_flux)[1,wrec80] / (sources.in_flux)[1,wrec80] LE 1.1 ) ) / n_elements(wrec80)
  rec_frac_120 = 1.0*n_elements( where( (sources.out_flux)[2,wrec120] / (sources.in_flux)[2,wrec120] GE 0.9 AND (sources.out_flux)[2,wrec120] / (sources.in_flux)[2,wrec120] LE 1.1 ) ) / n_elements(wrec120)
  
  ; add recovery fractions to sources structure
  sources.recovery_frac = [rec_frac_40, rec_frac_80, rec_frac_120]

  ; we noticed a correlated underrecovery of sources as a function of input flux
  ; this calculates the best fit line for that correlation
  fit40 = regress(influx40, outflux40-influx40, const=fit40_const, correlation=fit40_cor)
  fit80 = regress(influx80, outflux80-influx80, const=fit80_const, correlation=fit80_cor)
  fit120 = regress(influx120, outflux120-influx120, const=fit120_const, correlation=fit120_cor)
  linfit40_stats = [fit40,fit40_const,fit40_cor]
  linfit80_stats = [fit80,fit80_const,fit80_cor]
  linfit120_stats = [fit120,fit120_const,fit120_cor]
  
  ; plot the difference residual
  ; plot 0 line for comparison, setup ranges, plot out-in vs in since data was strongly correlated to 1:1 line originall (out vs in)
  ; plots fit line for the underrecovery calculated above
  set_plot, 'ps'
  DEVICE, BITS_PER_PIXEL=8, /color, FILENAME=outdir+'ptsrc_brightness_diffresid.ps', xsize=30, ysize=30
  TVLCT,[0,255,0,0],[0,0,255,0],[0,0,0,255]
 
  plot,  [xmin, xmax], [0, 0], xrange=[xmin, xmax], yrange=[ymin_diffresid, ymax_diffresid],$
	                        /ystyle, /xstyle, xtitle="Input Recovered Flux, w/ Background Subtraction (Jy)",$
                                ytitle="Output - Input Recovered Flux, w/ Background Subtraction (Jy)",$
			        title="Difference Residual of Recovered Flux Comparison w/ Background Subtraction"
  oplot, influx40, outflux40-influx40, psym=2, color=0
  oplot, xline, fit40[0]*xline+fit40_const, linestyle=2, color=0 
  oplot, influx80, outflux80-influx80, psym=4, color=1
  oplot, xline, fit80[0]*xline+fit80_const, linestyle=2, color=1 
  oplot, influx120, outflux120-influx120, psym=6, color=2
  oplot, xline, fit120[0]*xline+fit120_const, linestyle=2, color=2 
  ; legend labels above oplots and adds in pearsonr data, these are preliminary plots, if Adam decides to make paper-quality ones in python
  ; might think of making 40/80/120 labels parameters, although that might be unnecessary considering how standard our use of those apertures is
  legend, ['40 arcsec, PearR = ' +string(p_r_40, format='(F7.5," ",F7.5)'),$
	   '40 arcsec, out-in fit = ' +string(fit40, fit40_const, format='(F8.5," ", F8.5)'),$ 
	   '80 arcsec, PearR = ' +string(p_r_80, format='(F7.5," ",F7.5)'),$
	   '80 arcsec, out-in fit = ' +string(fit80, fit80_const, format='(F8.5," ", F8.5)'),$
	   '120 arcsec, PearR = '+string(p_r_120, format='(F7.5," ",F7.5)'),$
           '120 arcsec, out-in fit = ' +string(fit120, fit120_const, format='(F8.5," ", F8.5)')],$ 
	    psym=[2,0,4,0,6,0],linestyle=[0,2,0,2,0,2],color=[0,0,1,1,2,2], /right

  device, /close
  
  ; plot linear out vs in
  set_plot,'ps'
  DEVICE, BITS_PER_PIXEL=8, /color, FILENAME=outdir+'ptsrc_brightness_lin.ps', xsize=30, ysize=30
  TVLCT,[0,255,0,0],[0,0,255,0],[0,0,0,255]
 
  plot, xline, yline, linestyle=2, xrange=[xmin, xmax], yrange=[ymin_lin,ymax_lin], /ystyle, /xstyle,$
	              xtitle="Input Recovered Flux, w/ Background Subtraction (Jy)",$
		      ytitle="Output Recovered Flux, w/ Background Subtraction (Jy)",$
		      title="Recovered Flux Comparison w/ Background Subtraction (Jy)"
  oplot, influx40, outflux40, psym=2, color=0 
  oplot, influx80, outflux80, psym=4, color=1
  oplot, influx120, outflux120, psym=6, color=2
  ; legend labels above oplots and adds in pearsonr data
  legend, ['40 arcsec, PearR = ' +string(p_r_40, format='(F8.5," ",F8.5)'),$ 
	   '80 arcsec, PearR = ' +string(p_r_80, format='(F8.5," ",F8.5)'),$
	   '120 arcsec, PearR = '+string(p_r_120, format='(F8.5," ",F8.5)')], psym=[2,4,6],color=[0,1,2], /right
   device, /close

  ; plot relative residual
  set_plot,'ps'
  DEVICE, BITS_PER_PIXEL=8, /color, FILENAME=outdir+'ptsrc_brightness_relresid.ps', xsize=30, ysize=30
  TVLCT,[0,255,0,0],[0,0,255,0],[0,0,0,255]
  
  plot, [xmin, xmax], [1,1], linestyle=2, xrange=[xmin, xmax], yrange=[ymin_relresid,ymax_relresid], /ystyle, /xstyle,$
	              xtitle="Input Recovered Flux, w/ Background Subtraction (Jy)",$
		      ytitle="Output Recovered Flux/Input Recovered Flux, w/ Background Subtraction (Jy)",$
		      title="Relative Residual of Recovered Flux Comparison w/ Background Subtraction (Jy)"
  oplot, influx40, outflux40/influx40, psym=2, color=0 
  oplot, influx80, outflux80/influx80, psym=4, color=1
  oplot, influx120, outflux120/influx120, psym=6, color=2
  ; legend labels above oplots and adds in pearsonr data
  legend, ['40 arcsec, PearR = ' +string(p_r_40, format='(F8.5," ",F8.5)'),$ 
	   '80 arcsec, PearR = ' +string(p_r_80, format='(F8.5," ",F8.5)'),$
	   '120 arcsec, PearR = '+string(p_r_120, format='(F8.5," ",F8.5)')], psym=[2,4,6],color=[0,1,2], /right
   device, /close

  ; plot relative residual with trimmed data
  set_plot,'ps'
  DEVICE, BITS_PER_PIXEL=8, /color, FILENAME=outdir+'ptsrc_brightness_trimrelresid.ps', xsize=30, ysize=30
  TVLCT,[0,255,0,0],[0,0,255,0],[0,0,0,255]
  
  plot, [xmin, xmax], [1,1], linestyle=2, xrange=[-50, xmax], yrange=[0,2], /ystyle, /xstyle,$
	              xtitle="Input Recovered Flux, w/ Background Subtraction (Jy)",$
		      ytitle="Output Recovered Flux/Input Recovered Flux, w/ Background Subtraction (Jy)",$
		      title="Relative Residual of Recovered Flux Comparison w/ Background Subtraction (Jy)"
  oplot, trim_influx40, trim_outflux40/trim_influx40, psym=2, color=0 
  oplot, trim_influx80, trim_outflux80/trim_influx80, psym=4, color=1
  oplot, trim_influx120, trim_outflux120/trim_influx120, psym=6, color=2
  ; legend labels above oplots and adds in pearsonr data
  legend, ['40 arcsec, PearR = ' +string(p_r_40, format='(F8.5," ",F8.5)'),$ 
	   '80 arcsec, PearR = ' +string(p_r_80, format='(F8.5," ",F8.5)'),$
	   '120 arcsec, PearR = '+string(p_r_120, format='(F8.5," ",F8.5)')], psym=[2,4,6],color=[0,1,2], /right
   device, /close


  ; hisotgram of input source brightness
 ; bins = [[0.0,0.4],[0.4,0.8],[0.8,1.2],[1.2,1.6],[1.6,2.0],[1.0,1.2],[1.2,1.4],[1.4,1.6],[1.6,1.8],[1.8,2.0]]
 ; nbins = n_elements(bins[0,*])
 ; insrc_hist = intarr(nbins)
 ; FOR iBin=0, nbins-1 DO BEGIN
 ;   within_bin = where(sources.in_peak GE bins[0,iBin] AND sources.in_peak LT bins[1,iBin], ninbin)
 ;   insrc_hist[iBin] = ninbin
 ; ENDFOR
  
  inhist = histogram(alog10(influx40), locations=inlocs, /nan, bin=0.1)
  outhist = histogram(alog10(outflux40), locations=outlocs, /nan, bin=0.1)
  
  ; plot histogram of source brightnesses as they were added to the map
  set_plot, 'ps'
  DEVICE, BITS_PER_PIXEL=8, /COLOR, FILENAME=outdir+'src_hist.ps', xsize=30, ysize=20
  TVLCT,[0,255,0,0],[0,0,255,0],[0,0,0,255]
  plot, inlocs, inhist, psym=10, title='40" Recovered Source Brightness Histogram',$
	                         xtitle="Log Source Brightness (Jy)", ytitle="Frequency (black=in, red=out)"
  oplot, outlocs, outhist, color=1, psym=10
  device, /close
  analyzedSources = sources
  save, analyzedSources, props_in, props_out, p_r_40,p_r_80,p_r_120, linfit40_stats, linfit80_stats, linfit120_stats, filename=outdir+"_analyzed_sources.sav", /verbose

END ; analyze_point_sources




