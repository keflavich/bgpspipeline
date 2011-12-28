; this is a super-wrapper:
; it very strictly assumes a directory structure specific to milkyway
; therefore it should be used with EXTREME care
;
;
pro coalign_field,field_name,ref_map,scratchdir=scratchdir,coalign=coalign,$
        premap=premap,sliced_dir=sliced_dir,ref_field=ref_field,infile=infile,$
        checkpointing=checkpointing,npca=npca,prefix=prefix,refim=refim,$
        niter=niter,dsfactor=dsfactor,version=version, $
        pointing_model=pointing_model,indiv_prefix=indiv_prefix,_extra=_extra
    if ~keyword_set(scratchdir) then scratchdir = getenv('WORKINGDIR') 
    if n_elements(premap) eq 0 then premap=1
    if n_elements(checkpointing) eq 0 then checkpointing=0
    if n_elements(pointing_model) eq 0 then pointing_model=1
    if ~keyword_set(sliced_dir) then sliced_dir='sliced'
    if ~keyword_set(ref_field)  then ref_field =field_name
    if ~keyword_set(npca) then npca=[13,13]
    if ~keyword_set(niter) then niter=intarr(10)+13
    if keyword_set(version) and ~keyword_set(prefix) then prefix="v"+strc(version)+"_"
    if ~keyword_set(prefix) then prefix=""
    if ~keyword_set(dsfactor) then dsfactor=2
    if ~keyword_set(infile) then begin
        if ~getenv('INFILES') then infile=getenv('SLICED')+'/'+field_name+'/'+field_name+'_infile.txt' $
            else infile=getenv('INFILES')+'/'+field_name+'_infile.txt' 
    endif else begin
        if ~getenv('INFILES') then infile=getenv('SLICED')+'/INFILES/'+infile $
        else infile = getenv('INFILES')+'/'+infile
    endelse
    if n_elements(indiv_prefix) eq 0 then indiv_prefix=""
    print,"Reading files from ",infile

    pca_label = strc(niter[0])
    indiv_pca_label = strc(npca[0])
    if ~keyword_set(refim) then refim=scratchdir+'/'+ref_field+'/'+ref_map+'_raw_ds5.nc_indiv'+indiv_pca_label+'pca_map01.fits' 
    if n_elements(no_coadd) eq 0 then no_coadd = 0
    if n_elements(coalign) eq 0 then coalign=1

    start_time = systime(/sec)
    print,"FIELD "+prefix+field_name+" BEGUN at "+systime()

    spawn,'pwd',pwd

    field_dir = scratchdir+"/"+field_name
    cd,field_dir
    
    if (premap) then begin
        individual_obs,infile,$
            scratchdir+'/'+field_name+'/'+indiv_prefix,/fits_smooth,npca=npca,pointing_model=pointing_model,/no_offsets,_extra=_extra
        spawn,'ls '+field_dir+"/0*"+pca_label+"*_map01.fits > "+field_dir+"/"+field_name+"_fitslist.txt"
    endif
    spawn,'ls '+field_dir+"/[01]*ds"+strc(dsfactor)+"*"+indiv_pca_label+"*_map"+string(n_elements(npca)-1,format="(I02)")+".fits > "+field_dir+"/"+field_name+"_fitslist_ds"+strc(dsfactor)+".txt"

    if coalign then begin
        time_s,"Beginning coalignment: ",t0
        image_shifts,refim,$
            field_dir+"/"+field_name+'_fitslist_ds'+strc(dsfactor)+'.txt',$
            fileout=field_dir+"/"+field_name+'_align_to_'+ref_map+'.txt',$
            _extra=_extra
        write_imshifts,field_dir+'/'+field_name+'_align_to_'+ref_map+'.txt'
        ref_file = getenv('SLICED')+ref_field+'/'+ref_map+'_raw_ds5.nc'
        if file_test(ref_file) then ncdf_varput_scale,ref_file,'radec_offsets',[0,0] $
            else begin
                ref_file = getenv('SLICED_POLY')+ref_field+'/'+ref_map+'_raw_ds5.nc'
                if file_test(ref_file) then ncdf_varput_scale,ref_file,'radec_offsets',[0,0] 
            endelse
        time_e,t0,prtmsg="Finished coalignment in "
    endif


    if checkpointing then $
        individual_obs,infile,$
            scratchdir+'/'+field_name+'/lbcorrected',/fits_smooth,npca=npca,pointing_model=pointing_model,_extra=_extra

    if no_coadd eq 0 then $
        mem_iter,infile,$
            scratchdir+'/'+field_name+'/'+prefix+field_name+'_'+pca_label+'pca',$
            workingdir=scratchdir,niter=niter,/fits_smooth,pointing_model=pointing_model,$
            /dosave,version=version,source_name=field_name,$
            fits_timestream=0,ts_map=0,_extra=_extra
        ; iter0savename=scratchdir+'/'+field_name+'/'+field_name+".sav",  ; 2/20/09 removed this line because I want to distinguish versions
;    mem_iter_pc,'/scratch/'+sliced_dir+'/'+field_name+'/'+field_name+'_infile.txt',$
;        '/scratch/adam_work/'+field_name+'/'+field_name+'_13pca_nooffs',$
;        workingdir=scratchdir,niter=intarr(10)+13,/deconvolve,/fits_smooth,/pointing_model,/no_offsets

    print,"FIELD "+prefix+field_name+" COMPLETED at "+systime()+".  Took "+strc(systime(/sec)-start_time)+" seconds"
    cd,pwd

end
