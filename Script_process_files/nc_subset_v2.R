nc_subset_v2 = function(filename, varid, output, newvarid, compression,
                     force_v4=FALSE, ..., ignore.case=FALSE, drop=FALSE) {
  
  bounds = list(...)
  bounds = lapply(bounds, FUN = function(x) if(length(x)==1) return(rep(x, 2)) else return(x))
  
  if(isTRUE(ignore.case)) names(bounds) = tolower(names(bounds))
  nc = nc_open(filename)
  on.exit(nc_close(nc))
  
  varid = .checkVarid(varid=varid, nc=nc)
  varAtt = ncatt_get(nc, varid = varid)
  varAtt[["_FillValue"]] = NULL
  if(missing(newvarid)) newvarid = varid
  
  dims = ncvar_dim(nc, varid, value=TRUE)
  dimNames = names(dims)
  
  if(isTRUE(ignore.case)) names(dims) = tolower(names(dims))
  
  check = any(names(bounds) %in% names(dims), na.rm=TRUE)
  
  if(!isTRUE(check)) {
    warning("Dimensions to subset don't match, nothing to do.")
    return(invisible())
  }
  
  .getIndex = function(x, bound, FUN, default=1) {
    FUN = match.fun(FUN)
    # longitude in a torus
    if(is.null(bound)) return(default)
    if(diff(bound)<0) stop("Upper bound is lower than lower bound.")
    out = which((x>=bound[1]) & (x<=bound[2]))
    return(FUN(out))
  }
  
  count = setNames(sapply(names(dims),
                          function(x) .getIndex(dims[[x]], bounds[[x]], FUN=length, default=-1)),
                   names(dims))
  
  if(any(count==0)) {
    msg = sprintf("All index are out of bounds: (%s).", paste(bound, collapse=", "))
    
  }
  
  index = setNames(lapply(names(dims),
                          function(x) .getIndex(dims[[x]], bounds[[x]], FUN=identity, default=TRUE)),
                   dimNames) # keep original names
  
  start = setNames(sapply(names(dims),
                          function(x) .getIndex(dims[[x]], bounds[[x]], FUN=min, default=1)),
                   names(dims))
  
  x  = ncvar_get(nc, varid, collapse_degen=FALSE, start=start, count=count, raw_datavals = TRUE)
  
  newVar = nc$var[[varid]]
  newVar$size = dim(x)
  newVar$name = newvarid
  if(!missing(compression)) newVar$compression = compression
  newVar$chunksizes = NA
  
  .modifyDim = function(x, dim, index) {
    if(isTRUE(index[[x]])) return(dim[[x]])
    if(length(index[[x]])==1 & isTRUE(drop)) return(NULL)
    dim[[x]]$size = length(index[[x]])
    dim[[x]]$len = length(index[[x]])
    dim[[x]]$vals = dim[[x]]$vals[index[[x]]]
    return(dim[[x]])
  }
  
  newVar$dim = lapply(names(nc$dim), FUN=.modifyDim, dim=nc$dim, index=index)
  ind = newVar$dimids + 1
  if(isTRUE(drop)) ind = ind[dim(x)>1]
  newVar$dim = newVar$dim[ind]
  if(isTRUE(drop)) x = drop(x)
  
  newVar = ncvar_def(name=newVar$name, units = newVar$units,
                     missval = newVar$missval, dim = newVar$dim,
                     longname = newVar$longname, prec = ifelse(newVar$prec == "int", "float", newVar$prec),
                     compression = newVar$compression)
  
  ncNew = nc_create(filename=output, vars=newVar, force_v4=force_v4)
  on.exit(nc_close(ncNew), add=TRUE)
  
  ncvar_put(ncNew, newvarid, x)
  
  globalAtt = ncatt_get(nc, varid=0)
  
  xcall = paste(gsub(x=gsub(x=capture.output(match.call()),
                            pattern="^[ ]*", replacement=""), pattern="\"",
                     replacement="'"), collapse="")
  
  oldHistory = if(!is.null(globalAtt$history)) globalAtt$history else NULL
  
  newHistory = sprintf("%s: %s [nctools version %s, %s]",
                       date(), xcall, packageVersion("nctools"), R.version.string)
  
  globalAtt$history = paste(c(oldHistory, newHistory), collapse="\n")
  
  # copy global attributes from original nc file.

  ncatt_put_all(ncNew, varid=0, attval=globalAtt)
  ncatt_put_all(ncNew, varid=newvarid, attval=varAtt)

  
  return(invisible(output))
}






