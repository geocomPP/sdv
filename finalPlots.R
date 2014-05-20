# creates high resolution pdf plots of all the figures
# run after s2, s3 and s4 in this repo have loaded the required objects into the workspace

# ```{r A Basic Map of the World, results='hide', fig.width = 8, fig.height= 5, warning=FALSE, message=FALSE}
pdf(file="figure/A_Basic_Map_of_the_World.pdf")
library(rgdal) # load the package (needs to be installed)
wrld <- readOGR("data/", "world")
plot(wrld)
dev.off()

# ```{r The Robinson Projection, fig.width = 8, fig.height= 5, message=FALSE}
pdf(file="figure/The_Robinson_Projection.pdf")
wrld.rob <- spTransform(wrld, CRS("+proj=robin")) #`+proj=robin` refers to the Robinson projection
plot(wrld.rob)
dev.off()

# ```{r World Population Map, fig.width = 8, fig.height= 5}
map <- ggplot(wrld.pop.f, aes(long, lat, group = group, fill = pop_est/1000000)) + geom_polygon() +
  coord_equal() + labs(x = "Longitude", y = "Latitude", fill = "World Population") +
  ggtitle("World Population") +
  scale_fill_continuous(name="Population\n(millions)")
map
ggsave("figure/World_Population_Map.pdf")

# ```{r A Map of the Continents Using Default Colours, fig.width = 8, fig.height= 5}
# Produce a map of continents
map.cont <- ggplot(wrld.pop.f, aes(long, lat, group = group, fill = continent)) + 
  geom_polygon() + 
  coord_equal() + 
  labs(x = "Longitude", y = "Latitude", fill = "World Continents") + 
  ggtitle("World Continents")
# To see the default colours
map.cont
ggsave("figure/A_Map_of_the_Continents_Using_Default_Colours.pdf")

# ```{r The Impact of Line Width}
pdf(file="figure/The_Impact_of_Line_Width.pdf", width=14, height = 10)
map3 <- ggplot(wrld.pop.f, aes(long, lat, group = group)) + coord_equal() +
  theme(panel.background = element_rect(fill = "light blue"))
yellow <- map3 + geom_polygon(fill = "dark green", colour = "yellow") 
black <- map3 + geom_polygon(fill = "dark green", colour = "black") 
thin <- map3 + geom_polygon(fill = "dark green", colour = "black", lwd = 0.1) 
thick <- map3 + geom_polygon(fill = "dark green", colour = "black", lwd = 1.5)
grid.arrange(yellow, black, thick, thin, ncol = 2)
dev.off()

# ```{r Formatting the Legend}
#Position
map + theme(legend.position = "top")
ggsave("figure/Formatting_the_Legend.pdf")

# ```{r World Map}
wrld.f <- fortify(wrld, region = "sov_a3")
base <- ggplot(wrld.f, aes(x = long, y = lat))
wrld <- c(geom_polygon(aes(group = group), size = 0.1, colour = "black", fill = "#D6BF86",
                       data = wrld.f, alpha = 1))
base + wrld + coord_fixed()
ggsave("figure/World_Map.pdf")

# ```{r World Shipping}
base + route + wrld + theme(panel.background = element_rect(fill='#BAC4B9',colour='black')) + 
  annotation_raster(btitle, xmin = 30, xmax = 140, ymin = 51, ymax = 87) + 
  annotation_raster(compass, xmin = 65, xmax = 105, ymin = 25, ymax = 65) + coord_equal() + quiet
ggsave("/tmp/figure/World_Shipping.pdf")

# ```{r World Shipping with raster background}
earth <- readPNG("figure/earth_raster.png")
base + annotation_raster(earth, xmin = -180, xmax = 180, ymin = -90, ymax = 90) + 
  route + theme(panel.background = element_rect(fill='#BAC4B9',colour='black')) + 
  annotation_raster(btitle, xmin = 30, xmax = 140, ymin = 51, ymax = 87) + 
  annotation_raster(compass, xmin = 65, xmax = 105, ymin = 25, ymax = 65) + 
  coord_equal() + quiet
ggsave("/tmp/figure/World_Shipping_with_raster_background.pdf")




