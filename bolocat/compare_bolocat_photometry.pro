; compare photometry in a recovered vs an input simulation

function compare_bolocat_photometry, bolocat, inputfilename, beamuc=beamuc, savefile=savefile

    inputdata = readfits(inputfilename, inputhd)
    error = inputdata * 0

    if n_elements(beamuc) eq 0 then beamuc = 0.0

    nsources = n_elements(bolocat)
    for sourcenum = 0,nsources-1 do begin
        ; this stuff is all copied from bolocat.pro
        bolocat[sourcenum].flux_40 = object_photometry( inputdata, inputhd, error, bolocat[sourcenum], 40, fluxerr = fe40)
        bolocat[sourcenum].eflux_40 = sqrt((fe40)^2+4*beamuc^2*(bolocat[sourcenum].flux_40)^2)
        
        bolocat[sourcenum].flux_40_nobg = object_photometry(inputdata, inputhd, error, bolocat[sourcenum], 40.0, $
                                               fluxerr = fe40, /nobg)
        bolocat[sourcenum].eflux_40_nobg = sqrt((fe40)^2+4*beamuc^2*(bolocat[sourcenum].flux_40_nobg)^2)
        
        bolocat[sourcenum].flux_80 = object_photometry(inputdata, inputhd, error, bolocat[sourcenum], 80.0, $
                                          fluxerr = fe80, /nobg)
        bolocat[sourcenum].eflux_80 = sqrt((fe80)^2+4*beamuc^2*(bolocat[sourcenum].flux_80)^2)
        bolocat[sourcenum].flux_120 = object_photometry(inputdata, inputhd, error, bolocat[sourcenum], 120.0, $
                                           fluxerr = fe120, /nobg)
        bolocat[sourcenum].eflux_120 = sqrt((fe120)^2+4*beamuc^2*(bolocat[sourcenum].flux_120)^2)
        
        bolocat[sourcenum].flux_obj = object_photometry(inputdata, inputhd, error, bolocat[sourcenum], bolocat[sourcenum].rad_as_nodc*2, fluxerr = feobj)
        bolocat[sourcenum].flux_obj_err = feobj
    endfor

    if size(savefile,/type) eq 7 then begin
      save,bolocat,filename=savefile
    endif else if size(savefile,/type) eq 2 and savefile gt 0 then begin
      save,bolocat,filename=repstr(inputfilename,"_inputmap.fits","_bolocat_input.sav")
    endif

    return,bolocat
end
