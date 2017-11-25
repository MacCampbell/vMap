library(ggplot2)
library(maps)
library(mapdata)
library(ggrepel)
library(legendMap)


world<-map_data("world")
vietnam<-subset(world, region %in% c("Vietnam","Cambodia", "Laos", "China", "Thailand"))

xmin<-102
xmax<-110
ymin<-8
ymax<-25
