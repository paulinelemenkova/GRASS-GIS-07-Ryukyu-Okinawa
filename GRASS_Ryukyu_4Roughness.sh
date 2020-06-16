#!/bin/sh
# cut out an image subset from initial big image using boundary 'clockwise' coordinates W N E S (xMin, yMax, xMax, yMin). Here: cut off Ryukyu Trench geoid
gdalinfo rt_relief.nc
 WGS84 warped to a UTM projection, Zone 56:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc
gdalinfo rt_relief_UTM52.nc

# GDAL, gdaldem for roughness
gdaldem roughness rt_relief_UTM52.nc rt_roughness.tif
gdalinfo rt_roughness.tif
r.in.gdal rt_roughness.tif out=rt_roughness title="Surface Roughness of Topography"
r.info rt_roughness
g.list rast

# visualization
d.mon wx0
g.region raster=rt_roughness res=0.01 nsres=0.01 ewres=0.01 -p -g
r.colors rt_roughness col=gdd -n
r.colors --help
d.rast rt_roughness

# legend
d.legend raster=rt_roughness range=0,2178 title=Roughness title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=200 border_color=gray thin=8

# isolines
r.contour rt_relief_UTM52 out=TopoRT_UTM52 step=1000 --overwrite
d.vect TopoRT_UTM52 color='100:93:134' width=0

# grid & border box
#v.in.region output=rt_relief_UTM52_bbox
d.vect rt_relief_UTM52_bbox color=red width=4 fill_color="none"
d.grid size=3 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red


d.title map=rt_grav_UTM52 | d.text text="Roughness" font="Hiragino Sans GB" color=blue size=0.6 linespacing=0.3
d.text text="Surface" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Roughness" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="of" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Topography" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="from" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="smooth" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="to" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="rough" color=black size=1.0 font="LucidaGrande" linespacing=0.7

d.font -l
