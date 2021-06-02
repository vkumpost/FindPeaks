struct PeakResults
    indices::Vector  # Peak indices
    peaks::Vector  # Peak value
    locations::Vector  # Peak locations
    prominences::Vector  # Prominences
    width_bounds::Matrix  # Width bounds
end


function isempty(pr::PeakResults)
    return isempty(pr.indices)
end


function length(pr::PeakResults)
    return length(pr.indices)
end


@recipe function f(pr::PeakResults, data::Vector)

    x = 1:length(data)
    y = data

    indices = pr.indices
    peaks = pr.peaks
    prominences = pr.prominences
    width_bounds = pr.width_bounds
    n = length(peaks)

    for i = 1:n
        @series begin
            seriescolor := :orange
            label := "Prominence"
            primary := i == 1
            [indices[i], indices[i]], [peaks[i], peaks[i]-prominences[i]]
        end
        @series begin
            seriescolor := :gray
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
        indices, peaks
    end

end
