
pro compare_pointings,infile,outdir=outdir,dontmap=dontmap,_extra=_extra
    readcol,infile,filelist,format='A80',/silent
    if ~keyword_set(outdir) then outdir="TEST/"

    for i=0,n_e(filelist)-1 do begin
        filename = filelist[i]
        time_s,"Starting compare_pointings for file "+filename,time_cmp,/no_sticky
        lastslash = strpos(filename,'/',/reverse_search)
        filedir = strmid(filename,0,lastslash)
        next2lastslash = strpos(filedir,'/',/reverse_search)
        source_name = strmid(filename,next2lastslash+1,lastslash-next2lastslash-1)
;        file_nodir = strmid(filename,lastslash+1,strlen(filename)-3)
        file_nodir = strmid(filename,lastslash+1,strlen(filename)-lastslash-4)
        if ~keyword_set(dontmap) then begin
            mem_iter_pc,filename,outdir+file_nodir+"_noabnutnoprecess_"      +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/dontprecess,/dontabnut,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_noabnutnoprecessnofazo_"+source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/dontprecess,/dontabnut,/dont_correct_pointing,/pointing_model,_extra=_extra
            mem_iter_pc,filename,outdir+file_nodir+"_noabnut_"               +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/dontabnut,_extra=_extra
            mem_iter_pc,filename,outdir+file_nodir+"_rawcsoptg_"             +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/pointing_model,/raw_cso_pointing,_extra=_extra
            mem_iter_pc,filename,outdir+file_nodir+"_rawcsoptg_noprecesss_"  +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/pointing_model,/raw_cso_pointing,/dontprecess,_extra=_extra
            mem_iter_pc,filename,outdir+file_nodir+"_rawcsoptg_noabnut_"     +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/pointing_model,/raw_cso_pointing,/dontabnut,_extra=_extra
            mem_iter_pc,filename,outdir+file_nodir+"_rawcsoptg_noprecnoabnut_"+source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/pointing_model,/raw_cso_pointing,/dontabnut,/dontprecess,_extra=_extra
            mem_iter_pc,filename,outdir+file_nodir+"_ptgmdl_"                +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,/pointing_model,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_plusabnut_nomodel_"     +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='p',_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_minusabnut_nomodel_"    +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='m',_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_plusabnut_pm_"          +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='p',/pointing_model,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_minusabnut_pm_"         +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='m',/pointing_model,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_plusabnut_mp_"          +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='p',/pointing_model,/mp,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_minusabnut_mp_"         +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='m',/pointing_model,/mp,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_plusabnut_pm_altproj_"  +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='p',/pointing_model,/project_alt,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_minusabnut_pm_altproj_" +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='m',/pointing_model,/project_alt,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_plusabnut_mp_altproj_"  +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='p',/pointing_model,/mp,/project_alt,_extra=_extra
;            mem_iter_pc,filename,outdir+file_nodir+"_minusabnut_mp_altproj_" +source_name,workingdir='/scratch/adam_work/',minb=10,niter=[3],/deconvolve,/galactic,abnutsign='m',/pointing_model,/mp,/project_alt,_extra=_extra
        endif
        maplist = outdir+file_nodir+"_"+source_name+"_maplist.txt"
        openw,f,maplist,/get_lun
        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_noabnutnoprecess_"+         source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_noabnutnoprecessnofazo_"+   source_name+"_map0.fits"
        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_noabnut_"+                  source_name+"_map0.fits"
        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_ptgmdl_"+                   source_name+"_map0.fits"
        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_rawcsoptg_"              +  source_name+"_map0.fits"
        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_rawcsoptg_noprecesss_"   +  source_name+"_map0.fits"
        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_rawcsoptg_noabnut_"      +  source_name+"_map0.fits"
        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_rawcsoptg_noprecnoabnut_"+  source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_plusabnut_nomodel_"+        source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_minusabnut_nomodel_"+       source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_plusabnut_pm_"+             source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_minusabnut_pm_"+            source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_plusabnut_mp_"+             source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_minusabnut_mp_"+            source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_plusabnut_pm_altproj_"+     source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_minusabnut_pm_altproj_"+    source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_plusabnut_mp_altproj_"+     source_name+"_map0.fits"
;        printf,f,"/scratch/adam_work/"+outdir+file_nodir+"_minusabnut_mp_altproj_"+    source_name+"_map0.fits"
        close,f
        free_lun,f
        centfile = outdir+file_nodir+"_"+source_name+"_centroids.txt"
        find_object_radec,filename,objra,objdec
        if finite(objra) and finite(objdec) then $
            centroid_file_list,maplist,centfile,ra=objra,dec=objdec,source_name=source_name $
        else print,"No object RA/Dec found for ",filename,".  Could not centroid."
        time_e,time_cmp,prtmsg="DONE comparing pointings for file "+filename+"  "
        print,""
    endfor
end


