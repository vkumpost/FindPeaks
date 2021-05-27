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


@recipe function f(peaks::Peaks, data::Vector)

    x = 1:length(data)
    y = data

    locs = peaks.locs
    pks = peaks.pks

    @series begin
        seriescolor := :black
        label := "Data"
        x, y
    end

    @series begin
        seriestype := :scatter
        seriescolor := :red
        label := "Peaks"
        locs, pks
    end

end
