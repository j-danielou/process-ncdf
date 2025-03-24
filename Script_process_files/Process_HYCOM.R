library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/HYCOM_processing.R")

path = "Y:/HYCOM/datasets/GLBv0.08/expt_53.X/meanstd/netcdf/"
pattern = "GLBv0\\.08_53X_archMN\\.\\d{4}_\\d{2}_ts3z\\.nc$"
list_filename = list.files(path= path, pattern = pattern)
#list_filename = list_filename[1:12]
varid = "water_temp"
newvarid ="sst"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "199401"
end ="201512"
tempdir=NULL

HYCOM3.1_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)



xx = nc_open("Y:/BRAN/BRAN2020/month/ocean_temp_mth_2015_04.nc")
print(xx)

xx_test = ncvar_get(xx, 'temp', verbose = TRUE)

lon = ncvar_get(xx, "xt_ocean")
lat = ncvar_get(xx, "yt_ocean")

x11()
image.plot(lon,lat,xx_test[,,1])

nc_close(xx)
         
         
         