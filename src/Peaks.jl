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
    locs = peaks.locs
    p = peaks.p
    n = length(peaks)
    wbounds = findwbounds(data, 1:length(data), idx, p)

    for i = 1:n
        @series begin
            seriescolor := :orange
            label := "Prominence"
            primary := i == 1
            [idx[i], idx[i]], [pks[i], pks[i]-p[i]]
        end
        @series begin
            seriescolor := :gray
            label := "Width"
            primary := i == 1
            [wbounds[i, 1], wbounds[i, 2]], [pks[i]-p[i]/2, pks[i]-p[i]/2]
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
        idx, pks
    end

end
