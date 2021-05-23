data = [0, 0, 0, 1, 0, 0, 0]
@test find_idx(data) == [4]

data = [0, 0, 1, 1, 1, 0, 0]
@test find_idx(data) == [3]

data = [0, 1, 2, 3, 2, 1, 0, 1, 2, 2, 2, 0, 3, 3, 5, 4, 0]
@test find_idx(data) == [4, 9, 15]

data = [Inf, -14.4, Inf, 14.0, 18.1, -Inf, 12.3]
@test find_idx(data) == [3, 5]

data = [1, NaN, 3, 2, NaN, 1]
@test_logs (:warn,) find_idx(data)
