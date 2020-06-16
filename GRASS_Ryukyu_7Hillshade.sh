#!/bin/sh
# Computing Topographic Ruggedness Index (TRI) by GDAL, gdaldem
gdalinfo rt_relief.nc
 WGS84 warped to a UTM projection, Zone 56:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc
gdalinfo rt_relief_UTM52.nc

# GDAL, gdaldem: hillshade
gdaldem hillshade -of GTiff rt_relief_UTM52.nc rt_hillshade.tif -az 315 -alt 45 -alg ZevenbergenThorne -b 1 -z 1 -combined

gdalinfo rt_hillshade.tif
r.in.gdal rt_hillshade.tif out=rt_hillshade title="Hillshade: Okinawa"
r.timestamp map=rt_hillshade date='19 May 2020'
r.info rt_hillshade
g.list rast

# visualization
d.mon wx0
g.region raster=rt_hillshade -p -g
r.colors rt_hillshade col=grey.log -n
r.colors --help
d.rast rt_hillshade

# legend
d.legend raster=rt_hillshade range=1,255 title=Hillshade title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=30 border_color=gray thin=20

# isolines
r.contour rt_relief_UTM52 out=TopoRT_UTM52_2000 step=2000 --overwrite
d.vect TopoRT_UTM52_2000 color='red' width=0

# grid & border box
#v.in.region output=rt_relief_UTM52_bbox
d.grid size=3 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red
d.vect rt_relief_UTM52_bbox color=red width=4 fill_color="none"

d.title map=rt_grav_UTM52 | d.text text="Hillshade" font="Hiragino Sans GB" color=blue size=0.6 linespacing=0.3
d.text text="Shaded" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Terrain" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Relief" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Azimuth 315" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Altitude 45" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Okinawa" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Trough" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="region" color=black size=1.0 font="LucidaGrande" linespacing=0.7

d.font -l
