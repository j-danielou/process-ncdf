nc_unlim_v2 = function(filename, unlim, output=NULL) {
  # open ncdf connection
  if(is.null(output)) output = filename
  outputTemp = paste(output, ".temp", sep="")
  nc = nc_open(filename)
  gloAtt = ncatt_get(nc, varid = 0)

  on.exit(nc_close(nc))
  
  .makeUnlim = function(x, unlim) {
    names(x$dim) = sapply(x$dim, "[[", "name")
    if(is.null(x$dim[[unlim]])) return(x)
    x$dim[[unlim]]$unlim = TRUE
    x$unlim = TRUE
    return(x)
  }
  
  # new variables with unlimited dimension
  newVars = lapply(nc$var, FUN=.makeUnlim, unlim=unlim)
  
  ncNew = nc_create(filename=outputTemp, vars=newVars)
  
  for(iVar in names(newVars)){
    ncvar_put(ncNew, iVar, ncvar_get(nc, iVar, collapse_degen=FALSE, raw_datavals = TRUE))
    varAtt = ncatt_get(nc, varid = iVar)
    varAtt[["_FillValue"]] = NULL
    ncatt_put_all(ncNew, varid=iVar, attval=varAtt)
  }
  
  ncatt_put_all(ncNew, varid=0, attval=gloAtt)
  nc_close(ncNew)
  
  renameFlag = file.rename(outputTemp, output)
  
  return(invisible(newVars))
  
}