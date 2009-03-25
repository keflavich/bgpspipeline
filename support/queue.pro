pro queue
;+
; ROUTINE:      queue
;
; PURPOSE:      display print queues
;
; USEAGE:       queue
;
; PROCEDURE:    choose print queue from pop up menu
;
; AUTHOR:   Paul Ricchiazzi                        01 Jun 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
pdefault=getenv("PRINTER")
printers=[pdefault]
descrip =['(the default printer)']
openr,lunp,/get_lun,"/etc/printcap"
line='' & blank='                       '

while eof(lunp) eq 0 do begin
  readf,lunp,line
  if strpos(line,'|') ge 0 then begin
    parse=str_sep(line,"|")
    if strpos(parse(0),'6') eq 0 then parse(0)=parse(1)
    dsc=parse(n_elements(parse)-1)
    printers=[printers,parse(0)]
    nd=strlen(dsc)-2
    descrip=[descrip,strmid(dsc,0,nd)]
  endif
endwhile

free_lun,lunp
plen=strlen(printers)
pspace=fix(5+max(plen)-plen)
nprn=n_elements(printers)
for i=0,nprn-1 do descrip(i)=printers(i)+$
                             strmid(blank,0,pspace(i)) + descrip(i)

descrip=['Choose a print queue',descrip]
print=wmenu(descrip,title=0,init=1)-1
if print ge 0 then begin
  if printers(print) eq '' then $
    message,"check value of PRINTER environment variable"
  print,printers(print)
  spawn,['lpq','-P',printers(print)],/noshell,result
  choice=[printers(print),result]
  j=wmenu(choice,title=0,init=1)
endif

return
end





