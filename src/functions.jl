"""
`findidx(data::Vector)`

Find indices of peaks in `data`. For flat peaks, return only the lowest index.
"""
function findidx(data::Vector)

    # Print warning if the data vector contains NaN values
    if any(isnan.(data))
        @warn "Data vector contains NaN values!"
    end

    n = length(data)  # length of data
    idx = Int[]  # index vector for found peaks
    idx_candidate = 0  # index of a potential peak

    # iterate data points
    for i = 2:n-1

        # if previous data point was smaller,
        # the current index becomes a candidate
        if data[i-1] < data[i]
            idx_candidate = i
        end

        # if a candidate exists and future data point is smaller, 
        # then the point is a peak and its index saved
        if idx_candidate > 0 && data[i] > data[i+1]
            push!(idx, idx_candidate)
            idx_candidate = 0
        end

    end

    return idx

end


"""
`findp(data::Vector, idx::Vector)`

Find prominence for peaks at `idx` indicies of `data` vector.
"""
function findp(data::Vector, idx::Vector)
    
    # number of peaks and vector of peak prominences
    n_idx = length(idx)  
    p = typeof(data)(undef, n_idx)

    # iterate peak indicies
    for i_idx = 1:n_idx

        # current peak index and peak value
        current_idx = idx[i_idx]  
        peak_value = data[current_idx]

        # find the closest local minimum to the left from the peak
        left_index = 1
        for i = i_idx-1:-1:1
            if peak_value < data[idx[i]]
                left_index = idx[i]
                break                
            end
        end
        left_minimum = minimum(data[left_index:idx[i_idx]])

        # find the closest local minimum to the right from the peak
        right_index = length(data)
        for i = i_idx+1:1:n_idx
            if peak_value < data[idx[i]]
                right_index = idx[i]
                break                
            end
        end
        right_minimum = minimum(data[idx[i_idx]:right_index])

        # the higest of the two minima is a reference
        reference = max(left_minimum, right_minimum)

        # prominence
        p[i_idx] = peak_value - reference

    end    

    return p
    
end


"""
`findpeaks`

**Arguments**
- `data`: input signal vector.

**Keyword Arguments**
- `show_plot`: show found peaks and their properties in a plot. Default is `false`.

**Returns**
- Struct `Peaks` holding the array of all found local maxima and their 
    properties. The struct contains fields
    - `pks`: loacal maxima.
    - `locs`: peak locations.
    - `w`: Peak widths.
    - `p`: peak prominence.
"""
function findpeaks(data::Vector; show_plot = false)

    # find peak indices
    idx = findidx(data)

    # create Peaks struct
    pks = data[idx]
    locs = idx
    w = fill(-1, length(idx))
    p = fill(NaN, length(idx))
    peaks = Peaks(pks, locs, w, p)

    # show plot
    if show_plot
        plotpeaks(peaks, data)
    end

    return peaks

end
