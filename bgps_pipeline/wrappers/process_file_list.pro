; wrapper for some of the OLD CODE
; uses process_ncdf to produce a file that contains things like scans_info
pro process_file_list,filelist,array_params=array_params,bolo_params=bolo_params,beam_locations=beam_locations,$
    downsample_factor=downsample_factor,precise_scans_offset_file=precise_scans_offset_file,outfilelist=outfilelist
    readcol, filelist, thefiles, format='A80',/silent,comment="#"  ; read in the raw filenames 
    if keyword_set(outfilelist) then readcol, outfilelist, theoutfiles, format='A80',/silent,comment="#"

    if n_e(downsample_factor) eq 0 then downsample_factor = 5

    bgps_pipeline_root = getenv('PIPELINE_ROOT')

    for i=0,n_e(thefiles)-1 do begin
        infile  = thefiles[i]
        date = (stregex(infile,'(0[5-7]0[679])([0-9][0-9]_o[b0-9][0-9])',/extract,/subexpr))[1]
        print,"WORKING ON FILE "+infile+" WITH DATE "+date
        beam_locations = bgps_pipeline_root+'/bgps_params/beam_locations_default.txt'
        case date of 
            '0506': begin
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jun05.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_jun05.txt'
                end
            '0507': begin
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jul05.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_jun05.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jul05.txt'
                end
            '0509': begin
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jul05.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_sep05.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_sep05.txt'
                end
            '0606': begin
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jun06_rotating.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_jun06.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jun06.txt'
                end
            '0607': begin
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jun06_rotating.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_jun06.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jun06.txt'
                end
            '0609': begin
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jun06_rotating.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_jun06.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jun06.txt'
                end
            '0706': begin 
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jun07.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_jun07_mmd.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jun07.txt'
                end
            '0707': begin
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_jun07.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_jun07_mmd.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jun07.txt'
                end
            '0709': begin
;                array_params     = bgps_pipeline_root+'/bgps_params/array_params_sep07_no_rot.txt'
;                array_params     = bgps_pipeline_root+'/bgps_params/array_params_sep07.txt'
                array_params     = bgps_pipeline_root+'/bgps_params/array_params_sep07_agg.txt'
                bolo_params      = bgps_pipeline_root+'/bgps_params/bolo_params_sep07.txt'
                beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_sep07.txt'
                end
        endcase


        if stregex(infile,'_ds5.nc') gt 0 then begin
            if file_test(infile) then begin 
                set_params,infile,beam_locations,bolo_params,array_params
                calcoeffs_to_ncdf,infile,[ -3.26472e-15,0.398740,3.32002]
            endif else begin
                print,"Failed to open file "+infile
                stop
            endelse
        endif else begin
            if ~keyword_set(outfilelist) then outfile = strmid(infile,0,strlen(infile)-3)+"_ds"+strc(downsample_factor)+".nc" $
                else outfile=theoutfiles[i]
            process_ncdf,infile,outfile,array=array_params,bolo=bolo_params,$
                beam_locations_file=beam_locations_file,downsample_factor=downsample_factor,$
                precise_scans_offset_file=precise_scans_offset_file
            alignment_offsets_to_ncdf,outfile,0,0
            calcoeffs_to_ncdf,outfile,[ -3.26472e-15,0.398740,3.32002]
        endelse
    endfor
    retall
end

