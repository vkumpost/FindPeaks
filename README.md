# FindPeaks

[Julia](https://julialang.org/) package for peak detection inspired by MATLAB's `findpeaks` function. 

The current version can find peaks in a data vector together with their prominences and widths. The peaks can be filtered base on the minimal prominence or minimal distance between the individual peaks.

## Installation

The package can be installed by running
```julia
    import Pkg
    Pkg.add(url="https://github.com/vkumpost/FindPeaks")
```

To make sure everything is ready to go we can run package tests
```julia
    Pkg.test("FindPeaks")
```

## Example

```julia
    using FindPeaks
    using Plots
    
    data = rand(10)
    pk = findpeaks(data)
    plot(pk, data)
```

For more information see the documentation of the `findpeaks` function.