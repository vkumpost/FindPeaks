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
`findwidthbounds(data, x, indices)`

Find width bounds using a half height of a peak as a reference.
"""
function findwidthbounds(data, x, indices)

    n_indices = length(indices)
    width_bounds = Matrix{Float64}(undef, n_indices, 2)

    for i_index = 1:n_indices

        current_index = indices[i_index]
        peak = data[current_index]  # peak

        # for negative peaks return NaNs
        if peak < 0
            width_bounds[i_index, :] = [NaN, NaN]
            continue
        end

        # reference height at which to measure the peak width
        height_reference = 0.5 * peak

        # find point to the left from the peak where w_ref intersect data
        if i_index == 1
            left_index = 1
        else
            i_minimum = argmin(data[indices[i_index-1]:current_index])
            left_index = indices[i_index-1] + i_minimum -1
        end
        left_x = x[left_index]
        for i = current_index:-1:(left_index+1)
            y1 = data[i]
            y2 = data[i-1]
            if y2 <= height_reference <= y1
                # interpolate the precise point
                x1 = x[i]
                xdiff = x1 - x[i-1]
                left_x = x1 - xdiff / (y2 - y1) * (height_reference - y1)
                break
            end
        end

        # find point to the right from the peak where w_ref intersect data
        if i_index == n_indices
            right_index = length(data)
        else
            i_minimum = argmin(data[current_index:indices[i_index+1]])
            right_index = current_index + i_minimum -1
        end
        right_x = x[right_index]
        for i = current_index:1:(right_index-1)
            y1 = data[i]
            y2 = data[i+1]
            if y2 <= height_reference <= y1
                # interpolate the precise point
                x1 = x[i]
                xdiff = x[i+1] - x1
                right_x = x1 + xdiff / (y2 - y1) * (height_reference - y1)
                break
            end
        end

        width_bounds[i_index, :] = [left_x, right_x]

    end

    return width_bounds

end


"""
`findpeaks(data::Vector, x=1:length(data); kwargs...)`

**Argument**
- `data`: Input signal vector.

**Optional Argument**
- `x`: Locations for the input signal vector.

**Keyword Arguments**
- `npeaks`: Maximum number of peaks to return.
- `sortstr`: Sort peaks. Possible options are "ascend" (the smallest
    peak first) or "descend" (the largest peak first).
- `sortref`: Reference property used to sort the peaks. Possible options are
    "height" (default) and "prominence". This option is ignored if `sortstr` is
    not specified.
- `minheight`: Minimum peak height.
- `minprominence`: Minimum peak prominence.
- `threshold`: Minimum height difference between a peak and the neighboring
    points.
- `mindistance`: Minimum distance between neighboring peaks.
- `widthreference`: "halfheight" will use half heights, instead of half
    prominences, as reference heights to calculate the peak widths.
- `minwidth`: Minimum peak width.
- `maxwidth`: Maximum peak width.

**Returns**
- Struct `PeakResults` holding an array of all peaks and their properties.
"""
function findpeaks(data::Vector, x=1:length(data); kwargs...)

    # find peak indices
    indices = findindices(data)

    # apply minimum height
    if :minheight in keys(kwargs)
        minheight = kwargs[:minheight]
        peaks = data[indices]
        inds = peaks .>= minheight
        indices = indices[inds]
    end

    # apply threshold
    if :threshold in keys(kwargs)
        threshold = kwargs[:threshold]
        inds = []
        n = length(indices)
        for i = 1:n
            index = indices[i]
            height_difference = min(data[index] - data[index-1],
                data[index] - data[index+1])
            if height_difference >= threshold
                push!(inds, i)
            end
        end
        indices = indices[inds]
    end

    # find peak prominences
    prominences = findprominences(data, indices)

    # apply minimal prominence
    if :minprominence in keys(kwargs)
        minprominence = kwargs[:minprominence]
        inds = prominences .>= minprominence
        indices = indices[inds]
        prominences = prominences[inds]
    end

    # find peak width bounds
    if :widthreference in keys(kwargs)
        widthreference = kwargs[:widthreference]
        if widthreference == "halfheight"
            width_bounds = findwidthbounds(data, x, indices)
        else
            width_bounds = findwidthbounds(data, x, indices, prominences)
        end
    else
        width_bounds = findwidthbounds(data, x, indices, prominences)
    end

    # create Peaks struct
    peaks = data[indices]  # peak heights
    locations = x[indices]  # peak locations
    pr = PeakResults(indices, peaks, locations, prominences, width_bounds)

    # apply minwidth
    if :minwidth in keys(kwargs)
        minwidth = kwargs[:minwidth]
        widths = peakwidths(pr)
        inds = []
        n = length(widths)
        for i = 1:n
            width = widths[i]
            if width >= minwidth
                push!(inds, i)
            end
        end
        pr = pr[inds]
    end

    # apply maxwidth
    if :maxwidth in keys(kwargs)
        maxwidth = kwargs[:maxwidth]
        widths = peakwidths(pr)
        inds = []
        n = length(widths)
        for i = 1:n
            width = widths[i]
            if width <= maxwidth
                push!(inds, i)
            end
        end
        pr = pr[inds]
    end

    # apply minimal distance criterium
    if :mindistance in keys(kwargs)

        mindistance = kwargs[:mindistance]

        pr_remaining = pr
        selected_indices = []  # indices of selected peaks
        while !isempty(pr_remaining)
        
            # extract needed peak properties
            peaks = pr_remaining.peaks
            indices = pr_remaining.indices
            locations = pr_remaining.locations
        
            # select the highest peak
            index_maxpeak = argmax(peaks)
            push!(selected_indices, indices[index_maxpeak])
        
            # remove all peaks that are closer than mindistance to the selected peak
            location = locations[index_maxpeak]
            inds = abs.(locations .- location) .>= mindistance
            pr_remaining = pr_remaining[inds]
        
        end
        
        # select a subset of pr based on the selected indices
        sort!(selected_indices)
        inds = [x in selected_indices for x in pr.indices]
        pr = pr[inds]
    end

    # sort peaks
    if (:sortref in keys(kwargs)) && !(:sortstr in keys(kwargs))
        @warn "sortstr is not specified, sortref will be ignored"
    end

    if :sortstr in keys(kwargs)
        sortstr = kwargs[:sortstr]
        if :sortref in keys(kwargs)
            sortref = kwargs[:sortref]
        else
            sortref = "height"
        end
        if sortstr == "ascend"
            pr = sort(pr; ref=sortref)
        elseif sortstr == "descend"
            pr = sort(pr; rev=true, ref=sortref)
        end
    end

    # select demanded number of peaks
    if :npeaks in keys(kwargs)
        npeaks = kwargs[:npeaks]
        n = length(indices)
        maxind = min(n, npeaks)
        pr = pr[1:maxind]
    end

    return pr

end
