            
pro get_fixed_offsets_file, ncfile,  fazo, fzao, writetofile=writetofile, rpc_dir=rpc_dir 
    if ~keyword_set(rpc_dir) then rpc_dir = getenv('RPCDIR')  ;Milkyway default RPC directory
    if file_test(ncfile) and strmid(ncfile,strlen(ncfile)-3,3) eq '.nc' then ncdf_varget_scale,ncfile,'ut',ut else begin
        prefix = strmid(ncfile,0,strpos(ncfile,'/',/reverse_search))
        tempstr=stregex(ncfile,'([a-z0-9\._-]*)/([a-z_]*)([0-9]{6}_o[b0-9][0-9])',/extract,/subexpr)
        targetname = tempstr[1] ;strmid(prefix,strpos(prefix,'/',/reverse_search)+1,strlen(prefix)-strpos(prefix,'/',/reverse_search))
        obname = tempstr[3] ;strmid(ncfile,strpos(ncfile,'/',/reverse_search)+1,10)
        ncfile_new = getenv('SLICED_POLY')+'/'+targetname+"/"+obname+"_raw.nc"
        if file_test(ncfile_new) then ncdf_varget_scale,ncfile_new,"ut",ut $
            else begin
                fazo=0
                fzao=0
                message,"Couldn't open ncdf file "+ncfile_new,/info
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
    temp = tempstr[2]+tempstr[3]

    minstr = string(firstmin,format='(I04)')
    rpcfile = rpc_dir+'/rpc/'+'20'+temp[0]+'/20'+temp[0]+'_'+minstr+'_rpc.bin'

    if file_test(rpcfile) then begin
        data = read_rpc(rpcfile)

        fazo = median(data.AZIMUTH_FIXED_OFFSET)
        fzao = median(-data.ELEVATION_FIXED_OFFSET)
    endif else begin
        print,"Did not find rpcfile "+rpcfile+" for file "+ncfile
        fazo = 0
        fzao = 0
    endelse

    if keyword_set(writetofile) then begin
        ncid = ncdf_open(ncfile,/write)
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

end

