"""
`findidx(data)`

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


"""
`find_peaks`

**Arguments**
- `data`: input signal vector.

**Returns**
- Struct `Peaks` holding the array of all found local maxima and their 
    properties. The struct contains fields
    - `pks`: loacal maxima.
    - `locs`: peak locations.
    - `w`: Peak widths.
    - `p`: peak prominence.
"""
function find_peaks(data)

    idx = find_idx(data)
    
    if isempty(idx)
        T = eltype(data)
        return Peaks(T[], Int64[], Int64[], T[])
    end

    pks = data[idx]
    locs = idx
    w = fill(-1, length(idx))
    p = fill(NaN, length(idx))

    return Peaks(pks, locs, w, p)
end