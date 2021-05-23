"""
`find_idx(data)`

Find indices of peaks in `data`. For flat peaks, return only the lowest index.
"""
function find_idx(data)
    if any(isnan.(data))
        @warn "Data vector contains NaN values!"
    end
    n = length(data)  # length of data
    idx = Int[]
    idx_candidate = 0
    for i = 2:n-1
        if data[i-1] < data[i]
            idx_candidate = i
        end
        if idx_candidate > 0 && data[i] > data[i+1]
            push!(idx, idx_candidate)
            idx_candidate = 0
        end
    end
    return idx
end
