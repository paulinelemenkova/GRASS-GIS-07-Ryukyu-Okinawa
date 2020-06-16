#!/bin/sh
# raster NetCDF in WGS84 warped to UTM proj Zone 56 by GDAL:

gdalinfo rt_relief.nc
# WGS84 warped to a UTM projection, Zone 56:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc
gdalinfo rt_relief_UTM52.nc

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal rt_relief_UTM52.nc out=rt_relief_UTM52 title="Ryukyu Trench Topography: GEBCO" --overwrite
r.timestamp map=rt_relief_UTM52 date='18 May 2020'
r.info rt_relief_UTM52

# GRASS GIS
# visualize raster
g.list rast
g.region raster=rt_relief_UTM52 -p
d.mon wx0
r.colors --help
r.colors rt_relief_UTM52 col=srtm_plus
d.rast rt_relief_UTM52

# isolines
r.contour rt_relief_UTM52 out=TopoRT_UTM52 step=1000 --overwrite
d.vect TopoRT_UTM52 color='100:93:134' width=0

# grid
d.grid size=3 color=grey border_color=yellow width=0.1 fontsize=8 text_color=white

# border box
v.in.region output=rt_relief_UTM52_bbox
g.list vect
v.info map=rt_relief_UTM52_bbox
d.vect rt_relief_UTM52_bbox color=red width=3 fill_color="none"

# legend
d.legend raster=rt_relief_UTM52 range=-7439,3577 title=Topography,m title_fontsize=8 font=Arial fontsize=7 -t -b bgcolor=white label_step=1000 border_color=gray thin=8
# texts
d.text text="Topography" color='0:0:51' size=2.0 font=Arial
d.text text="GEBCO" color='0:0:51' size=2.0 font=Arial
d.text text="Ryukyu Trench" color='0:0:51' size=2.0 font=Arial
d.text text="East China Sea" color=yellow size=2.5 font="Verdana Bold"
d.text text="Philippine Sea" color=yellow size=2.5 font="Verdana Bold"
d.text text="R  y  u  k  y  u" color=yellow size=2.5 font="Trebuchet MS" rotation=36
d.text text="T  r  e  n  c  h" color=yellow size=2.5 font="Trebuchet MS" rotation=40

d.text text="R  y  u  k  y  u" color=yellow size=2.5 font="Trebuchet MS" rotation=37
d.text text="A  r  c" color=yellow size=2.5 font="Trebuchet MS" rotation=43

d.text text="Taiwan Island" color=black size=1.5 font="Trebuchet MS"
d.text text="C h i n a" color=black size=1.5 font="Trebuchet MS"
d.text text="Kyushu Island" color=black size=1.5 font="Trebuchet MS"
d.text text="O k i n a w a" color=yellow size=2.5 font="Trebuchet MS" rotation=38
d.text text="T r o u g h" color=yellow size=2.5 font="Trebuchet MS" rotation=47


r.in.gdal -e grassgis_logo_alpha.png out=grassgis_logo -o
d.rast grassgis_logo
d.rgb b=grassgis_logo.blue g=grassgis_logo.green r=grassgis_logo.red
r.composite blue=grassgis_logo.blue green=grassgis_logo.green red=grassgis_logo.red output=grassgis_logo


# title
d.title map=jt_relief_EAC | d.text text="Topography Japan Trench" color="red" size=5
# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
