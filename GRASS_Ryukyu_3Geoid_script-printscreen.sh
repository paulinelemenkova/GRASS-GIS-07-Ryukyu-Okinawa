#!/bin/sh
# cut out an image subset from initial image via GDAL using boundary coordinates WNES:
gdal_translate -projwin 120.0000 33.0000 134.0000 20.0000 geoid.egm96.grd rt_geoid.grd

# projecting raster GeoTIFF file to UTM Zone 52 via GDAL:
gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_geoid.grd rt_geoid_UTM52.tif
gdalinfo rt_geoid_UTM52.tif

# importing raster NetCDF file to GRASS GIS via GDAL:
r.in.gdal rt_geoid_UTM52.tif out=rt_geoid_UTM52 title="Geoid grid: Okinawa"
r.timestamp map=rt_geoid_UTM52 date='18 May 2020'
r.info rt_geoid_UTM52
g.list rast

# visualization:
d.mon wx0
g.region raster=rt_geoid_UTM52 res=0.01 nsres=0.01 ewres=0.01 -p -g
r.colors rt_geoid_UTM52 col=rainbow
d.rast rt_geoid_UTM52

# creating isolines usig GDAL:
gdal_contour -a elev rt_geoid_UTM52.tif contour.shp -i 1.0
v.in.ogr contour.shp out=rt_geoid_contour --overwrite
d.vect rt_geoid_contour color='100:93:134' width=0

# grid & border box:
v.in.region output=rt_relief_UTM52_bbox
d.vect rt_relief_UTM52_bbox color=red width=4 fill_color="none"
d.grid size=3 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red

# add legend, title and annotations:
d.legend raster=rt_geoid_UTM52 range=5,41 title=Geoid,m title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=2 border_color=gray thin=8
d.title map=rt_grav_UTM52 | d.text text="Geoid" font="Hiragino Sans GB" color=blue size=0.6 linespacing=0.3
d.text text="Okinawa" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Trough" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="&" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Ryukyu" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Trench" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="Arc" color=black size=1.0 font="LucidaGrande" linespacing=0.7
d.text text="System" color=black size=1.0 font="LucidaGrande" linespacing=0.7

d.font -l
