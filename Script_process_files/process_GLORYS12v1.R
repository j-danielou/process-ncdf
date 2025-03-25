library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/GLO12v1_processing.R")

path = "Z:/glorys_files/"
list_filename = list.files(path= path, pattern = "mercatorglorys")
list_filename = list_filename[1:227]
varid = "so"
newvarid ="sss"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "199301"
end ="201111"
tempdir=NULL

GLORYS12v1_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "glorys", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sst", output = "Z:/reanalysis/regional/southpacific/glorys-v1/glorys-v1-southpacific-sst-monthly-199301-202312.nc")

xx = nc_open(filename = "Z:/glorys_files/mercatorglorys12v1_gl12_mean_200106.nc")
print(xx)

xx_test = ncvar_get(xx, 'sst', verbose = FALSE)

lon = ncvar_get(xx, "longitude")
lat = ncvar_get(xx, "latitude")


x11()
image.plot(lon,lat,xx_test[,,1])

nc_close(xx)

