pro lookup_distmap,filename,bolonum=bolonum,bolodist=bolodist,boloang=boloang,boloerr=boloerr

    bgps_pipeline_root = getenv('PIPELINE_ROOT')

    date = (stregex(filename,'(0[3-9][01][12679])([0-9][0-9]_o[b0-9][0-9])',/extract,/subexpr))[1]
    beam_locations = bgps_pipeline_root+'/bgps_params/beam_locations_default.txt'
    case date of 
        '0301': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jan03.txt'
            end
        '0302': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_jan03.txt'
            end
        '0506': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/uranus_050628_o33-4.txt'
            end
        '0507': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/uranus_050628_o33-4.txt'
            end
        '0509': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/mars_050911_o22-3.txt'
            end
        '0606': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/uranus_060621_o29-30.txt'
            end
        '0607': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/uranus_060621_o29-30.txt'
            end
        '0609': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/uranus_060906_o12.txt'
            end
        '0706': begin 
            beam_locations   = bgps_pipeline_root+'/bgps_params/uranus_070702_o41-2.txt'
            end
        '0707': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/uranus_070702_o41-2.txt'
            end
        '0709': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/neptune_070902_ob5-6.txt'
            end
        '0912': begin
            beam_locations   = bgps_pipeline_root+'/bgps_params/beam_locations_dec09.txt'
            ; came from IRC+10216  irc10216_091223_o29-30.txt
            end
    endcase

    print,"Using beam locations file "+beam_locations+" for file "+filename

    readcol,beam_locations,bolonum,bolodist,boloang,boloerr,comment="#;",format="(I, F, F, F)",/silent

end

