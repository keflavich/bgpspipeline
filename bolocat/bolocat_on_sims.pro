pro bolocat_on_sims,filename,ppbeam=ppbeam,noiselevel=noiselevel

    if n_elements(ppbeam) eq 0 then ppbeam = 23.8
    if n_elements(noiselevel) eq 0 then noiselevel = 0.03

    noisemap = readfits(repstr(filename,"map20","noisemap20"),header)

    ;bolocat, filename, props = bolocat_struct, /zero2nan, obj = labelmask
    bolocat, filename, props = bolocat_struct, /zero2nan, obj = labelmask, $
                 /watershed, delta = [0.5], $
                 all_neighbors = 0b, expand = [1.00], $
                 minpix = [ppbeam], thresh = [2.0], $
                 corect = corect, round = [1], $
                 sp_minpix = [2], $
                 id_minpix = 2, beamuc = 1/33., $
                 error = noisemap

    print,"struct type: ",size(bolocat_struct,/type)
    bolocat2reg, bolocat_struct, repstr(filename,"_map20.fits",".reg")

    writefits,repstr(filename,"_map20","_labelmask"),labelmask,header

    save,bolocat_struct,filename=repstr(filename,"_map20.fits","_bolocat.sav"),/verbose
      
    bolocat, repstr(filename,"map20","inputmap"), props = bolocat_input_struct, /zero2nan, labelmask_in = labelmask, $
                 obj = labelmask_input, $
                 /watershed, delta = [0.5], $
                 all_neighbors = 0b, expand = [1.00], $
                 minpix = [ppbeam], thresh = [2.0], $
                 corect = corect, round = [1], $
                 sp_minpix = [2], $
                 id_minpix = 2, beamuc = 1/33., $
                 error = noisemap*0.0 + noiselevel ; constant noise level

    bolocat2reg, bolocat_input_struct, repstr(filename,"_map20.fits","_input.reg")

    writefits,repstr(filename,"_map20","_labelmask_input"),labelmask_input,header

    save,bolocat_input_struct,filename=repstr(filename,"_map20.fits","_bolocat_input.sav"),/verbose

    outmap = repstr(filename,"_map20.fits","")

    help,bolocat_struct,bolocat_input_struct

    set_plot,'ps'
    loadct,0
    !p.multi[*] = 0
    device,filename=outmap+"_bolocat_flux40_invsout.ps",/encapsulated,bits=24,/color
    plot,bolocat_struct.flux_40,bolocat_input_struct.flux_40,psym=7,xtitle="!6F40 map20",ytitle="!6F40 input",color=cgcolor('black')
    mm = [min([bolocat_struct.flux_40,bolocat_input_struct.flux_40]),max([bolocat_struct.flux_40,bolocat_input_struct.flux_40])]
    oplot,mm,mm,color=cgcolor('red'),thick=2
    ;oplot,mm,mm,color=fsc_color('Red'),thick=2
    device,/close_file

    device,filename=outmap+"_bolocat_flux40_nobg_invsout.ps",/encapsulated,bits=24,/color
    plot,bolocat_struct.flux_40_nobg,bolocat_input_struct.flux_40_nobg,psym=7,xtitle="!6F40 (nobg) map20",ytitle="!6F40 (nobg) input"
    mm = [min([bolocat_struct.flux_40_nobg,bolocat_input_struct.flux_40_nobg]),max([bolocat_struct.flux_40_nobg,bolocat_input_struct.flux_40_nobg])]
    oplot,mm,mm,color=cgcolor('red'),thick=2
    device,/close_file

    set_plot,'x'
      
end
