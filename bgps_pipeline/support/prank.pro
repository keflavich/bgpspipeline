function prank,array,p
;+
; ROUTINE:    prank
;
; PURPOSE:    compute the value in ARRAY which is at a given 
;             percentile ranking within ARRAY.  For example,
;             median_of_array=prank(array,50)
;
; USEAGE:     result=prank(array,percentile)
;
; INPUT:
;   array     an array of values, any type but string or complex
;   p         percentile rank (0-100), may be a vector of ranks
;
;
; OUTPUT:     result=prank(array,percentile)
;             result=value within array which is at the specified percentile
;             rank
;
; EXAMPLE:	
;
;    	 	r=10.^(randf(1000,2))*randomn(seed,1000)
;               
;               plot,r,psym=3
;               plot,r,yrange=prank(r,[5,95]),psym=3
;
;; print a set of percentile rankings within r
;
;;      percentile rank 0   =>  min
;;      percentile rank 50  =>  median
;;      percentile rank 100 =>  max
;
;               print,prank(r,[0,5,50,95,100])
;               
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            feb95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
nn = n_elements(array)
ip =  long(float(p)*nn/100.)

ii = sort(array)
return,array(ii(ip))
END
