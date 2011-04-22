
pro checkshift,stamp,fp,test,xoff,yoff,params,extra_x,extra_y,sz,maxoff,im1,im2,clean1,clean2,corr,subim1,subim2,sigbeam,lastx=lastx,lasty=lasty

      set_plot,'x'
      device,decompose=0
      window,0,xpos=0,ypos=1280-600
      !p.multi = [0,2,2,0,1]
      loadct,0,/silent
      imdisp,stamp,erase=0,/axis
      loadct,39,/silent
      oplot,[params[4]],[params[5]],psym=7,color=250
      loadct,0,/silent
      whnan = where(finite(subim2,/nan),nnan)
      if nnan gt 0 then begin psubim2 = subim2 & psubim2[whnan] = 0 & endif
      imdisp,asinh(psubim2),/axis
      imdisp,test    ,/axis
      loadct,39,/silent
      oplot,[params[4]],[params[5]],psym=7,color=250
      loadct,0,/silent
      imdisp,stamp-fp-test,erase=0,/axis
      loadct,39,/silent
      oplot,[params[4]],[params[5]],psym=7,color=250
      oplot,[maxoff+1],[maxoff+1],psym=1,color=150
      if keyword_set(lastx) and keyword_set(lasty) then oplot,[lastx],[lasty],psym=1,color=100
      loadct,0,/silent
      window,1,xpos=960,ypos=1280-600
      !p.multi = 0
      imdisp,stamp,erase=0,/axis
      loadct,39,/silent
      oplot,[params[4]],[params[5]],psym=7,color=250
      oplot,[maxoff+1],[maxoff+1],psym=1,color=150
      if keyword_set(lastx) and keyword_set(lasty) then oplot,[lastx],[lasty],psym=1,color=100
      cursor,x,y,/data,/down
      if !mouse.button eq 1 then begin
          oplot,[x],[y],psym=1,color=200
          xoff = (x-maxoff-1*(sz[1] mod 2 eq 1))-extra_x
          yoff = (y-maxoff-1*(sz[2] mod 2 eq 1))-extra_y
          print,"New xoff,yoff: ",xoff,yoff," from clicked point ",x,y
          if !mouse.button eq 1 then begin
              cursor,x2,y2,/down
              if !mouse.button eq 1 then stop
              if !mouse.button eq 2 then print,"Continuing with xoff,yoff=",xoff,yoff
              if !mouse.button eq 3 then begin
                  xoff = (x2-maxoff-1*(sz[1] mod 2 eq 1))-extra_x
                  yoff = (y2-maxoff-1*(sz[2] mod 2 eq 1))-extra_y
                  print,"New xoff,yoff: ",xoff,yoff," from clicked point ",x2,y2
                  stop
              endif
          endif
      endif else if !mouse.button eq 2 then begin
          params[2] = sigbeam
          params[3] = sigbeam
          params[4] = x
          params[5] = y
          print,"Guessed params: ",params
          test = mpfit2dpeak(stamp-fp, params, perror=perror, chisq=chisq, /tilt)
          print,"Fitted params: ",params
          xoff = (params[4]-maxoff-1*(sz[1] mod 2 eq 1))-extra_x
          yoff = (params[5]-maxoff-1*(sz[2] mod 2 eq 1))-extra_y
          print,"New xoff,yoff: ",xoff,yoff," from clicked point ",x,y
          checkshift,stamp,fp,test,xoff,yoff,params,extra_x,extra_y,sz,maxoff,im1,im2,clean1,clean2,corr,subim1,subim2,sigbeam,lastx=x,lasty=y
      endif

end
