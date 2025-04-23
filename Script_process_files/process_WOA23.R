library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/WOA2023_processing.R")

path = "Y:/WOA/WOA23/3.3/data/0-data/temperature/A5B4/0.25/"
list_filename = list.files(path= path)
list_filename = list_filename[2:13]
varid = "t_an"
newvarid ="sst"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "2005"
end ="2014"
tempdir="C:/Users/jdanielou/Desktop/temp/"

WOA2023_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

xx = nc_open(filename = "C:/Users/jdanielou/Desktop/woa-23-southpacific-sst-monthly-2005-2014.nc")
print(xx)

xx_test = ncvar_get(xx, 'sst', verbose = FALSE)

lon = ncvar_get(xx, "lon")
lat = ncvar_get(xx, "lat")


x11()
image.plot(lon,lat,xx_test[,,1])
nc_close(xx)

