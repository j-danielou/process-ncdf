library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/ARMOR3D_processing.R")

path = "C:/Users/jdanielou/Desktop/L4 TS/"
list_filename = list.files(path= path)
#list_filename = list_filename[1:3]
varid = "to"
newvarid ="to"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "199301"
end ="202212"
tempdir=NULL

ARMOR_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "glorys-v1-southpacific-sss", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "Z:/reanalysis/regional/southpacific/glorys-v1/glorys-v1-southpacific-sss-monthly-199301-202312.nc")

xx = nc_open(filename = "C:/Users/jdanielou/Desktop/armor-3d-southpacific-to-monthly-199301-202212.nc")
print(xx)

xx_test = ncvar_get(xx, 'to', verbose = FALSE)

lon = ncvar_get(xx, "longitude")
lat = ncvar_get(xx, "latitude")


x11()
image.plot(lon,lat,xx_test[,,1,3])

nc_close(xx)

