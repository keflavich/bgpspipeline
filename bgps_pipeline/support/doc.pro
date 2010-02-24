pro doc,name,full=full
;+
; ROUTINE:    doc
;
; PURPOSE:    find and display help for a named procedure
;
; USEAGE:     doc,'name'
;
; INPUT: 
;   name      name of idl .pro file.  Asterisk characters, "*", in NAME
;             specify wild card matches to 1 or more arbitrary characters.
;
;
; PROCEDURE:  DOC searches through the files /local/idl/help/*.help 
;             trying to find matches for the file specification, NAME.  
;
;             if there are no matches a brief failure message is displayed
;                  and control returns to the terminal
;
;             if 1 match is found, help for the specified procedure is 
;                  displayed and control returns to the terminal
;
;             if 2 or more matches are found a menu is generated 
;                  from which selections can be made.  Control returns to 
;                  the terminal when the DONE button of the MENUW widget
;                  is pressed.
;
;
; EXAMPLE:
;             doc,'legend'            ; exact match found in ESRG_LOCAL
;             
;             doc,'tv*'               ; many matches found, browse through
;                                     ; choices.  Notice that all procedure
;                                     ; libraries are searched
;
;
;  author:  Paul Ricchiazzi                            may94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

if n_elements(name) eq 0 then begin
  xhelp,'/local/idl/user_contrib/esrg/doc.pro'
  return
endif

helpfiles=findfile('/local/idl/help/*.help')

pname=strarr(1000)
gname=strarr(1000)

pstar=strupcase(name)
jj=-1
for i=0,n_elements(helpfiles)-1 do begin
  ig1=rstrpos(helpfiles(i),'/')+1
  ig2=strpos(helpfiles(i),'.help') 
  ig3=strpos(helpfiles(i),'_')
  if ig3 gt 0 then ig2=ig3
  group=strmid(helpfiles(i),ig1,ig2-ig1)
  openr,lun,/get_lun,helpfiles(i)
  line=''
  while strpos(line,';+') lt 0 do begin
    readf,lun,line
    ii=strpos(line,':')
    pn=strmid(line,ii+1,100)
    if ii ge 0 and strmatch(pn,pstar) then begin
      jj=jj+1
      pname(jj)=pn
      gname(jj)=group
    endif
  endwhile
  free_lun,lun
endfor

if jj eq -1 then begin
  font='-adobe-helvetica-bold-o-normal--24-240-75-75-p-138-iso8859-1'
  xmessage,'No matches found',wbase=wbase,font=font
  wait,2
  xmessage,kill=wbase
  return
endif

if jj gt 0 then begin
  pname=pname(0:jj)
  gname=gname(0:jj)
endif

nspc=strlen(gname)
mxspc=max(nspc)

for i=0,jj do pname(i)=gname(i)+repchr(4+mxspc-nspc(i))+pname(i)

if jj eq 0 then begin
  man_proc,pname(0)
endif else begin
  w=menuw(pname,prompt=['These files match "'+name+'"','choose one'],/done)
  k=menuw(w)
  while k ge 0 do begin
    man_proc,pname(k)
    k=menuw(w)
  endwhile
endelse

end

