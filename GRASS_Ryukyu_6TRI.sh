#!/bin/sh
# Computing Topographic Ruggedness Index (TRI) by GDAL, gdaldem
gdalinfo rt_relief.nc
 WGS84 warped to a UTM projection, Zone 56:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc
gdalinfo rt_relief_UTM52.nc

# GDAL, gdaldem: TRI
gdaldem TRI -compute_edges -of GTiff rt_relief_UTM52.nc rt_TRI.tif
gdalinfo rt_TRI.tif
r.in.gdal rt_TRI.tif out=rt_TRI title="Topographic Ruggedness Index (TRI)"
r.timestamp map=rt_TRI date='18 May 2020'
r.info rt_TRI
g.list rast

# visualization
d.mon wx0
g.region raster=rt_TRI -p -g
r.colors rt_TRI col=elevation -n
r.colors --help
d.rast rt_TRI

# legend
d.legend raster=rt_TRI range=0,728.875 title=TRI title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=50 border_color=gray thin=8

# isolines
d.vect TopoRT_UTM52 color='brown' width=0

# grid & border box
#v.in.region output=rt_relief_UTM52_bbox
d.grid size=3 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red
d.vect rt_relief_UTM52_bbox color=red width=4 fill_color="none"

d.title map=rt_grav_UTM52 | d.text text="TRI" font="Hiragino Sans GB" color=blue size=0.6 linespacing=0.3
d.text text="Topographic" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Ruggedness" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Index" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="(TRI)" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Okinawa" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="region" color=black size=1.0 font="LucidaGrande" linespacing=0.7

d.font -l
