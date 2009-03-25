readcol,'0707list',ml,format='(A80)'
for i=0,n_e(ml)-1 do begin
 map = readfits(ml[i],/silent)
 if i mod 2 eq 0 then begin
  fp1=(centroid_map(map))[1:3]
 endif else begin
  fp2=(centroid_map(map))[1:3]
  print,ml[i],fp1-fp2,fp1,fp2,format="(A30,9F15)"
 endelse
endfor

end
