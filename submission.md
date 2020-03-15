# JuliaCon 2020 submission

**Submission title**: (64 characters)

Simple layers for Species Distributions Modelling in Julia

**Abstract**: (500 characters)

In this talk, we will present the `SimpleSDMLayers` package, which implements types and functions to
interact with bioclimatic data and species distribution models in *Julia*. This package
offers convenient integration between bioclimatic information and spatial information,
allows access to data according to spatial coordinates, has integrated functions to
download WorldClim 2.0 data, as well as default plotting settings allowing easier
visualization of modelling results.


**Description**: (2500 characters - Optional)

- Type system:
  - layer --> grid with data of any type, bounding spatial coordinates
  - Predictor vs Response
- Methods
  - Overloads from Base
  - Access a normal 2D-Arrays, either on grid position or coordinates, for single values or ranges
  - Easy assignment of values for Responses based on coordinates
- Bioclimatic Data
  - WorldClim 2.0 integration, layers for all variables, based on coordinates range. Ease of cropping
- Plotting
  - Recipes & functions for visualization (heatmap), or representing important features (density, histogram), scatter plots comparing variables

- Base type to be reused by packages implementing species distribution models
- SDMs by default work on continuous ranges, hence for need for grid-like integration

- Other interesting features
  - Missing data handling
  - Coarsening
  -

**Notes**:



Scoring Criterias:
1. Applicability to the Julia Community
2. Contributions to the community
3. Clarity
4. Significance to the community
5. Topic diversity
6. Soundness
7. Classification
