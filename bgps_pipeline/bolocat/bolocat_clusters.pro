pro bolocat_clusters, p, clusternum, clsz, clglon, clglat, clnum

; Identify clusters in data based on separations

  dmat = fltarr(n_elements(p), n_elements(p))
  
  for k = 0, n_elements(p)-1 do begin 

    gcirc, 2, p.ra, p.dec, p[k].ra, p[k].dec, dist
    dmat[*, k] = dist
;     ind = where(dist lt mindist, ct)
;     if ct eq 1 then keep[k] = k else begin
;       null = max(p[ind].mn_s2n, thisone)
;       keep[k] = ind[thisone]
;     endelse
  endfor

  clusters = cluster_tree(dmat, link_distance, $
                          linkage = 2, measure = 0)


;  dendro_plot, clusters, link_distance, /ylo, yrange = [10, 200]

  ld = where(link_distance lt 60, count)
  sz = size(clusters)
  clusternum = lonarr(n_elements(p)) 
  for k = 0, count-1 do begin
    leaves = cluster_leaves(k+sz[2]+1, clusters)
    leaves = leaves[where(leaves lt sz[2]+1)]
    clusternum[leaves] = k+1 > clusternum[leaves]
  endfor
  goodcl = clusternum[uniq(clusternum,  sort(clusternum))]
  clsz = fltarr(n_elements(goodcl))+!values.f_nan 
  clglon = dblarr(n_elements(goodcl))+!values.d_nan 

  clglat = dblarr(n_elements(goodcl))+!values.d_nan 
  clnum = intarr(n_elements(goodcl)) 
  for j = 1, n_elements(goodcl)-1 do begin 
    ind = where(clusternum eq goodcl[j], ct)
    clsz[j] = max(dmat[ind#replicate(1, ct), replicate(1, ct)#ind])
    clglon[j] = mean(p[ind].glon)
    clglat[j] = mean(p[ind].glat)
    clnum[j] = ct
  endfor


  
  return
end
