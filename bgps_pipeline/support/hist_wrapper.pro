function $
   hist_wrapper, $
      data, binsize, hbmin_in, hbmax_in, $
      input = input, $
      gauss_fit = gauss_fit, $
      ks_test = ks_test , $
      cumulative = cumulative, $
      cum_frac = cum_frac, $ 
      noverbose = noverbose, $
      plot_flag = plot_flag, $
      xlog = xlog, ylog = ylog, $
      xtitle = xtitle, ytitle = ytitle, title = title, $
      ps_file = ps_file
;
; $Id: hist_wrapper.pro,v 1.14 2006/06/16 00:01:37 golwala Exp $
; $Log: hist_wrapper.pro,v $
; Revision 1.14  2006/06/16 00:01:37  golwala
; 2006/06/15 SG Deal better with cases where we can't find the fwhm.
;
; Revision 1.13  2004/10/05 21:13:41  golwala
; SG add ks_test option
;
; Revision 1.12  2004/06/06 18:08:54  golwala
; SG change so user doesn't have to do change_field to make .hc a double
;
; Revision 1.11  2004/05/21 16:04:57  golwala
; SG modify hist_wrapper so USER_COMMON is only needed if plotting
;
; Revision 1.10  2004/05/18 22:47:23  golwala
; SG Add cleanplot to end of hist_wrapper
;
; Revision 1.9  2004/04/22 12:03:41  golwala
; SG various minor changes/additions, see the routines
;
; Revision 1.8  2004/04/02 16:33:48  jaguirre
; Added input keyword (same as keyword to histogram) to accumulate histograms.
;
;
;+
; NAME:
;	hist_wrapper
;
; PURPOSE:
;	Wrapper for IDL HISTOGRAM function -- takes care of sorting
;       out where the bin edges are, calculates bin center array,
;       calculates median and fwhm, can do optional gaussian fit and plot.
;
; CALLING SEQUENCE:
;	result = 
;          hist_wrapper( $
;             data, binsize, hbmin_in, hbmax_in, $
;             input = input, $
;             cumulative = cumulative, $
;             cum_frac = cum_frac, $
;             gauss_fit = gauss_fit, $
;             ks_test = ks_test, $
;             noverbose = noverbose, $
;             plot_flag = plot_flag, $
;             xlog = xlog, ylog = ylog, $
;             xtitle = xtitle, ytitle = ytitle, title = title, $
;             ps_file = ps_file )
;
; INPUTS:
;	data: the data to be histogrammed
;       binsize: histogram bin width
;       hbmin_in, hbmax_in: lower edge of first bin, upper edge of
;          last bin.  If hbmax_in lies in the middle of a bin, 
;          then histogram is extended to the upper edge of that bin.
;
; OPTIONAL KEYWORD PARAMETERS:
;       input: provide an input histogram to add on to; bins, etc.
;           are fixed by the input histogram
;       cumulative: set this to get a cumulative histogram.  
;           0: standard differential histogram
;           1: cumulative from left (N(<x))
;          -1: cumulative from right (N(>x))
;       cum_frac: set this to overplot lines at the specified
;          cumulative fractions
;       gauss_fit: set this to perform a gaussian fit on the histogram
;          1: fits for mean, amplitude, and rms
;          2: fits for mean, amplitude, rms, and baseline
;       ks_test: perform a ks test of the unbinned data against
;          the best fit Gaussian; note that gauss_fit must also
;          be set.  Set this number to the scaling factor needed
;          to determine the effective number of independent data
;          points.  E.g. for a beam-smoothed map, set ks_test to
;          to beam_area/pixel_area.  
;       noverbose: set this to turn off diagnostic messages
;       plot_flag: set this to get plots (two plots appear, one 
;          of the entire histogram and one a zoom on the region near
;          the peak)
;       xlog, ylog, xtitle, ytitle, title: standard keywords for plots
;       ps_file: set this to get an output postscript file instead
;          of a screen plot
;
; OUTPUTS:
;	result is a structure with fields:
;          hb: histogram bin centers
;          hc: histogram (counts in bins)
;          peak: peak value of histogram
;          hb_peak: bin center of peak bin
;          fwhm: fwhm of histogram
;          median: median value of data in the histogram (does not
;             include overflows)
;          n_tot: total number of data points in input vector
;          n_in: total number of points in histogram range
;          n_out: total number of points outside histogram range
;             (overflow points)
;       if a gaussian fit is done, the following additional fields are
;          included:
;          fit_mean, fit_rms, fit_ampl, fit_base: mean, rms,
;             amplitude, and baseline (offset) from gaussian fit
;          fit_base is only included if gauss_fit = 2
;       if a ks test is done, the following additional fields are
;          included:
;          ks_stat: ks test statistic
;          ks_prob: 
;
; COMMON BLOCKS:
;	USER_COMMON: only used if plotting
;
; MODIFICATION HISTORY:
; 	2003/01/?? SG
;       2003/11/10 SG Documented
;       2003/11/11 SG Error check for all n_in = 0 case
;       2003/11/12 SG Better calculate of fwhm
;       2003/12/06 SG A bit more error-checking
;       2003/12/06 SG Change use of gauss_fit keyword
;	2004/02/03 GL Allowed for possibility that input data is a 
;                     constant rather than an array
;       2004/04/16 SG Reason 792 that IDL sucks: if the input data
;                     are integer and binsize is float, histogram
;                     returns an error.  So float the data.
;       2004/05/18 SG Add cleanplot at end.
;       2004/05/26 SG Make hc double type so that user does not have
;                     to change_field on .hc field
;       2004/08/21 SG Add ks_test.
;       2006/06/15 SG Deal better with cases where we can't find the fwhm
;-

