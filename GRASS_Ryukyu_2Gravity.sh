#!/bin/sh
# cut out an image subset from initial big image using boundary 'clockwise' coordinates W N E S (xMin, yMax, xMax, yMin). Here: cut off Ryukyu Trench gravity
# Step-4. Extract a subset for the Ryukyu trench area via GMT
img2grd grav_27.1.img -R120/134/20/33 -Grt_grav.grd -T1 -I1 -E -S0.1 -V

# projecting raster GeoTIFF file to Equal Area Cylindrical projection by GDAL:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_grav.grd rt_grav_UTM52.tif

# importing raster NetCDF file to GRASS GIS via GDAL:
r.in.gdal rt_grav_UTM52.tif out=rt_grav_UTM52 title="Gravity grid: Okinawa"

r.timestamp map=rt_grav_UTM52 date='18 May 2020'
r.info rt_grav_UTM52
g.list rast

# display
d.mon wx0
r.colors rt_grav_UTM52 col=roygbiv
g.region raster=rt_grav_UTM52 -p -g
d.rast rt_grav_UTM52

# isolines
r.contour rt_grav_UTM52 out=GravRT_UTM52 step=30 --overwrite
d.vect GravRT_UTM52 color='100:93:134' width=0

# grid & border box
#v.in.region output=rt_relief_UTM52_bbox
d.vect rt_relief_UTM52_bbox color=red width=3 fill_color="none"
d.grid size=3 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red

#
d.legend raster=rt_grav_UTM52 range=-238.2651,330.1856 title=Gravity,mGal title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=30 border_color=gray thin=8
d.title map=rt_grav_UTM52 | d.text text="Gravity" font="Hiragino Sans GB" color=blue size=0.7 linespacing=0.3
d.text text="Okinawa" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Trough" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="&" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Ryukyu" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Trench" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Arc" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="System" color=black size=1.0 font="LucidaGrande" linespacing=0.7

d.font -l
