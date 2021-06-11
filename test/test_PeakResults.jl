@testset "PeakResults" begin

    pr = PeakResults([0, 9], [1, 2], [3, 4], [5, 6], [1 2; 3 4])
    @test pr.indices == [0, 9]
    @test pr.peaks == [1, 2]
    @test pr.locations == [3, 4]
    @test pr.prominences == [5, 6]
    @test pr.width_bounds == [1 2; 3 4]

end

@testset "isempty" begin

    pr = PeakResults([0, 9], [1, 2], [3, 4], [5, 6], [1 2; 3 4])
    @test !isempty(pr)
    @test length(pr) == 2

    pr = PeakResults([], [], [], [], reshape([], 0, 2))
    @test isempty(pr)
    @test length(pr) == 0

end

@testset "getindex" begin

    indices = [0, 2, 4, 6]
    peaks = [1, 3, 5, 7]
    locations = [10, 11, 12, 13]
    prominences = [21, 22, 23, 24]
    width_bounds = [1 1; 2 2; 3 3; 4 4]
    pr = PeakResults(indices, peaks, locations, prominences, width_bounds)
    pr_select = pr[[2, 4]]
    @test pr_select.indices == [2, 6]
    @test pr_select.peaks == [3, 7]
    @test pr_select.locations == [11, 13]
    @test pr_select.prominences == [22, 24]
    @test pr_select.width_bounds == [2 2; 4 4]

end

@testset "sort" begin

    indices = [0, 2, 4, 6]
    peaks = [5, 3, 2, 7]
    locations = [10, 11, 12, 13]
    prominences = [21, 22, 23, 24]
    width_bounds = [1 1; 2 2; 3 3; 4 4]
    pr = PeakResults(indices, peaks, locations, prominences, width_bounds)

    pr_sort = sort(pr)
    @test pr_sort.indices == [4, 2, 0, 6]
    @test pr_sort.peaks == [2, 3, 5, 7]
    @test pr_sort.locations == [12, 11, 10, 13]
    @test pr_sort.prominences == [23, 22, 21, 24]
    @test pr_sort.width_bounds == [3 3; 2 2; 1 1; 4 4]

    pr_sort_rev = sort(pr; rev=true)
    @test pr_sort_rev.indices == [6, 0, 2, 4]
    @test pr_sort_rev.peaks == [7, 5, 3, 2]
    @test pr_sort_rev.locations == [13, 10, 11, 12]
    @test pr_sort_rev.prominences == [24, 21, 22, 23]
    @test pr_sort_rev.width_bounds == [4 4; 1 1; 2 2; 3 3]

end

@testset "plot" begin

    data = [1, 2, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1]
    pr = findpeaks(data)
    p = plot(pr, data)
    @test p.n == 8

end
