            
pro get_fixed_offsets_file, ncfile,  fazo, fzao, writetofile=writetofile, rpc_dir=rpc_dir 
    if ~keyword_set(rpc_dir) then rpc_dir = getenv('RPCDIR')  ; default RPC directory
    if file_test(ncfile) and strmid(ncfile,strlen(ncfile)-3,3) eq '.nc' then begin
        ncdf_varget_scale,ncfile,'ut',ut 
        ncfile_new = ncfile
    endif else begin
        prefix = strmid(ncfile,0,strpos(ncfile,'/',/reverse_search))
        tempstr=stregex(ncfile,'([a-z0-9\._-]*)/([a-zA-Z_]*)([0-9]{6}_o[b0-9][0-9])',/extract,/subexpr)
        targetname = tempstr[1] ;strmid(prefix,strpos(prefix,'/',/reverse_search)+1,strlen(prefix)-strpos(prefix,'/',/reverse_search))
        obname = tempstr[3] ;strmid(ncfile,strpos(ncfile,'/',/reverse_search)+1,10)
        ncfile_new = getenv('SLICED_POLY')+'/'+targetname+"/"+obname+"_raw.nc"
        if file_test(ncfile_new) ne 1 then begin
            ;spawn,'find '+getenv('SLICED')+'* -name "*'+stregex(tempstr,'[0-9]{6}_o[b0-9][0-9]',/extract)+'_raw_ds5.nc"',ncfilea
            spawn,'find '+getenv('SLICED')+'* -name "*'+obname+'_raw_ds[1-9].nc"',ncfilea
            ncfile_new=ncfilea[0]
        endif
        if file_test(ncfile_new) ne 1 then ncfile_new = strmid(ncfile_new,0,strlen(ncfile_new)-3)+"_ds5.nc"
        if file_test(ncfile_new) ne 1 then ncfile_new = strmid(ncfile_new,0,strlen(ncfile_new)-7)+"_ds1.nc"
        if file_test(ncfile_new) then ncdf_varget_scale,ncfile_new,"ut",ut $
            else begin
                fazo=0
                fzao=0
                message,"Couldn't open ncdf file "+ncfile_new+" generated from "+ncfile+" and "+ncfilea ,/info
                return
            endelse
    endelse


    ; Weird shit sometimes creeps in
    if max(ut) le 0 then message,"ALL UT TIMES ARE NEGATIVE FOR "+ncfile+" : QUITTING."
    ut = ut[where(ut gt 0)]

    firstmin = ceil(min(ut)/24.*1440.)
    lastmin = floor(max(ut)/24.*1440.)

;    temp = strmid(ncfile,strpos(ncfile,'/',/reverse_search)+1,6)
    tempstr=stregex(ncfile,'([a-z0-9\._-]*)/([a-z_]*)([0-9]{6})(_o[b0-9][0-9])',/extract,/subexpr)
    temp = [tempstr[3],tempstr[4]]

    minstr = string(firstmin,format='(I04)')
    rpcfile = rpc_dir+'/rpc/'+'20'+temp[0]+'/20'+temp[0]+'_'+minstr+'_rpc.bin'

    if file_test(rpcfile) then begin
        data = read_rpc(rpcfile)

        fazo = median(data.AZIMUTH_FIXED_OFFSET)
        fzao = median(-data.ELEVATION_FIXED_OFFSET)
        print,"Read RPC file "+rpcfile+" and found fazo, fzao"+strtrim(fazo)+","+strtrim(fzao)
    endif else begin
        print,"Did not find rpcfile "+rpcfile+" for file "+ncfile
        fazo = 0
        fzao = 0
    endelse

    if keyword_set(writetofile) then begin
        ncid = ncdf_open(ncfile_new,/write)
        ncdf_control,ncid,/redef
        varid_az = ncdf_varid(ncid,'fazo_manual')
        varid_za = ncdf_varid(ncid,'fzao_manual')
        if varid eq -1 then begin
            varid_az = ncdf_vardef(ncid,'fazo_manual',/float)
            varid_za = ncdf_vardef(ncid,'fzao_manual',/float)
        endif
        ncdf_attput,ncid,varid_az,'scale_factor',1.
        ncdf_attput,ncid,varid_az,'add_offset',0.
        ncdf_attput,ncid,varid_az,'units',"arcseconds"
        ncdf_attput,ncid,varid_za,'scale_factor',1.
        ncdf_attput,ncid,varid_za,'add_offset',0.
        ncdf_attput,ncid,varid_za,'units',"arcseconds"
        ncdf_control,ncid,/endef
        ncdf_varput,ncid,varid_az,fazo
        ncdf_varput,ncid,varid_za,fzao
        ncdf_close, ncid
    endif

    ncdf_varget_scale,ncfile_new,'jd',jd

    ; hack to deal with the fact that RPC files may have been recorded for dates where the pointing model
    ; was calculated without subtracting fazo/fzao
    if median(jd) gt 2400000 then mjd = median( jd - 2400000.D ) else mjd = median(jd)
    if mjd lt 53614.5 then begin 
        message,"Forcing FAZO/FZAO to zero b/c rpc files don't exist for most of this period (0506) mjd="+strc(mjd),/info
        fazo = 0 
        fzao = 0
    endif else if (mjd ge 53887.5 and mjd lt 53895.5 or round(mjd) eq 53916) then begin
        ;message,"Forcing FAZO/FZAO to -110.2,88.0 b/c rpc files don't exist for most of this period (0606).  Read in "+strc(fazo)+","+strc(fzao),/info
        message,"Forcing FAZO/FZAO to 0,0 b/c rpc files don't exist for most of this period (0606).  Read in "+strc(fazo)+","+strc(fzao),/info
        fazo = -110.20000
        fzao = 88.000000
        fazo = 0 & fzao = 0
    endif else if (mjd ge 53895.5 and mjd lt 53947.5) then begin
        message,"WARNING: not clear whether FAZO/FZAO should be -110.2,88.0 or not set at all.  Check pointing carefully!",/info
    endif else if (mjd ge 53615 and mjd lt 53640) then begin
        message,"Forcing FAZO/FZAO to -78.3,108.1 b/c rpc files don't exist for most of this period (0509)",/info
        fazo = -78.3
        fzao = 108.1
    endif
end

