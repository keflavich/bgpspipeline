; individual_obs is a wrapper code that takes in a filename list
; and then runs mem_iter_pc on each element of that list
; it uses the default reduction scheme of deconvolution and baseline subtraction
; though it allows you to specify the number of PCA components
; the input files will be renamed in a pretty ugly fashion, where 
; _indiv#pca will be appended to the file name and then prepended
; to the standard pipeline postfixes.  # is the number of PCA components
; default is 3 PCA components
; a prefix can be automatically found as the directory directly containing the file,
; but a user-specific prefix that comes first MUST be specified

pro individual_obs,infilename,prefix,find_prefix=find_prefix,npca=npca,workingdir=workingdir,_extra=_extra
if ~keyword_set(npca) and size(npca,/n_d) ne 1 then npca = [3]
if ~keyword_set(workingdir) then workingdir=getenv('WORKINGDIR')
;if ~keyword_set(prefix) then find_prefix = 1 else find_prefix = 0
	
if n_e(infilename) gt 1 then filelist=infilename $
    else if strmid(infilename,strlen(infilename)-3,strlen(infilename)) eq '.nc' then filelist=[infilename] $
    else readcol,infilename,filelist,format='A80',comment="#"
for i=0,n_e(filelist)-1 do begin
	filename = filelist[i]
	if keyword_set(find_prefix) then begin
		last_slash = strpos(filename,'/',/reverse_search)
		substring1 = strmid(filename,0,last_slash)
		next_last_slash = strpos(substring1,'/',/reverse_search)
		tprefix = strmid(filename,next_last_slash+1,last_slash-next_last_slash) + prefix
	endif else tprefix = prefix
	outname = tprefix+strmid(filename,strpos(filename,'/',/reverse_search)+1,strlen(filename)-3)+"_indiv"+strc(npca[0])+"pca"
 	print,"Individual_obs on file " + filename + " with output " + outname 
	; this doesn't do anything if stregex(filename,"mars") gt 0 then mars=1 else mars=0
	mem_iter,filename,outname,workingdir=workingdir,/median_sky,niter=npca,$
            iter0savename=outname+'_save_iter0.sav',_extra=_extra
endfor


end
