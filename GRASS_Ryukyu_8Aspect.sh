#!/bin/sh
# Computing Topographic Ruggedness Index (TRI) by GDAL, gdaldem
gdalinfo rt_relief.nc
 WGS84 warped to a UTM projection, Zone 56:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc
gdalinfo rt_relief_UTM52.nc

# GDAL, gdaldem: aspect
gdaldem aspect -of GTiff rt_relief_UTM52.nc rt_aspect.tif -trigonometric -zero_for_flat -alg ZevenbergenThorne
gdalinfo rt_aspect.tif
r.in.gdal rt_aspect.tif out=rt_aspect title="Aspect: Okinawa Trough" --overwrite
r.timestamp map=rt_aspect date='19 May 2020'
r.info rt_aspect
g.list rast

# visualization
d.mon wx0
g.region raster=rt_aspect -p -g
r.colors --help
r.colors rt_aspect col=haxby
d.rast rt_aspect

# legend
d.legend raster=rt_aspect range=1,255 title=Aspect title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=30 border_color=gray thin=15

# isolines
#r.contour rt_relief_UTM52 out=TopoRT_UTM52_2000 step=2000 --overwrite
#d.vect TopoRT_UTM52_2000 color='red' width=0
r.contour rt_aspect out=AspectRT step=300 --overwrite
d.vect AspectRT color='red' width=0

# grid & border box
#v.in.region output=rt_relief_UTM52_bbox
d.grid size=3 color=white border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=blue
d.vect rt_relief_UTM52_bbox color=blue width=4 fill_color="none"

d.title map=rt_grav_UTM52 | d.text text="Aspect" font="Hiragino Sans GB" color=blue size=0.6 linespacing=0.3
d.text text="Terrain" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Directions" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Physical" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Slope" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Orientation" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Okinawa" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Trough" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="region" color=black size=1.0 font="LucidaGrande" linespacing=0.7

d.font -l
