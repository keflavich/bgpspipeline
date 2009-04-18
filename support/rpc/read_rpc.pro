; $Id: read_rpc.pro,v 1.4 2008/02/20 19:52:50 jaguirre Exp $
; $Log: read_rpc.pro,v $
; Revision 1.4  2008/02/20 19:52:50  jaguirre
; One last tweak?
;
; Revision 1.3  2008/02/20 19:41:21  jaguirre
; More of the same.
;
; Revision 1.2  2008/02/20 19:33:08  jaguirre
; Making the FAZO/FZAO reading from rpc ready to use on milkyway.
;

function read_rpc, filename, $
                   def_file = def_file, use_file = use_file, $
                   hdr_file = hdr_file

; Header file contains variables which are constant over an observation
pipeline_root = getenv('PIPELINE_ROOT') ;BOLOCAM_PIPELINE_ROOT

if not(keyword_set(def_file)) then $
  def_file = PIPELINE_ROOT + '/support/rpc/rpc_def.txt'

if not(keyword_set(use_file)) then $
  use_file = PIPELINE_ROOT + '/support/rpc/rpc_use.txt'

if not(keyword_set(hdr_file)) then $
  hdr_file = PIPELINE_ROOT + '/support/rpc/rpc_hdr.txt'

; File containing the definition of the RPC frame
readcol,def_file,comment=';',format='(A,I,A)',$
  var_type, n_array, var_name,/silent

; Specify the number of bytes for each variable
nbytes_var = lonarr(n_e(var_type))
for i=0,n_e(var_type)-1 do begin
    case var_type[i] of 
        'double' : nbytes_var[i] = 8L*n_array[i]
        'int' : nbytes_var[i] = 4L*n_array[i]
        'char' : nbytes_var[i] = 1L*n_array[i]
    endcase
endfor

; Define a structure so that read_binary can read the file

; 17 May 2007 - BN - using both ENDIAN = 'little' & 
; swap_if_big_endian in OPENR caused endian problems on Bret Naylor's
; PowerBook G4.  Commenting out the ENDIAN declaration in the line
; below fixed the problem and worked properly on tuamotu.jpl.nasa.gov
; (a presumeably little endian system).  Hopefully this will work
; on all machines.  
binary_template = create_binary_template(def_file);,ENDIAN = 'little')

; Create a template structure by reading the first frame of the file
OPENR, lun, filename, /GET_LUN,/swap_if_big_endian
data_template = read_binary(lun,template=binary_template)

ntags = n_tags(data_template)
nbytes_per_frame = long(total(nbytes_var)) ;n_tags(data_template,/data_length)

;openr,unit,filename,/get_lun
nbytes = (fstat(lun)).size
;close,unit
;free_lun,unit

; Figure out how many frames are in the data
if ( (nbytes mod nbytes_per_frame) ne 0) then begin
    message,'Data file does not contain an integral number of data frames.'
endif else begin
    nframes = nbytes / nbytes_per_frame
endelse

; Allocate an array of structures for the file

data = replicate(data_template,nframes)
data[0] = data_template ; data_template is the first frame

;byte_offset = 0
for i = 1,nframes-1 do begin
; lets try reading in a whole frame at a time - hopefully faster
   data[i] = READ_BINARY(lun,TEMPLATE = binary_template) 
; Well, it's only sligtly faster, but it still works.  I'll leave the
; original code in case it stops working.
;;     for j = 0,ntags-1 do begin
;;         sz = size(data[i].(j))
;;         data[i].(j) = read_binary(filename,$
;;                                   data_start=byte_offset,$
;;                                   data_type=sz[n_e(sz)-2], $
;;                                   data_dims = size(data[i].(j),/dim), $
;;                                   ENDIAN = 'little')
;;         byte_offset = byte_offset + nbytes_var[j]
;;     endfor
endfor

CLOSE, lun
FREE_LUN, lun

; Don't use all the variables
; File containing the definition of variables to use
readcol,use_file,comment=';',format='(A,I,A)',$
  var_type2, n_array2, var_name2,/silent

wh = where_arr(var_name, var_name2)

data_out = create_struct(var_name[wh[0]], data[0].(wh[0]))

for i = 1,n_e(wh)-1 do begin
    data_out = create_struct(data_out, var_name[wh[i]], data[0].(wh[i]))
endfor

data_out_array = replicate(data_out,nframes)

for i=0,n_e(wh)-1 do begin
    data_out_array.(i) = data.(wh[i])
endfor

return, data_out_array

end
