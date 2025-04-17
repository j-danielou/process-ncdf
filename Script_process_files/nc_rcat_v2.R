nc_rcat_v2 = function(filenames, varid, output) {
  # add function validation
  # check for unlim
  for(i in seq_along(filenames)) {
    nc = nc_open(filenames[i])
    if(!any(ncdim_isUnlim(nc))) stop("Files don't have an unlimited dimension.")
    if(i==1) {
      varid = .checkVarid(varid=varid, nc=nc)
      isUnlim  = ncdim_isUnlim(nc)[ncvar_dim(nc)[[varid]]]
      unlimDim = names(nc$dim)[which(ncdim_isUnlim(nc))]
      ncNew = nc_create(filename=output, vars=nc$var[[varid]])
      start = rep(1, length(isUnlim))
      refSize = nc$var[[varid]]$size[which(!isUnlim)]
      gloAtt = ncatt_get(nc, varid = 0)
      varAtt = ncatt_get(nc, varid = varid)
      varAtt[["_FillValue"]] = NULL
    }
    if(!(varid %in% names(nc$var))) {
      msg = sprintf("Variable '%s' not found in '%s'.", varid, nc$filename)
      stop(msg)
    }
    ncSize = nc$var[[varid]]$size
    if(!identical(ncSize[which(!isUnlim)], refSize))
      stop("File dimensions doesn't match.")
    count = ncSize*isUnlim -1*!isUnlim
    # add values to varid
    ncvar_put(ncNew, varid, ncvar_get(nc, varid, collapse_degen=FALSE),
              start=start, count=ncSize)
    # add values to unlimited dimension
    ncvar_put(ncNew, varid=unlimDim, ncvar_get(nc, varid=unlimDim),
              start=start[which(isUnlim)], count=ncSize[which(isUnlim)])
    start = start + ncSize*isUnlim
    nc_close(nc)
  }
  ncatt_put_all(ncNew, varid=0, attval=gloAtt)
  ncatt_put_all(ncNew, varid=varid, attval=varAtt)
  nc_close(ncNew)
  return(invisible(output))
}