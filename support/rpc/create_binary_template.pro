function create_binary_template, def_file, endian = endian

if (keyword_set(endian)) then endian = endian else endian = 'native'

; Serves the same purpose as IDL's "binary_template" program, but
; creates the structure without using a GUI according to the
; definitions in the def_file

readcol,def_file,comment=';',format='(A,I,A)',$
  var_type, n_array, var_name, /silent

fieldcount = long(n_e(var_type))

typecodes = intarr(fieldcount)
for i=0,fieldcount-1 do begin
    case var_type[i] of 
        'double' : typecodes[i] = (size(double(0.)))[1]
        'int' : typecodes[i] = (size(long(0.)))[1]
        'char' : typecodes[i] = (size(byte(0.)))[1]
    endcase
endfor

offsets = replicate('>0', fieldcount)

numdims = lonarr(fieldcount)
numdims[where(n_array gt 1)] = 1

dimensions = strarr(fieldcount,8)
dimensions[where(numdims eq 1),0] = n_array[where(numdims eq 1)]

reverseflags = bytarr(fieldcount,8)

absoluteflags = bytarr(fieldcount)
    
returnflags = intarr(fieldcount) + 1

verifyflags = intarr(fieldcount)

dimallowformulas = intarr(fieldcount) + 1

offsetallowformulas = intarr(fieldcount) + 1

verifyvals = replicate('', fieldcount)

; Create the structure that read_binary needs
binary_struct = create_struct('version', 1.0, $
                              'templatename', 'rpc', $
                              'endian', endian, $
                              'fieldcount', fieldcount, $
                              'typecodes', typecodes, $
                              'names', var_name, $
                              'offsets', offsets, $
                              'numdims', numdims, $
                              'dimensions', dimensions, $
                              'reverseflags', reverseflags, $
                              'absoluteflags', absoluteflags, $
                              'returnflags', returnflags, $
                              'verifyflags', verifyflags, $
                              'dimallowformulas', dimallowformulas, $
                              'offsetallowformulas', offsetallowformulas, $
                              'verifyvals', verifyvals $
                             )

return,binary_struct

end
