; find_goodbolos - meant to find the non-flagged bolometers in a file by incorporating both
; the beam locations
function find_goodbolos,filename
;    ncdf_varget_scale,filename,'beam_locations',beam_locations
    ncdf_varget_scale,filename,'bolo_params',bolo_params
;    if total(beam_locations[0,*] ne 0) eq 0 then begin
;        readcol,'/home/milkyway/student/ginsbura/bolocamcvsold/pipeline/cleaning/parameters/beam_locations_jul05.txt',goodbolos_beam,bl1,bl2,/silent
;        beam_locations[0,*] = goodbolos_beam
;    endif
;    goodbolos_tf = bolo_params[0,*] * (beam_locations[0,*] ne 0)
    goodbolos_tf = bolo_params[0,*]
    return,where(goodbolos_tf)
end
