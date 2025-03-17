library(nctools)
source("C:/Users/Pret/Desktop/Rstudio/Processing_Scripts/ncdf_variable_extraction.R")
source("C:/Users/Pret/Desktop/Rstudio/Processing_Scripts/ncdf_spatiale_extraction.R")


#####################################
###  Process GLORYS (GLORYS12v1)  ### 
#####################################

###  Variable Process  ###

path="Y:/GLOBAL_MULTIYEAR_PHY_001_030/cmems_mod_glo_phy_my_0.083_P1M-m/2016/"
list_filename=list.files(path = path)
#list_filename=list_filename[1:2]
varid= "thetao"
outputDir= "Y:/GLOBAL_MULTIYEAR_PHY_001_030/cmems_mod_glo_phy_my_0.083_P1M-m/processed_files/2023/"

GLORYS_extract_var(path,list_filename,varid,outputDir)


###  Spatiale Process ###

newvarid ="sst"
path=outputDir
list_filename = list.files(path = path, pattern = "GLO12v1_sst_mean_2016_") 
outputDir = "Y:/GLOBAL_MULTIYEAR_PHY_001_030/cmems_mod_glo_phy_my_0.083_P1M-m/processed_files/2023/Final/"


GLORYS_spatial_sub(path,list_filename,varid,newvarid,outputDir)




################################################
###  Process Bluelink ReANalysis (BRAN2020)  ### 
################################################

###  Variable Process  ###

path="Y:/BRAN/BRAN2020/month/"
pattern="ocean_temp_mth_"
list_filename=list.files(path = path, pattern = pattern)
#list_filename=list_filename[1:2]
varid= "temp"
outputDir= "Y:/BRAN/BRAN2020/processed_files/"

BRAN_extract_var(path,list_filename,varid,outputDir)


###  Spatiale Process  ###

newvarid ="sst"
path=outputDir
list_filename = list.files(path = path, pattern = "BRAN2020_sst_mean") 
outputDir = "Y:/BRAN/BRAN2020/processed_files/Final/"

BRAN_spatial_sub(path,list_filename,varid,newvarid,outputDir)




##################################
###  Process HYCOM (GOFS 3.1)  ### 
##################################

###  Variable Process  ###

path="Y:/HYCOM/datasets/GLBv0.08/expt_53.X/meanstd/netcdf/"
pattern <- "GLBv0\\.08_53X_archMN\\.\\d{4}_\\d{2}_ts3z\\.nc$"
list_filename=list.files(path = path, pattern = pattern)
list_filename=list_filename[1:2]
varid= "water_temp"
outputDir= "Y:/HYCOM/datasets/GLBv0.08/expt_53.X/meanstd/processed_files/"

HYCOM_extract_var(path,list_filename,varid,outputDir)


###  Spatiale Process  ###

newvarid ="sst"
path=outputDir
list_filename = list.files(path = path, pattern = "HYCOM_sst_mean") 
outputDir = "Y:/HYCOM/datasets/GLBv0.08/expt_53.X/meanstd/processed_files/Final/"

HYCOM_spatial_sub(path,list_filename,varid,newvarid,outputDir)








