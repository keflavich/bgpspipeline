pro table,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,f=f,index=index
;+
; ROUTINE:    table
;
; PURPOSE:    print a table of vectors in nicely formatted columns
;
; USEAGE:     table,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,f=f
;
; INPUT:      
;  p1,p2,...  a set of vector quantities to print. all vectors must
;             be of the same length
;
; KEYWORD INPUT:
;   f         format specification string, E.G.  'f10.3,e11.2'
;
;             NOTE:     don't provide a specification for the integer
;             subscript which appears in the first column. TABLE puts
;             it in automatically. Also, the format string need not
;             have opening and closing parenthesis, but its ok to put
;             them in.
;
;   index     if set, the array indicies of the first parameter, p1,
;             are printed.  This only has effect when p1 has dimension
;             greater than two.  Indicies for array dimensions greater
;             than 5 are not printed.
;
;
; EXAMPLE:
;
;    x=sqrt(findgen(20)+23)
;    y=sin(.1*x)
;
;    table,x,y                                            ; 
;    table,x,y,x+y,x-y,x*y,(x+y)*(x-y),x/y,f='7f10.3'
;    table,rebin(x,4,5),y,/index
;    table,rebin(x,5,4),y,/index
;    table,rebin(x,5,2,2),y,/index
;
;  author:  Paul Ricchiazzi                            may94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
nn=n_elements(p1)
np=n_params()
parm1='p1(i)'

if keyword_set(index) then begin
  sz=size(p1)
  if sz(0) ge 2 then indicies='i mod sz(1),i/sz(1) mod sz(2)'
  if sz(0) ge 3 then indicies=indicies+',i/(sz(1)*sz(2)) mod sz(3)'
  if sz(0) ge 4 then indicies=indicies+',i/(sz(1)*sz(2)*sz(3)) mod sz(4)'
  if sz(0) ge 5 then indicies=indicies+',i/(sz(1)*sz(2)*sz(3)*sz(4)) mod sz(5)'
  if keyword_set(indicies) then parm1=indicies+','+parm1
endif

if keyword_set(f) then begin
  ff=f
  if strpos(ff,'(') eq 0  then ff=strmid(ff,1,100)
  if strpos(ff,')') eq strlen(ff)-1 then ff=strmid(ff,0,strlen(ff)-1)
  fmt='(i'+strcompress(string(fix(1+alog10(nn))),/remove_all)+','+ff+')'
  cmd="for i=i1,i1+iscrn do print,f='"+fmt+"',i,"+parm1
endif else begin
  cmd="for i=i1,i1+iscrn do print,i,' ',"+parm1
endelse
for i=2,np do cmd=cmd+",p"+strcompress(string(i),/remove_all)+"(i)"

print,cmd
iscrn=22
i1=0L

if iscrn gt nn-1 then begin
  iscrn=nn-1
  flag=execute(cmd)
endif else begin
  flag=execute(cmd)
  quit=0
  repeat begin
    i0=i1
    case get_kbrd(1) of
      'b': i1=(i1-iscrn-1L)>0
      'q': quit=1
      '0': i1=0L
      '1': i1=long(.1*nn)>0L<(nn-1-iscrn)
      '2': i1=long(.2*nn)>0L<(nn-1-iscrn)
      '3': i1=long(.3*nn)>0L<(nn-1-iscrn)
      '4': i1=long(.4*nn)>0L<(nn-1-iscrn)
      '5': i1=long(.5*nn)>0L<(nn-1-iscrn)
      '6': i1=long(.6*nn)>0L<(nn-1-iscrn)
      '7': i1=long(.7*nn)>0L<(nn-1-iscrn)
      '8': i1=long(.8*nn)>0L<(nn-1-iscrn)
      '9': i1=long(.9*nn)>0L<(nn-1-iscrn)
      'e': i1=(nn-1L-iscrn)
     else: i1=(i1+iscrn+1L)<(nn-1L-iscrn)
    end
    if i1 ne i0 then flag=execute(cmd)
  endrep until quit
endelse

if flag eq 0 then message,'illegal output operation'

end
