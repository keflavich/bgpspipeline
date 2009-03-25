

pro write_distmaps,infile,fileroot=fileroot
    
    if stregex(infile,'nc') gt 0 then files = [infile] else readcol,infile,files,format='(A80)',comment="#",/silent

    if ~keyword_set(fileroot) then fileroot='/home/milkyway/student/ginsbura/bgps_pipeline'

    for i=0,n_e(files)-1 do begin 

        infile = files[i]
        if ~file_test(infile) then begin
            print,"DID NOT FIND FILE ",infile
            continue 
        endif

        date = (stregex(infile,'(0[5-7]0[679])([0-9][0-9]_o[b0-9][0-9])',/extract,/subexpr))[1]
        print,"WORKING ON FILE "+infile+" WITH DATE "+date

        case date of 
            '0506': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_jul05.txt'
                end
            '0507': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_jul05.txt'
                end
            '0509': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_sep05.txt'
                end
            '0606': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_jun06.txt'
                end
            '0607': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_jun06.txt'
                end
            '0609': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_sep06.txt'
                end
            '0706': begin 
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_jul07.txt'
                end
            '0707': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_jul07.txt'
                end
            '0709': begin
                beam_loc_file =  fileroot+'/bgps_params/beam_locations_sep07.txt'
                end
        endcase
        
        write_distmap,infile,beam_loc_file
        
    endfor
end
