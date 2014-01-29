R and Spatial Data
==================

## Preliminaries

R has a unique syntax that is worth learning in basic terms before 
loading spatial data: to R spatial and non-spatial data are 
treated in the same way, although they have different underlying data structures. 

The first step is to ensure that you are in the correct working directory. 
Use `setwd` to select the correct folder. Assuming the folder has been downloaded
from GitHub and unpacked into the desktop on a Windows computer, you would type the
following:


```r
setwd("C:/Users/Uname/Desktop/sdvwR-master")
```



```r
getwd()
```

```
## [1] "/nfs/foe-fs-01_users/georl/repos/sdv/appendices"
```





```r
getwd()
```

```
## [1] "/nfs/foe-fs-01_users/georl/repos/sdv/appendices"
```

```r
setwd("../../sdvwR")
getwd()
```

```
## [1] "/nfs/foe-fs-01_users/georl/repos/sdvwR"
```



In RStudio, it is recommended to work from *script files*. To open a new
R script, click `File > New File` (see the 
[RStudio website](http://www.rstudio.com/ide/docs/using/keyboard_shortcuts) for shortcuts.)
Try typing and running (by pressing `ctl-Enter` in an RStudio script)
the following calculations to see how R works and plot the result.


```r
t <- seq(from = 0, to = 20, by = 0.1)
x <- sin(t) * exp(-0.2 * t)
plot(t, x)
```

![plot of chunk A preliminary plot](figure/A_preliminary_plot.png) 


R code consists of *functions*, usually proceeded by brackets (e.g. `seq`)
and *objects* (`d`, `t` and `x`). Each function contains *arguments*,
the names of which often do not need to be stated: the function `seq(0, 20, 0.1)`, for example,
would also work because `from`, `to` and `by` are the *default* arguments.
Knowing this is important as it can save typing. In this chapter, however, 
we generally spell out each of the argument names, for clarity. 

Note the use of the assignment arrow `<-` to create new objects. 
Objects are entities that can be called to by name in R 
and can be renamed through additional assignements (e.g `y <- x` if y seems 
a more appropriate name). This is an efficient way of referring to large data objects or sets of commands.

Spatial Data in R
-----------------

In any data analysis project, spatial or otherwise, it is important to
have a strong understanding of the dataset before progressing. 
We will see how data can be loaded into R and exported
to other formats, before going into more detail about the underlying
structure of spatial data in R.

### Loading spatial data in R

In most situations, the starting point of a spatial analysis project is to
load in the datasets. These may originate from government
agencies, remote sensing devices or 'volunteered geographical
information' (Goodchild 2007). R is able to import a very wide range of spatial data formats thanks to
its interface with the Geospatial Data Abstraction Library (GDAL), which
is a large database of the different spatial reference and projection types. I R the package `rgdal` makes the database accessible. Below we will install the rgdal package
using the function `install.packages` (this can be used to install any packages) and then load
data from two common spatial data formats: GPS eXchange (`.gpx`) and ESRI
Shapefile.

Let's start with a `.gpx` file, a tracklog recording a bicycle
ride from Sheffield to Wakefield uploaded OpenStreetMap [3].


```r
# install.packages('rgdal') # install rgdal package if not already installed
library(rgdal)  # load the gdal package
```

```
## Loading required package: sp
## rgdal: version: 0.8-14, (SVN revision 496)
## Geospatial Data Abstraction Library extensions to R successfully loaded
## Loaded GDAL runtime: GDAL 1.9.2, released 2012/10/08
## Path to GDAL shared files: /usr/share/gdal
## Loaded PROJ.4 runtime: Rel. 4.8.0, 6 March 2012, [PJ_VERSION: 480]
## Path to PROJ.4 shared files: (autodetected)
```

```r
getwd()
```

```
## [1] "/nfs/foe-fs-01_users/georl/repos/sdv/appendices"
```

```r
ogrListLayers(dsn = "data/gps-trace.gpx")
```

```
## Error: Cannot open data source
```

```r
shf2lds <- readOGR(dsn = "data/gps-trace.gpx", layer = "tracks")  # load track
```

```
## Error: Cannot open file
```

```r
plot(shf2lds)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'shf2lds' not found
```

```r
shf2lds.p <- readOGR(dsn = "data/gps-trace.gpx", layer = "track_points")  # load points
```

```
## Error: Cannot open file
```

```r
points(shf2lds.p[seq(1, 3000, 100), ])
```

```
## Error: object 'shf2lds.p' not found
```



```
## Error: plot.new has not been called yet
```

```
## Error: plot.new has not been called yet
```


When `rgdal` has successfully loaded, the next task is not to import the
file directly, but to find out which *layers* are available to import,
with `ogrListLayers`. The output from this command tells us
that various layers are available, including `tracks` and
`track_points`. These are imported into R's *workspace* using `readOGR`.

Finally, the basic
`plot` function is used to visualize the newly imported objects, ensuring
they make sense. In the second plot function (`points`), we
add points for a subset of the object. There will be no axes in the plot;
to see how to add them, enter `?axis`

Try discovering more about the function by typing `?readOGR`.
The documentation explains that the `dsn =` argument is
interpreted differently depending on the type of
file used. In the above example, the `dsn` was set to as the name of the file.
To load Shapefiles, by contrast, the *folder* containing the data is
used:


```r
lnd <- readOGR(dsn = "data/", "london_sport")
```

```
## Error: Cannot open file
```


Here, the files reside in a folder entitled `data`, which is in
R's current working directory (you can check this using `getwd()`).
If the files were stored in the working directory, one would use
`dsn = "."` instead. Again, it may be wise to plot the data that
results, to ensure that it has worked correctly. Now that the data has
been loaded into R's own `sp` format, try interrogating and plotting it,
using functions such as `summary` and `plot`.

The london_sport file contains data pertaining to the percentage of people within each London Borough who regularly undertake physical activity and also the 2001 population of each Borough.

### The size of spatial datasets in R

Any datasets that have been read into R's *workspace*, which constitutes all
objects that can be accessed by name and can be listed using the `ls()`
function, can be saved in R's own data storage file type `.RData`.
Spatial datasets can get quite large and this can cause problems on
computers by consuming all available memory (RAM) or hard
disk space. It is therefore wise to understand
roughly how large spatial objects are, providing insight
into how long certain functions will take to run.

In the absence of prior knowledge, which of the two objects loaded in
the previous section would one expect to be larger? One could
hypothesize that the London dataset
would be larger based on its greater spatial extent, but how much larger?
The answer in R is found in the function `object.size`:


```r
object.size(shf2lds)
```

```
## Error: object 'shf2lds' not found
```

```r
object.size(lnd)
```

```
## Error: object 'lnd' not found
```


In fact, the objects have similar sizes: the GPS dataset is surprisingly large.
To see why, we can find out how
many *vertices* (points connected by lines) are contained in each
dataset. To do this we use `fortify` from the ggplot2 package
(use the same method used for rgdal, described above, to install it).


```r
shf2lds.f <- fortify(shf2lds)
```

```
## Error: object 'shf2lds' not found
```

```r
nrow(shf2lds.f)
```

```
## Error: object 'shf2lds.f' not found
```

```r

lnd.f <- fortify(lnd)
```

```
## Error: object 'lnd' not found
```

```r
nrow(lnd.f)
```

```
## Error: object 'lnd.f' not found
```


In the above block of code we performed two
functions for each object: 1) *flatten* the dataset so that
each vertice is allocated a unique row 2) use
`nrow` to count the result.

