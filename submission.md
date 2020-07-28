# JuliaCon 2020 submission

**Submission title**: (64 characters)

Simple Layers for Species Distributions Modelling in Julia

**Abstract**: (500 characters)

In this talk, we will present the `SimpleSDMLayers` package, which implements types and functions to
interact with bioclimatic data and species distribution models in *Julia*. This package
offers convenient integration between bioclimatic data and spatial coordinates, handles
missing data, implements functions to download and manipulate WorldClim 2.0 data, and
provides default plotting recipes allowing easier visualization of modelling results.

**Description**: (2500 characters - Optional)

We will present the main features of the `SimpleSDMLayers.jl` package, and show how it allows convenient
manipulation of species distribution modelling outputs.
Species Distribution Models (SDMs) are widely used in Ecology and Biogeography, mainly to
predict where environmental conditions should be suitable for a given species on
continuous geographic scales.
Hence, SDMs require strong integration between bioclimatic data and spatial coordinates.
[`SimpleSDMLayers.jl`](https://github.com/EcoJulia/SimpleSDMLayers.jl), developed by Timothée Poisot and the
*EcoJulia* organization, provides an efficient way to interact with these data in Julia, as
well as a canvas on which SDM analyses can be built.

The package is built around the `SimpleSDMLayer` type, and stores bioclimatic data as **layers**. Each
layer contains a `grid` field, which can store any type of data, as well as `left`, `right`, `top`, and `bottom`
fields to store the bounding coordinates of a layer.
This type allows extraction of data based on single coordinates or ranges.
This type is intuitive and similar to the raster format used in Geographic Information
Systems (GIS) for spatial data, while being easier to manipulate in the context of SDMs.

The package also implements default recipes for the `Plots` package, which allow efficient
visualization and mapping of the bioclimatic variables and SDM outputs.
The package handles missing data, and implements functions for operations such as
resolution coarsening.

Another key feature of the package is its integration of the WorldClim 2.0 database, one
of the most common source for climate data in SDM studies.
WorldClim climate variable can be downloaded through the package and represented as `SimpleSDMLayers`.
Theses layers can then be used in SDM models or represented using the plotting recipes of
the package.

Our presentation will demonstrate the key features of the package through concrete
examples of bioclimatic data visualization and species distribution modelling.
It is aimed at ecologists and biogeographers in the Julia community, as well as all
scientists working with spatial data.
