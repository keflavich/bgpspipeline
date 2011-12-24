; Generate timestreams given a map
; Use realistic scan strategy...
;
;
; INSTRUCTIONS:
; 1. Generate a .fits file with a legitimate header (i.e. one that includes
; CDELT or CD parameters) and the artificial data
; 2. Read it in: map=readfits('filename.fits',hdr)
; 3. Call make_artificial_timestreams,map,header,dosave=1,outmap='filename_prefix'
; 4. call mem_iter,'filename_prefix_preiter.sav','filename_prefix'    (plus
; whatever other parameters you're running with mem_iter) and let 'er rip.
;
; offset_timestream = a constant to add to the ac_bolos timestream in order to force
; a correlated component (attempt to get around PCA picking out nonexistent correlations)

pro make_artificial_timestreams, map, header, bgps=bgps, mapstr=mapstr, stepsize=stepsize, $
    beam_loc_file=beam_loc_file, scan_angle=scan_angle, sample_interval=sample_interval,$
    scanspeed=scanspeed, ts=ts, ra_all=ra_all, dec_all=dec_all, astrosignal=astrosignal, $
    array_angle=array_angle,bolo_spacing=bolo_spacing,start_position=start_position,$
    rotang=rotang,badbolos=badbolos,outmap=outmap,dosave=dosave,$
    needed_once_struct=needed_once_struct,dofilter=dofilter,cdelt_out=cdelt_out,$
    wait_artificial=wait_artificial,offset_timestream=offset_timestream 

    if ~keyword_set(bolo_spacing) then bolo_spacing = 7.7 ; "/mm
    if ~keyword_set(array_angle) then array_angle = 45
    if ~keyword_set(stepsize) then stepsize = 120 ; " 
    if ~keyword_set(scanspeed) then scanspeed = 120 ; "/s
    if ~keyword_set(sample_interval) then sample_interval = 0.1 ; seconds per sample
    if ~keyword_set(outmap) then outmap = ''
    if ~keyword_set(offset_timestream) then offset_timestream = 0.0
    if n_elements(dosave) eq 0 then dosave = 0
    if n_elements(scan_angle) eq 0 then scan_angle = 0
    if n_elements(dofilter) eq 0 then dofilter = 1
    mapsize = size(map,/dim)
    map = float(map)

    ds1rate = 0.02
    dsfactor = sample_interval/ds1rate
    if dsfactor gt 1 and keyword_set(dofilter) then begin
      scanrate = ds1rate 
      dofilter = 1
    endif else begin
      scanrate = sample_interval
      dofilter = 0
    endelse

    bolo_params = fltarr(3,144)
    bolo_params[0,*] = indgen(144)

    if n_elements(beam_loc_file) eq 0 then beam_loc_file = getenv('PIPELINE_ROOT')+'/bgps_params/beam_locations_boloparams.txt'
    if size(beam_loc_file,/type) eq 7 then begin ; if the beam location file is passed as a string
        readcol,beam_loc_file,bl_num,bl_dist,bl_ang,bl_rms,/silent
        bolo_params[2,*] = bl_dist
        bolo_params[1,*] = bl_ang
        bl_dist *= 5.*bolo_spacing/3600.   ; bolometer spacing on array is nominally 38 arcseconds
    endif else message,'You need to input a valid beam locations file'

    ; ASSUME square pixels
    pixsize = 3600.0 * abs(sxpar(header,'CDELT1'))
    if pixsize eq 0 then pixsize = 3600.0 * abs(sxpar(header,'CD1_1'))
    if n_elements(cdelt_out) eq 0 then cdelt_out = 7.2
    
    array_halfwidth_deg = max(bl_dist)
    array_halfwidth_as = array_halfwidth_deg * 3600.0
    array_halfwidth_pix = array_halfwidth_as / pixsize
    time_s,"Generating indices",t0
    if n_elements(start_position) eq 0 then begin
        x0 = array_halfwidth_pix
        y0 = array_halfwidth_pix
        sample_spacing = (scanspeed*scanrate)/pixsize
        if scan_angle le 45 then begin
          scanlength_pix = sqrt( (mapsize[0]-2*x0)^2 + ( (mapsize[0]-2*x0)*tan(scan_angle*!dtor) )^2 ) 
          scanxlen_pix = scanlength_pix*cos(scan_angle*!dtor)
          scanylen_pix = scanlength_pix*sin(scan_angle*!dtor)
          nsamples = floor( scanlength_pix / sample_spacing )
          nscans   = floor( (mapsize[1] - scanylen_pix - 2*y0 ) / (2*stepsize/pixsize) )
          step_direction = "y"
        endif else begin
          scanlength_pix = sqrt( (mapsize[1]-2*y0)^2 + ( (mapsize[1]-2*y0)/tan(scan_angle*!dtor) )^2 ) 
          scanxlen_pix = scanlength_pix*cos(scan_angle*!dtor)
          scanylen_pix = scanlength_pix*sin(scan_angle*!dtor)
          nsamples = floor( scanlength_pix / sample_spacing )
          nscans   = floor( (mapsize[0] - scanxlen_pix - 2*x0 ) / (2*stepsize/pixsize) )
          step_direction = "x"
        endelse
        if nscans lt 1 then stop
        print," with ",nsamples," samples per scan and ",nscans," scans"
        xarr = findgen(nsamples) * cos(scan_angle*!dtor) * sample_spacing + x0
        yarr = findgen(nsamples) * sin(scan_angle*!dtor) * sample_spacing + y0
        scans_info = [0,nsamples-1]
        for ii=1,nscans-1 do begin 
            if ii mod 2 eq 0 then begin
                xarr = [xarr,findgen(nsamples) * cos(scan_angle*!dtor) * sample_spacing + 2*stepsize/pixsize*ii*(step_direction eq "x") + x0]
                yarr = [yarr,findgen(nsamples) * sin(scan_angle*!dtor) * sample_spacing + 2*stepsize/pixsize*ii*(step_direction eq "y") + y0]
            endif else begin
                xarr = [xarr,(nsamples-1-findgen(nsamples)) * cos(scan_angle*!dtor) * sample_spacing + 2*stepsize/pixsize*ii*(step_direction eq "x") + x0]
                yarr = [yarr,(nsamples-1-findgen(nsamples)) * sin(scan_angle*!dtor) * sample_spacing + 2*stepsize/pixsize*ii*(step_direction eq "y") + y0]
            endelse
            scans_info = [[scans_info],[nsamples*ii,nsamples*(ii+1)-1]]
        endfor
    endif else message,"Other start positions (besides bottom left) not implemented yet"
    time_e,t0

    extast,header,astr,header_type
    if header_type lt 0 or header_type gt 2 then message,"Header is wrong type: "+string(header_type)

    time_s,"Indices -> RA/Dec and back ... ",t1
    xy2ad,xarr,yarr,astr,ra,dec

    nbolos = n_elements(bl_ang)
    ntime = n_elements(ra)

    if n_elements(rotang) eq 0 then rotang = replicate(0,ntime)
    angle = (bl_ang+array_angle) # replicate(1,ntime) + replicate(1,nbolos) # (scan_angle-rotang)

    ra_all  = replicate(1,nbolos) # ra   + bl_dist # replicate(1,ntime) * cos(angle*!dtor) / cos(replicate(1,nbolos)#dec*!dtor)
    dec_all = replicate(1,nbolos) # dec  - bl_dist # replicate(1,ntime) * sin(angle*!dtor)

    ad2xy,ra_all,dec_all,astr,xind,yind
    time_e,t1

    ts = round(xind) + mapsize[0] * round(yind)

    if n_elements(badbolos) gt 0 then begin
        bolo_params[2,badbolos] = 0
        goodbolos = where(bolo_params[2,*] gt 0,ngood)
        ts = ts[goodbolos,*]
    endif

    astrosignal = map[ts]
    nhitsmap = finite(map)*0
    nhitsmap[min(ts):max(ts)] = nhitsmap[min(ts):max(ts)] + histogram(ts)  

    if cdelt_out ne pixsize then begin
      pixsize_ratio = pixsize / cdelt_out
      new_header = header
      sxaddpar,new_header,'CDELT1',-1*cdelt_out
      sxaddpar,new_header,'CDELT2',cdelt_out
      sxaddpar,new_header,'NAXIS1',mapsize[0]/pixsize_ratio
      sxaddpar,new_header,'NAXIS2',mapsize[1]/pixsize_ratio
      pixsize = cdelt_out

      writefits,outmap+"_nhitsmap_fullres.fits",nhitsmap,header
      writefits,outmap+"_inputmap_fullres.fits",map,header

      newsize = size(map,/dim) * pixsize_ratio
      hcongrid,map,header,new_map,new_header,newsize[0],newsize[1],/half
      map = new_map
      header = new_header

      mapsize = size(map,/dim)

      extast,header,astr,header_type
      ad2xy,ra_all,dec_all,astr,xind,yind
      ts = round(xind) + mapsize[0] * round(yind)
    endif

    if dofilter then begin
        ; filter
        insize = ntime
        outsize = long(insize / dsfactor)
        freq = fft_mkfreq(ds1rate, insize)
        fnyq = 1./(2. * ds1rate)
        fnyq_out = fnyq / dsfactor
        filt_ac = replicate(1.0,insize)/(1. + 10.^(abs(freq/(fnyq_out))^3.))*2.0
        freq_out = fft_mkfreq(sample_interval,outsize)
        filt_ds_deconv = (1. + 10.^(abs(freq_out/(fnyq_out))^3.)) / 2.0
        data_ft = fft(astrosignal,-1)
        data = fft(data_ft*(filt_ac##replicate(1.d,nbolos)),1)
        ; have to split the data to resample (downsample) it
        data_out_r = congrid(real_part(data),nbolos,outsize,interp=0)
        data_out_i = congrid(imaginary(data),nbolos,outsize,interp=0)
        data_out = complex(data_out_r,data_out_i)
        data_out_ft = fft(data_out,-1)
        astrosignal = float(fft(data_out_ft * (filt_ds_deconv##(replicate(1.d,nbolos))), 1))
        ts = congrid(ts,nbolos,outsize,interp=0)
        ra_all = congrid(ra_all,nbolos,outsize,interp=0)
        dec_all = congrid(dec_all,nbolos,outsize,interp=0)
        xarr = congrid(xarr,outsize,interp=0)
        yarr = congrid(yarr,outsize,interp=0)
        ra = congrid(ra,outsize,interp=0)
        dec = congrid(dec,outsize,interp=0)
        scans_info = [ceil(scans_info[0,*]/5),floor(scans_info[1,*]/5-1)]
        si1 = [where( (ts[0,1:outsize-1]-ts[0,0:outsize-2]) gt ceil(scanspeed*sample_interval/pixsize), ns ), outsize-1]
        if ns ne nscans-1 then message,'ERROR: scans improperly identified'
        si0 = [0,si1[0:nscans-2]+1]
        scans_info = transpose([[si0],[si1]])
        nhitsmap = finite(map)*0
        nhitsmap[min(ts):max(ts)] = nhitsmap[min(ts):max(ts)] + histogram(ts)  
        if scans_info[1,nscans-1] eq outsize then stop
    endif

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
        hdr: header,$
        model: finite(map)*0.0,$
        rawmap: finite(map)*0.0, $
        pixsize: float(pixsize) $
        }

    needed_once_struct = { $
        }

    bgps = { $
        scans_info: scans_info ,$
        ac_bolos: astrosignal+offset_timestream,$
        dc_bolos: astrosignal,$
        raw: astrosignal,$
        noise: astrosignal*0.0,$
        astrosignal: astrosignal*0.0,$
        ;mapped_astrosignal: ac_bolos*0.0,$
        atmosphere: astrosignal*0.0,$
        atmo_one: astrosignal,$
        glitchloc: byte(astrosignal*0),$ ; as of 1/27/2011, removed to save memory byte(flags*0), $
        sample_interval: sample_interval,$
        flags: byte(astrosignal*0),$
        bolo_params: bolo_params,$
        wh_scan: indgen(n_elements(ra)),$
        bolo_indices: indgen(144),$
        ra_map: ra_all,$
        dec_map: dec_all,$
        wt2d:fltarr(n_e(scans_info[0,*]),n_e(astrosignal[*,0])),$
        var2d:fltarr(n_e(scans_info[0,*]),n_e(astrosignal[*,0])),$
        weight: astrosignal*0.0+1.0,$
        n_obs: 1, $
        scale_coeffs: replicate(1.0,144) ## replicate(1.0,nscans),$
        scalearr: astrosignal*0.0+1.0, $
        badscans: -1, $
        source_ra: median(ra),$
        source_dec: median(dec),$ 
        mvperjy: [1,0,0],$
        radec_offsets: [0,0],$
        lst: (xarr+nsamples*yarr)/max((xarr+nsamples*yarr)) * 24,$
        jd: fltarr(n_elements(ra)), $
        fazo: 0.0,$
        fzao: 0.0,$
        filenames: [''],$
        arrang: angle,$
        posang: scan_angle,$
        rotang: rotang,$
        scanspeed: scanspeed $
        }


    if n_e(iter0savename) eq 0 then iter0savename=outmap+"_preiter.sav" 
    if dosave gt 0 then begin
        print,"V1.0: Saving bgps_struct and mapstr in ",iter0savename
        save,bgps,mapstr,filename=iter0savename,/verbose
        writefits,outmap+"_nhitsmap.fits",nhitsmap,header
        writefits,outmap+"_inputmap.fits",map,header
    endif

    if keyword_set(wait_artificial) then stop

end
