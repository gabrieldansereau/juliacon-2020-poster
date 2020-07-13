using SimpleSDMLayers
using Plots, StatsPlots

# Temperature

temperature = worldclim(1)

plot(temperature, c = :cividis, frame = :box,
     xguide = "Longitude", yguide = "Latitude")

density(temperature, frame=:zerolines, c=:grey, fill=(0, :grey, 0.5), leg=false)
xaxis!("Temperature", (-50,30))

temperature_europe = temperature[left=-11.0, right=31.1, bottom=29.0, top=71.1]
heatmap(temperature_europe, c=:cividis, aspectratio=1, frame=:box)

size(temperature_europe)

import Statistics
temperature_europe_coarse = coarsen(temperature_europe, Statistics.mean, (2, 2))
## Problem 1: coarsen

heatmap(temperature_europe_coarse, aspectratio=1, c=:cividis, frame=:box)

density(temperature, frame=:zerolines, c=:grey, fill=(0, :grey, 0.5), lab="")
density!(temperature_europe, c=:black, lab="Raw data")
density!(temperature_europe_coarse, c=:darkgrey, lab="Average")
xaxis!("Temperature", (-50,30))

# GBIF

using SimpleSDMLayers
using GBIF
using Plots
using StatsPlots
temperature = worldclim(1)
precipitation = worldclim(12)

kingfisher = GBIF.taxon("Megaceryle alcyon", strict=true)
kf_occurrences = occurrences(kingfisher)

# We will get some more occurrences
for i in 1:9
  occurrences!(kf_occurrences)
end

filter!(GBIF.have_ok_coordinates, kf_occurrences)
@info kf_occurrences

temperature[kf_occurrences[1]]

temperature_clip = clip(temperature, kf_occurrences)
precipitation_clip = clip(precipitation, kf_occurrences)

histogram2d(temperature_clip, precipitation_clip, c=:viridis)
scatter!(temperature_clip[kf_occurrences], precipitation_clip[kf_occurrences], lab="", c=:white, msc=:orange)
## Problem 2: plotting Float32
temperature_obs = temperature_clip[kf_occurrences]
precipitation_obs = precipitation_clip[kf_occurrences]
Float64.(filter(!isnothing, temperature_obs)) # oh some are nothing
# Remove nothing
inds_nothing = findall(!isnothing, temperature_obs)
inds_nothing == findall(!isnothing, precipitation_obs) # ok they match
temperature_notnothing = temperature_obs[inds_nothing]
precipitation_notnothing = precipitation_obs[inds_nothing]
scatter(temperature_notnothing, precipitation_notnothing, lab="", c=:white, msc=:orange) # works
scatter(temperature_clip[kf_occurrences], precipitation_clip[kf_occurrences], 
        lab="", c=:white, msc=:orange) # really didn't work
scatter(replace(temperature_obs, nothing => NaN32), replace(precipitation_obs, nothing => NaN32), 
        lab="", c=:white, msc=:orange) # works fine with NaN
scatter(replace(x -> isnothing(x) ? x : Float64(x), Array{Any}(temperature_obs)),
        replace(x -> isnothing(x) ? x : Float64(x), Array{Any}(precipitation_obs)),
        lab="", c=:white, msc=:orange) # Float32 aren't the problem, nothings are
histogram2d(temperature_clip, precipitation_clip, c=:viridis)
scatter!(temperature_notnothing, precipitation_notnothing, lab="", c=:white, msc=:orange)
# So solution is to filter out nothings

contour(precipitation_clip, c=:YlGnBu, title="Precipitation", frame=:box, fill=true)
scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences), lab="", c=:white, msc=:orange)

## Sliding window analysis

using SimpleSDMLayers
using Plots
using Statistics

precipitation = worldclim(12; left=-80.0, right=-56.0, bottom=44.0, top=62.0)

averaged = slidingwindow(precipitation, Statistics.mean, 100.0)

plot(precipitation, c=:alpine)
contour!(averaged, c=:white, lw=2.0)

## Landcover data

using SimpleSDMLayers
urban = landcover(9; left=-11.0, right=31.1, bottom=29.0, top=71.1)

n_urban_grid = zeros(Float32, size(urban))
for (i,e) in enumerate(urban.grid)
  n_urban_grid[i] = isnothing(e) ? NaN : Float32(e)
end

urban = SimpleSDMPredictor(n_urban_grid, urban)
filter(!isnan, urban.grid)

using Plots
heatmap(urban, c=:terrain)