struct Peaks
    idx::Vector  # Peak indicies
    pks::Vector  # Peak amplitude
    locs::Vector  # Peak locations
    w::Vector  # Peak widths
    p::Vector  # Peak prominences
end


function isempty(peaks::Peaks)
    return isempty(peaks.idx)
end


function length(peaks::Peaks)
    return length(peaks.idx)
end


@recipe function f(peaks::Peaks, data::Vector)

    x = 1:length(data)
    y = data

    idx = peaks.idx
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
        idx, pks
    end

end
