library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/CMEMS_SSS_processing.R")

path = "C:/Users/jdanielou/Desktop/SSS COPERNICUS"
list_filename = list.files(path= path)
list_filename = list_filename[188:348] #187 2008-07
varid = "sos"
newvarid ="sss"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "200808"
end ="202112"
tempdir=NULL

CMEMS_SSS_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "cmems-sss", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "C:/Users/jdanielou/Desktop/reanalysis/regional/southpacific/cmems/cmems-l4-southpacific-sss-monthly-199301-202112.nc")

xx = nc_open(filename = "C:/Users/jdanielou/Desktop/reanalysis/regional/southpacific/cmems/cmems-l4-southpacific-sss-monthly-199301-202112.nc")
print(xx)

xx_test = ncvar_get(xx, 'sss', verbose = FALSE)

lon = ncvar_get(xx, "lon")
lat = ncvar_get(xx, "lat")


x11()
image.plot(lon,lat,xx_test[,,192])

nc_close(xx)

