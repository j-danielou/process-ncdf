library(nctools)


###  Spatiale Extraction For GLORYS Files (.nc)  ###


GLORYS_spatial_sub = function(path, list_filename, varid, newvarid, outputDir){
  
  for (filename in list_filename){
    message("Start Meridian Change for : ", filename)
    
    nc_changePrimeMeridian(filename = paste0(path,filename), output = paste0(path,filename), varid=varid, primeMeridian = "left", compression = 9, overwrite = TRUE)
    
    message("Succes Meridian Change to left for : ", filename)
    message("Start of the Spatial Subsetting for : ", filename)
    
    nc_subset(filename=paste0(path,filename), varid=varid, output = paste0(outputDir,filename), newvarid=newvarid, compression = 9, latitude=c(-70,10), longitude=c(120,300))
    
    message("Succes Spatial Subsetting for : ", filename)
  }
  message("All Files are done !!")
}




###  Spatiale Extraction For BRAN Files (.nc)  ###


HYCOM_spatial_sub = function(path, list_filename, varid, newvarid, outputDir){
  
  for (filename in list_filename){

    message("Start of the Spatial Subsetting for : ", filename)
    
    nc_subset(filename=paste0(path,filename), varid=varid, output = paste0(outputDir,filename), newvarid=newvarid, compression = 9, lat=c(-70,10), lon=c(120,300))
    
    message("Succes Spatial Subsetting for : ", filename)
  }
  message("All Files are done !!")
}
