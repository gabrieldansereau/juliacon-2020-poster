function _bioclim_score(x)
    if isnothing(x)
        return nothing
    end
    @assert 0. <= x <= 1.
    if x >= 0.5
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
