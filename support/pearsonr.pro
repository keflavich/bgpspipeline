; Translated from scipy on August 6th, 2011
;"""Calculates a Pearson correlation coefficient and the p-value for testing
;non-correlation.
;
;The Pearson correlation coefficient measures the linear relationship
;between two datasets. Strictly speaking, Pearson's correlation requires
;that each dataset be normally distributed. Like other correlation
;coefficients, this one varies between -1 and +1 with 0 implying no
;correlation. Correlations of -1 or +1 imply an exact linear
;relationship. Positive correlations imply that as x increases, so does
;y. Negative correlations imply that as x increases, y decreases.
;
;The p-value roughly indicates the probability of an uncorrelated system
;producing datasets that have a Pearson correlation at least as extreme
;as the one computed from these datasets. The p-values are not entirely
;reliable but are probably reasonable for datasets larger than 500 or so.
;
;Parameters
;----------
;x : 1D array
;y : 1D array the same length as x
;
;Returns
;-------
;(Pearson's correlation coefficient,
; 2-tailed p-value)
;
;References
;----------
;http://www.statsoft.com/textbook/glosp.html#Pearson%20Correlation
;"""
function pearsonr,x,y
    ; x and y should have same length.
    n = n_elements(x)
    mx = mean(x)
    my = mean(y)
    xm = x-mx
    ym = y-my
    r_num = n*(total(xm*ym))
    r_den = n*sqrt(total(xm^2)*total(ym^2))
    r = (r_num / r_den)

    ; Presumably, if r > 1, then it is only some small artifact of floating
    ; point arithmetic.
    r = min([r, 1.0])
    df = n-2 ; degrees of freedom (I assume)

    ; holdover from scipy...
    ; Use a small floating point value to prevent divide-by-zero nonsense
    ; fixme: TINY is probably not the right value and this is probably not
    ; the way to be robust. The scheme used in spearmanr is probably better.
    TINY = 1.0e-10
    t = r*sqrt(df/((1.0-r+TINY)*(1.0+r+TINY)))
    prob = ibeta(0.5*df,0.5,df/(df+t*t))
    return,[r,prob]
end
