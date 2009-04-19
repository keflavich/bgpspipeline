
pro fix_headers,filename,version=version,pixsize=pixsize,beamsize=beamsize,mvperjy=mvperjy
    m = readfits(filename,hdr)

    if n_e(pixsize) eq 0 then pixsize = 7.2
    if n_e(beamsize) eq 0 then beamsize = 35.6  ; was 31.2
    if n_e(mvperjy) eq 0 then mvperjy=[ -3.26472e-15,0.398740,3.32002]
    if n_e(version) eq 0 then version = '1.0'
    if n_e(maptype) eq 0 then begin
        if stregex(filename,"_map") ne -1 then maptype="map"
        if stregex(filename,"_noise") ne -1 then maptype="residual"
        if stregex(filename,"_nhits") ne -1 then maptype="nhits"
        if stregex(filename,"_weight") ne -1 then maptype="weight"
        if stregex(filename,"_flag") ne -1 then maptype="flag"
        if stregex(filename,"_model") ne -1 then maptype="model"
    endif

    if maptype eq "nhits" then bunit=".1s hits"      $
    else if maptype eq "flag" then bunit="n_flagged" $
    else bunit="Jy/Beam"

    sxdelpar,hdr,'WL'
    sxdelpar,hdr,'ITERNUM'
    sxdelpar,hdr,'N_PCA'
    sxdelpar,hdr,'COMMENT'

    fxaddpar,hdr,"PROTITLE","Bolocam Galactic Plane Survey","PI: John Bally, University of Colorado"
    fxaddpar,hdr,"MAPTYPE",maptype
    fxaddpar,hdr,"BUNIT",bunit,"Units in map"
    fxaddpar,hdr,"BMAJ",beamsize/3600.
    fxaddpar,hdr,"BMIN",beamsize/3600.
    fxaddpar,hdr,"BPA",0
    fxaddpar,hdr,"ppbeam" ,2*!dpi*(beamsize/2.35482)^2/pixsize^2,"pixels per beam" 
    fxaddpar,hdr,"calib_0",mvperjy[0]," 0th coefficient for flux cal (see methods paper)"
    fxaddpar,hdr,"calib_1",mvperjy[1]," 1st coefficient for flux cal"
    fxaddpar,hdr,"calib_2",mvperjy[2]," 2nd coefficient for flux cal"
    fxaddpar,hdr,"BGPSITER",50,"Iteration number"
    fxaddpar,hdr,"bgpsnpca",13,"number of PCA components subtracted"
    fxaddpar,hdr,"BGPSVERS",version,"BGPS Processing Version Number"
    fxaddpar,hdr,"WAVELENG",1.12,"mm (avoids CO 2-1)"
    fxaddpar,hdr,"COMMENT","FITS (Flexible Image Transport System) format is defined in 'Astronomy"
    fxaddpar,hdr,"COMMENT","and Astrophysics', volume 376, page 359; bibcode 2001A&A...376..359H"
    fxaddpar,hdr,"COMMENT","Made by the Bolocam Galactic Plane Survey (BGPS) pipeline"
    fxaddpar,hdr,"COMMENT","described in Aguirre et al 2009 (not yet published)"
    fxaddpar,hdr,"COMMENT","BGPS data was taken at the Caltech Submillimeter Observatory"
    fxaddpar,hdr,"COMMENT","Pixel coverage is in the nhitsmap file (each hit represents .1s dwell time)"
    fxaddpar,hdr,"COMMENT","Pixel weighting is in the weightmap file"
    fxaddpar,hdr,"COMMENT","Flag counts are in the flagmap file"
    fxaddpar,hdr,"COMMENT","Deconvolved model is in the model file"

    writefits,filename,m,hdr

end