if n_params() ne 4 then message, 'Requires 4 calling parameters.'

if (binsize le 0) then begin
   message, 'binsize must be positive'
endif
if (hbmax_in le hbmin_in) then begin
   message, 'hbmax must be greater than hbmin'
endif

if not keyword_set(cumulative) then cumulative = 0
if not keyword_set(gauss_fit) then gauss_fit = 0
if (gauss_fit lt 0 or gauss_fit gt 2) then begin
   message, 'gauss_fit keyword may be 0, 1, or 2 only'
endif
if keyword_set(ks_test) and gauss_fit ne 1 then begin
   message, $
   'if ks_test keyword is set, then gauss_fit keyword must be set to 1.'
endif
if not keyword_set(noverbose) then noverbose = 0
if not keyword_set(plot_flag) then plot_flag = 0
if not keyword_set(xlog) then xlog = 0
if not keyword_set(ylog) then ylog = 0
if not keyword_set(xtitle) then xtitle = ''
if not keyword_set(ytitle) then ytitle = ''
if not keyword_set(title) then title = ''
if not keyword_set(ps_file) then ps_file = ''
if (ps_file ne '') then plot_flag = 1

hbmin = hbmin_in
hbmax = hbmax_in

nbins = ceil( (hbmax - hbmin)/binsize )
hb = hbmin + (0.5 + findgen(nbins))*binsize
hbmax = hbmin + (nbins+1)*binsize
if (keyword_set(input) and (n_e(input) eq nbins)) then $
  hc = $
      histogram( $
         double([data]), binsize = binsize, min = hbmin, nbins= nbins, $
         input=input) $
else $
  hc = $
      histogram( $
         double([data]), binsize = binsize, min = hbmin, nbins = nbins)

; so that the user doesn't have to do change_field on the output
; structure to do math on it
hc = double(hc)

peak = !VALUES.F_NAN
hb_peak = !VALUES.F_NAN
fwhm = !VALUES.F_NAN
med = !VALUES.F_NAN
if (total(hc) ne 0) then begin
   peak = float(max(hc, index_pk))
   hb_peak = hb[index_pk]
   index_left = index_pk
   index_right = index_pk
   keepgoing = 1
   while keepgoing do begin
      index_left = index_left-1 
      if (index_left eq -1) then begin
         keepgoing = 0
      endif else begin
         if (hc[index_left] lt 0.5*peak) then keepgoing = 0
      endelse
   endwhile
   keepgoing = 1
   while keepgoing do begin
      index_right = index_right+1 
      if (index_right eq n_elements(hb )) then begin
         keepgoing = 0
      endif else begin
         if (hc[index_right] lt 0.5*peak) then keepgoing = 0
      endelse
   endwhile
   if (index_left ge 0 and index_right le n_elements(hb)-1) then begin
      fwhm = hb[index_right] - hb[index_left]
   endif
   index = where(data ge hbmin and data le hbmax)
   med = median(data[index])
endif
if (cumulative ne 0) then begin
   if (cumulative ge 1) then hc = total(hc, /cum)
   if (cumulative le -1) then hc = reverse(total(reverse(hc), /cum))
endif

