pro merge_savefiles,infile1,infile2,outmap=outmap,iter0savename=iter0savename,bgps=bgps,mapstr=mapstr,needed_once_struct=needed_once_struct

    print,"Merging savefiles ",infile1," and ",infile2
    if not file_test(infile1) then message,"File "+infile1+" does not exist"
    if not file_test(infile2) then message,"File "+infile2+" does not exist"

    restore,infile1,/verbose
    help,mapstr
    astrosignal = bgps.astrosignal
    scalearr = bgps.scalearr
    scale_coeffs = bgps.scale_coeffs
    weight = bgps.weight
    wt2d = bgps.wt2d
    var2d = bgps.var2d
    wh_scan = bgps.wh_scan
    ac_bolos = bgps.ac_bolos
    scans_info = bgps.scans_info
    ra_all =  bgps.ra_map
    dec_all =  bgps.dec_map
    arrang = bgps.arrang
    rotang = bgps.rotang
    lst = bgps.lst
    jd = bgps.jd
    glitchloc = bgps.glitchloc
    ;nhitsmap = mapstr.nhitsmap
    tsmerge = mapstr.ts
    atmo_one = bgps.atmo_one
    restore,infile2,/verbose
    help,mapstr
    astrosignal = [[astrosignal],[bgps.astrosignal]]
    atmo_one = [[atmo_one],[bgps.atmo_one]]
    scalearr = [[scalearr],[bgps.scalearr]]
    scale_coeffs = [[scale_coeffs],[bgps.scale_coeffs]]
    glitchloc = [[glitchloc],[bgps.glitchloc]]
    weight = [[weight],[bgps.weight]]
    var2d = [var2d,bgps.var2d]
    wt2d = [wt2d,bgps.wt2d]
    wh_scan = [wh_scan,bgps.wh_scan]
    ac_bolos = [[ac_bolos],[bgps.ac_bolos]]
    message,"Scans_info size: "+strjoin(strcompress(string(size(scans_info,/dim)))),/info ; this needs to be removed when I'm done debugging
    message,"Scale_coeffs size: "+strjoin(strcompress(string(size(scale_coeffs,/dim)))),/info ; this needs to be removed when I'm done debugging
    scans_info = [[scans_info],[bgps.scans_info+1+max(bgps.scans_info)]]
    ra_all = [[ra_all],[bgps.ra_map]]
    dec_all =  [[dec_all],[bgps.dec_map]]
    rotang = [rotang,bgps.rotang]
    arrang = [[arrang],[bgps.arrang]]
    lst = [lst,bgps.lst]
    jd = [jd,bgps.jd]
    ;nhitsmap += mapstr.nhitsmap
    tsmerge = [[tsmerge],[mapstr.ts]]

    ; Note that the two input maps do not necessarily have the same dimensions
    ; therefore, we have to re-compute the X, Y indices of each data point and 
    ; then recompute the nhitsmap
    extast,mapstr.hdr,astr,header_type
    ad2xy,ra_all,dec_all,astr,xind,yind
    ts = round(xind) + mapstr.blank_map_size[0] * round(yind)
    nhitsmap = fltarr(mapstr.blank_map_size) ;fltarr(ceil(max(xind)),ceil(max(yind)))
    nhitsmap[min(ts):max(ts)] = nhitsmap[min(ts):max(ts)] + histogram(ts)  

    map = mapstr.astromap
    if ~keyword_set(outmap) then outmap = mapstr.outmap
    mapstr = {$
        outmap: outmap,$
        astromap: map,$
        residmap: finite(map)*0.0,$
        noisemap: finite(map)*0.0,$
        wt_map: finite(map)*0.0+1.0,$
        nhitsmap: nhitsmap, $
        blank_map: finite(map)*0.0,$
        blank_map_size: size(map,/dim),$
        ts: ts,$
        hdr: mapstr.hdr,$
        model: finite(map)*0.0,$
        rawmap: finite(map)*0.0, $
        pixsize: mapstr.pixsize $
        }

    bgps = { $
        scans_info: scans_info ,$
        ac_bolos: ac_bolos,$
        noise: astrosignal*0.0,$
        astrosignal: astrosignal*0.0,$
        ;mapped_astrosignal: ac_bolos*0.0,$
        atmosphere: astrosignal*0.0,$
        atmo_one: astrosignal,$
        glitchloc: glitchloc,$ ; as of 1/27/2011, removed to save memory byte(flags*0), $
        sample_interval: bgps.sample_interval,$
        flags: byte(astrosignal*0),$
        bolo_params: bgps.bolo_params,$
        wh_scan: wh_scan,$
        bolo_indices: bgps.bolo_indices,$
        ra_map: ra_all,$
        dec_map: dec_all,$
        wt2d:wt2d,$
        var2d:var2d,$
        weight: weight,$
        n_obs: 2, $
        scale_coeffs: scale_coeffs, $
        scalearr: scalearr, $
        badscans: -1, $
        scanspeed: bgps.scanspeed, $
        dc_bolos: astrosignal,$
        raw: astrosignal,$
        ra_all: ra_all,$
        dec_all: dec_all,$
        source_ra: bgps.source_ra,$
        source_dec: bgps.source_dec,$ 
        radec_offsets: [0,0],$
        arrang: arrang,$
        posang: bgps.posang,$
        rotang: rotang,$
        fazo: 0.0,$
        fzao: 0.0,$
        lst: lst,$
        filenames: [''],$
        mvperjy: [1,0,0],$
        jd: jd $
        }

    if n_e(iter0savename) eq 0 then iter0savename=outmap+"_preiter.sav" 
    print,"Saving bgps, and mapstr in ",iter0savename
    save,bgps,mapstr,filename=iter0savename,/verbose
    ; debug help,bgps,mapstr,/struct

end
