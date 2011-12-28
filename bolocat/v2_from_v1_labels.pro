
pro v2_from_v1_labels,fieldname,props=props,doplot=doplot,v2mapdir=v2mapdir,$
    v2npca=v2npca,v2niter=v2niter,savedir=savedir,v2noisemapdir=v2noisemapdir,$
    savesuffix=savesuffix,dsfactor=dsfactor,v1field=v1field,continue=continue,$
    v2version=v2version

    if n_elements(v2version) eq 0 then v2version = 'v2.0_'
    if n_elements(v2mapdir) eq 0 then v2mapdir = '/Volumes/disk2/data/bgps/releases/v2.0/December2011/'
    if n_elements(v2noisemapdir) eq 0 then v2noisemapdir = '/Volumes/disk2/data/bgps/releases/v2.0/December2011/noise/'
    if n_elements(v2npca) eq 0 then v2npca = "_13pca" else v2npca = string(v2npca,format="('_',I0,'pca')")
    if n_elements(v2niter) eq 0 then v2niter = 20
    if n_elements(dsfactor) eq 0 then dsf = "ds2_" else dsf = string(dsfactor,format="('ds',I0,'_')")
    v1labeldir = '/Volumes/disk2/data/bgps/releases/IPAC/labelmap/'
    v1noisedir = '/Volumes/disk2/data/bgps/releases/IPAC/rmsmap/'
    v1mapdir   = '/Volumes/disk2/data/bgps/releases/v1.0/v1.0.2/'
    if n_elements(savedir) eq 0 then savedir    = '/Volumes/disk3/adam_work/v1v2compare/'
    if n_elements(savesuffix) eq 0 then savesuffix = "_v1v2_bolocat_compare.sav"
    if n_elements(v1field) eq 0 then v1field=fieldname

    data     = readfits(v2mapdir+"/"+v2version+dsf+fieldname+v2npca+"_map"+string(v2niter,format="(I02)")+".fits",hdrv2)
    error    = readfits(v2noisemapdir+"/"+v2version+dsf+fieldname+v2npca+"_noisemap"+string(v2niter,format="(I02)")+".fits",hdrv2)
    datav1   = readfits(v1mapdir+"/v1.0.2_"+v1field+"_13pca_map50.fits",hdrv1data)
    errorv1  = readfits(v1noisedir+"/v1.0.2_"+v1field+"_13pca_rmsmap50.fits",hdrv1)
    labelmap = readfits(v1labeldir+"/v1.0.2_"+v1field+"_13pca_labelmap50.fits",hdrv1)

    print,"Working on field ",fieldname," v1field ",v1field

    failmessage = ""
    if not file_test(v1mapdir+"/v1.0.2_"+v1field+"_13pca_map50.fits") then failmessage="Could not find V1 file\n"
    if not file_test(v2mapdir+"/"+v2version+dsf+fieldname+v2npca+"_map"+string(v2niter,format="(I02)")+".fits") then failmessage += "Could not find V2 file\n"
    if n_elements(failmessage) gt 0 then message,failmessage,continue=continue

    hastrom,data,hdrv2,data_reproj,hdrv1,hdrv1
    ;hastrom,datav1,hdrv1data,datav1_reproj,hdrv1,hdrv1
    datav1_reproj = datav1
    hastrom,error,hdrv2,error_reproj,hdrv1,hdrv1

    onsource = where(labelmap gt 0,nonsource)
    minindex = min(labelmap[onsource])
    labelmap[onsource] = labelmap[onsource] - minindex + 1

    help,labelmap,datav1_reproj,data_reproj,error_reproj,reproj,datav1,data,error,errorv1

    propsv2 = propgen(data_reproj, hdrv1, labelmap, error_reproj)
    print,"Finished propgen v2"

    hd = hdrv1
    error = error_reproj
    data = data_reproj
    beamuc = 0

    print,"F40, v2"
    propsv2.flux_40 = object_photometry(data, hd, error, propsv2, 40.0, $
                                      fluxerr = fe40)
    propsv2.eflux_40 = sqrt((fe40)^2+4*beamuc^2*(propsv2.flux_40)^2)
    
    propsv2.flux_40_nobg = object_photometry(data, hd, error, propsv2, 40.0, $
                                           fluxerr = fe40, /nobg)
    propsv2.eflux_40_nobg = sqrt((fe40)^2+4*beamuc^2*(propsv2.flux_40_nobg)^2)
    
    print,"F80, v2"
    propsv2.flux_80 = object_photometry(data, hd, error, propsv2, 80.0, $
                                      fluxerr = fe80, /nobg)
    propsv2.eflux_80 = sqrt((fe80)^2+4*beamuc^2*(propsv2.flux_80)^2)
    print,"F120, v2"
    propsv2.flux_120 = object_photometry(data, hd, error, propsv2, 120.0, $
                                       fluxerr = fe120, /nobg)
    propsv2.eflux_120 = sqrt((fe120)^2+4*beamuc^2*(propsv2.flux_120)^2)
    
    print,"Fobj, v2"
    propsv2.flux_obj = object_photometry(data, hd, error, propsv2, propsv2.rad_as_nodc*2, fluxerr = feobj)
    propsv2.flux_obj_err = feobj



    propsv1 = propgen(datav1_reproj, hdrv1, labelmap, errorv1)
    print,"Finished propgen v1"

    hd = hdrv1
    error = errorv1
    data = datav1_reproj
    beamuc = 0

    print,"F40, v1"
    propsv1.flux_40 = object_photometry(data, hd, error, propsv1, 40.0, $
                                      fluxerr = fe40)
    propsv1.eflux_40 = sqrt((fe40)^2+4*beamuc^2*(propsv1.flux_40)^2)
    
    propsv1.flux_40_nobg = object_photometry(data, hd, error, propsv1, 40.0, $
                                           fluxerr = fe40, /nobg)
    propsv1.eflux_40_nobg = sqrt((fe40)^2+4*beamuc^2*(propsv1.flux_40_nobg)^2)
    
    print,"F80, v1"
    propsv1.flux_80 = object_photometry(data, hd, error, propsv1, 80.0, $
                                      fluxerr = fe80, /nobg)
    propsv1.eflux_80 = sqrt((fe80)^2+4*beamuc^2*(propsv1.flux_80)^2)
    print,"F120, v1"
    propsv1.flux_120 = object_photometry(data, hd, error, propsv1, 120.0, $
                                       fluxerr = fe120, /nobg)
    propsv1.eflux_120 = sqrt((fe120)^2+4*beamuc^2*(propsv1.flux_120)^2)
    
    print,"Fobj, v1"
    propsv1.flux_obj = object_photometry(data, hd, error, propsv1, propsv1.rad_as_nodc*2, fluxerr = feobj)
    propsv1.flux_obj_err = feobj


    save,propsv1,propsv2,filename=savedir+fieldname+savesuffix,/verbose

    if keyword_set(doplot) then begin
        plot,propsv1.flux_40,propsv2.flux_40,psym=5
    endif

    return
end


    
