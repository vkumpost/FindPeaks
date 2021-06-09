module FindPeaks

import Base.isempty, Base.length, Base.getindex, Base.sort

using RecipesBase

export findindices, findprominences, findwidthbounds, findpeaks

export PeakResults, widths, isempty, length, getindex, sort

include("functions.jl")
include("PeakResults.jl")

end  # module
