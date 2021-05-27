using Test
using FindPeaks

@testset "Tests" begin

    @testset "functions" begin
        include("test_functions.jl")
    end

    @testset "Peaks" begin
        include("test_Peaks.jl")
    end

end
