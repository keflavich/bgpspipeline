#!/usr/bin/env python
import idlsave
from pylab import *

def plot_inscales_outscales(prefix):
    """
    prefix = mapstr.outmap+"_relscales_both.sav"
    save,relscales_both,bgps.scale_coeffs,filename=mapstr.outmap+"_relscales_both.sav"
    """
    data = idlsave.read(prefix+"_relscales_both.sav")

    figure(1)
    clf()
    D = concatenate([data.inscale,data.outscale])
    plot([D.min(),D.max()],[D.min(),D.max()],'r--',linewidth=2)
    plot(data.inscale,data.outscale,'ko',markersize=10,markeredgewidth=1,alpha=0.25,markerfacecolor='none',markeredgecolor='k')
    xlabel("Input Gain",fontsize=20)
    ylabel("Pipeline Recovered Gain",fontsize=20)
    savefig(prefix+"_invsout_scales.png",bbox_inches='tight')

    figure(1)
    clf()
    hist((data.outscale-data.inscale).ravel(),histtype='stepfilled')
    xlabel("Pipeline-Input Gain",fontsize=20)
    ylabel("Number of Bolometers",fontsize=20)

    savefig(prefix+"_invsout_histdiff.png",bbox_inches='tight')

if __name__ == "__main__":
    import optparse

    parser=optparse.OptionParser()
    options,args = parser.parse_args()

    plot_inscales_outscales(*args)
    




"""
;
;
; simple wrapper to plot the "input" vs output relative scales in simulations
; inscale and outscale need to have the same shape
; outmap is the prefix for the postscript file to be generated; it will have "_invsout_scales.ps" appended
pro plot_inscale_outscale,inscale,outscale,outmap=outmap,rms=rms,nsig=nsig

    if n_elements(nsig) eq 0 then nsig = 4
    help,inscale,outscale
    set_plot,'ps'
    !p.multi[*] = 0
    device,filename=outmap+"_invsout_scales.ps",/encapsulated,bits=24,/color,/decomposed
    loadct,0,/silent
    plot,inscale,outscale,psym=7,xstyle=1,ystyle=1,xrange=[1-nsig*rms,1+nsig*rms],yrange=[1-nsig*rms,1+nsig*rms],xtitle="!6Input Gain",ytitle="!6Pipeline Recovered Gain",xthick=2,ythick=2
    oplot,[1-nsig*rms,1+nsig*rms],[1-nsig*rms,1+nsig*rms],color=cgcolor('red')
    ;rp = pearsonr(double(inscale),double(outscale))
    ;xyouts,1-2*rms,1+2*rms,"!6"+string(rp,format="('R:',G8.5,'  P(R):',G8.5)")
    ;print,"rp: ",rp,"log10(rp): ",alog10(rp)
    device,/close_file

    device,filename=outmap+"_invsout_diffhist.ps",/encapsulated,bits=24,/color,/decomposed
    loadct,0,/silent
    bin = abs(max(outscale-inscale)-min(outscale-inscale))/10.
    print,"mmmmm(outscale-inscale): ",mmmmm(outscale-inscale),"bin: ",bin
    plothist,outscale-inscale,xh,yh,xtitle="!6Pipeline-Input Gain",ytitle="!6Number of Bolometers",thick=2,bin=bin
    device,/close_file

    set_plot,'x'
end
"""
