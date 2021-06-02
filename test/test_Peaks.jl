@testset "Struct" begin

    pr = PeakResults([0, 9], [1, 2], [3, 4], [5, 6], [1 2; 3 4])
    @test pr.indices == [0, 9]
    @test pr.peaks == [1, 2]
    @test pr.locations == [3, 4]
    @test pr.prominences == [5, 6]
    @test pr.width_bounds == [1 2; 3 4]

end

@testset "Basic functions" begin

    pr = PeakResults([0, 9], [1, 2], [3, 4], [5, 6], [1 2; 3 4])
    @test !isempty(pr)
    @test length(pr) == 2

    pr = PeakResults([], [], [], [], reshape([], 0, 2))
    @test isempty(pr)
    @test length(pr) == 0

end

@testset "plot" begin

    data = [1, 2, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1]
    pr = findpeaks(data)
    p = plot(pr, data)
    @test p.n == 8

end