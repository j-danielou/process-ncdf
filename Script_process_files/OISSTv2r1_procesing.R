library(nctools) # install_github("roliveros-ramos/nctools")
#source("temporary_functions.R")


OISSTv2r1_process = function(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL) {
  
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_extract_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_changePrimeMeridian_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_unlim_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_subset_v2.R")
  source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/nc_rcat_v2.R")
  
  if(is.null(tempdir)) tempdir = tempdir()
  
  # check = requireNamespace("nctools")
  # if(!check) stop("You need to install the 'nctools' package from ...")
  # nctools::nc_apply()
  # nctools::nc_extract_v2
  # nctools::nc_changePrimeMeridian_v2
  # nctools::nc_subset_v2
  # nctools::nc_unlim_v2
  #
  # library(nctools)
  # nc_apply()
  
  if (is.null(newvarid) || missing(newvarid)) {
    newvarid <- varid
  }
  
  dir.create(file.path(tempdir,"temp"))
  on.exit(unlink(x = file.path(tempdir,"temp"), recursive = TRUE))
  folder_path = file.path(tempdir,"temp")
  
  dir.create(file.path(folder_path,"extract"))
  output_path = file.path(folder_path,"extract")
  
  varid_name=varid
  count = 1
  
  for (filename in list_filename){
    message("Start of Variable Extraction for the : ", filename)
    OISST = paste0("OISSTv2.1", ifelse(varid_name == "temp", "sst", varid), "_temp")
    OISST = paste0(OISST, "_", sprintf("%04d", count), ".nc")
    output= file.path(output_path,OISST)
    nc_extract_v2(file.path(path,filename),varid,output)
    message("Variable Extracted for the : ", filename)
    count= count + 1
  }
  
  if (!meridian == "center"){
    
    input_path = output_path
    list_filename = list.files(path=input_path)
    
    for (filename in list_filename){
      message("Start Meridian Change for : ", filename)
      
      nc_changePrimeMeridian_v2(filename = file.path(input_path,filename), varid=varid, primeMeridian = "left", overwrite = TRUE)
      
      message("Succes Meridian Change to left for : ", filename)
    }
  }
  
  else{
    input_path = output_path
    list_filename = list.files(path=input_path)
    
    for (filename in list_filename){
      message("Start Meridian Change for : ", filename)
      
      nc_changePrimeMeridian_v2(filename = file.path(input_path,filename), varid=varid, primeMeridian = "center", overwrite = TRUE)
      
      message("Succes Meridian Change to left for : ", filename)
    }
  }
  
  if(!domain == "global" ){
    dir.create(file.path(folder_path,"subset"))
    output_path = file.path(folder_path,"subset")
    
    list_filename = list.files(path= input_path)
    
    for (filename in list_filename){
      message("Start of the Spatial Subsetting for : ", filename)
      
      nc_subset_v2(filename=file.path(input_path,filename), varid=varid, output = file.path(output_path,filename), newvarid=newvarid, compression = 9, lat=c(-60,10), lon=c(120,291))
      
      message("Succes Spatial Subsetting for : ", filename)
    }
  }
  else{
    dir.create(file.path(folder_path,"subset"))
    output_path = file.path(folder_path,"subset")
    
    list_filename = list.files(path= input_path)
    
    for (filename in list_filename){
      message("Start of the Spatial Subsetting (upper layer) for : ", filename)
      
      nc_subset_v2(filename=file.path(input_path,filename), varid=varid, output = file.path(output_path,filename), newvarid=newvarid, compression = 9)
      
      message("Succes Spatial Subsetting (upper layer) for : ", filename)
    }
  }
  
  input_path = output_path
  
  dir.create(file.path(folder_path,"unlim"))
  output_path = file.path(folder_path,"unlim")
  
  list_filename = list.files(path=input_path)
  
  for (filename in list_filename){
    message("Start Processing Dimension for : ", filename)
    
    nc_unlim_v2(filename = file.path(input_path,filename), unlim = "time", output = file.path(output_path,filename))
    
    message("Succes ! Processing Dimension for : ", filename)
    
    #file.rename(file.path(input_path,list_filename[-1]), file.path(output_path, list_filename[-1]))
  }
  
  ###   Concatenation for a Variable for OISST files (.nc)  ###
  
  input_path = output_path
  
  list_filename= list.files(path=input_path)
  
  output_file = paste0("esacci-v5.5-",domain,"-",newvarid,"-",temp,"-",start,"-",end,".nc")
  output = file.path(outputDir,output_file)
  nc_rcat_v2(filenames = file.path(input_path,list_filename),varid=newvarid,output)
  message("Succes !! Concatenation for the variable : ",varid)
  
  return(invisible(TRUE))
  
}




