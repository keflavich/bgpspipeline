
pro compare_v1v2, fieldname, props=props, doplot=doplot, v2mapdir=v2mapdir, $
    v2npca=v2npca, v2niter=v2niter, savedir=savedir, $
    dsfactor=dsfactor, v1field=v1field,  continue=continue

    if n_elements(v2mapdir) eq 0 then v2mapdir = '/Volumes/disk2/data/bgps/releases/v2.0/December2011/'
    if n_elements(v2npca) eq 0 then v2npca = "_13pca" else v2npca = string(v2npca,format="('_',I0,'pca')")
    if n_elements(v2niter) eq 0 then v2niter = 20
    if n_elements(dsfactor) eq 0 then dsf = "ds2_" else dsf = string(dsfactor,format="('ds',I0,'_')")
    v1mapdir   = '/Volumes/disk2/data/bgps/releases/v1.0/v1.0.2/'
    if n_elements(savedir) eq 0 then savedir    = '/Volumes/disk3/adam_work/v1v2compare/'
    if n_elements(v1field) eq 0 then v1field=fieldname

    v2filename = "v2.0_"+dsf+fieldname+v2npca+"_map"+string(v2niter,format="(I02)")+".fits"
    v1filename = "v1.0.2_"+v1field+"_13pca_map50.fits"
    output_name = savedir+"/compare_v1v2_"+dsf+fieldname+v2npca+"_map"+string(v2niter,format="(I02)")

    print,"Working on field ",fieldname," v1field ",v1field

    failmessage = ""
    if not file_test(v1filename) then failmessage="Could not find V1 file\n"
    if not file_test(v2filename) then failmessage += "Could not find V2 file\n"
    if n_elements(failmessage) gt 0 then message,failmessage,continue=continue

    compare_images,v2filename,prefix2=v2mapdir+"/",prefix1=v1mapdir+"/",suffix2=v2filename,suffix1=v1filename,$
        output_name=output_name,in1='v1.0',in2='v2.0',/samescale,wcsaperture=" ",cuts='0.25,0.50'

    return
end


    

