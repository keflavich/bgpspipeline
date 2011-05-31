pro merge_savefiles_v1,infile1,infile2,outmap=outmap,iter0savename=iter0savename,bgps=bgps,mapstr=mapstr

    print,"Merging savefiles ",infile1," and ",infile2
    if not file_test(infile1) then message,"File "+infile1+" does not exist"
    if not file_test(infile2) then message,"File "+infile2+" does not exist"

    restore,infile1,/verbose
    astrosignal = bgps.astrosignal
    scalearr = bgps.scalearr
    weight = bgps.weight
    wt2d = bgps.wt2d
    var2d = bgps.var2d
    wh_scan = bgps.wh_scan
    ac_bolos = bgps.ac_bolos
    scans_info = bgps.scans_info
    ra_map = bgps.ra_map
    dec_map = bgps.dec_map
    arrang = bgps.arrang
    rotang = bgps.rotang
    lst = bgps.lst
    jd = bgps.jd
    nhitsmap = mapstr.nhitsmap
    ts = mapstr.ts
    scale_coeffs = bgps.scale_coeffs
    restore,infile2,/verbose
    astrosignal = [[astrosignal],[bgps.astrosignal]]
    scalearr = [[scalearr],[bgps.scalearr]]
    weight = [[weight],[bgps.weight]]
    var2d = [var2d,bgps.var2d]
    wt2d = [wt2d,bgps.wt2d]
    wh_scan = [[wh_scan],[bgps.wh_scan]]
    ac_bolos = [[ac_bolos],[bgps.ac_bolos]]
    scans_info = [[scans_info],[bgps.scans_info]]
    ra_map = [[ra_map],[bgps.ra_map]]
    dec_map = [[dec_map],[bgps.dec_map]]
    rotang = [rotang,bgps.rotang]
    arrang = [[arrang],[bgps.arrang]]
    scale_coeffs = [scale_coeffs,bgps.scale_coeffs]
    lst = [lst,bgps.lst]
    jd = [jd,bgps.jd]
    nhitsmap += mapstr.nhitsmap
    ts = [[ts],[mapstr.ts]]

    extast,mapstr.hdr,astr,header_type
    ad2xy,ra_map,dec_map,astr,xind,yind
    ts = round(xind) + mapstr.blank_map_size[0] * round(yind)

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
        glitchloc: 0,$ ; as of 1/27/2011, removed to save memory byte(flags*0), $
        sample_interval: bgps.sample_interval,$
        flags: byte(astrosignal*0),$
        bolo_params: bgps.bolo_params,$
        wh_scan: wh_scan,$
        bolo_indices: bgps.bolo_indices,$
        ra_map: ra_map,$
        dec_map: dec_map,$
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
    print,"Saving bgps and mapstr in ",iter0savename
    save,bgps,mapstr,filename=iter0savename,/verbose

end
