; add_point_sources.pro  
;===========================================================
;
; add_point_sources
; 
; Given a bgps input map, adds point sources in the form of bright pixels
; 3 types of source arrangement: randomized, by high flux and by combination
; Tracks location and characteristics of input/output sources
;
; INPUT: map_in:             .fits file of input map to be modified
; KEYWORDS: n_sources:       number of sources to add, use this if you want a specific number of sources
;           n_source_random:   enter in 2 element array with the mean of the random distr
;                              and the std dev of the random distr           
;                              (8/5): set n_source_random so that if no deviation given,
;                                     it simply behaves as if it was n_sources
;           arrange:  how the sources are to be arranged (randomly, by flux density, etc)
;           peak_alpha: the alpha value for randomly choosing source brightnesses via powerlaw
;           seed:     the seed for randomization
;           source_range: range of source peak fluxes
;           prox_check : flag if sources should check to see if they are too close together
;           vary_size  : range of source sigmas to vary between (two element array)
;           
; OUTPUT: output_map:  the map with sources added in
;         sourcesOut:  array of sourceStructs to be used in apPhotometry later
;===========================================================
FUNCTION add_point_sources, map_in, n_sources=n_sources, n_source_random=n_source_random, arrange=arrange, peak_alpha=peak_alpha,$
                                    source_range=source_range, sourcesOut=sourcesOut, seed=seed, prox_check=prox_check, vary_size=vary_size,$
				    smoothing=smoothing

  
  ; if given a string for the input map, read fits file at that location, if given an array, just use the array
  if datatype(map_in, 0) eq 'STR' then input_map = readfits(map_in, hdr) else input_map = map_in
  xsize = (size(input_map))[1]
  ysize = (size(input_map))[2]
  buffer = 70
  xbuffered = xsize - buffer
  ybuffered = ysize - buffer

  ; defaults for keywords
  if n_e(peak_alpha) eq 0 then peak_alpha = 2.25
  if n_e(arrange) eq 0 then arrange='random'
  if n_e(n_source_random) eq 0 AND n_e(n_sources) eq 0 then n_source_random = [250,40]
  if n_e(source_range) eq 0 then source_range = [0.01, 2.0]
  if n_e(prox_check) eq 0 then prox_check = 0


  ; create a source structure that will keep track of added point sources,
  ; All it tracks so far: Input and Output: location, peak amplitude (no smoothing needed for this one)
  ; Also tracks (8/5) : input flux and output flux, added into structure with analyze_point_sources.pro,
  ; pear_r -> pearson_r coefficients and probability values for each aperture (correlation of in_flux with out_flux)
  ; uses basic aperphotometry with apertures of 40,80,120"
  ; size must be handled after smoothing, or through some relation 
  ; between the fwhm of the gaussian used to smooth
  dummy_source = { SourceStruct, in_loc : fltarr(2), out_loc : fltarr(2), in_peak : 0d, out_peak : 0d, in_flux : fltarr(3), out_flux : fltarr(3),$
	                         pear_r : fltarr(3,2), in_sigma : fltarr(2), out_sigma : fltarr(2), recovery_frac : fltarr(3) }


  ; determine number of sources:
  if n_e(n_source_random) eq 2 then n_sources = round(n_source_random[0] + n_source_random[1]*randomn(seed+0)) else n_sources =  n_source_random[0]
	                        
  sources = replicate( {SourceStruct}, n_sources)
  ; decide where to place the sources, if too close together, find another spot
  IF prox_check then proximity_limit = 25 else proximity_limit =0
  IF arrange EQ 'random' THEN BEGIN
    FOR iSource=0,n_sources-1 DO BEGIN
      iX = round(xbuffered*(randomu(seed+1+3*iSource)) + buffer/2.0)
      iY = round(ybuffered*(randomu(seed+2+3*iSource)) + buffer/2.0)
      source_distances = sqrt((iX-sources.in_loc[0])^2 + (iY - sources.in_loc[1])^2)
      prox_warning = where(source_distances LE proximity_limit, prox)
      proxseed=0 ; to increment the seeds passed to iX and iY random generators, 
                 ;in order to allow for them to progress through different positions if they get too close together
      WHILE prox NE 0 DO BEGIN
        prox = 0 ; reset the proximity counter
        iX = round(xbuffered*(randomu(seed+1+3*iSource+proxseed)) + buffer/2.0)
        iY = round(ybuffered*(randomu(seed+2+3*iSource+proxseed)) + buffer/2.0)
	; test for proximity to other sources
	FOR testSource=0, n_sources-1 DO BEGIN
          IF testSource EQ iSource THEN BEGIN
            testSource++  ; skip when equal
          ENDIF ELSE BEGIN
            source_distance = sqrt((iX - sources[testSource].in_loc[0])^2 + (iY - sources[testSource].in_loc[1])^2)
            IF source_distance LE proximity_limit then prox++
          ENDELSE
        ENDFOR ; each other source (testSource)
	proxseed++
      ENDWHILE ; prox test
      sources[iSource].in_loc = [iX, iY]
      ;print, "Assigned source location #", iSource
      counter, iSource, n_sources, "Assigned source location #"
    ENDFOR ; each source
  ENDIF ; random arrangement

  ; calculate source brightnesses from power law
  
  randomp, rand_peaks, -1*peak_alpha, n_sources, RANGE_X=source_range, seed=seed+3
  
  FOR iSource=0, n_sources-1 DO BEGIN
    sources[iSource].in_peak = rand_peaks[iSource]
  ENDFOR

  ; add the sources
  output_map = input_map
  IF keyword_set(vary_size) THEN BEGIN
    psf_sig = 33 / 7.2 ; 33 arcsecond psf with 7.2 arcseconds per pixelof c
    randomp, random_sizes, -1*peak_alpha, n_sources, range_X=vary_sizes, seed=3
    FOR iSource=0, n_sources-1 DO BEGIN
      blank_map = fltarr(xsize, ysize)
      sources[iSource].in_sigma = [sqrt(random_sizes[iSource]^2 + psf_sig^2), sqrt(random_sizes[iSource]^2 + psf_sig^2)]
      output_map += add_source(blank_map, sources[iSource].in_loc[0], sources[iSource].in_loc[1], sources[iSource].in_sigma[0], sources[iSource].in_sigma[1], sources[iSource].in_peak, 0)
    ENDFOR
  ENDIF ELSE BEGIN
    FOR iSource=0, n_sources-1 DO BEGIN
      output_map[sources[iSource].in_loc[0], sources[iSource].in_loc[1]] += sources[iSource].in_peak
    ENDFOR ; each source
  ENDELSE

  print,"Source stats: ",mmmmm(rand_peaks)
  
  sourcesOut = sources
  return, output_map

END ; add_point_sources
