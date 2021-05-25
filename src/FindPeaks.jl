module FindPeaks

import Base.isempty, Base.length

using Plots

export findidx, findpeaks

export Peaks, isempty, length, plotpeaks

include("functions.jl")
include("Peaks.jl")

end  # module
