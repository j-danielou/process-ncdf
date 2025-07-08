library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/CMEMS_SLA_processing.R")

path = "C:/Users/jdanielou/Desktop/L4 SLA COPERNICUS"
list_filename = list.files(path= path)
list_filename = list_filename[1:3] #187
varid = "sla"
newvarid ="sla"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "199301"
end ="202312"
tempdir=NULL

CMEMS_SLA_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "glorys-v1-southpacific-sss", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "Z:/reanalysis/regional/southpacific/glorys-v1/glorys-v1-southpacific-sss-monthly-199301-202312.nc")

xx = nc_open(filename = "Z:/reanalysis/regional/southpacific/glorys-v1/glorys-v1-southpacific-sss-monthly-199301-202312.nc")
print(xx)

xx_test = ncvar_get(xx, 'sss', verbose = FALSE)

lon = ncvar_get(xx, "longitude")
lat = ncvar_get(xx, "latitude")


x11()
image.plot(lon,lat,xx_test[,,1])

nc_close(xx)
