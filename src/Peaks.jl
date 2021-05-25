struct Peaks
    pks::Vector  # Local maxima
    locs::Vector  # Peak locations
    w::Vector  # Peak widths
    p::Vector  # Peak prominences
end


function isempty(peaks::Peaks)
    return isempty(peaks.locs)
end


function length(peaks::Peaks)
    return length(peaks.locs)
end


"""
`plot_peaks(peaks::Peaks, data::Vector)`

Plot peaks on data.
"""
function plotpeaks(peaks::Peaks, data::Vector)

    pks = peaks.pks
    locs = peaks.locs

    p = plot(data, label = "Data", color = :black)
    plot!(p, locs, pks, seriestype = :scatter, label = "Peaks", color = :red)
    display(p)

end
