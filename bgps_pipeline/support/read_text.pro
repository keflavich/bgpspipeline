function read_text,file,tag
;+
; ROUTINE:  read_text
;
; PURPOSE:  read text from a file
;
; USEAGE:   result=read_text(file,tag)
;
; INPUT:    
;   file    name of input file (string).  if only one argument is
;           supplied it is interpreted as the tag value and
;           "captions.txt" is used as the default file.
;
;   tag     search string.  READ_TEXT scans forward in the file until
;           a line containing the TAG string is found.  From there
;           READ_TEXT reads forward until an empty line is found.
;
;           You can also tag the text block with a special invisible
;           tag, i.e., a tag string which will not appear in the
;           output string.  This special tag is composed of any NUMBER
;           surrounded by the semicolon character ";".  In this case
;           the value of tag supplied to READ_TEXT should be an integer
;           For example if FILE contains the lines,
;
;       ;1;this is an example
;
;       ;2;this is the second line 
;
;          then read_text(FILE,1) would yield, "this is an example".
;
;          NOTE: Since a semicolon is interpreted by IDL as a comment
;                you can put your caption text inside your IDL scripts.
;
;
; OUTPUT:
;   result  matched text in FILE.
;
; DISCUSSION:
;   READ_TEXT can be used to read text blocks from a file.  READ_TEXT
;   opens the named file and scans forward in the file until a line
;   containing the TAG string is found.  READ_TEXT reads forward until
;   until a record containing no characters is found. (i.e., a
;   carriage return with no characters or spaces in the line).  All
;   text between the TAGed record and the blank line are returned.
;   READ_TEXT can be used with CAPTION to write figure captions onto
;   plots.
;
; EXAMPLE:  
;
;  suppose file captions.txt contains ("|" indicates zeroeth column):
;
;  |figure 1. some stuff
;  |
;  |figure 2. some other stuff
;  |test test test
;  |
;  |figure 3. some more stuff
;
; caption,read_text('captions.txt','figure 2.')
;
; AUTHOR:   Paul Ricchiazzi                        13 Mar 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if n_params() eq 1 then begin
  tag=file
  file='captions.txt'
endif
sz=size(tag)

if sz(n_elements(sz)-2) ne 7 then  $
   tag=strcompress(string(';',tag,';'),/remove_all)

openr,lun,/get_lun,file
line=''

while strpos(line,tag) lt 0 do readf,lun,line

text=line

while not eof(lun) and line ne '' do begin
  readf,lun,line 
  text=text+' '+line
endwhile

free_lun,lun

if strpos(text,';') eq 0 then begin
  i=strpos(text,';',1)+1
  text=strmid(text,i,10000)
endif

return,text

end
