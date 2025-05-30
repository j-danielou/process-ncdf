library(nctools)

nc_extract_v2 = function(filename, varid, output) {
  nc = nc_open(filename)
  on.exit(nc_close(nc))
  varid = .checkVarid(varid=varid, nc=nc)
  globalAtt = ncatt_get(nc, varid = 0)
  varAtt = ncatt_get(nc, varid = varid)
  varAtt[["_FillValue"]] = NULL
  ncNew = nc_create(filename=output, vars=nc$var[[varid]])
  ncvar_put(ncNew, varid, ncvar_get(nc, varid, collapse_degen=FALSE, raw_datavals = TRUE))
  if (length(globalAtt)==0){
    
    ncatt_put_all(ncNew, varid=varid, attval=varAtt)
    
  }else{
    
    ncatt_put_all(ncNew, varid=0, attval=globalAtt)
    ncatt_put_all(ncNew, varid=varid, attval=varAtt)
  }
  
  nc_close(ncNew)
  return(invisible(output))
}