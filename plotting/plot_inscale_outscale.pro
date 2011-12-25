; simple wrapper to plot the "input" vs output relative scales in simulations
; inscale and outscale need to have the same shape
; outmap is the prefix for the postscript file to be generated; it will have "_invsout_scales.ps" appended
pro plot_inscale_outscale,inscale,outscale,outmap=outmap,rms=rms,nsig=nsig

    if ~keyword_set(rms) then rms=0.1

    save,inscale,outscale,filename=outmap+"_relscales_both.sav"
    spawn,getenv('PIPELINE_ROOT')+'/plotting/plot_inscales_outscales.py '+outmap

    if n_elements(nsig) eq 0 then nsig = 4
    help,inscale,outscale
    set_plot,'ps'
    !p.multi[*] = 0
    device,filename=outmap+"_invsout_scales.ps",/encapsulated,bits=24,/color
    loadct,0,/silent
    plot,inscale,outscale,psym=7,xstyle=1,ystyle=1,xrange=[1-nsig*rms,1+nsig*rms],yrange=[1-nsig*rms,1+nsig*rms],xtitle="!6Input Gain",ytitle="!6Pipeline Recovered Gain",xthick=2,ythick=2
    oplot,[1-nsig*rms,1+nsig*rms],[1-nsig*rms,1+nsig*rms],color=cgcolor('red')
    ;rp = pearsonr(double(inscale),double(outscale))
    ;xyouts,1-2*rms,1+2*rms,"!6"+string(rp,format="('R:',G8.5,'  P(R):',G8.5)")
    ;print,"rp: ",rp,"log10(rp): ",alog10(rp)
    device,/close_file

    device,filename=outmap+"_invsout_diffhist.ps",/encapsulated,bits=24,/color
    loadct,0,/silent
    bin = abs(max(outscale-inscale)-min(outscale-inscale))/10.
    print,"mmmmm(outscale-inscale): ",mmmmm(outscale-inscale),"bin: ",bin
    plothist,outscale-inscale,xh,yh,xtitle="!6Pipeline-Input Gain",ytitle="!6Number of Bolometers",thick=2,bin=bin
    device,/close_file

    set_plot,'x'
end
