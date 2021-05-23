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
