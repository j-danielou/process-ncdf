library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/OISSTv2r1_procesing.R")

path = "C:/Users/jdanielou/Desktop/OISS"
list_filename = list.files(path= path, pattern = "\\.nc")
list_filename = list_filename[1:3]
varid = "sss"
newvarid ="sss"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "201109"
end ="202412"
tempdir=NULL

OISSTv2r1_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "oisst", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "Z:/reanalysis/regional/southpacific/oisst-v2.1/")


data = nc_open(filename = "C:/Users/jdanielou/Desktop/OISS/OISSS_L4_multimission_global_monthly_v2.0_2011-09.nc")
print(data)

xx_test = ncvar_get(data, 'sss', verbose = FALSE)

lon = ncvar_get(data, "longitude")
lat = ncvar_get(data, "latitude")

x11()
image.plot(lon,lat,xx_test[,])

nc_close(data)
