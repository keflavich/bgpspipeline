pro boloexp, x, a, f, pder

; set time constant of exponential:
  
  tc=10.4                       ;in seconds
  
  expterm = exp(-x/(tc*50.))	;data taken at 50 Hz
  f = a(0) * expterm + a(1)
  
  if n_params() ge 4 then $
    pder = [[expterm], [replicate(1.0, n_elements(x))]]
  
end












