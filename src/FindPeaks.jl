module FindPeaks

import Base.isempty, Base.length, Base.getindex, Base.sort

using RecipesBase

export findindices, findprominences, findwidthbounds
export findpeaks

export PeakResults
export peakmaxima, peaklocations, peakprominences, peakwidths
export isempty, length, getindex, sort

include("functions.jl")
include("PeakResults.jl")

end  # module
