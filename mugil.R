library(ggplot2)
library(maps)
library(mapdata)
library(ggrepel)
library(dplyr)

world<-map_data("world")

mugil<-tbl_df(read.csv("./mugil.csv", sep=";",header=FALSE))
mugil<-mugil%>% rename(Species = V1, Location = V2, Latitude = V3, Longitude = V4)

xmin<-min(mugil$Longitude)-1
xmax<-max(mugil$Longitude)+1
ymin<-min(mugil$Latitude)-1
ymax<-max(mugil$Latitude)+1

mugilMap<- ggplot() + 
  geom_polygon(data = world, aes(x=long, y = lat, group = group), fill = "grey", color = "black") + 
  geom_point(data=mugil, aes(x=Longitude, y=Latitude, colour=Species), cex=0.75) +
  xlab("Longitude")+
  ylab("Latitude")+
  theme_classic()+
  theme(axis.text=element_text(size=10, family="Times"),
        axis.title=element_text(size=12, face="bold", family="Times")) +
  coord_fixed(1)+
  coord_fixed(xlim = c(xmin, xmax), ylim = c(ymin, ymax)) +
  facet_grid(Species ~ .)  

mugilMap

### mugil df contains multiple entries for each location, filter 
#      Species         Location Latitude Longitude
#<fctr>           <fctr>    <dbl>     <dbl>
#1 Mugil sp. C   Ba Bo, Can Tho 10.01946  105.7817
#2 Mugil sp. C   Ba Bo, Can Tho 10.01946  105.7817

#this may do the trick
reduced<-mugil %>% group_by(.dots=c("Species","Latitude", "Longitude")) %>% 
  mutate(Count = n()) %>% distinct()

#Then we may want to make our map for each species again
pdf("./examples/mugilMapSize.pdf")
ggplot() + 
  geom_polygon(data = world, aes(x=long, y = lat, group = group), fill = "grey", color = "black") + 
  geom_point(data=reduced, aes(x=Longitude, y=Latitude, fill=Species, size=Count), shape=21, colour="black", alpha=0.5) +
  xlab("Longitude")+
  ylab("Latitude")+
  theme_classic()+
  theme(axis.text=element_text(size=10, family="Times"),
        axis.title=element_text(size=12, face="bold", family="Times")) +
  coord_fixed(1)+
  coord_fixed(xlim = c(xmin, xmax), ylim = c(ymin, ymax)) +
  facet_grid(Species ~ .)  
dev.off()

### What about plotting by each species by its own boundaries?
## Hmmm... This works ok.

species<-levels(reduced$Species)

colorV<-c("red","green","blue")
i <- 0

for (sp in species) {
i <- i+1
print(paste(sp))

short <- filter(reduced, Species == sp)
xmn<-min(short$Longitude)-1
xmx<-max(short$Longitude)+1
ymn<-min(short$Latitude)-1
ymx<-max(short$Latitude)+1


reducedMap<-ggplot() + 
  geom_polygon(data = world, aes(x=long, y = lat, group = group), fill = "grey", color = "black") + 
  geom_point(data=short, aes(x=Longitude, y=Latitude, size=Count), fill=colorV[i], 
             shape=21, colour="black", alpha=0.5) +
  xlab("Longitude")+
  ylab("Latitude")+
  theme_classic()+
  theme(axis.text=element_text(size=10, family="Times"),
        axis.title=element_text(size=12, face="bold", family="Times")) +
  coord_fixed(1.3)+
  coord_fixed(xlim = c(xmn, xmx), ylim = c(ymn, ymx))+
  labs(title = paste(sp))

pdf(file=paste("./examples/",sp,".pdf", sep=""))
print(reducedMap)
dev.off()

}

