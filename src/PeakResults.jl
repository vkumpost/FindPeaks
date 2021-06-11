"""
`PeakResults`

This struct holds peak properties.

**Fields**
- `indices`: Vector of peak indices.
- `peaks`: Vector of peak values.
- `locations`: Vector of peak locations.
- `prominences`: Vector of peak prominences.
- `width_bounds`: Matrix with two columns indicating the beginnings and the ends
    of the peak widths.
"""
struct PeakResults
    indices::Vector  # Peak indices
    peaks::Vector  # Peak values
    locations::Vector  # Peak locations
    prominences::Vector  # Prominences
    width_bounds::Matrix  # Width bounds
end


"""
`peakheights(pr::PeakResults)`

Return peak values (local maxima).
"""
function peakheights(pr::PeakResults)
    return pr.peaks
end


"""
`peaklocations(pr::PeakResults)`

Return peak locations.
"""
function peaklocations(pr::PeakResults)
    return pr.locations
end


"""
`peakprominences(pr::PeakResults)`

Return peak prominences.
"""
function peakprominences(pr::PeakResults)
    return pr.prominences
end


"""
`peakwidths(pr::PeakResults)`

Return peak widths.
"""
function peakwidths(pr::PeakResults)
    return [diff(pr.width_bounds, dims = 2)...]
end


"""
`isempty(pr::PeakResults)`

Return `true` if `pr` does not contain any peaks.
"""
function isempty(pr::PeakResults)
    return isempty(pr.indices)
end


"""
`length(pr::PeakResults)`

Return the number of peaks in `pr`.
"""
function length(pr::PeakResults)
    return length(pr.indices)
end


"""
`getindex(pr::PeakResults, inds)`

Return a subset of `pr` as specified by `inds`.
"""
function getindex(pr::PeakResults, inds)
    indices = pr.indices[inds]
    peaks = pr.peaks[inds]
    locations = pr.locations[inds]
    prominences = pr.prominences[inds]
    width_bounds = pr.width_bounds[inds, :]
    return PeakResults(indices, peaks, locations, prominences, width_bounds)
end


"""
`sort(pr::PeakResults; rev::Bool=false)`

Return sorted `pr` with peaks sorted from lowest to highest. Use `rev = true` to
    reverse the sorting order.
"""
function sort(pr::PeakResults; rev::Bool=false)

    peaks = pr.peaks
    inds = sortperm(peaks; rev = rev)
    pr_sorted = pr[inds]
    return pr_sorted

end


"""
A recipe for Plots.jl to visualize peaks and their properties and underlying 
    data.
"""
@recipe function f(pr::PeakResults, data, x=1:length(data))

    y = data

    peaks = pr.peaks
    locations = pr.locations
    prominences = pr.prominences
    width_bounds = pr.width_bounds
    n = length(peaks)

    for i = 1:n
        @series begin
            seriescolor := :red
            label := "Prominence"
            primary := i == 1
            [locations[i], locations[i]], [peaks[i], peaks[i]-prominences[i]]
        end
        @series begin
            seriescolor := :blue
            label := "Width"
            primary := i == 1
            [width_bounds[i, 1], width_bounds[i, 2]],
                [peaks[i]-prominences[i]/2, peaks[i]-prominences[i]/2]
        end
    end

    @series begin
        seriescolor := :black
        label := "Data"
        x, y
    end

    @series begin
        seriestype := :scatter
        seriescolor := :red
        label := "Peaks"
        legend := false
        locations, peaks
    end

end
