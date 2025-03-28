library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/HYCOM_processing.R")

path = "Y:/HYCOM/datasets/GLBv0.08/expt_53.X/meanstd/netcdf/"
pattern = "GLBv0\\.08_53X_archMN\\.\\d{4}_\\d{2}_ts3z\\.nc$"
list_filename = list.files(path= path, pattern = pattern)
list_filename = list_filename[1:132]
varid = "salinity"
newvarid ="sss"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "194401"
end ="200412"
tempdir=NULL

HYCOM3.1_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "gofs", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "Z:/reanalysis/regional/southpacific/hycom-3.1/gofs-3.1-southpacific-sss-monthly-199401-201512.nc")

xx = nc_open("C:/Users/jdanielou/Desktop/gofs-3.1-southpacific-sst-monthly-200501-201512.nc")
print(xx)

xx_test = ncvar_get(xx, 'sst', verbose = FALSE)

lon = ncvar_get(xx, "lon")
lat = ncvar_get(xx, "lat")

x11()
image.plot(lon,lat,xx_test[,,1])

nc_close(xx)
         
         
         