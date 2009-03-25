function mode,array
    nbins = ceil(sqrt(n_e(array)))
    h=histogram(array,nbins=nbins,location=l)
    m=max(ts_smooth(h,sqrt(nbins)),lm)
    return,l[lm]
end
