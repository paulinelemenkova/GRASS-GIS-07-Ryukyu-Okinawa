#!/bin/sh
# GDAL/GRASS script for topographical analysis by gdaldem

# cut out an image subset from by boundary coordinates WESN:
gdalinfo rt_relief.nc
# WGS84 warped to a UTM projection, Zone 56:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc
gdalinfo rt_relief_UTM52.nc

# GDAL, gdaldem for roughness
gdaldem roughness rt_relief_UTM52.nc rt_roughness.tif
gdalinfo rt_roughness.tif
r.in.gdal rt_roughness.tif out=rt_roughness title="Surface Roughness of Topography"
r.info rt_roughness

# GDAL, gdaldem for TPI
gdaldem TPI -compute_edges -of GTiff rt_relief_UTM52.nc rt_TPI.tif
gdalinfo rt_TPI.tif
r.in.gdal rt_TPI.tif out=rt_TPI title="Topographic Position Index (TPI)"
r.timestamp map=rt_TPI date='18 May 2020'
r.info rt_TPI

# GDAL, gdaldem for TRI
gdaldem TRI -compute_edges -of GTiff rt_relief_UTM52.nc rt_TRI.tif
gdalinfo rt_TRI.tif
r.in.gdal rt_TRI.tif out=rt_TRI title="Topographic Ruggedness Index (TRI)"
r.timestamp map=rt_TRI date='18 May 2020'
r.info rt_TRI

# GDAL, gdaldem for hillshade
gdaldem hillshade -of GTiff rt_relief_UTM52.nc rt_hillshade.tif -az 315 -alt 45 -alg ZevenbergenThorne -b 1 -z 1 -combined
gdalinfo rt_hillshade.tif
r.in.gdal rt_hillshade.tif out=rt_hillshade title="Hillshade: Okinawa"
r.timestamp map=rt_hillshade date='19 May 2020'
r.info rt_hillshade

# GDAL, gdaldem for aspect
gdaldem aspect -of GTiff rt_relief_UTM52.nc rt_aspect.tif -trigonometric -zero_for_flat -alg ZevenbergenThorne
gdalinfo rt_aspect.tif
r.in.gdal rt_aspect.tif out=rt_aspect title="Aspect: Okinawa Trough" --overwrite
r.timestamp map=rt_aspect date='19 May 2020'
r.info rt_aspect

g.list rast
