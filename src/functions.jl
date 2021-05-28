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

        # run left until a value higher than the current peak is reached
        left_index = 1
        for i = i_idx-1:-1:1
            if peak_value < data[idx[i]]
                left_index = idx[i]
                break                
            end
        end

        # find minimum of the left interval
        left_minimum = minimum(data[left_index:idx[i_idx]])

        # run right until a value higher than the current peak is reached
        right_index = length(data)
        for i = i_idx+1:1:n_idx
            if peak_value < data[idx[i]]
                right_index = idx[i]
                break                
            end
        end

        # find minimum of the right interval
        right_minimum = minimum(data[idx[i_idx]:right_index])

        # the higest of the two minima is a reference point
        reference_point = max(left_minimum, right_minimum)

        # prominence
        p[i_idx] = peak_value - reference_point

    end

    return p
    
end


"""
`findwbounds(data, x, idx, p)`

Find width bounds for peaks in `data` vector. `x` is location vector for `data`.
`idx` and `p` are peak indicies and prominences.
"""
function findwbounds(data, x, idx, p)

    n_idx = length(idx)
    w_bounds = Matrix{Float64}(undef, n_idx, 2)

    for i_idx = 1:n_idx

        current_idx = idx[i_idx]
        pk = data[current_idx]  # peak
        w_ref = pk - p[i_idx] * 0.5  # reference height for width measurements

        # find point to the left from the peak where w_ref intersect data
        left_index = 1
        for i = current_idx:-1:2
            y1 = data[i]
            y2 = data[i-1]
            if y2 <= w_ref <= y1
                # interpolate the precise point
                x1 = x[i]
                xdiff = x1 - x[i-1]
                left_index = x1 - xdiff / (y2 - y1) * (w_ref - y1)
                break
            end
        end

        # find point to the right from the peak where w_ref intersect data
        right_index = length(data)
        for i = current_idx:1:length(data)-1
            y1 = data[i]
            y2 = data[i+1]
            if y2 <= w_ref <= y1
                # interpolate the precise point
                x1 = x[i]
                xdiff = x[i+1] - x1
                right_index = x1 + xdiff / (y2 - y1) * (w_ref - y1)
                break
            end
        end

        w_bounds[i_idx, :] = [left_index, right_index]

    end

    return w_bounds

end


"""
`findpeaks`

**Arguments**
- `data`: input signal vector.

**Returns**
- Struct `Peaks` holding the array of all found local maxima and their 
    properties. The struct contains fields
    - `idx`: peak indices.
    - `pks`: local maxima.
    - `locs`: peak locations.
    - `w`: peak widths.
    - `p`: peak prominence.
"""
function findpeaks(data::Vector)

    # location vector
    x = 1:length(data)

    # find peak indices
    idx = findidx(data)

    # create Peaks struct
    pks = data[idx]
    locs = idx
    p = findp(data, idx)
    w_bounds = findwbounds(data, x, idx, p)
    w = [diff(w_bounds, dims = 2)...]
    peaks = Peaks(idx, pks, locs, w, p)

    return peaks

end
