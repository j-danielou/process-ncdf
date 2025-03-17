library(nctools)


###  Variable Extraction For GLORYS Files (.nc)  ###

GLORYS_extract_var = function(path,list_filename,varid,outputDir ){
  
  varid_name=varid
  GLORYS=paste0("GLO12v1_",ifelse(varid_name=="thetao","sst",varid),"_mean")
  
  for (filename in list_filename){
    message("Start of Variable Extraction for the : ", filename)
    extracted_part <- sub(".*_(\\d{4})(\\d{2})\\.nc$", "\\1_\\2", filename)
    output=paste0(outputDir,GLORYS,"_",extracted_part,".nc" )
    nc_extract(paste0(path,filename),varid,output)
    message("Variable Extracted for the : ", filename)
}

  message("All Files are done !!")
}


###  Variable Extraction For BRAN Files (.nc)  ###

BRAN_extract_var = function(path,list_filename,varid,outputDir ){
  
  varid_name=varid
  BRAN=paste0("BRAN2020_",ifelse(varid_name=="temp","sst",varid),"_mean")
  
  for (filename in list_filename){
    message("Start of Variable Extraction for the : ", filename)
    extracted_part <- sub(".*_(\\d{4}_\\d{2})\\.nc$", "\\1", filename)
    output=paste0(outputDir,BRAN,"_",extracted_part,".nc" )
    nc_extract(paste0(path,filename),varid,output)
    message("Variable Extracted for the : ", filename)
  }
  
  message("All Files are done !!")
}


###  Variable Extraction For HYCOM Files (.nc)  ###

HYCOM_extract_var = function(path,list_filename,varid,outputDir ){
  
  varid_name=varid
  HYCOM=paste0("HYCOM_",ifelse(varid_name=="water_temp","sst",varid),"_mean")
  
  for (filename in list_filename){
    message("Start of Variable Extraction for the : ", filename)
    extracted_part <- sub(".*\\.(\\d{4}_\\d{2})_.*\\.nc$", "\\1", filename)
    output=paste0(outputDir,HYCOM,"_",extracted_part,".nc" )
    nc_extract(paste0(path,filename),varid,output)
    message("Variable Extracted for the : ", filename)
  }
  
  message("All Files are done !!")
}





