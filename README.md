
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xrprof

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xrprof)](https://cran.r-project.org/package=xrprof)
<!-- badges: end -->

`xrprof` is the companion package to
[`xrprof`](https://github.com/atheriel/xrprof), an external sampling
profiler for R programs.

## Installation

`xrprof` is not yet available on [CRAN](https://CRAN.R-project.org). For
now, you can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("atheriel/xrprof-package")
```

## Usage

Suppose you have some R code running that you want to profile. You can
grab the process identifier (PID) with something like

``` console
$ pgrep rsession
67017
```

You can then use `xrprof()` as a replacement for `Rprof()` (and related
tools, such as [**profvis**](https://rstudio.github.io/profvis/)). For
example, to profile the process at 50 Hz for 5 seconds:

``` r
fname <- tempfile()
xrprof(fname, pid = 67017, frequency = 50, duration = 5)
# Wait 5 seconds...
```

You can then analyze the results using traditional R tools:

``` r
summaryRprof(fname)
# Or
profvis::profvis(prof_output = fname)
```

On many systems, this will require you to enter your password, but you
can give `xrprof` permission to run without it by running
`enable_no_sudo()`.

## License

`xrprof` is made available under the terms of the GPL, version 2.
