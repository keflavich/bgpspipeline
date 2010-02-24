; an ineffective but still moderately useful algorith to determine
; the smallest number size that is some multiple of 2^n and possibly
; 3,5 or 3 and 5 for fft efficiency...
function best_fft_size,n,guess
    n = long(n)
    guess = long(guess)
    if guess eq n or guess eq n+1 then return,guess
    if guess * 3 / 4 gt n then return,guess * 3 / 4
    if guess * 5 / 8 gt n then return,guess * 5 / 8
    if guess * 3 * 5 / 16 gt n then return,guess * 3 * 5 / 16
    if guess gt n then return,guess ;return,guess/2+best_fft_size(n-guess/2,2)
    if guess eq 0 then guess = 2
    return,best_fft_size(n,guess*2)
end



    
