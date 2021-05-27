@testset "structure" begin

    peaks = Peaks([1, 2], [3, 4], [5, 6], [7, 8])
    @test peaks.pks == [1, 2]
    @test peaks.locs == [3, 4]
    @test peaks.w == [5, 6]
    @test peaks.p == [7, 8]

end

@testset "functions" begin

    peaks = Peaks([1, 2], [3, 4], [5, 6], [7, 8])
    @test !isempty(peaks)
    @test length(peaks) == 2

    peaks = Peaks([], [], [], [])
    @test isempty(peaks)
    @test length(peaks) == 0

end
