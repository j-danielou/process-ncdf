library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/WOA2023_processing.R")

path = "Y:/WOA/WOA23/3.3/data/0-data/salinity/B5C2/0.25/"
list_filename = list.files(path= path)
list_filename = list_filename[2:13]
varid = "s_an"
newvarid ="sss"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "2015"
end ="2022"
tempdir="C:/Users/jdanielou/Desktop/temp/"

WOA2023_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "woa-23-southpacific-sss", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "Z:/reanalysis/regional/southpacific/glorys-v1/glorys-v1-southpacific-sss-monthly-199301-202312.nc")

xx = nc_open(filename = "C:/Users/jdanielou/Desktop/woa-23-southpacific-sss-monthly-2015-2022.nc")
print(xx)

xx_test = ncvar_get(xx, 'sss', verbose = FALSE)

lon = ncvar_get(xx, "lon")
lat = ncvar_get(xx, "lat")


x11()
image.plot(lon,lat,xx_test[,,1])

