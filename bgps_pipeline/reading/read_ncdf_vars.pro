; simple wrapper to read any variable from any file WITH error checking
pro read_ncdf_vars,filename,ac_bolos=ac_bolos,dc_bolos=dc_bolos,flags=flags,bolo_params=bolo_params, $
        raw=raw,atmos_model=atmos_model,map_model=map_model,sample_interval=sample_interval,         $
        scans_info=scans_info,lst=lst,noisefilt_weights=noisefilt_weights,mvperjy=mvperjy,           $
        radec_offsets=radec_offsets,beam_loc=beam_loc,source_ra=source_ra,source_dec=source_dec

    f=ncdf_open(filename)
;    mapid = ncdf_varid(f,'map_model')
;    atmid = ncdf_varid(f,'atmos_model')
;    rawid = ncdf_varid(f,'raw')
    ncdf_control,f,/noverbose
    bpid = ncdf_varid(f,'bolo_params')
    flagid = ncdf_varid(f,'flags')
    dcbid = ncdf_varid(f,'dc_bolos')
    acbid = ncdf_varid(f,'ac_bolos')
    lstid = ncdf_varid(f,'lst')
    raoid = ncdf_varid(f,'radec_offsets')
    calid = ncdf_varid(f,'cal_coefs')
    blid = ncdf_varid(f,'beam_locations')
    sraid = ncdf_varid(f,'source_ra')
    sdecid = ncdf_varid(f,'source_dec')

    if raoid gt -1 then begin
        ncdf_varget,f,raoid,radec_offsets
    endif else if keyword_set(radec_offsets) then begin
        print,"Error: radec_offsets not found."
        radec_offsets = [0,0]
    endif
    
    if calid gt -1 then begin
        ncdf_varget,f,calid,mvperjy
    endif else begin
        print,"cal_coefs not found; no calibration will be applied."
        mvperjy = [1,0,0]
    endelse
    
    if acbid gt -1 then begin
        ncdf_varget,f,acbid,ac_bolos
        ncdf_attget,f,acbid,'scale_factor',acb_sf
        ncdf_attget,f,acbid,'add_offset',acb_offset
        ac_bolos *= acb_sf
        ac_bolos += acb_offset
    endif else if keyword_set(ac_bolos) then print,"Error: ac_bolos not found."

    if lstid gt -1 then begin
        ncdf_varget,f,lstid,lst
        ncdf_attget,f,lstid,'scale_factor',lst_sf
        ncdf_attget,f,lstid,'add_offset',lst_offset
        lst *= lst_sf
        lst += lst_offset
    endif else if keyword_set(lst) then print,"Error: lst not found."

;    if atmid gt -1 then begin
;        ncdf_varget,f,atmid,atmos_model
;        ncdf_attget,f,atmid,'scale_factor',atm_sf
;        ncdf_attget,f,atmid,'add_offset',atm_offset
;        atmos_model *= atm_sf
;        atmos_model += atm_offset
;    endif else if keyword_set(atmos_model) then print,"Error: atmos_model not found."

;    if mapid gt -1 then begin
;        ncdf_varget,f,mapid,map_model
;        ncdf_attget,f,mapid,'scale_factor',map_sf
;        ncdf_attget,f,mapid,'add_offset',map_offset
;        map_model *= map_sf
;        map_model += map_offset
;    endif else if keyword_set(map_model) then print,"Error: map_model not found."

;    if rawid gt -1 then begin
;        ncdf_varget,f,rawid,raw
;        ncdf_attget,f,rawid,'scale_factor',raw_sf
;        ncdf_attget,f,rawid,'add_offset',raw_offset
;        raw *= raw_sf
;        raw += raw_offset
;    endif else if keyword_set(raw) then print,"Error: raw not found."

    if bpid gt -1 then begin
        ncdf_varget,f,bpid,bolo_params
        ;ncdf_attget,f,bpid,'scale_factor',bp_sf
        ;ncdf_attget,f,bpid,'add_offset',bp_offset
        ;bolo_params *= bp_sf
        ;bolo_params += bp_offset
    endif else if keyword_set(bolo_params) then print,"Error: bolo_params not found."


    if blid gt -1 then begin
        ncdf_varget,f,blid,beam_loc
    endif else if keyword_set(beam_loc) then print,"Error: beam_locations not found."

    if flagid gt -1 then begin
        ncdf_varget,f,flagid,flags
        ncdf_attget,f,flagid,'scale_factor',flag_sf
        ncdf_attget,f,flagid,'add_offset',flag_offset
        flags *= flag_sf
        flags += flag_offset
    endif else if keyword_set(flags) then print,"Error: flags not found."

    if dcbid gt -1 then begin
        ncdf_varget,f,dcbid,dc_bolos
        ncdf_attget,f,dcbid,'scale_factor',dcb_sf
        ncdf_attget,f,dcbid,'add_offset',dcb_offset
        dc_bolos *= dcb_sf
        dc_bolos += dcb_offset
    endif else if keyword_set(dc_bolos) then print,"Error: dc_bolos not found."

    sampintid = ncdf_varid(f,'sample_interval')
    if sampintid gt -1 then begin
        ncdf_varget,f,sampintid,sample_interval
        ;ncdf_attget,f,sampintid,'scale_factor',sampint_sf
        ;ncdf_attget,f,sampintid,'add_offset',sampint_offset
        ;sample_interval *= sampint_sf
        ;sample_interval += sampint_offset
    endif else if keyword_set(sample_interval) then print,"Error: sample_interval not found."

    if sraid gt -1 then begin
        ncdf_varget,f,sraid,source_ra
    endif else if keyword_set(source_ra) then print,"Error: source_ra not found."
    if sdecid gt -1 then begin
        ncdf_varget,f,sdecid,source_dec
    endif else if keyword_set(source_dec) then print,"Error: source_dec not found."

    sciid = ncdf_varid(f,'scans_info')
    if sciid gt -1 then begin
        ncdf_varget,f,sciid,scans_info
        ;ncdf_attget,f,sciid,'scale_factor',sci_sf
        ;ncdf_attget,f,sciid,'add_offset',sci_offset
        ;scans_info *= sci_sf
        ;scans_info += sci_offset
    endif else if keyword_set(scans_info) then print,"Error: scans_info not found."

;    nfwid = ncdf_varid(f,'noisefilt_weights')
;    if nfwid gt -1 then begin
;        ncdf_varget,f,nfwid,noisefilt_weights
;        ncdf_attget,f,nfwid,'scale_factor',nfw_sf
;        ncdf_attget,f,nfwid,'add_offset',nfw_offset
;        noisefilt_weights *= nfw_sf
;        noisefilt_weights += nfw_offset
;    endif else if keyword_set(noisefilt_weights) then print,"Error: noisefilt_weights not found."

    ncdf_close,f

;    bgps_struct = { bgps_struct,
;        scans_info: scans_info ,
;        ac_bolos: ac_bolos,
;        raw: ac_bolos,
;        noise: ac_bolos,
;        atmosphere: ac_bolos,
;        sample_interval: sample_inerval,
;        dc_bolos: dc_bolos,
;        lst: lst,
;        flags: flags,
;        mvperjy: mvperjy,
;        radec_offsets: radec_offsets,
;        bolo_params: bolo_params
;        }

end


