module FindPeaks

import Base.isempty, Base.length, Base.getindex

using RecipesBase

export findindices, findprominences, findwidthbounds, findpeaks

export PeakResults, isempty, length, getindex

include("functions.jl")
include("PeakResults.jl")

end  # module
