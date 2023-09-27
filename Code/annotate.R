library(magick)
library(MetBrewer)
library(colorspace)
library(ggplot2)
library(glue)
library(stringr)

img <- image_read("final_bali.png")

colors <- met.brewer("VanGogh3")
swatchplot(colors)

text_color <- darken(colors[7], .25)
swatchplot(text_color)

annot <- glue("This map shows population density of Bali. Population estimates are represented by 400m hexagons.") |> 
  str_wrap(55)

img |> 
  image_annotate("Bali Population Density",
                 gravity = "north",
                 location = "+0+100",
                 color = text_color,
                 size = 80,
                 weight = 700,
                 font = "Trebuchet MS") |> 
  image_annotate(annot,
                 gravity = "south",
                 location = "+0+100",
                 color = text_color,
                 size = 50,
                 font = "Trebuchet MS") |> 
  image_annotate(glue("Author: Mahendrayana | ",
                      "Data: Kontur-Population Density (2022)"),
                 gravity = "south",
                 location = "+0+30",
                 font = "Trebuchet MS",
                 color = alpha(text_color, .5),
                 size = 25) |> 
  image_write("titled_final_bali.png")
