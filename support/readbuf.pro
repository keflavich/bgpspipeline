pro readbuf,file,buf,tag=tag,nskip=nskip,point=point,ntag=ntag, $
            err=err,columns=columns,nlines=nlines
;+
; purpose:    read a multi-dimension data buffer from a named ASCII file
;
; USEAGE:     readbuf,file,buf
;             readbuf,file,buf,tag=tag,ntag=ntag,nskip=nskip,point=point,$
;                     err=err,columns=columns,nlines=nlines
; input:  
;
;   file      file name   
;
;   buf       a named array or structure set up to match the 
;             data structure of FILE.
;             
;
; optional keyword input:
;
;   tag       string to search before reading begins.
;             READBUF will scan through FILE looking for a line
;             containing the string TAG. Data input starts on the
;             next record (or NSKIP records later, if NSKIP is set)
;
;   ntag      number of times TAG string is searched before reading input
;             (default=1 when TAG is set, otherwise zero)
;
;   nskip     number of records to skip before reading data.
;             If TAG is set, data input starts NSKIP records after the 
;             NTAG'th occurance of the TAG string in the file.
;             If TAG is not set, data input starts NSKIP records 
;             after the begining of the file. (default=0)
;
;   point     byte offset into file after which reading begins
;
;   columns   if set buf is automatical dimensioned fltarr(columns,nlines)
;             where nlines is the number of lines remaining in the file
;             after tag, ntag and nskip actions.  This option doesn't
;             work when POINT is specified.
;
;   nlines    if set buf is dimensioned fltarr(columns,nlines)
;             where columns is set with the COLUMNS option.  
;
; output:
;
;  buf        data array 
;
; keyword output:
;
;  point      byte offset into file at which reading stoped,
;             can be used as input to next call of READBUF
;
; EXAMPLE:
;;             following a bunch of uninteresting output a fortran code 
;;             writes to file junk.dat as follows
;;
;;              write(*,'(a)') 'bufout:'
;;              do 20 k=1,3
;;               do 10 j=1,6
;;                 write(*,'(1p11e11.3)') (buf(i,j,k), i=1,11) 
;;          10   continue
;;          20 continue
;;
;;            the buf array could be read with
;
;              buf=fltarr(11,6,3)
;              readbuf,'junk.dat',buf,tag='bufout:'
; 
;;            if the fortran code listed above were executed twice
;;            it is possible to read the second occurance of buf as follows
;
;              point=0                              
;              buf0=fltarr(1)
;              readbuf,'junk.dat',buf0,tag='bufout:',point=point 
;              buf=fltarr(11,6,3)
;              readbuf,'junk.dat',buf,tag='bufout:',point=point
;
;;            In this case the first call to READBUF is used to find the
;;            point (byte offset) in the file just past the first instance
;;            of the string 'bufout:'.  The second call to READBUF starts 
;;            where the previous READBUF left off, scanning the file until
;;            just after the second  occurance of 'bufout:'. At this point
;;            the second buf is read.
;
;;            a simpler way of doing the same thing is with the NTAG parameter,
;
;              buf=fltarr(11,6,3)
;              readbuf,'junk.dat',buf,ntag=2,tag='bufout:',
;             
;             NOTE: care must be taken that the TAG string is unique.
;
;  author:  Paul Ricchiazzi                            8JAN93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-


if n_params() eq 0 then begin
  xhelp,'readbuf'
  return
endif  

line=''
get_lun,lun
openr,lun,file

on_ioerror,bail_out

if keyword_set(ntag) eq 0 then ntag=1
if keyword_set(point) then point_lun,lun,point
;
iline=0
if keyword_set(tag) then begin
  for ntg=1,ntag do begin
    repeat begin
      readf,lun,line 
      iline=iline+1
    endrep until strpos(line,tag) ge 0
  endfor
endif
;
if keyword_set(nskip) then begin
  for i=1,nskip do begin
    readf,lun,line
    iline=iline+1
  endfor
endif
;
if keyword_set(columns) then begin
  if not keyword_set(nlines) then nlines=n_lines(file)-iline
  if columns eq 1 then  buf=fltarr(nlines) else buf=fltarr(columns,nlines)
endif

readf,lun,buf
point_lun,-lun,point
free_lun,lun
on_ioerror,null
;
err=0
return

bail_out:

err=1
free_lun,lun
return
end







