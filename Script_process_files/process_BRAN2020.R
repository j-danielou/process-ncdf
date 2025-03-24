library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/BRAN2020_processing.R")

path = "Y:/BRAN/BRAN2020/month/"
list_filename = list.files(path= path, pattern = "ocean_temp_mth")
#list_filename = list_filename[1:12]
varid = "temp"
newvarid ="sst"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "199301"
end ="202312"
tempdir=NULL

BRAN2020_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)



xx = nc_open("Y:/BRAN/BRAN2020/month/ocean_temp_mth_2015_04.nc")
print(xx)

xx_test = ncvar_get(xx, 'temp', verbose = TRUE)

lon = ncvar_get(xx, "xt_ocean")
lat = ncvar_get(xx, "yt_ocean")

x11()
image.plot(lon,lat,xx_test[,,1])

nc_close(xx)
