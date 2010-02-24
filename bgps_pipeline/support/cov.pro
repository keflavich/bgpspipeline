;##################################
; program calculates the coefficiency of var1 and var2
;##################################
; Gang He
; ESRG
; Jan. 1, 1993


pro  cov,var1, var2

;std1=mstdev(var1,mean1)
;std2=mstdev(var2,mean2)
std1=stdev(var1,mean1)
std2=stdev(var2,mean2)
var3=(var1-mean1)*(var2-mean2)
std3=stdev(var3,mean3)
;std3=mstdev(var3,mean3)
cov = mean3/(std1*std2)

;sz=size(var)
;print,'size=',sz
;print,'min=',min(var)
;print,'max=',max(var)
;print,'mean3=',mean3
;print,'diff=', max(var)-min(var)
;print,'std1=',std1
;print,'std2=',std2
;print,'Cov(var1,var2)',cov
print,cov

return
end

