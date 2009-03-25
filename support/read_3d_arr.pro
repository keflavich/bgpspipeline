pro read_3d_arr,arr,dirname=dirname,files=files,nx=nx,ny=ny
	path=strcompress(dirname+'/'+files,/rem)
	all=findfile(path,count=count)
	arr=fltarr(nx,ny,count)
	tmp=fltarr(nx,ny)
	for i=0,(count-1) do begin
		print,'Loading '+all(i)

		openr,1,all(i)
		readf,1,tmp
		close,1

		arr(*,*,i)=tmp
	endfor
end
