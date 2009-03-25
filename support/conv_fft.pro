; image convolution using FFTs
function conv_fft,im1,im2

    imsize1 = size(im1,/dim)
    imsize2 = size(im2,/dim)
    dim1 = max([imsize1[0],imsize2[0]])
    dim2 = max([imsize1[1],imsize2[1]])

    ; assume we want the images to be zero padded
    ; i.e. make them larger, not smaller, to match
    ; sizes
    im1_big = dblarr(dim1,dim2)
    im2_big = dblarr(dim1,dim2)

    ; zero padding in each dimension
    xlow1 = dim1/2-imsize1[0]/2
    xlow2 = dim1/2-imsize2[0]/2
    ylow1 = dim2/2-imsize1[1]/2
    ylow2 = dim2/2-imsize2[1]/2
    im1_big[xlow1:xlow1+imsize1[0]-1,ylow1:ylow1+imsize1[1]-1] = im1
    im2_big[xlow2:xlow2+imsize2[0]-1,ylow2:ylow2+imsize2[1]-1] = im2

    if max(finite(im1_big,/nan)) eq 1 then im1_big[where(finite(im1_big,/nan))] = 0
    if max(finite(im2_big,/nan)) eq 1 then im2_big[where(finite(im2_big,/nan))] = 0

    fft1 = fft(im1_big)
    fft2 = fft(im2_big)

    convolved = float(fft(fft1*fft2,/inverse))
    
    scalefactor = mean(im1,/nan)/mean(convolved,/nan)

    return,shift(convolved,dim1/2+1,dim2/2+1)*scalefactor
;    return,convolved

end
