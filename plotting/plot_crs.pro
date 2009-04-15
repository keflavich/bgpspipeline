; plot cosmic ray histogram
; i.e. raw value of hits flagged out


; plot_crs,'/usb/scratch1/l111/v1.0.2_l111_13pca_postiter.sav'
pro plot_crs,savefile

    restore,savefile

    whflag = where(bgps.flags,complement=whnotflag)
    whflag = where(bgps.glitchloc,complement=whnotflag)
    rcrs = bgps.raw[whflag]
    acrs = bgps.ac_bolos[whflag]
    astrcrs = bgps.astrosignal[whflag]
    dcrs = bgps.dc_bolos[whflag]

    rhcr=histogram(rcrs,location=rlcr,binsize=2)
    ahcr=histogram(acrs,location=alcr,binsize=2)
    astrhcr=histogram(astrcrs,location=astrlcr,nbins=100)
    dhcr=histogram(dcrs,location=dlcr,binsize=.05)

    set_plot,'ps'
    device,filename=getenv('HOME')+'/paper_figures/glitch_histogram.eps',/encapsulated

    awhpos = where(alcr ge 0)
    plot,alcr[awhpos],ahcr[awhpos],psym=10,yrange=[0,100],xtitle='Amplitude (Jy)',$
        ytitle='Number of Points'
    device,/close_file
    set_plot,'x'

end

;below here is unimportant, just stuff I used when writing the code

;rh = histogram(bgps.raw[whnotflag],location=rl,binsize=2)
;ah = histogram(bgps.ac_bolos[whnotflag],location=al,binsize=2)
;dh = histogram(bgps.dc_bolos[whnotflag],location=dl,binsize=.05)
;astrh = histogram(bgps.astrosignal[whnotflag],location=astrl,nbins=100)
;
;awhpos = where(alcr ge 0)
;plot,alcr[awhpos],ahcr[awhpos],/ylog,psym=10,yrange=[.5,1e6]
;oplot,al,ah,psym=10,color=250
;
;rwhpos = where(rlcr ge 0)
;plot,rlcr[rwhpos],rhcr[rwhpos],/ylog,psym=10,yrange=[.5,1e6]
;oplot,rl,rh,psym=10,color=250
;
;dwhpos = where(dlcr ge 0)
;plot,dlcr[dwhpos],dhcr[dwhpos],/ylog,psym=10,yrange=[.5,1e6]
;
;
;astrwhpos = where(astrlcr ge 0)
;plot,astrlcr[astrwhpos],astrhcr[astrwhpos],/ylog,psym=10,yrange=[.5,1e6]
;oplot,astrl,astrh,psym=10,color=250
;
