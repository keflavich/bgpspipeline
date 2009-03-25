PRO TEXTOPEN,PROGRAM,TEXTOUT=TEXTOUT
;+
; NAME:
;	TEXTOPEN
; PURPOSE
;	Procedure to open file for text output.   The type of output 
;	device (disk file or terminal screen) is specified by the 
;	TEXTOUT keyword or the (nonstandard) system variable !TEXTOUT.
;
; CALLING SEQUENCE:
;	textopen, program, [ TEXTOUT = ]
;
; INPUTS:
;	program - scalar string giving name of program calling textopen
;
; OPTIONAL INPUT KEYWORDS:
;	TEXTOUT - Integer scalar (0-6) specifying output file/device to be 
;		opened (see below) or scalar string giving name of output file.
;		If TEXTOUT is not supplied, then the (non-standard) system 
;		variable !TEXTOUT is used.
;
; SIDE EFFECTS:
;	The following dev/file is opened for output.
;
;		textout=0 	Nowhere
;		textout=1	TERMINAL using /more option
;		textout=2	TERMINAL without /more option
;		textout=3	<program>.prt
;		textout=4	laser.tmp
;		textout=5      user must open file
;		textout = filename (default extension of .prt)
;
;	The unit it is opened to is obtained with the procedure GET_LUN
;	unless !TEXTOUT=5.  The unit number is placed in system variable 
;	!TEXTUNIT.  For !TEXTOUT=5 the user must set !TEXTUNIT to the 
;	appropriate unit number.
;
; NOTES:
;	Note that TEXTOUT = 1 or TEXTOUT = 2 will open a unit to the terminal,
;	SYS$OUTPUT (VMS) or /dev/tty (Unix).     However, this terminal 
;	output will *not* appear in an IDL JOURNAL session, unlike text
;	printed with the PRINT command.	
;
; NON-STANDARD SYSTEM VARIABLES:
;	DEFSYSV,'!TEXTOUT',1
;	DEFSYSV,'!TEXTUNIT',0
;
; HISTORY:
;	D. Lindler  Dec. 1986  
;	Keyword textout added, J. Isensee, July, 1990
;	Made transportable, D. Neill, April, 1991
;	Trim input PROGRAM string W. Landsman  Feb 1993
;	Don't modify TEXTOUT value   W. Landsman   Aug 1993
;-
;-----------------------------------------------------------
  ;
  ; Open proper unit.
  ;
  if N_elements( textout ) NE 1 then textout = !textout ;use default output dev.

  ptype = size(textout)
  if ptype(1) EQ 7 then begin      ;text if filename entered for textout
	filename = textout
	j = strpos(filename,'.')        ;test if file extension given
	if j lt 0 then filename = filename + ".prt"
	text_out = 6
  endif else text_out = textout     

  if TEXT_OUT eq 5 then begin
     if !TEXTUNIT eq 0 then begin
         print,' '
         print,' You must set !TEXTUNIT to the desired unit number...'
         print,'                    ...see following example'
         print,' '
         print,'                    OPENW, LUN, filename, /GET_LUN
         print,'                    !TEXTUNIT = LUN
         print,'                    DBPRINT...
         print,'
         print,' Action: returning'
         print,' '
         retall
     end
     return
  end

  if !TEXTUNIT ne 0 then free_lun,!TEXTUNIT 

  get_lun,unit
  !TEXTUNIT = unit

  case text_out of
     1: openw, !TEXTUNIT, filepath(/TERMINAL), /MORE

     2: openw, !TEXTUNIT, filepath(/TERMINAL)

     3: begin
        oname = strtrim( PROGRAM,2) +'.prt'
        openw, !TEXTUNIT, oname
        if !VERSION.OS EQ "vms" then oname = strupcase(oname)
        message,'Output is being directed to a file ' + oname,/INFORM
        end

     4: openw, !TEXTUNIT, 'laser.tmp'

     6: begin
        openw,!TEXTUNIT,filename
        message,'Output is being directed to a file ' + filename,/INFORM
        end

     0: openw,!TEXTUNIT, strtrim(PROGRAM,2) + '.tmp',/DELETE

     else: begin
        !textunit = 0
        print,' '
	print,' Invalid value for TEXTOUT =',TEXTOUT
        print,' '
        print,' 		...the possibilities are:
        print,' '
        print,' 		textout=0      nowhere
        print,' 		textout=1      terminal with /more
        print,' 		textout=2      terminal without /more
        print,' 		textout=3      file   <program>.prt
        print,' 		textout=4      file   laser.tmp
	print,' 		textout=5      User supplied file
        print,'                 textout = filename (default extension of .prt)
        print,' '
        print,' Action: returning
        print,' '
	retall
    end
 endcase

 return
 end   ; textout