n_tot = long(n_elements(data))
n_out = long(n_tot - total(long(hc)))

if not noverbose and not cumulative then begin
message, /cont, $
   string(format = '(I0, "/", I0, " entries lie outside the range.")', $
          n_out, n_elements(data))
message, /cont, string(format = '("FWHM = ", G10.2)', fwhm)
endif

result = $
   create_struct( $
      'hb', hb, 'hc', hc, 'peak', peak, 'hb_peak', hb_peak, $
      'fwhm', fwhm, 'median', med, $
      'n_tot', n_tot, 'n_in', n_tot - n_out, 'n_out', n_out )

if (plot_flag) then begin

   common USER_COMMON

   set_plot, IDL_WIN.default
   device, decomposed = 0
   tek_color

   window_std, xsize = 400, ysize = 600
   cleanplot, /silent
   !P.MULTI = [0, 1, 2]

   if (ps_file ne '') then begin
      wdelete
      pageInfo = pswindow()
      set_plot, 'PS'
      device, _Extra = pageInfo, /color, filename = ps_file
   endif

   !Y.RANGE = [0, peak]
   if (ylog eq 1) then !Y.RANGE = [0.5, max(hc)]
   plot, hb, hc, psym = 10, xlog = xlog, ylog = ylog, $
      xtitle = xtitle, ytitle = ytitle, title = title
   if not keyword_set(cumulative) then begin
      oplot, hb_peak-0.5*fwhm*[1,1], !Y.CRANGE, color = 2
      oplot, hb_peak+0.5*fwhm*[1,1], !Y.CRANGE, color = 2
   endif
   if (keyword_set(cumulative) and keyword_set(cum_frac)) then begin
      for k = 0, n_elements(cum_frac)-1 do begin
         oplot, !X.CRANGE, cum_frac[k]*peak*[1,1], color = 3
     endfor
   endif

   !X.RANGE= !X.CRANGE
   if (finite(fwhm) eq 1) then !X.RANGE = hb_peak + 5.*fwhm*[-1,1]
   plot, hb, hc, psym = 10, xlog = xlog, ylog = ylog, $
      xtitle = xtitle, ytitle = ytitle, title = title
   oplot, hb_peak-0.5*fwhm*[1,1], !Y.CRANGE, color = 2
   oplot, hb_peak+0.5*fwhm*[1,1], !Y.CRANGE, color = 2
   if (keyword_set(cumulative) and keyword_set(cum_frac)) then begin
      for k = 0, n_elements(cum_frac)-1 do begin
         oplot, !X.CRANGE, cum_frac[k]*peak*[1,1], color = 3
     endfor
   endif

endif

if (gauss_fit ne 0) then begin

   a0 = fltarr(3)
   a0[0] = hb_peak
   a0[1] = fwhm/ (2. * sqrt(2. * alog(2.)))
   if (finite(fwhm) ne 1) then a0[1] = max(hb) - min(hb)
   a0[2] = peak
   if (gauss_fit eq 2) then a0 = [a0, 0.0]

   a = mpfitfun('gauss_mpfit_func', hb, hc, sqrt(hc+1), a0, /quiet)

   if (plot_flag) then begin
      oplot, hb, gauss_mpfit_func(hb, a), color = 3
      str = 'median = ' + string(format = '(G8.2,"!C")', med)
      str = str + 'fit params:!C'
      str = str + '   mean = ' + string(format = '(G8.2,"!C")', a[0])
      str = str + '   rms  = ' + string(format = '(G8.2,"!C")', a[1])
      str = str + '   ampl = ' + string(format = '(G8.1,"!C")', a[2])
      if (gauss_fit eq 2) then $
         str = str + '   base = ' + string(format = '(G8.2,"!C")', a[3])
      xstr = !X.CRANGE[0] + 0.05 * (!X.CRANGE[1] - !X.CRANGE[0])
      ystr = !Y.CRANGE[0] + 0.95 * (!Y.CRANGE[1] - !Y.CRANGE[0])
      if (!X.TYPE eq 1) then xstr = 10.^xstr
      if (!Y.TYPE eq 1) then ystr = 10.^ystr
      xyouts, /data, xstr, ystr, str

      if (ps_file ne '') then begin
         xyouts, 0, !D.Y_CH_SIZE + !D.Y_SIZE, ps_file, $
            charsize = 0.5, /device 
      endif

   endif

   result = $
      create_struct( $
         result, 'fit_mean', a[0], 'fit_rms', a[1], $
         'fit_ampl', a[2] )
   if (gauss_fit eq 2) then $
      result = create_struct(result, 'fit_base', a[3])

   if not noverbose then $      
      message, /cont, string(format = '("Fit params = ", 4G10.2)', a)

   ; do the ks test if so desired
   if keyword_set(ks_test) and total(finite(a)) ne n_elements(a) then begin
      message, /info, $
