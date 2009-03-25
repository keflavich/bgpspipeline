 pro fordata,name,v,format=format,lun=lun,margin=margin
;+ 
; ROUTINE:      fordata
;
; USEAGE:       fordata,name,v,format=format,lun=lun,margin=margin
;
; PURPOSE:      print a fortran data statement defining variable NAME 
;               with data values v
;
; input:
;   name        name of variable or string to placed between the fortran
;               "data" and "/" keywords, as in 
; 
;               data NAME / ...
;
;   v           vector of values
;
; keyword input
;   format      format specifier (string) of the form 
;               x# or x## x#.# x##.# where x = { i, g, f, e } 
;               and # is a digit (default = 'g10.4').  Note that
;               the format string does not include parenthesis.
;
;   lun         logical unit number for output, if not specified output is
;               directed to standard out.
;
;   margin      number of leading blanks (margin=0 starts at column 7)
;               (default=2)
;
; output:       none
; 
; EXAMPLE:
;
;   v=sin(findgen(200))
;   openw,lun,'junk.f',/get_lun
;   fordata,'(v(i),i=1,200)',v,f='f12.6',lun=lun
;   close,lun
;
;  author:  Paul Ricchiazzi                            jun92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
if n_params() eq 0 then begin
  xhelp,'fordata'
  return
end
if n_params() ne 2 then message,'must supply both NAME and V'
if keyword_set(format) eq 0 then format='g10.4'
type=strmid(format,0,1)
if n_elements(margin) eq 0 then margin=2
if margin eq 0 then lb='' else lb=strtrim(string(margin),2)+'x,'
iw=strlen(string(f='('+format+')',0))

ncol=(72-6-margin)/(iw+1)
if ncol eq 0 then  message,"field width too wide"
nn=n_elements(v)
nlines=((nn+ncol-1)/ncol) 

f1=strcompress(string(nlines-1),/remove_all)             ; number of lines - 1
f2=strcompress(string(ncol),/remove_all)                 ; number of columns
f3=strcompress(string(nn-ncol*(nlines-1)-1),/remove_all) ; number of columns
                                                         ;  in last line

if f1 eq 0 then begin
  frmt="(5x,'&',"
endif else begin
  frmt="(" + f1 + "(5x,'&'," + lb + f2 + "(" + format + ",','),/),5x,'&',"
endelse
frmt=frmt + lb

if f3 eq 0 then begin
  frmt=frmt + format + ",'/')"
endif else begin
  frmt=frmt + f3 + "(" + format + ",',')," + format + ",'/')"
endelse

;       f1           f2 frm                 f3  frm     frm
;       vv           vv vvv                 vv  vvv     vvv
;frmt="(  (5x,'&',3x,  (   ,',')),5x,'&',3x,  (   ,','),  ,'/')"

if n_elements(lun) eq 0 then begin
  print,form='(6x,"data ",a,"/")',name
  print,form=frmt,v
endif else begin
  printf,lun,form='(6x,"data ",a,"/")',name
  printf,lun,form=frmt,v
endelse
end
