
pro distmap_comp,ncfile,outfile,bl=bl,nobl=nobl,defaultbl=defaultbl,check=check,doplot=doplot,mars=mars,$
    coordsys=coordsys,projection=projection,blfile=blfile,outtxt=outtxt,_extra=_extra

    if n_e(nopointing) eq 0 then nopointing=1
    if n_e(coordsys) eq 0 then coordsys='radec'
    if n_e(projection) eq 0 then projection='TAN'
    if n_e(outtxt) eq 0 then outtxt='/dev/tty'
    if keyword_set(blfile) then begin
        write_distmap,ncfile,blfile
        mem_iter,ncfile,outfile+"_BL",pointing_model=0,niter=[0,0],/distcor,mars=mars
    endif else begin
        distmap,ncfile,outfile,doplot=doplot,check=check,nopointing=nopointing,coordsys=coordsys,projection=projection,_extra=_extra  
        write_distmap,ncfile,outfile+".txt"
        mem_iter,ncfile,outfile+"_BL",pointing_model=0,niter=[0,0],/distcor,mars=mars
    endelse
    write_distmap,ncfile,'/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/beam_locations_default.txt'
    mem_iter,ncfile,outfile+"_defaultBL",pointing_model=0,niter=[0,0],/distcor,mars=mars
    mem_iter,ncfile,outfile+"_noBL",pointing_model=0,niter=[0,0],mars=mars

    BL = readfits(outfile+"_BL_map01.fits",hdBL)
    noBL = readfits(outfile+"_noBL_map01.fits",hdnoBL)
    defaultBL = readfits(outfile+"_defaultBL_map01.fits",hddefaultBL)

    hastrom,BL,hdBL,hdnoBL, missing = !values.f_nan
    fpBL = centroid_map(BL)
    fpnoBL = centroid_map(noBL)
    fpdefaultBL = centroid_map(defaultBL)
;    print,"PEAK COMPARISON","BL:",max(BL,/nan),"noBL:",max(noBL,/nan),"defaultBL:",max(defaultBL,/nan),format="(A20,A8,F20,A8,F20,A12,F20)"
;    print,"FWHM","BL:",fpBL[2:3],"noBL:",fpnoBL[2:3],"defaultBL:",fpdefaultBL[2:3],format="(A20,A8,F10,F10,A8,F10,F10,A12,F10,F10)"
;    print,"GAUSSpeak","BL:",fpBL[1],"noBL:",fpnoBL[1],"defaultBL:",fpdefaultBL[1],format="(A20,A8,F20,A8,F20,A12,F20)"
    printf,outtxt,"TYPE","GAUSSPEAK","PEAK","FWHM X","FWHM Y",format='(A15,A15,A15,A15,A15)'
    printf,outtxt,"BL",fpBL[1], max(BL,/nan), fpBL[2:3],format="(A15,F15,F15,F15,F15)"
    printf,outtxt,"noBL",fpnoBL[1], max(noBL,/nan), fpnoBL[2:3],format="(A15,F15,F15,F15,F15)"
    printf,outtxt,"defaultBL",fpdefaultBL[1], max(defaultBL,/nan), fpdefaultBL[2:3],format="(A15,F15,F15,F15,F15)"

    if keyword_set(doplot) then atv,BL-noBL
    if keyword_set(check) then stop

end


; plot_beamloc,'/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/beam_locations_default.txt',/noxy,psym=6
; plot_beamloc,'/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/beam_locations_boloparams.txt',/noxy,psym=5,color=200,/overplot
; plot_beamloc,'/scratch/adam_work/distmaps/uranus_050619_o23.txt',color=200,/overplot ,/noxy,psym=1
; plot_beamloc,'/scratch/adam_work/distmaps/uranus_050619_o24.txt',color=250,/overplot ,/noxy,psym=1
; plot_beamloc,'/scratch/adam_work/distmaps/0506_average_beamloc.txt',color=250,/overplot ,/noxy,psym=1
; plot_beamloc,'/scratch/adam_work/distmaps/uranus_050628_o34.txt',color=150,/overplot ,/noxy,psym=1
; plot_beamloc,'/scratch/adam_work/distmaps/uranus_050628_o33.txt',color=100,/overplot ,/noxy,psym=1
; plot_beamloc,'/scratch/adam_work/distmaps/neptune_050626_o19.txt',color=50,/overplot ,/noxy,psym=7
; plot_beamloc,'/scratch/adam_work/distmaps/neptune_050626_o20.txt',color=75,/overplot ,/noxy,psym=7
; plot_beamloc,'/scratch/adam_work/distmaps/mars_050627_o31.txt',color=175,/overplot ,/noxy,psym=7
; plot_beamloc,'/scratch/adam_work/distmaps/mars_050627_o32.txt',color=225,/overplot ,/noxy,psym=7
;
;
; plot_beamloc,'/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/beam_locations_default.txt',/noxy,psym=6,/overplot,color=250
;
; plot_beamloc,'/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/beam_locations_sep05_backup.txt',color=200,/overplot,/noxy,psym=7
; plot_beamloc,'/home/milkyway/student/ginsbura/bgps_pipeline/bgps_params/beam_locations_nov06.txt',color=150,/overplot,/noxy,psym=7
; plot_beamloc,'/scratch/adam_work/distmaps/uranus_050619_o24_doptg.txt',color=150,/overplot ,/noxy,psym=1
; plot_beamloc,'/scratch/adam_work/distmaps/uranus_050619_o24_gal.txt',color=50,/overplot ,/noxy,psym=1
; plot_beamloc,'/scratch/adam_work/distmaps/uranus_050619_o24_doptg_gal.txt',color=100,/overplot ,/noxy,psym=1
