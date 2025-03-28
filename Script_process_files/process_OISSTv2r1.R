library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/OISSTv2r1_procesing.R")

path = "Y:/OISST/v2.1/"
list_filename = list.files(path= path, pattern = "\\.nc4")
list_filename = list_filename[1:244]
varid = "sst"
newvarid ="sst"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "198109"
end ="200112"
tempdir=NULL

OISSTv2r1_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "oisst", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "Z:/reanalysis/regional/southpacific/oisst-v2.1/")


data = nc_open(filename = "Y:/OISST/v2.1/oisst-avhrr-v02r01.198211.nc4")
print(data)

xx_test = ncvar_get(data, 'sst', verbose = FALSE)

lon = ncvar_get(data, "lon")
lat = ncvar_get(data, "lat")

x11()
image.plot(lon,lat,xx_test)

nc_close(data)
