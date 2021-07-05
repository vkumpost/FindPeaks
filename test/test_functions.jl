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
    width_bounds_2 = findwidthbounds(data, x, indices)
    @test isempty(width_bounds_2)

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
    x = (1:length(data)) .+ 5
    indices = [4, 9, 15]
    prominences = [3, 2, 6]
    width_bounds = findwidthbounds(data, x, indices, prominences)
    @test all(width_bounds .≈ ([2.5 5.5; 8.0 11.5; 14.0 16.25] .+ 5))
    width_bounds_2 = findwidthbounds(data, x, indices)
    @test all(width_bounds_2 .≈ ([2.5 5.5; 8.0 11.5; 14.0 16.25] .+ 5))

    data = [0, -1, -2, -1, -2, -2, 1, 1, 2, 3, 4, 3, 2, 1]
    x = (1:length(data)) .- 2
    indices = [4, 11]
    prominences = [1, 3]
    width_bounds = findwidthbounds(data, x, indices, prominences)
    @test all(width_bounds .≈ ([3.5 4.5; 9.5 12.5] .- 2))
    width_bounds_2 = findwidthbounds(data, x, indices)
    @test all(isnan.(width_bounds_2[1, :]))
    @test all(width_bounds_2[2, :] .≈ ([9.0, 13.0] .- 2))

    data = [0, 1, 2, 3, 4, 3, 4, 5, 4, 3, 4, 3, 2, 1, 0]
    x = (1:length(data)) .+ 1.5
    indices = [5, 8, 11]
    prominences = [1, 5, 1]
    width_bounds = findwidthbounds(data, x, indices, prominences)
    @test all(width_bounds .≈ ([4.5 5.5; 3.5 12.5; 10.5 11.5] .+ 1.5))
    width_bounds_2 = findwidthbounds(data, x, indices)
    @test all(width_bounds_2 .≈ ([3.0 6.0; 6.0 10.0; 10.0 13.0] .+ 1.5))

    data = [3, 4, 3, 3, 3, 4, 4, 3]
    indices = [2, 6]
    x = [-1, NaN, 8, NaN, NaN, NaN, NaN, 31]
    width_bounds_2 = findwidthbounds(data, x, indices)
    @test all(width_bounds_2 .≈ [-1 8; 8 31])

end

@testset "findpeaks" begin

    data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
    pr = findpeaks(data)
    @test pr.indices == [4, 9, 15]
    @test pr.peaks == [3, 2, 6]
    @test pr.locations == [4, 9, 15]
    @test pr.prominences == [3, 2, 6]
    @test all(pr.width_bounds .≈ [2.5 5.5; 8.0 11.5; 14.0 16.25])

    pr = findpeaks(data; npeaks = 2)
    @test pr.indices == [4, 9]

    @testset "sortstr, sortref" begin
    
        data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
        pr = findpeaks(data; sortstr = "ascend")
        @test pr.indices == [9, 4, 15]

        pr = findpeaks(data; sortstr = "descend")
        @test pr.indices == [15, 4, 9]

        @test_logs (:warn, "sortstr is not specified, sortref will be ignored")
            findpeaks(data; sortref = "prominences")

        data = [0, 4, 2, 3, 0, 2, 0]
        pr = findpeaks(data; sortstr = "ascend", sortref = "prominence")
        @test pr.indices == [4, 6, 2]

        data = [0, 4, 2, 3, 0, 2, 0]
        pr = findpeaks(data; sortstr = "descend", sortref = "prominence")
        @test pr.indices == [2, 6, 4]

    end

    @testset "mindistance" begin

        data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 6, 4, 0]
        pr = findpeaks(data; mindistance = 8)
        @test pr.indices == [4, 15]

    end

    @testset "minprominence" begin

        data = [1, 1, 2, 3, 2, 4, 1, 1, 2, 3, 2, 3, 4, 5, 6, 4, 1]
        pr = findpeaks(data; minprominence = 3)
        @test pr.indices == [6, 15]

    end

    @testset "minheight" begin

        data = [1, 1, 2, 3, 2, 1, 1, 1, 2, 2, 2, 1, 3, 3, 6, 4, 1]
        pr = findpeaks(data; minheight = 3)
        @test pr.indices == [4, 15]

    end

    @testset "threshold" begin

        data = [0, 1, 2, 0, 2, 1, 0, 2, 0, 2, 2, 0, 4, 0]
        pr = findpeaks(data; threshold = 2)
        @test pr.indices == [8, 13]

    end

    @testset "widthreference" begin
        
        data = [0, 1, 2, 3, 4, 3, 4, 5, 4, 3, 4, 3, 2, 1, 0]
        pr = findpeaks(data, widthreference="halfheight")
        @test all(pr.width_bounds .≈ [3.0 6.0; 6.0 10.0; 10.0 13.0])
        pr = findpeaks(data, widthreference="halfprominence")
        @test all(pr.width_bounds .≈ [4.5 5.5; 3.5 12.5; 10.5 11.5])

    end

    @testset "minwidth" begin

        data = [0, 1, 0, 0, 2, 2, 2, 0, 1, 1, 0, 6, 0]
        pr = findpeaks(data; minwidth = 2)
        @test pr.indices == [5, 9]

    end

    @testset "maxwidth" begin

        data = [0, 1, 0, 0, 2, 2, 2, 0, 1, 1, 0, 6, 6, 0]
        pr = findpeaks(data; maxwidth = 2)
        @test pr.indices == [2, 9, 12]

    end

end