'Gaussian fit does not return reasonable parameters, no KS test will be done.'
      return, result
   endif
   if keyword_set(ks_test) and total(finite(a)) eq n_elements(a) then begin
      ; this is just the algorithm from numerical recipes, copied out
      ; of the astrolib ksone.pro function

      index = where(data gt hbmin and data lt hbmax)
      data_ks = data[index]
      data_ks = data_ks[sort(data_ks)]
      n = n_elements(data_ks)

      cdf_0 = findgen(n)/n
      cdf_n = ( findgen( n ) +1. ) / n
      ; note that gauss_pdf is actually a CDF.  IDL sucks!
      cdf_f = gauss_pdf( (data_ks-a[0])/a[1] )

      ks_stat = $
         max( [ max( abs(cdf_0-cdf_f), sub0 ), $
                max( abs(cdf_n-cdf_f), subn ) ], msub )
      ; compute probability of getting a worse value of d
      prob_ks, ks_stat, n/ks_test, ks_prob

      result = $
         create_struct( $
            result, 'ks_stat', ks_stat, 'ks_prob', ks_prob )

      if keyword_set(plot_flag) then begin

         str1 = $
            textoidl( string( format = '(%"D_{KS} = %5.3f")', ks_stat ) )
         str2 = $
            textoidl( string( format = '(%"P_{KS} = %5.3f")', ks_prob ) )

         if (ps_file eq '') then begin
            window_std, xsize = 400, ysize = 600
            cleanplot, /silent
            !P.MULTI = [0, 1, 2]
         endif

         !Y.RANGE = [0, 1]
   
         plot, minmax(data_ks), [1,1], /nodata, xlog = xlog, ylog = ylog, $
            xtitle = xtitle, ytitle = 'cum. frac.', title = title

         if msub EQ 0 then begin 
            oplot, data_ks, cdf_0, psym = 10
            oplot, data_ks[sub0]*[1,1], !Y.CRANGE, color = 3
            oplot, !X.CRANGE, cdf_0[sub0]*[1,1], color = 3
         endif else begin
            oplot, data_ks, cdf_n, psym = 10
            oplot, data_ks[subn]*[1,1], !Y.CRANGE, color = 3
            oplot, !X.CRANGE, cdf_n[subn]*[1,1], color = 3
         endelse 
         oplot, data_ks, cdf_f, color = 2, linestyle = 2
         legend, /top, /left, $
            ['data', 'fit', 'largest dev.', str1, str2], $
            linestyle = [0, 0, 2, -1, -1], color = [!P.COLOR, 2, 3, 0, 0]
         
         !X.RANGE = hb_peak + 5.*fwhm*[-1,1]
         plot, [0,0], [1,1], /nodata, xlog = xlog, ylog = ylog, $
            xtitle = xtitle, ytitle = ytitle, title = title
         if msub EQ 0 then begin 
            oplot, data_ks, cdf_0, psym = 10
            oplot, data_ks[sub0]*[1,1], !Y.CRANGE, color = 3
            oplot, !X.CRANGE, cdf_0[sub0]*[1,1], color = 3
         endif else begin
            oplot, data_ks, cdf_n, psym = 10
            oplot, data_ks[subn]*[1,1], !Y.CRANGE, color = 3
            oplot, !X.CRANGE, cdf_n[subn]*[1,1], color = 3
         endelse 
         oplot, data_ks, cdf_f, color = 2, linestyle = 2
         legend, /top, /left, $
            ['data', 'fit', 'largest dev.', str1, str2], $
            linestyle = [0, 0, 2, -1, -1], color = [!P.COLOR, 2, 3, 0, 0]

         if (ps_file ne '') then begin
            xyouts, 0, !D.Y_CH_SIZE + !D.Y_SIZE, ps_file, $
               charsize = 0.5, /device 
         endif

      endif ; if keyword_set(plot_flag)

   endif; if keyword_set(ks_test)

endif

if (ps_file ne '') then begin
   device, /close_file 
   set_plot, IDL_WIN.default
endif

if (plot_flag ne 0) then cleanplot, /silent

return, result

end

