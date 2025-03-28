library(ncdf4)
library(nctools)
library(fields)
source("C:/Users/jdanielou/Desktop/process-ncdf/Script_process_files/BRAN2020_processing.R")

path = "Y:/BRAN/BRAN2020/month/"
list_filename = list.files(path= path, pattern = "ocean_salt_mth")
list_filename = list_filename[187:372]
varid = "salt"
newvarid ="sss"
domain = "southpacific"
temp = "monthly"
outputDir = "C:/Users/jdanielou/Desktop"
meridian = "left"
start = "200807"
end ="202312"
tempdir=NULL

BRAN2020_process(path, list_filename, varid, newvarid, domain, temp, outputDir, meridian, start, end, tempdir=NULL)

file_list = list.files(path = "C:/Users/jdanielou/Desktop/", pattern = "bran-2020-southpacific-sss", full.names = TRUE)
nc_rcat_v2(file_list, varid ="sss", output = "Z:/reanalysis/regional/southpacific/bran-2020/bran-2020-southpacific-sss-monthly-199301-202312.nc")

xx = nc_open("Z:/reanalysis/regional/southpacific/bran-2020/bran-2020-southpacific-sss-monthly-199301-202312.nc")
print(xx)

xx_test = ncvar_get(xx, 'sss', verbose = FALSE)

lon = ncvar_get(xx, "xt_ocean")
lat = ncvar_get(xx, "yt_ocean")

x11()
image.plot(lon,lat,xx_test[,,1])

nc_close(xx)
