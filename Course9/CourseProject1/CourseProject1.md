# Course Project 1
Erik Johnson  
12/7/2017  



## Synopsis
In this project, we create a simple map using the leaflet package. We show the location of ComicCon 2018.

## Simple Leaflets Map


```r
library(leaflet)

# The lat and lng for the Anaheim Convention Center
# where Wondercon 2018 will be held
wonderconLat <- 33.8014049
wonderconLng <- -117.920892

# Create the map
my_map <-
    leaflet() %>%
    addTiles() %>%
    addMarkers(lat=wonderconLat, lng=wonderconLng, 
               popup="<a href='https://www.comic-con.org/wca'>WonderCon 2018</a>")

my_map
```

<!--html_preserve--><div id="htmlwidget-745aef3497203e10941d" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-745aef3497203e10941d">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[33.8014049,-117.920892,null,null,null,{"clickable":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},"<a href='https://www.comic-con.org/wca'>WonderCon 2018<\/a>",null,null,null,null,null,null]}],"limits":{"lat":[33.8014049,33.8014049],"lng":[-117.920892,-117.920892]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
