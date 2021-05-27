module FindPeaks

import Base.isempty, Base.length

using RecipesBase

export findidx, findp, findwbounds, findpeaks

export Peaks, isempty, length

include("functions.jl")
include("Peaks.jl")

end  # module
