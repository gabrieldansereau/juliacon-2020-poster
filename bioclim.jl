function _bioclim_score(x)
    if isnothing(x)
        return nothing
    end
    @assert 0. ≤ x ≤ 1.
    if x ≥ 0.5
        return 2(1-x)
    else
        return 2x
    end
end

function bioclim(layer::T, records::GBIFRecords) where {T <: SimpleSDMLayer}
    bioclim_prediction = convert(SimpleSDMResponse, copy(layer))
    qf = StatsBase.ecdf(Float32.(filter(!isnothing, layer[records])))
    qfgrid = replace(x -> isnothing(x) ? nothing : qf(x), layer.grid)
    bioclim_prediction.grid = _bioclim_score.(qfgrid)
    return bioclim_prediction
end

function Base.min(l1::T, l2::T) where {T <: SimpleSDMLayer}
    SimpleSDMLayers._layers_are_compatible(l1, l2)
    min_layer = similar(l1)
    for i in eachindex(l1.grid)
        if !isnothing(l1[i])
            min_layer[i] = min(l1[i], l2[i])
        end
    end
    return min_layer
end
