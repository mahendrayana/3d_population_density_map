# 3D Population Density Visualization


![3d map of Bali](Images/titled_final_bali.png)
![3d map of Yogyakarta](Images/final_jogja.png)


## Table of Contents

- [Project Overview](#project-overview)
- [Data](#data)
- [Data Preprocessing](#data-preprocessing)
- [Visualization](#visualization)
- [Acknowledgement](#acknowledgement)
- [Contact](#contact)

## Project Overview

This data visualization focused on exploring rayshader package in r to produce a 3d spatial data visualization.

## Data

The data for this project is acquired from kontur site:
https://www.kontur.io/portfolio/population-dataset/

## Preprocessing
The main data used is the subset for Indonesia, but still, it's necesarry to layer the data with administrative boundaries shp of Indonesia districts to improve the visualization flexibility. The preprocessing process indluces:
1. loading the dataset and the shp
2. match the crs
3. Intersect the data and the shp
4. Create the matrix as the value that determine the visualization's height.

## Visualization
The output mapping is visualized using rayshader package and annotated using magick package.

## Acknowledgment
This project draws significant inspiration from Mr.Pecners project that could be accessed here:
https://github.com/Pecners/kontur_rayshader_tutorial


## Contact
For questions or further information, please contact mahendrayana at [mahendrayana203@gmail.com].