; filename should be a _map20.fits file
; the _map20.fits will be replaced with the appropriate noisemaps etc. to run the default
; bolocat script on the data
pro bolocat_default,filename,ppbeam=ppbeam,zeronoise=zeronoise,thresh=thresh,bolocat_struct=bolocat_struct

    if n_elements(ppbeam) eq 0 then ppbeam = 23.8
    if n_elements(thresh) eq 0 then thresh = 2.0

    data = readfits(filename)
    if keyword_set(zeronoise) then begin
      noisemap = 0
    endif else begin
      noisemap = readfits(repstr(filename,"map20","noisemap20"),header)
      ;noisemap = readfits(repstr(filename,"map20","residualmap20"),header)
    endelse

    ;bolocat, filename, props = bolocat_struct, /zero2nan, obj = labelmask
    bolocat, filename, props = bolocat_struct, /zero2nan, obj = labelmask, $
                 /watershed, delta = [0.5], $
                 all_neighbors = 0b, expand = [1.00], $
                 minpix = [ppbeam], thresh = [thresh], $
                 corect = corect, round = [1], $
                 sp_minpix = [2], $
                 id_minpix = 2, beamuc = 1/33., $
                 error = noisemap

    whnan = where(finite(data,/nan),nnan)
    if nnan gt 0 then data[whnan] = 0
    whnan = where(finite(noisemap,/nan),nnan)
    if nnan gt 0 then noisemap[whnan] = 0
    SNmap = data/noisemap
    whnan = where(finite(SNmap,/nan),nnan)
    if nnan gt 0 then SNmap[whnan] = 0

    print,"Maximum S/N in map ",filename," was ",max(SNmap)
    if finite(max(SNMAP)) eq 0 then message,"Bolocat failed.  NAN"
    if corect eq 0 and max(data/noisemap) gt thresh then message,"Bolocat failed." $
    else if corect eq 0 then return
    ;if n_elements(bolocat_struct) eq 0 then stop

    print,"struct type: ",size(bolocat_struct,/type)
    bolocat2reg, bolocat_struct, repstr(filename,"_map20.fits",".reg")

    writefits,repstr(filename,"_map20","_labelmask"),labelmask,header

    save,bolocat_struct,filename=repstr(filename,"_map20.fits","_bolocat.sav"),/verbose
      
end
