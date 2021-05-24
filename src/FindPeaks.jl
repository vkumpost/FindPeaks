module FindPeaks

import Base.isempty, Base.length

using Plots

export find_idx, find_peaks

export Peaks, isempty, length, plot_peaks

include("functions.jl")
include("Peaks.jl")

end  # module
