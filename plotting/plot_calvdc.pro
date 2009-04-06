
; plot_calvdc,'/usb/scratch1/l111/v1.0.2_l111_13pca_postiter.sav'
pro plot_calvdc,savfile

    restore,savfile

    meandc = fltarr(n_e(bgps.scale_coeffs[*,0]))

    for i=0,n_e(bgps.scale_coeffs[*,0])-1 do begin  
        meandc[i] = median(bgps.dc_bolos[*,bgps.scans_info[0,i]:bgps.scans_info[1,i]]) 
    endfor

    set_plot,'ps'
    device,filename='/home/milkyway/student/ginsbura/paper_figures/calib_vs_dc.ps',/encapsulated
    plot,meandc,bgps.scale_coeffs[*,0],psym=1,xtitle='Median DC voltage',ytitle='Calibration factor'
    device,/close_file
    set_plot,'x'
end
