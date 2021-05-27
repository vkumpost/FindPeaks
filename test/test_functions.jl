@testset "findidx and findp" begin

    data = [0, 0, 0, 1, 0, 0, 0]
    idx = findidx(data)
    p = findp(data, idx)
    @test idx == [4]
    @test p == [1]

    data = [0, 0, 1, 1, 1, 0, 0]
    idx = findidx(data)
    p = findp(data, idx)
    @test idx == [3]
    @test p == [1]

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 5, 4, 0]
    idx = findidx(data)
    p = findp(data, idx)
    @test idx == [4, 9, 15]
    @test p == [3, 2, 5]

    data = [Inf, -14.4, Inf, 14.0, 18.1, -Inf, 12.3]
    idx = findidx(data)
    p = findp(data, idx)
    @test idx == [3, 5]
    @test all(p .≈ [Inf, 4.1])

    data = [1, NaN, 3, 2, NaN, 1]
    @test_logs (:warn,) findidx(data)

end

@testset "findpeaks" begin

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 5, 4, 0]
    peaks = findpeaks(data)
    @test peaks isa Peaks
    @test peaks.pks == [3, 2, 5]
    @test peaks.locs == [4, 9, 15]
    @test peaks.w == [-1, -1, -1]
    @test all(isnan.(peaks.p))

    data = [1, 2, 3, 4, 5, 6, 6, 6, 6]
    peaks = findpeaks(data)
    @test isempty(peaks)

end
