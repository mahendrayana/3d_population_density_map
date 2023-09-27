library(sf)
library(tidyverse)
library(stars)
library(rayshader)
library(colorspace)

#load shp
districts<-st_read("shpkab")
# Filter the ROI shapefile and necesarry features
ids_to_keep <- c("ID714")
districts_subset <- subset(districts, ADM2_PCODE %in% ids_to_keep)
shp_subset <- districts_subset %>% select(ADM1_EN, ADM1_PCODE, geometry)

#Load the data
data <- st_read("kontur_population_ID_20220630.gpkg")

#Match the crs and intersect
shp_final <- shp_subset |> 
  st_transform(crs = st_crs(data))

pop <- st_intersection(data, shp_final)


# define aspect ratio based on bounding box
bb <- st_bbox(pop)

bottom_left <- st_point(c(bb[["xmin"]], bb[["ymin"]])) |> 
  st_sfc(crs = st_crs(data))

bottom_right <- st_point(c(bb[["xmax"]], bb[["ymin"]])) |> 
  st_sfc(crs = st_crs(data))

width <- st_distance(bottom_left, bottom_right)

top_left <- st_point(c(bb[["xmin"]], bb[["ymax"]])) |> 
  st_sfc(crs = st_crs(data))

height <- st_distance(bottom_left, top_left)

# handle conditions of width or height being the longer side

if (width > height) {
  w_ratio <- 1
  h_ratio <- height / width
} else {
  h_ration <- 1
  w_ratio <- width / height
}

# convert to raster so we can then convert to matrix

size <- 2000 #this is the final size. Lower the matrix size for the trial render until you find everything perfet 

pop_rast <- st_rasterize(pop, 
                             nx = floor(size * w_ratio),
                             ny = floor(size * h_ratio))

mat <- matrix(pop_rast$population, 
              nrow = floor(size * w_ratio),
              ncol = floor(size * h_ratio))

# create color palette

retro <- c("#E8E8E8", "#E8BD3B", "#E87927", "#DB4C46", "#AF3736", "#4F315B", "#3D1C49")
swatchplot(retro)

#Interactive window
mat |> 
  height_shade(texture = retro) |> 
  plot_3d(heightmap = mat,
          zscale = 60,
          solid = FALSE,
          shadowdepth = 0)

render_camera(theta = 70, phi = 45, zoom = 0.95)

#trial render

render_highquality(
  filename = "test_jakarta.png",
  interactive = FALSE,
  lightdirection = 150,
  lightaltitude = c(30,80),
  lightcolor = c(retro[2], "white"),
  lightintensity = c(800, 200)
)

#Final render

outfile <- "final_jogja.png"

{
  start_time <- Sys.time()
  cat(crayon::cyan(start_time), "\n")
  if (!file.exists(outfile)) {
    png::writePNG(matrix(1), target = outfile)
  }
  render_highquality(
    filename = outfile,
    interactive = FALSE,
    lightdirection = 100,
    lightaltitude = c(30, 80),
    lightcolor = c(retro[1], "white"),
    lightintensity = c(800, 200),
    samples = 350,
    width = 2000,
    height = 2000
  )
  end_time <- Sys.time()
  diff <- end_time - start_time
  cat(crayon::cyan(diff), "\n")
}

