checkLongitude = function(x, primeMeridian="center", sort=FALSE, ...) {
  
  .longitude2Center = function(x, ...) {
    if (!any(x > 180))
      return(x)
    x[x > 180] = x[x > 180] - 360
    return(x)
  }
  
  .longitude2Left = function(x, ...) {
    if (!any(x < 0))
      return(x)
    x[x < 0] = x[x < 0] + 360
    return(x)
  }
  
  out = switch(primeMeridian,
               center = .longitude2Center(x, ...),
               left = .longitude2Left(x, ...))
  
  if(isTRUE(sort)) out = sort(out)
  
  return(out)
}






findPrimeMeridian = function(x) {
  if(any(x<0)) return("center")
  if(any(x>180)) return("left")
  warning("Indeterminate Prime Meridian from longitude values.")
  return(NULL)
}

.checkVarid = function(varid, nc) {
  
  if(missing(varid)) varid = NA
  
  if(is.na(varid)) {
    if(length(nc$var)==1) varid = nc$var[[1]]$name
    msg = sprintf("Several variables found in %s, must specify 'varid'.", nc$filename)
    if(length(nc$var)>1) stop(msg)
  }
  
  if(inherits(varid, "ncvar4")) varid = varid$name
  
  if(!is.character(varid))
    stop("varid must be a string or an object of class 'ncvar4'.")
  
  varExists = varid %in% names(nc$var)
  
  msg = sprintf("Variable '%s' not found in '%s'.", varid, nc$filename)
  if(!varExists) stop(msg)
  
  return(varid)
  
}

nc_changePrimeMeridian_v2 = function(filename, output, varid=NA, MARGIN=1, primeMeridian="center",
                                  verbose=FALSE, overwrite=FALSE, compression=NA,
                                  mem.limit=3072, ignore.case=FALSE) {
  
  if(missing(output) & !isTRUE(overwrite))
    stop("output file is missing. Set 'overwrite' to TRUE to make changes in the original file.")
  
  if(missing(output)) output = filename
  
  if(file.exists(output) & !isTRUE(overwrite))
    stop("output file already exists. Set 'overwrite' to TRUE.")
  
  tmp = paste(output, ".temp", sep="")
  
  nc = nc_open(filename)
  on.exit(nc_close(nc))
  
  varid = .checkVarid(varid=varid, nc=nc)
  gloAtt = ncatt_get(nc, varid = 0)
  varAtt = ncatt_get(nc, varid = varid)
  varAtt[["_FillValue"]] = NULL
  
  dn = ncvar_dim(nc, varid, value=TRUE)
  dnn = if(isTRUE(ignore.case)) tolower(names(dn)) else names(dn)
  
  if(length(MARGIN)!=1) stop("MARGIN must be of length one (dim of 'longitude').")
  
  if (is.character(MARGIN)) {
    if(isTRUE(ignore.case)) MARGIN = tolower(MARGIN)
    MARGIN = match(MARGIN, dnn)
    if(anyNA(MARGIN))
      stop("not all elements of 'MARGIN' are names of dimensions")
  }
  
  ivar = nc$var[[varid]]
  lon = ivar$dim[[MARGIN]]$vals
  ndim = length(ivar$dim)
  if(ndim<2) stop("Data must have at least two dimensions!")
  
  cellLimit = (mem.limit*2^20)/8
  
  bigData = (prod(ivar$size) > cellLimit) # 3GB by default
  
  if(bigData) {
    
    npiece = floor(prod(ivar$size)/cellLimit)
    useDim = setdiff(which(ivar$size >= npiece), MARGIN)
    useDim = which.min(ivar$size[useDim])
    itDim  = max(ceiling(ivar$size[useDim]/npiece), 1)
    
    starts = seq(from=1, to=ivar$size[useDim], by=itDim)
    counts = diff(c(starts-1, ivar$size[useDim]))
    npiece = length(starts)
    
    start = rep(1, ndim)
    count = rep(-1, ndim)
    
  }
  
  pm = findPrimeMeridian(lon)
  
  pmCheck = is.null(pm) | identical(pm, primeMeridian)
  
  if(isTRUE(pmCheck)) {
    warning("Longitud values are correct, nothing to do.")
    nc_close(nc)
    on.exit()
    if(!identical(filename, output))
      file.copy(filename, output, overwrite=TRUE)
    return(invisible(output))
  }
  
  newlon = checkLongitude(lon, primeMeridian = primeMeridian)
  ind = sort(newlon, index.return=TRUE)$ix
  ivar$dim[[MARGIN]]$vals = newlon[ind]
  if(!is.na(compression)) ivar$compression = compression
  ivar$chunksizes = NA
  
  ncNew = nc_create(filename=tmp, vars=ivar)
  on.exit(if(file.exists(tmp)) file.remove(tmp))
  
  if(!bigData) {
    
    newvar = c(list(x=ncvar_get(nc, varid, collapse_degen=FALSE, raw_datavals = TRUE),
                    drop=FALSE), rep(TRUE, ndim))
    newvar[[MARGIN+2]] = ind
    newvar = do.call('[', newvar)
    ncvar_put(ncNew, varid, newvar)
    
  } else {
    
    message("Using big data method.")
    pb = txtProgressBar(style=3)
    setTxtProgressBar(pb, 0)
    
    
    for(i in seq_len(npiece)) {
      
      start[useDim] = starts[i]
      count[useDim] = counts[i]
      
      newvar = c(list(x=ncvar_get(nc, varid, collapse_degen=FALSE,
                                  start=start, count=count, raw_datavals = TRUE),
                      drop=FALSE), rep(TRUE, ndim))
      newvar[[MARGIN+2]] = ind
      newvar = do.call('[', newvar)
      invisible(gc())
      ncvar_put(ncNew, varid, newvar, start=start, count=count)
      nc_sync(ncNew)
      
      pb = txtProgressBar(style=3)
      setTxtProgressBar(pb, i/npiece)
      
    }
  }
  
  ncatt_put_all(ncNew, varid=0, attval=gloAtt)
  ncatt_put_all(ncNew, varid=varid, attval=varAtt)
  
  nc_close(ncNew)
  nc_close(nc)
  
  if(file.exists(output)) file.remove(output)
  file.rename(tmp, output)
  
  return(invisible(output))
  
}
