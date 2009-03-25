pro dockey,keywords,minmatch=minmatch
;+
; ROUTINE:    dockey
;
; PURPOSE:    display help documententation of file headers which
;             contain matches for specified keywords
;
; USEAGE:     dockey,'name',keyword=keyword,all=all,minmatch=minmatch
;
; INPUT: 
;   keywords  keyword string. Keywords withing the KEYWORDS must be
;             separated by blanks. 
;
; KEYWORD_INPUT
;
;   minmatch  the minimum number of keyword hits required for a procedure
;             to be listed in the hit-list menu. 
;
; PROCEDURE:  DOCKEY searches through the helpfiles in subdirectory
;             /local/idl/help, trying to find matches for the keywords.
;             If more than one file match is found a menu of procedure
;             names is displayed from which the desired procedure
;             can be selected.  The parenthisized number next to each
;             procedure name is the number of keyword matches, which
;             can vary between one to the total number of keywords in
;             KEYWORDS. 
;
;             MAN_PROC is used to display the text
;
; EXAMPLE:
;             dockey,'simpson rule integration';  pick group 'numerical'
;            
;             dockey,'polar orthographic'      ;  pick group 'esrg'
;
;             dockey,'color key image',m=2     ;  pick group 'color'
;
;; 
;
;
;  author:  Paul Ricchiazzi                            may94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

helppath='/local/idl/help/*.help'

keys=str_sep(keywords,' ')
files=findfile(helppath)

if not keyword_set(all) then begin
  slsh=rstrpos(files(0),'/')
  fitems=strmid(files,slsh+1,100)
  for i=0,n_elements(fitems)-1 do fitems(i)=(str_sep(fitems(i),'.'))(0)
  w=menuws(fitems,prompt='choose a help lib group',/order)
  if min(w) eq -1 then return
  files=files(w)
endif

nkeys=n_elements(keys)

if keyword_set(minmatch) then limit=minmatch < nkeys else limit=1

nhlp=n_elements(files)
imenu=''
pname=''
groupm=''
nn=0

for i=0,nhlp-1 do begin
  openr,lun,/get_lun,files(i)
  line='%'
  while strpos(line,'%') ge 0 do readf,lun,line
  reads,line,nn
  readf,lun,line

  name_arr=strarr(nn)
  hits_arr=lonarr(nn)
  for j=0,nn-1 do begin 
    readf,lun,f='(a15)',line 
    lline=str_sep(line,':')
    name_arr(j)=lline(1)
  endfor

  for k=0,nkeys-1 do begin
    cmd1=['grep','-ni',keys(k),files(i)]
    cmd2=['grep','-n','^;+$',files(i)]
    spawn,cmd1,matches,/noshell
    spawn,cmd2,matchp,/noshell
    m1=0
    m2=0
    for j=0,n_elements(matchp)-1 do begin &$
      m=str_sep(matchp(j),':') &$
      m1=[m1,long(m(0))] &$
    endfor 
    for j=0,n_elements(matches)-1 do begin &$
      m=str_sep(matches(j),':') &$
      m2=[m2,long(m(0))] &$
    endfor
    if n_elements(m1) gt 1 and n_elements(m2) gt 1 then begin
      m1=m1(1:*)
      m2=m2(1:*)
      mm=[lindgen(n_elements(m1)),replicate(-1,n_elements(m2))]
      ii=sort([m1,m2])
      mm=mm(ii)
      ms=shift(mm,-1)
      ms(n_elements(ms)-1)=0
      jj=where(mm ge 0 and ms lt 0, nhit)
      if nhit ne 0 then begin
        ind=mm(jj)
        hits_arr(ind)=hits_arr(ind)+1
      endif
    endif
  endfor

  ii=where(hits_arr ge limit,nhit)
  if nhit gt 0 then begin
    l1=rstrpos(files(i),'/')+1
    l2=strpos(files(i),'.help') 
    l3=strpos(files(i),'_')
    if l3 gt l1 then l2=l2 < l3        
    grp=strmid(files(i),l1,l2-l1)
    for n=0,nhit-1 do begin
      rootname=name_arr(ii(n))
      if strpos(rootname,'<') ne 0 then begin
        hits=hits_arr(ii(n))
        groupm=[groupm,grp]
        pname=[pname,rootname]
        item=string(f='(a10,3x,a,a,i0,a)',grp,rootname,'   (',hits,')')
        imenu=[imenu,item]
      endif
    endfor
  endif
  free_lun,lun
endfor


case n_elements(imenu) of
1:begin
  imenu(0)='DONE'
  font='-adobe-helvetica-bold-o-normal--24-240-75-75-p-138-iso8859-1'
  xmessage,'No matches found',wbase=wbase,font=font
  wait,2
  xmessage,kill=wbase
  end
2:begin
  man_proc,groupm(1)+' '+pname(1)
  end
else:begin
  imenu(0)= ' '
  prompt=['choose one of the matches to keywords:',keywords]
  w=menuw(imenu,prompt=prompt,title='wild card matches',/done)
  k=menuw(w)
  while k ne -1 do begin
    grp_pro=groupm(k)+' '+pname(k)
    man_proc,grp_pro
    k=menuw(w)
  endwhile
  end
endcase

end