It is clear that the GPS data has almost 6 times the number
of vertices compared to the London data, explaining its large size. Yet
when plotted, the GPS data does not seem more detailed, implying that
some of the vertices in the object are not needed for effective visualisation since the nodes of the line are imperceptible.

### Simplifying geometries

Simplifcation can help to make a graphic more readable and less cluttered. Within the 'rgeos' package it is possible to use the `gSimplify` function to simplify spatial R objects:


```r
library(rgeos)
shf2lds.simple <- gSimplify(shf2lds, tol = 0.001)
```

```
## Error: object 'shf2lds' not found
```

```r
(object.size(shf2lds.simple)/object.size(shf2lds))[1]
```

```
## Error: object 'shf2lds.simple' not found
```

```r
plot(shf2lds.simple)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'shf2lds.simple' not found
```

```r
plot(shf2lds, col = "red", add = T)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'shf2lds' not found
```


In the above block of code, `gSimplify` is given the object `shf2lds`
and the `tol` argument of 0.001 (much
larger tolerance values may be needed, for data that is *projected*).
Next, we divide the size of the simplified object by the original
(note the use of the `/` symbol). The output of `0.04...`
tells us that the new object is only around
4% of its original size. We can see how this has happened
by again counting the number of vertices. This time we use the
`coordinates` and `nrow` functions together:


```r
nrow(coordinates(shf2lds.simple)[[1]][[1]])
```

```
## Error: error in evaluating the argument 'obj' in selecting a method for function 'coordinates': Error: object 'shf2lds.simple' not found
```


The syntax of the double square brackets will seem strange,
providing a taster of how R 'sees' spatial data.
Do not worry about this for now.
Of interest here is that the number of vertices has shrunk, from over 6,000 to
only 44, without losing much information about the shape of the line.
To test this, try plotting the original and simplified tracks
on your computer: when visualized using the `plot` function,
object `shf2lds.simple` retains the overall shape of the
line and is virtually indistinguishable from the original object.

