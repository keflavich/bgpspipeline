function pfill,string,nchars=nchars,exdent=exdent,cr=cr,nlines=nlines
;+
; ROUTINE:  pfill
;
; PURPOSE:  break a long string consisting of many blank-separated
;           words into a paragraph that consists of several lines each
;           with a given number of characters (60 character default).
;           This procedure can be use used with LEGEND to produce
;           nicely formated figure captions.  The nice thing about
;           PFILL is that it will properly compute the length of lines
;           which contain text escape sequences such as a = !7d!x!ai!b.
;
; USEAGE:   result=pfill(string,nchars=nchars)
;
; INPUT:    
;  string   a string which consists of words separated by blanks
;           Note that the !9K!x maps to a hardwired space
;
; KEYWORD INPUT:
;
;  nchars   maximum number of characters per line (default=60)
;
;  exdent   if set, EXDENT specifies the number of characters with
;           which to indent all but the first line.  Use this to make
;           a "hanging indent."  You can indent the first line by
;           simply adding some spaces to the beginning of the string.
;
;  cr       if set, replace instances of "\" in output string with "!c".  
;           This allows formatted string to be used with XYOUTS or PUTSTR.
;
; OUTPUT:
;  result   a paragraph string which consists of several lines each 
;           with a given number of characters (60 character default).
;           Lines are separated by the character "\", which is
;           understood by LEGEND to indicate a newline.  You can turn
;           the string into a string array, with each array element
;           corresponding to one line in the paragraph by using
;           STR_SEP.  For example, t=str_sep(pfill(t,n=30),'\').
;
;
; EXAMPLE:  
;
; 
; t='PURPOSE: break a long string consisting of many blank-separated '+$
;   'words into a paragraph that consists of several lines each with '+$
;   'a given number of characters (60 character default).  This procedure'+$
;   ' can be used with LEGEND to produce nicely formated figure'+$
;   ' captions.  The nice thing about PFILL is that it will properly'+$
;   ' compute the length of lines which contain text escape sequences'+$
;   ' such as x = !7d!xa!a2!n / !7d!xb!bi!n * (!13A - B!x) * (!13C -'+$
;   ' D!3).  Text editors do not understand that all those extra exclamation'+$
;   ' points should not be included in the character count of each line.'
; 
; w8x11
;
; legend,pfill(t),/fill,/box,/norm,pos=[0.14,0.71,0.82,0.98]
;
; legend,pfill(t,nchar=80),/fill,/box,/norm,pos=[0.05,0.48,0.96,0.68]
;
; legend,pfill(t,n=80,exdent=11),/fill,/norm,pos=[0.11,0.28,0.85,0.46]
;
; legend,pfill('        '+t,n=80),bg=0,/fill,/norm,pos=[0.11,0.04,0.89,0.22]
;
; AUTHOR:   Paul Ricchiazzi                        03 Jul 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
if not keyword_set(nchars) then nchars=60
len=lenstr(string)
slen=strlen(string)
dx=len/slen
linelen=dx*nchars
bstring=str_sep(string,' ')
blnklen=lenstr(' ')
wordlen=lenstr(bstring)

if keyword_set(cr) then newline='!c' else newline='\'

if keyword_set(exdent) then begin       ; !9K!x maps to a spc
  linesep=newline+'!9'+string(replicate(75b,exdent))+'!x'    
  extra=dx*exdent
endif else begin
  linesep=newline
  extra=0
endelse

result=bstring(0)
count=wordlen(0)
nlines=1
start=0
for i=1,n_elements(wordlen)-1 do begin
  bb=bstring(i)
  if not (bb eq '' and start) then begin
    if count+blnklen+wordlen(i) lt linelen then begin
      if bstring(i) eq '\' then begin
        result=result+linesep
        count=0
        nlines=nlines+1
        start=1
      endif else begin
        if start then begin
          result=result+bb
          ;print,'1|',bbt,'|',start
          count=count+wordlen(i)
        endif else begin
          result=result+' '+bb
          ;print,'2| ',bb,'|',start
          count=count+blnklen+wordlen(i)
        endelse
        start=0
      endelse
    endif else begin
      if bb ne '' then begin
        start=0
        result=result+linesep+bb
        ;print,'3|\',bbt,'|',start
        count=wordlen(i)+extra
        nlines=nlines+1
      endif
    endelse
  endif else begin
    start=0
    result=result+' '
    count=count+blnklen
  endelse

endfor
  
return,result
end

