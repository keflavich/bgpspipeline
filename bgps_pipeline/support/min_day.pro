pro min_day,input,output
	sz=size(input)
	if (sz(0) ne 3) then begin
		print,'Input must be 3 d'
	endif
	output=fltarr(sz(1),sz(2))
	for i=0,sz(1)-1 do begin
		for j=0,sz(2)-1 do begin
			output(i,j)=min(input(i,j,*))
		endfor
	endfor
return 
end