This example is rather contrived because even the larger object
`shf2lds` is only a tenth of a megabyte, negligible compared with the gigabytes of
memory available to modern computers. However, it underlines a wider point:
for visualizing *small scale* maps, spatial data *geometries*
can often be simplified to reduce processing time and
use of memory.

### The structure of spatial data in R

Spatial datasets in R are saved in their own format, defined as 
`Spatial...` classes within the `sp` package. For this reason, 
`sp` is the basic spatial package in R, upon which the others depend. 
Spatial classes range from the basic `Spatial` class to the complex
`SpatialPolygonsDataFrame`: the `Spatial` class contains only two required *slots* [5]:


```r
getSlots("Spatial")
```

```
##        bbox proj4string 
##    "matrix"       "CRS"
```


This tells us that `Spatial` objects must contain a bounding box (`bbox`) and 
a coordinate reference system (CRS) accessed via the function `proj4string`. 
Further details on these can be found by typing `?bbox` and `?proj4string`. 
All other spatial classes in R build on 
this foundation of a bounding box and a projection system (which 
is set automatically to `NA` if it is not known). However, more complex 
classes contain more slots, some of which are lists which contain additional 
lists. To find out the slots of `shf2lds.simple`, for example, we would first 
ascertain its class and then use the `getSlots` command: !!!!I THINK THIS REQUIRES MORE EXPLANATION- MAYBE MOVE THE APPENDIX UP!!!


```r
class(shf2lds)  # identify the object's class
```

```
## Error: object 'shf2lds' not found
```

```r
getSlots("SpatialLinesDataFrame")  # find the associated slots
```

```
##         data        lines         bbox  proj4string 
## "data.frame"       "list"     "matrix"        "CRS"
```


The same principles apply to all spatial classes including 
`Spatial* Points`, `Polygons` `Grids` and `Pixels`
as well as associated `*DataFrame` classes. For more information on 
this, see the `sp` documentation: `?Spatial`.

To flatten a `Spatial*` object in R, so it becomes a simple
data frame, the `fortify` function can be used (more on this later).
For most spatial data handling tasks the `Spatial*` object classes are idea, 
as illustrated below.

### Saving and exporting spatial objects

A typical R workflow involves loading the data, processing/analysing the data
and finally exporting the data in a new form. 
`writeOGR`, the 
logical counterpart of `readOGR` is ideal for this task. This is performed using
the following command (in this case we are exporting to an ESRI Shapefile): 


```r
writeOGR(shf2lds, layer = "shf2lds", dsn = "data/", driver = "ESRI Shapefile")
```

```
## Error: object 'shf2lds' not found
```





In the above code, the object was first converted into a spatial dataframe class required
by the `writeOGR` command, before 
being exported as a shapefile entitled shf2lds. Unlike with `readOGR`, the driver must 
be specified, in this case with "ESRI Shapefile" [4]. The simplified GPS data are now available
to other GIS programs for further analysis. Alternatively, 
`save(shf2lds, file = "data/shf2lds.RData")`
will save the object in R's own spatial data format.

### Attribute joins 

London Boroughs are official administrative
zones so we can easily join a range of other datasets 
to the polygons in the `lnd` object. We will use the example 
of crime data to illustrate this data availability, which is 
stored in the `data` folder available from this project's github page.


```r
load("data/crimeAg.Rdata")  # load the crime dataset from an R dataset
```

```
## Warning: cannot open compressed file 'data/crimeAg.Rdata', probable reason
## 'No such file or directory'
```

```
## Error: cannot open the connection
```


After the dataset has been explored (e.g. using the `summary` and `head` functions)
to ensure compatibility, it can be joined to `lnd`. We will use the
the `join` function in the `plyr` package but the `merge` function 
could equally be used (remember to type `library(plyr)` if needed).




`join` requires all joining variables to have the 
same name, which has already been done [7].


```r
lnd@data <- join(lnd@data, crimeAg)
```

```
## Error: object 'crimeAg' not found
```


As with many operations in R, there is more than one way to 
acheive this result: `merge(lnd@data, crimeAg, by = )`

Take a look at the `lnd@data` object. You should 
see new variables added, meaning the attribute join 
was successful. 


## Summary

To summarise this appendix, we have learned how to 
perform the crucial tasks of loading and saving spatial datasets 
in R. This should have been surprisingly painless 
considering the dread surrounding some command-line programs 
(watch out for typos!). We have also taken a look inside R's representation 
of spatial data, learned how to manipulate these datasets 
with a simple attribute join. Much more complex procedures are 
possible, but for now we will move on to visualisation by returning to the chapter. 
