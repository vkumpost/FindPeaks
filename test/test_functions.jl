@testset "findindices" begin

    data = [0, 0, 0, 0, 1, 1, 1, 1]
    indices = findindices(data)
    @test isempty(indices)

    data = [0, 0, 0, 1, 0, 0, 0]
    indices = findindices(data)
    @test indices == [4]

    data = [0, 0, 1, 1, 1, 0, 0]
    indices = findindices(data)
    @test indices == [3]

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
    indices = findindices(data)
    @test indices == [4, 9, 15]

    data = [Inf, -14.4, Inf, 14.0, 18.0, -Inf, 12.3]
    indices = findindices(data)
    @test indices == [3, 5]

    data = [1, NaN, 3, 2, NaN, 1]
    @test_logs (:warn,) findindices(data)

end

@testset "findprominences" begin

    data = [0, 0, 0, 0, 1, 1, 1, 1]
    indices = []
    prominences = findprominences(data, indices)
    @test isempty(prominences)

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
    indices = [4, 9, 15]
    prominences = findprominences(data, indices)
    @test prominences == [3, 2, 6]

    data = [Inf, -14.4, Inf, 14.0, 18.0, -Inf, 12.3]
    indices = [3, 5]
    prominences = findprominences(data, indices)
    @test all(prominences .≈ [Inf, 4.0])

end

@testset "findwidthbounds" begin

    data = [0, 0, 0, 0, 1, 1, 1, 1]
    x = 1:length(data)
    indices = []
    prominences = []
    width_bounds = findwidthbounds(data, x, indices, prominences)
    @test isempty(width_bounds)

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
    x = 1:length(data)
    indices = [4, 9, 15]
    prominences = [3, 2, 6]
    width_bounds = findwidthbounds(data, x, indices, prominences)
    @test all(width_bounds .≈ [2.5 5.5; 8.0 11.5; 14.0 16.25])

    data = [Inf, -14.4, Inf, 14.0, 18.0, -Inf, 12.3]
    x = 1:length(data)
    indices = [3, 5]
    prominences = [Inf, 4.0]
    width_bounds = findwidthbounds(data, x, indices, prominences)
    @test all(width_bounds .≈ [1.0 7.0; 4.5 5.0])

end

@testset "findpeaks" begin

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
    pr = findpeaks(data)
    @test pr.indices == [4, 9, 15]
    @test pr.prominences == [3, 2, 6]
    @test all(pr.width_bounds .≈ [2.5 5.5; 8.0 11.5; 14.0 16.25])

    pr = findpeaks(data; minprominence = 3)
    @test pr.indices == [4, 15]

    pr = findpeaks(data; npeaks = 2)
    @test pr.indices == [4, 9]

end