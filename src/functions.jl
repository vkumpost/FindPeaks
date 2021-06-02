"""
`findindices(data::Vector)`

Find indices of peaks in `data`. For flat peaks, return only the lowest index.
"""
function findindices(data::Vector)

    # Print warning if the data vector contains NaN values
    if any(isnan.(data))
        @warn "Data vector contains NaN values!"
    end

    n = length(data)  # length of data
    indices = Int[]  # index vector for found peaks
    index_candidate = 0  # index of a potential peak

    # iterate data points
    for i = 2:n-1

        # if previous data point was smaller,
        # the current index becomes a candidate
        if data[i-1] < data[i]
            index_candidate = i
        end

        # if a candidate exists and future data point is smaller, 
        # then the point is a peak and its index saved
        if index_candidate > 0 && data[i] > data[i+1]
            push!(indices, index_candidate)
            index_candidate = 0
        end

    end

    return indices

end


"""
`findprominences(data::Vector, indices::Vector)`

Find prominence for peaks at `indices` of `data` vector.
"""
function findprominences(data::Vector, indices::Vector)
    
    # number of peaks and vector of peak prominences
    n_indices = length(indices)  
    prominences = typeof(data)(undef, n_indices)

    # iterate peak indices
    for i_index = 1:n_indices

        # current peak index and peak value
        current_index = indices[i_index]  
        peak_value = data[current_index]

        # run left until a value higher than the current peak is reached
        left_index = 1
        for i = i_index-1:-1:1
            if peak_value < data[indices[i]]
                left_index = indices[i]
                break                
            end
        end

        # find minimum of the left interval
        left_minimum = minimum(data[left_index:indices[i_index]])

        # run right until a value higher than the current peak is reached
        right_index = length(data)
        for i = i_index+1:1:n_indices
            if peak_value < data[indices[i]]
                right_index = indices[i]
                break                
            end
        end

        # find minimum of the right interval
        right_minimum = minimum(data[indices[i_index]:right_index])

        # the higest of the two minima is a reference point
        reference_point = max(left_minimum, right_minimum)

        # prominence
        prominences[i_index] = peak_value - reference_point

    end

    return prominences
    
end


"""
`findwidthbounds(data, x, indices, prominences)`

Find width bounds for peaks in `data` vector. `x` is location vector for `data`.
"""
function findwidthbounds(data, x, indices, prominences)

    n_indices = length(indices)
    width_bounds = Matrix{Float64}(undef, n_indices, 2)

    for i_index = 1:n_indices

        current_index = indices[i_index]
        peak = data[current_index]  # peak

        # reference height at which to measure the peak width
        height_reference = peak - prominences[i_index] * 0.5

        # find point to the left from the peak where w_ref intersect data
        left_index = 1
        for i = current_index:-1:2
            y1 = data[i]
            y2 = data[i-1]
            if y2 <= height_reference <= y1
                # interpolate the precise point
                x1 = x[i]
                xdiff = x1 - x[i-1]
                left_index = x1 - xdiff / (y2 - y1) * (height_reference - y1)
                break
            end
        end

        # find point to the right from the peak where w_ref intersect data
        right_index = length(data)
        for i = current_index:1:length(data)-1
            y1 = data[i]
            y2 = data[i+1]
            if y2 <= height_reference <= y1
                # interpolate the precise point
                x1 = x[i]
                xdiff = x[i+1] - x1
                right_index = x1 + xdiff / (y2 - y1) * (height_reference - y1)
                break
            end
        end

        width_bounds[i_index, :] = [left_index, right_index]

    end

    return width_bounds

end


"""
`findpeaks(data::Vector)`

**Arguments**
- `data`: input signal vector.

***Keyword Arguments*
- `minprominence`: Minimum peak prominence. Default is 0.

**Returns**
- Struct `Peaks` holding the array of all found local maxima and their 
    properties.
"""
function findpeaks(data::Vector; minprominence = 0.0)

    # location vector
    x = 1:length(data)

    # find peak indices
    indices = findindices(data)

    # get peaks
    peaks = data[indices]

    # get locations
    locations = indices

    # find peak prominences
    prominences = findprominences(data, indices)

    # find peak width bounds
    width_bounds = findwidthbounds(data, x, indices, prominences)

    # apply minimal prominence criterium
    ind = prominences .>= minprominence
    indices = indices[ind]
    peaks = peaks[ind]
    locations = locations[ind]
    prominences = prominences[ind]
    width_bounds = width_bounds[ind, :]

    # create Peaks struct
    pr = PeakResults(indices, peaks, locations, prominences, width_bounds)

    return pr

end
