; this is a super-wrapper:
; it very strictly assumes a directory structure specific to milkyway
; therefore it should be used with EXTREME care
;
;
pro coalign_field,field_name,ref_map,scratchdir=scratchdir,coalign=coalign,$
        premap=premap,sliced_dir=sliced_dir,ref_field=ref_field,infile=infile,$
        checkpointing=checkpointing,npca=npca,prefix=prefix,refim=refim,$
        niter=niter,version=version,_extra=_extra
    if ~keyword_set(scratchdir) then scratchdir = getenv('WORKINGDIR') ;'/scratch/adam_work'
    if n_e(premap) eq 0 then premap=1
    if n_e(checkpointing) eq 0 then checkpointing=0
    if ~keyword_set(sliced_dir) then sliced_dir='sliced'
    if ~keyword_set(ref_field)  then ref_field =field_name
    if ~keyword_set(npca) then npca=[13,13]
    if ~keyword_set(niter) then niter=intarr(10)+13
    if keyword_set(version) and ~keyword_set(prefix) then prefix="v"+strc(version)+"_"
    if ~keyword_set(prefix) then prefix=""
    if ~keyword_set(infile) then infile='/scratch/'+sliced_dir+'/'+field_name+'/'+field_name+'_infile.txt' $
        else infile='/scratch/sliced/INFILES/'+infile
    print,"Reading files from ",infile

    pca_label = strc(npca[0])
    if ~keyword_set(refim) then refim=scratchdir+'/'+ref_field+'/'+ref_map+'_raw_ds5.nc_indiv'+pca_label+'pca_map01.fits' 
    if n_e(no_coadd) eq 0 then no_coadd = 0
    if n_e(coalign) eq 0 then coalign=1

    start_time = systime(/sec)
    print,"FIELD "+prefix+field_name+" BEGUN at "+systime()

    field_dir = scratchdir+"/"+field_name
    cd,field_dir
    
    if (premap) then begin
        individual_obs,infile,$
            scratchdir+'/'+field_name+'/',/fits_smooth,npca=npca,/pointing_model,/no_offsets,version=version,_extra=_extra
        spawn,'ls '+field_dir+"/0*"+pca_label+"*_map01.fits > "+field_dir+"/"+field_name+"_fitslist.txt"
    endif

    if coalign then begin
        image_shifts,refim,$
            field_dir+"/"+field_name+'_fitslist.txt',$
            field_dir+"/"+field_name+'_align_to_'+ref_map+'.txt',$
            _extra=_extra
        write_imshifts,field_dir+'/'+field_name+'_align_to_'+ref_map+'.txt'
        ref_file = '/scratch/sliced/'+ref_field+'/'+ref_map+'_raw_ds5.nc'
        if file_test(ref_file) then ncdf_varput_scale,ref_file,'radec_offsets',[0,0] $
            else begin
                ref_file = '/scratch/sliced_polychrome/'+ref_field+'/'+ref_map+'_raw_ds5.nc'
                if file_test(ref_file) then ncdf_varput_scale,ref_file,'radec_offsets',[0,0] 
            endelse
    endif


    if checkpointing then $
        individual_obs,infile,$
            scratchdir+'/'+field_name+'/lbcorrected',/fits_smooth,npca=npca,/pointing_model,_extra=_extra

    if no_coadd eq 0 then $
        mem_iter,infile,$
            scratchdir+'/'+field_name+'/'+prefix+field_name+'_'+pca_label+'pca',$
            workingdir=scratchdir,niter=niter,/fits_smooth,/pointing_model,$
            /dosave,version=version,$
            fits_timestream=0,ts_map=0,_extra=_extra
        ; iter0savename=scratchdir+'/'+field_name+'/'+field_name+".sav",  ; 2/20/09 removed this line because I want to distinguish versions
;    mem_iter_pc,'/scratch/'+sliced_dir+'/'+field_name+'/'+field_name+'_infile.txt',$
;        '/scratch/adam_work/'+field_name+'/'+field_name+'_13pca_nooffs',$
;        workingdir=scratchdir,niter=intarr(10)+13,/deconvolve,/fits_smooth,/pointing_model,/no_offsets

    print,"FIELD "+prefix+field_name+" COMPLETED at "+systime()+".  Took "+strc(systime(/sec)-start_time)+" seconds"

end
