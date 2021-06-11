# FindPeaks

[Julia](https://julialang.org/) package for peak detection inspired by MATLAB's `findpeaks` function. 

The current version can find peaks in a data vector together with their prominences and widths. The peaks can be filtered based on several properties including minimal prominence and height, the minimal distance between the individual peaks, and minimal and maximal width.

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
    pr = findpeaks(data)
    plot(pr, data)
```
![image](assets/example_plot.png)

## Usage

For more information see the documentation of the `findpeaks` function.
