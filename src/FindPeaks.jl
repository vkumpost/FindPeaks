module FindPeaks

import Base.isempty, Base.length

using RecipesBase

export findindices, findprominences, findwidthbounds, findpeaks

export PeakResults, isempty, length

include("functions.jl")
include("PeakResults.jl")

end  # module
