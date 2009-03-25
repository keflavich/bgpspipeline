
function xy_to_rth,xy
    r = sqrt(xy[*,0]^2+xy[*,1]^2)
    th = atan(xy[*,1],xy[*,0])
    return,[[r],[th]]
end
