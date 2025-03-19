GLORYS12v1_process = function(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end){
  
  library(nctools)
  library(ncdf4)
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_extract_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_changePrimeMeridian_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_unlim_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_subset_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_rcat_v2.R")
  
  if (is.null(newvarid) || missing(newvarid)) {
    newvarid <- varid
  }
  
  dir.create(paste0(outputDir,"temp"))
  varid_name=varid
  GLORYS=paste0("GLO12v1_",ifelse(varid_name=="thetao","sst",varid),"_temp")
  count = 1
  
  for (filename in list_filename){
    data = nc_open(filename = paste0(path,filename))
    message("Start of Variable Extraction for the : ", filename)
    #extracted_part <- sub(".*_(\\d{4})(\\d{2})\\.nc$", "\\1_\\2", filename)
    output=paste0(outputDir,"temp/",GLORYS,"_",count,".nc" )
    nc_extract_v2(paste0(path,filename),varid,output)
    message("Variable Extracted for the : ", filename)
    count= count + 1
  }
  
  if (!meridian == "center"){
    
    newpath = paste0(outputDir,"temp/")
    list_filename = list.files(path=newpath)
    
    for (filename in list_filename){
      message("Start Meridian Change for : ", filename)
      
      nc_changePrimeMeridian_v2(filename = paste0(newpath,filename), varid=varid, primeMeridian = "left", overwrite = TRUE)
      
      message("Succes Meridian Change to left for : ", filename)
    }
  }
  
  else{
    newpath = paste0(outputDir,"temp/")
    list_filename = list.files(path=newpath)
    
    for (filename in list_filename){
      message("Start Meridian Change for : ", filename)
      
      nc_changePrimeMeridian_v2(filename = paste0(newpath,filename), varid=varid, primeMeridian = "center", overwrite = TRUE)
      
      message("Succes Meridian Change to left for : ", filename)
    }
  }
  
  if(!domain == "global" ){
    dir.create(paste0(outputDir,"temp_spa"))
    newpath = paste0(outputDir,"temp/")
    endpath = paste0(outputDir,"temp_spa/")
    list_filename = list.files(path=newpath)
    
    for (filename in list_filename){
      message("Start of the Spatial Subsetting for : ", filename)
      
      nc_subset_v2(filename=paste0(newpath,filename), varid=varid, output = paste0(endpath,filename), newvarid=newvarid, compression = 9, latitude=c(-70,10), longitude=c(120,300), depth =c(0,0.5))
      
      message("Succes Spatial Subsetting for : ", filename)
    }
  }
  else{
    dir.create(paste0(outputDir,"temp_spa"))
    newpath = paste0(outputDir,"temp/")
    endpath = paste0(outputDir,"temp_spa/")
    list_filename = list.files(path=newpath)
    
    for (filename in list_filename){
      message("Start of the Spatial Subsetting (upper layer) for : ", filename)
      
      nc_subset_v2(filename=paste0(newpath,filename), varid=varid, output = paste0(endpath,filename), newvarid=newvarid, compression = 9, depth =c(0,0.5))
      
      message("Succes Spatial Subsetting (upper layer) for : ", filename)
    }
  }
  
  dir.create(paste0(outputDir,"temp_unlim"))
  unlim_path = paste0(outputDir,"temp_unlim/")
  list_filename = list.files(path=endpath)
  for (filename in list_filename){
    
    message("Start Processing Dimension for : ", filename)
    
    nc_unlim_v2(filename = paste0(endpath,filename), unlim = "time", output = paste0(unlim_path, filename))
    
    message("Succes ! Processing Dimension for : ", filename)
  }

 
   
  ###   Concatenation for a Variable for GLORYS files (.nc)  ###
  


  list_filename= list.files(path=unlim_path)
  output = paste0(outputDir,"glorys-v1-",domain,"-",newvarid,"-",temp,"-",start,"-",end,".nc")
  nc_rcat_v2(filenames = paste0(unlim_path,list_filename),varid=newvarid,output)
  message("Succes !! Concatenation for the variable : ",varid)

  unlink(x = paste0(outputDir,"temp"), recursive = TRUE)
  unlink(x = paste0(outputDir,"temp_unlim"), recursive = TRUE)
  unlink(x = paste0(outputDir,"temp_spa"), recursive = TRUE)
  
}
 




