; drizzle is an implementation of the "Double Histogram"
; drizzling routine outlined at:
; http://www.dfanning.com/code_tips/drizzling.html
; it is a more efficient way to add each element of a timestream
; array to a given map
; INPUTS:
;    blank_map_size must be a 2-element array specifying the map size
;    inds is the list of timestream indices (i.e. that returned by prepare_map)
;    data is the data to be indexed and added
function drizzle,blank_map_size,inds,data
    mx=long(blank_map_size[0])*long(blank_map_size[1])
    vec6=fltarr(mx)
    h1=histogram(inds,reverse_indices=ri1,OMIN=om)
    h2=histogram(h1,reverse_indices=ri2,MIN=1)
    ;; easy case - single values w/o duplication
    if ri2[1] gt ri2[0] then begin 
       vec_inds=ri2[ri2[0]:ri2[1]-1] 
       vec6[om+vec_inds]=data[ri1[ri1[vec_inds]]]
    endif
    for j=1,n_elements(h2)-1 do begin 
       if ri2[j+1] eq ri2[j] then continue ;none with that many duplicates
       vec_inds=ri2[ri2[j]:ri2[j+1]-1] ;indices into h1
       vinds=om+vec_inds
       vec_inds=rebin(ri1[vec_inds],h2[j],j+1,/SAMPLE)+ $
                rebin(transpose(lindgen(j+1)),h2[j],j+1,/SAMPLE)
       vec6[vinds]=vec6[vinds]+total(data[ri1[vec_inds]],2)
    endfor 
    map = reform(vec6,blank_map_size)
    return,map
end


