
pro compare_images,outmap,cuts=cuts,suffix1=suffix1,suffix2=suffix2,wcsaperture=wcsaperture,$
  in1=in1,in2=in2,point=point,pdb=pdb,outfile=outfile,title=title,header=header,samescale=samescale,$
  output_name=output_name,prefix1=prefix1,prefix2=prefix2,debug=debug,scalefactor1=scalefactor1,$
  scalefactor2=scalefactor2
; thin wrapper of python code
  ; do analysis:
  if keyword_set(pdb) then python='python -m pdb ' else python = 'python '
  command = python+getenv("PIPELINE_ROOT")+'/plotting/compare_images.py'
  if ~keyword_set(prefix1) then prefix1 = outmap
  if ~keyword_set(prefix2) then prefix2 = outmap
  if ~keyword_set(output_name) then output_name = outmap
  if n_elements(suffix1) gt 0  then file1 = prefix1+suffix1 else file1 = prefix1+"_inputmap.fits"
  if n_elements(suffix2) gt 0  then file2 = prefix2+suffix2 else file2 = prefix2+"_map20.fits"

  img1 = readfits(file1,hdr1)
  xcen = sxpar(hdr1,'CRVAL1')
  ycen = sxpar(hdr1,'CRVAL2')

  if n_elements(wcsaperture) eq 0 then wcsaperture="--wcsaperture "+strc(xcen)+","+strc(ycen)+",100,200" 
  if n_elements(in1) eq 0 then in1 = "Input"
  if n_elements(in2) eq 0 then in2 = "Map20"
  options = " "+wcsaperture+" --psd "+output_name+"_psds.png --savename "+output_name+"_compare.png --stf "+output_name+"_stf.png --im1 "+in1+" --im2 "+in2
  if n_elements(cuts) eq 0 then cuts='0.1,0.25'
  if size(cuts,/type) ne 7 then cuts=string(cuts,/print)
  if keyword_set(cuts) then options = " --cuts "+cuts+options
  if keyword_set(outfile) then options = " --datafile "+outfile+options
  if keyword_set(point) then options = options+" --point "+output_name+"_pointcompare.png"
  if keyword_set(title) then options = options+" --title '"+title+"'"
  if keyword_set(header) then options = options+" --header "+header
  if keyword_set(samescale) then options = options+" --samescale "
  if keyword_set(debug) then options = options+" --debug "
  if keyword_set(units) then options = options+" --units="+strcompress(units,/remove_all)
  if keyword_set(scalefactor1) then options = options+" --scalefactor1="+strcompress(scalefactor1,/remove_all)
  if keyword_set(scalefactor2) then options = options+" --scalefactor2="+strcompress(scalefactor2,/remove_all)
  print,(command+" "+file1+" "+file2+" "+options)
  spawn,(command+" "+file1+" "+file2+" "+options),outputs
  print,"compare_images output: ",outputs
end
