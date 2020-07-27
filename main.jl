import Pkg; Pkg.activate(".")
using SimpleSDMLayers
using Plots
using StatsPlots
using Statistics
using StatsBase
using GBIF

## World-scale example

# Get world temperature
temperature = worldclim(1)
# Verify size
size(temperature)
# Map temperature
temperature_plot = plot(temperature, xguide = "Longitude", yguide = "Latitude", colorbar_title = "Average Temperature (°C)")
# Save result
savefig(temperature_plot, "fig/temperature.png")

## Common manipulations

# Clip to Europe
temperature_europe = temperature[left=-11.2, right=30.6, bottom=29.2, top=71.0];
# Verify size again
size(temperature_europe)
# Map result
temperature_europlot = plot(temperature_europe, frame = :box, ticks = false, colorbar = false)
# Save
savefig(temperature_europlot, "fig/temperature_europe.png")

# Coarsen example
temperature_europe_coarse = coarsen(temperature_europe, Statistics.mean, (4, 4))
plot(temperature_europe_coarse, frame = :box, ticks = false, colorbar = false)
# Save
savefig("fig/coarsen.png")

# Sliding window example
averaged = slidingwindow(temperature_europe, Statistics.mean, 100.0)
plot(averaged, frame = :box, ticks = false, colorbar = false)
# Save
savefig("fig/slidingwindow.png")

## GBIF integration

# Get taxon & occurrences
kingfisher = GBIF.taxon("Megaceryle alcyon", strict=true)
kf_occurrences = occurrences(kingfisher)

# Get some more occurrences
for i in 1:9
  occurrences!(kf_occurrences)
end

# Filter for correct coordinates
# filter!(GBIF.have_ok_coordinates, kf_occurrences)
# @info kf_occurrences

# Clip layer to occurrences
temperature_clip = clip(temperature, kf_occurrences)

# Plot occurrences
contour(temperature_clip, fill=true, colorbar_title = "Average temperature (°C)",
                  xguide = "Longitude", yguide = "Latitude")
scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences), 
         label = "Kingfisher occurrences", legend = :bottomleft, 
         c=:white, msc=:orange)
# Save
savefig("fig/occurrences.png")

## BIOCLIM example

include("bioclim.jl")

# Get all worldclim variables
vars = worldclim(1:19)

# Get prediction for each variable
vars_predictions = bioclim.(vars, kf_occurrences)

# Get minimum prediction per site
sdm_predictions = reduce(min, vars_predictions)

# Set value to nothing if prediction is zero
replace!(x -> isnothing(x) || iszero(x) ? nothing : x, sdm_predictions.grid)

# Filter predictions with threshold
# threshold = quantile(filter(!isnothing, sdm_predictions.grid), 0.05)
# replace!(x -> isnothing(x) || x <= threshold ? nothing : x, sdm_predictions.grid)

# Map background
plot(temperature_clip, c = :lightgrey,
     xguide = "Longitude", yguide = "Latitude")
# Map predictions
plot!(clip(sdm_predictions, kf_occurrences), c = :viridis, 
      clim = (minimum(sdm_predictions), maximum(sdm_predictions)),
      colorbar_title = "Predicted suitability score")
# Map occurrences
# scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences), 
#          label = "Kingfisher occurrences", legend = :bottomleft, 
#          c=:white, msc=:orange)
# Save result
savefig("fig/bioclim.png")